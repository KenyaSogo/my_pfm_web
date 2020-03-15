class AcctToClassMap < ApplicationRecord
  belongs_to :sum_by_acct_class_setting
  belongs_to :asset_account
  belongs_to :simulation_acct_class
end
