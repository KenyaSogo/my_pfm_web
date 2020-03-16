class SumAcctClassDaily < ApplicationRecord
  belongs_to :sum_by_account_class
  belongs_to :simulation_acct_class

  validates :sum_by_account_class, :base_date, :balance, presence: true
end
