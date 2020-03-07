class SimulationSummaryByAccount < ApplicationRecord
  belongs_to :simulation_summary

  validate :validate_unity_within_simulation_summary, on: :create

  private

  def validate_unity_within_simulation_summary
    return if SimulationSummaryByAccount.where(simulation_summary_id: simulation_summary.id).size == 0
    errors.add(:base, 'simulation_summary_by_account must be single')
  end
end
