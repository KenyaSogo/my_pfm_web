class AssetAccount < ApplicationRecord
  belongs_to :asset
  belongs_to :asset_type
  has_many :asset_activities, dependent: :destroy

  validates :asset_type, :initial_balance, :initial_balance_base_date, presence: true, on: :update
end
