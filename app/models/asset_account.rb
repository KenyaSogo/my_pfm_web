class AssetAccount < ApplicationRecord
  belongs_to :asset
  belongs_to :asset_type
  has_many :asset_activities, dependent: :destroy

  validates :asset_type, :initial_balance, presence: true, on: :update
end
