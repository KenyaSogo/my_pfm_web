class SimulationSummaryByAccount < ApplicationRecord
  belongs_to :simulation_summary
  has_many :sum_account_dailies, dependent: :destroy

  before_validation :set_is_active_true, on: :create

  validates :memo, length: { maximum: 400 }
  validate :validate_active_dependency, on: :update
  validate :validate_unity_within_simulation_summary, on: :create

  private

  def set_is_active_true
    self.is_active = true
  end

  def validate_active_dependency
    if simulation_summary.summary_by_asset_type&.is_active
      errors.add(:is_active, 'must be true when ByAssetType is active') unless is_active
    end

    if simulation_summary.sum_by_account_classes.where(is_active: true).exists?
      errors.add(:is_active, 'must be true when ByAccountClass is active') unless is_active
    end
  end

  def validate_unity_within_simulation_summary
    return if SimulationSummaryByAccount.where(simulation_summary_id: simulation_summary.id).size == 0
    errors.add(:base, 'simulation_summary_by_account must be single')
  end
end
