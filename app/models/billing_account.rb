class BillingAccount < ApplicationRecord
  belongs_to :simulation
  belongs_to :credit_account
  belongs_to :billing_item
  belongs_to :billing_sub_item
  belongs_to :debit_account
  belongs_to :debit_item
  belongs_to :debit_sub_item
end
