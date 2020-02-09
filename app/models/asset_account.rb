class AssetAccount < ApplicationRecord
  belongs_to :asset
  belongs_to :asset_type
end
