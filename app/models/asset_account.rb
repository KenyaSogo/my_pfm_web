class AssetAccount < ApplicationRecord
  belongs_to :asset
  belongs_to :asset_type
  has_many :asset_activities, dependent: :destroy
end
