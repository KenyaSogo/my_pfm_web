class BillingActivity < ApplicationRecord
  belongs_to :billing_account
  belongs_to :asset_account
  belongs_to :item
  belongs_to :sub_item
end
