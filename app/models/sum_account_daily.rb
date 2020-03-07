class SumAccountDaily < ApplicationRecord
  belongs_to :simulation_summary_by_account
  belongs_to :asset_account
end
