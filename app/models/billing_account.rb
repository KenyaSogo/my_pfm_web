class BillingAccount < ApplicationRecord
  belongs_to :simulation
  belongs_to :credit_account, class_name: 'AssetAccount'
  belongs_to :billing_item, class_name: 'Item'
  belongs_to :billing_sub_item, class_name: 'SubItem'
  belongs_to :debit_account, class_name: 'AssetAccount'
  belongs_to :debit_item, class_name: 'Item'
  belongs_to :debit_sub_item, class_name: 'SubItem'

  validates :simulation, :credit_account, :billing_closing_day, :withdrawal_day, :withdrawal_month_offset,
    :billing_item, :billing_sub_item, :debit_account, :debit_item, :debit_sub_item, presence: true
  validate :validation_abort_if_errors_present
  validates :credit_account, uniqueness: { scope: :simulation }
  validates :credit_account_id, inclusion: { in: :related_asset_account_ids }
  validates :billing_closing_day, :withdrawal_day, inclusion: { in: 1..31 }
  validates :withdrawal_month_offset, inclusion: { in: 0..12 }
  validates :withdrawal_month_offset, numericality: { greater_than_or_equal_to: 1, if: :after_next_month_withdrawal_day? }
  validates :billing_item_id, :debit_item_id, inclusion: { in: :related_item_ids }
  validates :billing_sub_item_id, inclusion: { in: :related_billing_sub_item_ids, message: 'is not related with item' }
  validates :debit_account_id, inclusion: { in: :related_debit_account_ids }
  validates :debit_sub_item_id, inclusion: { in: :related_debit_sub_item_ids, message: 'is not related with item' }

  private

  def validation_abort_if_errors_present
    throw :abort if errors.present?
  end

  def related_asset_account_ids
    simulation.asset.asset_accounts.map(&:id)
  end

  def after_next_month_withdrawal_day?
    billing_closing_day > withdrawal_day
  end

  def related_item_ids
    simulation.asset.items.map(&:id)
  end

  def related_billing_sub_item_ids
    billing_item.sub_items.map(&:id)
  end

  def related_debit_account_ids
    related_asset_account_ids - [credit_account_id]
  end

  def related_debit_sub_item_ids
    debit_item.sub_items.map(&:id)
  end
end
