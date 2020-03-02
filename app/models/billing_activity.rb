class BillingActivity < ApplicationRecord
  belongs_to :billing_account
  belongs_to :asset_account
  belongs_to :item
  belongs_to :sub_item

  validate :validate_account_and_date_uniqueness, on: :create

  private

  def validate_account_and_date_uniqueness
    return unless BillingActivity.where(asset_account_id: asset_account_id, transaction_date: transaction_date).exists?
    errors.add(:base, 'account and transaction_date must be unique')
  end
end
