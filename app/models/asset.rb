class Asset < ApplicationRecord
  belongs_to :user
  has_many :asset_accounts, dependent: :destroy
  has_many :simulations, dependent: :destroy
  has_many :items, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :user }
end
