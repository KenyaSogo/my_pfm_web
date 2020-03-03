class SimulationResultGenerateJob < ApplicationJob
  class SimulationResultError < StandardError; end

  queue_as :default

  def perform(simulation_id)
    simulation = Simulation.find(simulation_id)
    return if simulation.blank?

    last_generated_at = simulation.last_generated_at.presence || Time.new(1900, 1, 1, 0, 0, 0)

    ApplicationRecord.transaction do
      simulation.simulation_entries.each do |simulation_entry|
        updated_simulation_entry_details(simulation_entry, last_generated_at).each do |entry_detail|
          entry_detail.simulation_result_activities.each { |a| a.destroy! }
          apply_dates = simulation_entry.entry_type_any_time? ? [Date.new(entry_detail.transaction_date_year, entry_detail.transaction_date_month, entry_detail.transaction_date_day)]
            : simulation_entry.apply_from..simulation_entry.apply_to
          apply_dates.each do |apply_date|
            create_result_activity!(entry_detail, apply_date) if transaction_date?(apply_date, entry_detail)
          end
        end
      end

      simulation.billing_accounts.each do |billing_account|
        billing_account.billing_activities.each { |a| a.destroy! } if billing_account.updated_at >= last_generated_at

        current_month_closing_date = Date.new(Date.today.year, Date.today.month, billing_account.billing_closing_day)
        aggregate_target_activities = fetch_aggregate_target_activities(simulation.id, billing_account, current_month_closing_date)

        billing_periods(current_month_closing_date, aggregate_target_activities).each do |billing_period|
          target_activities_in_period = aggregate_target_activities.select { |a| a.transaction_date.to_date.in?(billing_period) }
          next if target_activities_in_period.blank?

          billing_amount = target_activities_in_period.map { |a| - a.amount }.sum
          withdrawal_date = Date.new(billing_period.last.year, billing_period.last.month, billing_account.withdrawal_day) + billing_account.withdrawal_month_offset.month

          create_or_update_billing_activity_set!(billing_account, withdrawal_date, billing_amount)
        end
      end

      simulation.update!(last_generated_at: Time.now)
    end
  end

  private

  def create_or_update_billing_activity_set!(billing_account, withdrawal_date, billing_amount)
    create_or_update_billing_activity_if_changed!(
      billing_account_id: billing_account.id,
      account_id: billing_account.credit_account_id,
      withdrawal_date: withdrawal_date,
      billing_amount: billing_amount,
      item_id: billing_account.billing_item_id,
      sub_item_id: billing_account.billing_sub_item_id
    )
    create_or_update_billing_activity_if_changed!(
      billing_account_id: billing_account.id,
      account_id: billing_account.debit_account_id,
      withdrawal_date: withdrawal_date,
      billing_amount: - billing_amount,
      item_id: billing_account.debit_item_id,
      sub_item_id: billing_account.debit_sub_item_id
    )
  end

  def fetch_aggregate_target_activities(simulation_id, billing_account, current_month_closing_date)
    asset_activities = AssetActivity.where(asset_account_id: billing_account.credit_account_id)
    billing_aggregate_start_date = if billing_account.billing_activities.blank?
        go_back_months = [month_diff(current_month_closing_date, asset_activities.minimum(:transaction_date)), 0].max
        current_month_closing_date.ago((go_back_months + 1).month).tomorrow
      else
        current_month_closing_date.ago(2.month).tomorrow
      end

    target_asset_activities = asset_activities.where('transaction_date >= ?', billing_aggregate_start_date)
    target_simulation_result_activities = SimulationResultActivity.joins(simulation_entry_detail: :simulation_entry)
      .where(simulation_entries: { simulation_id: simulation_id })
      .where(asset_account_id: billing_account.credit_account_id)
      .where('transaction_date > ?', target_asset_activities.map(&:transaction_date).max)

    target_asset_activities + target_simulation_result_activities
  end

  def billing_periods(current_month_closing_date, aggregate_target_activities)
    target_transaction_dates = aggregate_target_activities.map(&:transaction_date)
    go_back_months = [month_diff(current_month_closing_date, target_transaction_dates.min), 0].max
    go_ahead_months = [month_diff(target_transaction_dates.max, current_month_closing_date), 0].max
    ((- go_ahead_months)..go_back_months).to_a.reverse.map do |i|
      closing_date = current_month_closing_date.ago(i.month)
      starting_date = closing_date.last_month.tomorrow
      starting_date.to_date..closing_date.to_date
    end
  end

  def month_diff(compare_date, base_date)
    (compare_date.year * 12 + compare_date.month) - (base_date.year * 12 + base_date.month)
  end

  def create_or_update_billing_activity_if_changed!(billing_account_id:, account_id:, withdrawal_date:, billing_amount:, item_id:, sub_item_id:)
    billing_activity = BillingActivity.find_or_initialize_by(
      billing_account_id: billing_account_id,
      asset_account_id: account_id,
      transaction_date: withdrawal_date
    )
    billing_activity.assign_attributes(
      amount: billing_amount,
      item_id: item_id,
      sub_item_id: sub_item_id,
      is_transfer: true,
      is_calculation_target: true
    )
    billing_activity.save! if billing_activity.changed?
  end

  def updated_simulation_entry_details(simulation_entry, last_generated_at)
    if simulation_entry.updated_at >= last_generated_at
      simulation_entry.simulation_entry_details
    else
      simulation_entry.simulation_entry_details.select { |d| d.updated_at >= last_generated_at }
    end
  end

  def transaction_date?(apply_date, simulation_entry_detail)
    simulation_entry = simulation_entry_detail.simulation_entry
    case
    when simulation_entry.entry_type_any_time?
      true
    when simulation_entry.entry_type_daily?
      true
    when simulation_entry.entry_type_weekly?
      apply_date.wday + 1 == simulation_entry_detail.transaction_date_weekday
    when simulation_entry.entry_type_monthly?
      apply_date.day == simulation_entry_detail.transaction_date_day
    when simulation_entry.entry_type_yearly?
      apply_date.month == simulation_entry_detail.transaction_date_month && apply_date.day == simulation_entry_detail.transaction_date_day
    else
      fail SimulationResultError, 'invalid simulation_entry_type'
    end
  end

  def create_result_activity!(simulation_entry_detail, transaction_date)
    result_activity = SimulationResultActivity.new
    result_activity.attributes = {
      simulation_entry_detail_id: simulation_entry_detail.id,
      asset_account_id: simulation_entry_detail.asset_account.id,
      transaction_date: transaction_date,
      description: simulation_entry_detail.description,
      amount: simulation_entry_detail.amount,
      item_id: simulation_entry_detail.item_id,
      sub_item_id: simulation_entry_detail.sub_item_id,
      is_transfer: simulation_entry_detail.is_transfer,
      is_calculation_target: simulation_entry_detail.is_calculation_target,
    }
    result_activity.save!
  end
end