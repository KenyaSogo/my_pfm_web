class SumAssetTypeDaily < ApplicationRecord
  belongs_to :summary_by_asset_type
  belongs_to :asset_type

  validates :summary_by_asset_type, :base_date, :asset_type, :balance, presence: true
end
