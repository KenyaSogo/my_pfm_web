class Asset < ApplicationRecord
  belongs_to :user
  has_many :asset_accounts, dependent: :destroy
  has_many :items, dependent: :destroy
end
