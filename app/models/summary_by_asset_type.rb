class SummaryByAssetType < ApplicationRecord
  belongs_to :simulation_summary
  has_many :sum_asset_type_dailies, dependent: :destroy

  before_validation :set_is_active_true, on: :create

  validates :memo, length: { maximum: 400 }
  validate :validate_unity_within_simulation_summary, on: :create

  private

  def set_is_active_true
    self.is_active = true
  end

  def validate_unity_within_simulation_summary
    return if SummaryByAssetType.where(simulation_summary_id: simulation_summary.id).size == 0
    errors.add(:base, 'summary_by_asset_type must be single')
  end
end
