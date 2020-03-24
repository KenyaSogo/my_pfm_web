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
          entry_detail.simulation_result_activities.delete_all
          apply_dates = simulation_entry.entry_type_any_time? ? [Date.new(entry_detail.transaction_date_year, entry_detail.transaction_date_month, entry_detail.transaction_date_day)]
            : simulation_entry.apply_from..simulation_entry.apply_to
          apply_dates.each do |apply_date|
            create_result_activity!(entry_detail, apply_date) if transaction_date?(apply_date, entry_detail)
          end
        end
      end

      simulation.billing_accounts.each do |billing_account|
        if billing_account.updated_at >= last_generated_at
          billing_account.billing_activities.delete_all
          billing_account.billing_complement_activities.delete_all
        end

        current_month_closing_date = Date.new(today.year, today.month, billing_account.billing_closing_day)
        aggregate_target_activities = fetch_aggregate_target_activities(simulation.id, billing_account, current_month_closing_date)

        billing_periods(current_month_closing_date, aggregate_target_activities).each do |billing_period|
          target_activities_in_period = aggregate_target_activities.select { |a| a.transaction_date.to_date.in?(billing_period) }
          next if target_activities_in_period.blank?

          billing_amount = target_activities_in_period.map { |a| - a.amount }.sum
          withdrawal_date = Date.new(billing_period.last.year, billing_period.last.month, billing_account.withdrawal_day) + billing_account.withdrawal_month_offset.month

          create_or_update_billing_activity_set!(billing_account, withdrawal_date, billing_amount)
        end

        debit_asset_activities = AssetActivity.where(asset_account_id: billing_account.debit_account_id)
        complement_start_date = billing_account.billing_complement_activities.blank? ? debit_asset_activities.minimum(:transaction_date)
          : Date.new(today.year, today.month, 1).last_month
        (0..month_diff(today, complement_start_date)).to_a.reverse.each do |month_index|
          withdrawal_debit_asset_activity = fetch_withdrawal_debit_asset_activity(billing_account, month_index.month, debit_asset_activities)
          next if withdrawal_debit_asset_activity.blank? || transfered_credit_asset_activity_exists?(billing_account, withdrawal_debit_asset_activity)
          create_or_update_billing_complement_activity_if_changed!(billing_account, withdrawal_debit_asset_activity)
        end
      end

      simulation_summary = SimulationSummary.find_or_create_by!(simulation_id: simulation.id)
      simulation_summary_by_account = SimulationSummaryByAccount.find_or_create_by!(simulation_summary_id: simulation_summary.id)
      summary_by_asset_type = SummaryByAssetType.find_or_create_by!(simulation_summary_id: simulation_summary.id)

      if simulation_summary_by_account.is_active
        asset_activity_daily_sums = fetch_asset_activity_daily_sums(simulation)
        simulations_activity_daily_sums = fetch_simulation_activity_daily_sums(simulation)
        daily_sum_results = merge_daily_sum_results(asset_activity_daily_sums, simulations_activity_daily_sums)
        daily_balance_results = aggregate_daily_balance(daily_sum_results)

        simulation_summary_by_account.sum_account_dailies.delete_all
        daily_balance_results.each do |account_id, daily_balances|
          daily_balances.each do |base_date, balance|
            SumAccountDaily.create!(
              simulation_summary_by_account_id: simulation_summary_by_account.id,
              base_date: base_date,
              asset_account_id: account_id,
              balance: balance,
            )
          end
        end

        simulation_summary_by_account.update!(summarized_at: Time.now)
      else
        simulation_summary_by_account.sum_account_dailies.delete_all
        simulation_summary_by_account.update!(summarized_at: nil)
      end

      if summary_by_asset_type.is_active
        daily_sum_results = fetch_daily_sums_by_asset_type(simulation_summary_by_account)

        summary_by_asset_type.sum_asset_type_dailies.delete_all
        daily_sum_results.each do |asset_type_id, daily_sums|
          daily_sums.sort.each do |base_date, balance|
            SumAssetTypeDaily.create!(
              summary_by_asset_type_id: summary_by_asset_type.id,
              base_date: base_date,
              asset_type_id: asset_type_id,
              balance: balance,
            )
          end
        end

        summary_by_asset_type.update!(summarized_at: Time.now)
      else
        summary_by_asset_type.sum_asset_type_dailies.delete_all
        summary_by_asset_type.update!(summarized_at: nil)
      end

      simulation_summary.sum_by_account_classes.each do |sum_by_account_class|
        if sum_by_account_class.is_active
          daily_sum_results = fetch_daily_sums_by_account_class(simulation_summary_by_account, sum_by_account_class)

          sum_by_account_class.sum_acct_class_dailies.delete_all
          daily_sum_results.each do |account_class_id, daily_sums|
            daily_sums.sort.each do |base_date, balance|
              SumAcctClassDaily.create!(
                sum_by_account_class_id: sum_by_account_class.id,
                base_date: base_date,
                simulation_acct_class_id: account_class_id,
                balance: balance,
              )
            end
          end

          sum_by_account_class.update!(summarized_at: Time.now)
        else
          sum_by_account_class.sum_acct_class_dailies.delete_all
          sum_by_account_class.update!(summarized_at: nil)
        end
      end

      summary_executed = simulation_summary_by_account.is_active || summary_by_asset_type.is_active || simulation_summary.sum_by_account_classes.any?(&:is_active)
      simulation_summary.update!(summarized_at: summary_executed ? Time.now : nil)

      simulation.update!(last_generated_at: Time.now)
    end
  end

  private

  def aggregate_daily_balance(daily_sum_results)
    sum_end_date = daily_sum_results.map { |account_id, daily_sums| daily_sums.keys.max }.max
    daily_sum_results.keys.each_with_object({}) do |account_id, results_h|
      daily_sums = daily_sum_results[account_id]

      prev_balance = AssetAccount.find(account_id).initial_balance.presence || 0
      daily_balances = (daily_sums.keys.min..sum_end_date).each_with_object({}) do |date, daily_h|
        amount = daily_sums[date] || 0
        current_balance = prev_balance + amount
        daily_h[date] = current_balance

        prev_balance = current_balance
        daily_h
      end

      results_h[account_id] = daily_balances
    end
  end

  def fetch_daily_sums_by_account_class(simulation_summary_by_account, sum_by_account_class)
    daily_sum_aggregates = simulation_summary_by_account.sum_account_dailies
      .joins('inner join asset_accounts accts on sum_account_dailies.asset_account_id = accts.id')
      .joins('left join acct_to_class_maps maps on accts.id = maps.asset_account_id')
      .select('sum_account_dailies.*, maps.*')
      .where(maps: { sum_by_acct_class_setting_id: sum_by_account_class.sum_by_acct_class_setting.id })
      .group(:simulation_acct_class_id, :base_date)
      .sum(:balance)
    daily_sum_aggregates_to_h(daily_sum_aggregates)
  end

  def fetch_daily_sums_by_asset_type(simulation_summary_by_account)
    daily_sum_aggregates = simulation_summary_by_account.sum_account_dailies
      .includes(:asset_account)
      .group(:asset_type_id, :base_date)
      .sum(:balance)
    daily_sum_aggregates_to_h(daily_sum_aggregates)
  end

  def daily_sum_aggregates_to_h(daily_sum_aggregates)
    daily_sum_aggregates.keys.each_with_object({}) do |k, h|
      asset_type_id = k[0]
      base_date = k[1]
      balance = daily_sum_aggregates[k]
      h[asset_type_id] ||= {}
      h[asset_type_id][base_date] = balance
    end
  end

  def merge_daily_sum_results(asset_activity_daily_sums, simulations_activity_daily_sums)
    asset_account_ids = (asset_activity_daily_sums.keys + simulations_activity_daily_sums.keys).uniq

    asset_account_ids.each_with_object({}) do |account_id, h|
      asset_activity_max_date = asset_activity_daily_sums[account_id]&.keys&.max.presence || Date.new(2000, 1, 1)
      target_simulation_activity_sums = simulations_activity_daily_sums[account_id]&.select { |date, amount| date > asset_activity_max_date }
      merged_sums = (asset_activity_daily_sums[account_id].presence || {}).merge(target_simulation_activity_sums.presence || {})

      initial_balance_base_date = AssetAccount.find(account_id).initial_balance_base_date.presence || Date.new(2000, 1, 1)
      merged_sums_since_initial_balance = merged_sums.select { |date, amount| date >= initial_balance_base_date }

      h[account_id] = merged_sums_since_initial_balance
    end
  end

  def fetch_simulation_activity_daily_sums(simulation)
    sql = <<-SQL
      select
        asset_account_id,
        transaction_date,
        sum(daily_balance_in_class) as daily_balance
      from
        (
          select
            sra.asset_account_id,
            sra.transaction_date,
            sum(sra.amount) as daily_balance_in_class
          from
            simulations s
            inner join simulation_entries se on s.id = se.simulation_id
            inner join simulation_entry_details sed on se.id = sed.simulation_entry_id
            inner join simulation_result_activities sra on sed.id = sra.simulation_entry_detail_id
          where
            s.id = ?
          group by
            sra.asset_account_id, sra.transaction_date
          union all
          select
            bact.asset_account_id,
            bact.transaction_date,
            sum(bact.amount) as daily_balance_in_class
          from
            simulations s
            inner join billing_accounts bacc on s.id = bacc.simulation_id
            inner join billing_activities bact on bacc.id = bact.billing_account_id
          where
            s.id = ?
          group by
            bact.asset_account_id, bact.transaction_date
        ) daily_simulation_results_and_daily_billing_activities
      group by
        asset_account_id, transaction_date
    SQL
    sanitize_sql = ActiveRecord::Base.send(:sanitize_sql_array, [sql, simulation.id, simulation.id])
    activity_daily_sums = ActiveRecord::Base.connection.select_all(sanitize_sql).to_hash

    activity_daily_sums_to_h(activity_daily_sums)
  end

  def fetch_asset_activity_daily_sums(simulation)
    sql = <<-SQL
      select
        asset_account_id,
        transaction_date,
        sum(daily_balance_in_class) as daily_balance
      from
        (
          select
            aact.asset_account_id,
            aact.transaction_date,
            sum(aact.amount) as daily_balance_in_class
          from
            assets a
            inner join asset_accounts aacc on a.id = aacc.asset_id
            inner join asset_activities aact on aacc.id = aact.asset_account_id
          where 1 = 1
            and a.id = ?
            and aact.transaction_date >= ifnull(aacc.initial_balance_base_date, 0)
          group by
            aact.asset_account_id, aact.transaction_date
          union all
          select
            bcact.asset_account_id,
            bcact.transaction_date,
            sum(bcact.amount) as daily_balance_in_class
          from
            simulations s
            inner join billing_accounts bacc on s.id = bacc.simulation_id
            inner join billing_complement_activities bcact on bacc.id = bcact.billing_account_id
            inner join asset_accounts aacc on aacc.id = bcact.asset_account_id
          where 1 = 1
            and s.id = ?
            and bcact.transaction_date >= ifnull(aacc.initial_balance_base_date, 0)
          group by
            bcact.asset_account_id, bcact.transaction_date
        ) daily_asset_and_billing_complement_activities
      group by
        asset_account_id, transaction_date
    SQL
    sanitize_sql = ActiveRecord::Base.send(:sanitize_sql_array, [sql, simulation.id, simulation.id])
    activity_daily_sums = ActiveRecord::Base.connection.select_all(sanitize_sql).to_hash

    activity_daily_sums_to_h(activity_daily_sums)
  end

  def activity_daily_sums_to_h(activity_daily_sums)
    activity_daily_sums.each_with_object({}) do |a, h|
      asset_account_id = a.symbolize_keys[:asset_account_id]
      transaction_date = a.symbolize_keys[:transaction_date].to_date
      daily_balance = a.symbolize_keys[:daily_balance]
      h[asset_account_id] ||= {}
      h[asset_account_id][transaction_date] = daily_balance
    end
  end

  def transfered_credit_asset_activity_exists?(billing_account, withdrawal_debit_asset_activity)
    AssetActivity.where(asset_account_id: billing_account.credit_account_id)
      .where(transaction_date: withdrawal_debit_asset_activity.transaction_date)
      .where(amount: - withdrawal_debit_asset_activity.amount)
      .exists?
  end

  def fetch_withdrawal_debit_asset_activity(billing_account, ago_month, target_debit_asset_activities)
    withdrawal_date = Date.new(today.year, today.month, billing_account.withdrawal_day).ago(ago_month)
    target_debit_asset_activities
      .where('transaction_date >= ?', withdrawal_date - 5.days).where('transaction_date <= ?', withdrawal_date + 5.days)
      .where('amount < 0')
      .where(item_id: billing_account.debit_item_id).where(sub_item_id: billing_account.debit_sub_item_id)
      .first
  end

  def today
    @today ||= Date.today
  end

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

  def create_or_update_billing_complement_activity_if_changed!(billing_account, withdrawal_debit_asset_activity)
    billing_complement_activity = BillingComplementActivity.find_or_initialize_by(
      billing_account_id: billing_account.id,
      asset_account_id: billing_account.credit_account_id,
      transaction_date: withdrawal_debit_asset_activity.transaction_date
    )
    billing_complement_activity.assign_attributes(
      amount: - withdrawal_debit_asset_activity.amount,
      item_id: billing_account.billing_item_id,
      sub_item_id: billing_account.billing_sub_item_id,
      is_transfer: true,
      is_calculation_target: true
    )
    billing_complement_activity.save! if billing_complement_activity.changed?
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