class SimulationSummary < ApplicationRecord
  belongs_to :simulation
  has_one :simulation_summary_by_account, dependent: :destroy
  has_one :summary_by_asset_type, dependent: :destroy

  validate :validate_unity_within_simulation, on: :create

  private

  def validate_unity_within_simulation
    return if SimulationSummary.where(simulation_id: simulation.id).size == 0
    errors.add(:base, 'simulation_summary must be single')
  end
end
