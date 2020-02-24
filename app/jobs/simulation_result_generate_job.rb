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
      simulation.update!(last_generated_at: Time.now)
    end
  end

  private

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