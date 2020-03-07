class SumAccountDaily < ApplicationRecord
  belongs_to :simulation_summary_by_account
  belongs_to :asset_account

  validates :simulation_summary_by_account, :base_date, :asset_account, :balance, presence: true
end
