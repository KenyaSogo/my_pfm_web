class SumByAcctClassSetting < ApplicationRecord
  belongs_to :sum_by_account_class
  has_many :simulation_acct_classes, dependent: :destroy
  has_many :acct_to_class_maps, dependent: :destroy

  validate :validate_unity_within_simulation_summary, on: :create

  private

  def validate_unity_within_simulation_summary
    return if SumByAcctClassSetting.where(sum_by_account_class_id: sum_by_account_class.id).size == 0
    errors.add(:base, 'sum_by_acct_class_setting must be single')
  end
end
