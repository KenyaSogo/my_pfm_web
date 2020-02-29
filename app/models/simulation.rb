class Simulation < ApplicationRecord
  belongs_to :asset
  has_many :simulation_entries, dependent: :destroy
  has_many :billing_accounts, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :asset }
end
