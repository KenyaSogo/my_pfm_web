class AssetActivity < ApplicationRecord
  belongs_to :asset_account
  belongs_to :item
  belongs_to :sub_item
end
