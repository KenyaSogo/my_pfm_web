class SumAssetTypeDaily < ApplicationRecord
  belongs_to :summary_by_asset_type
  belongs_to :asset_type
end
