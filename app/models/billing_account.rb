class BillingAccount < ApplicationRecord
  belongs_to :simulation
  belongs_to :credit_account, class_name: 'AssetAccount'
  belongs_to :billing_item, class_name: 'Item'
  belongs_to :billing_sub_item, class_name: 'SubItem'
  belongs_to :debit_account, class_name: 'AssetAccount'
  belongs_to :debit_item, class_name: 'Item'
  belongs_to :debit_sub_item, class_name: 'SubItem'
end
