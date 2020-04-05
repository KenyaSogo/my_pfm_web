class AssetAccount < ApplicationRecord
  belongs_to :asset
  belongs_to :asset_type
  has_many :asset_activities, dependent: :destroy

  validates :asset_type, :initial_balance, :initial_balance_base_date, presence: true, on: :update
  validates :initial_balance, numericality: { only_integer: true }, on: :update
  validate :validate_initial_balance_base_date_range, on: :update

  private

  def validate_initial_balance_base_date_range
    errors.add(:initial_balance_base_date, 'must be past date (or today)') if initial_balance_base_date > Date.today
  end
end
