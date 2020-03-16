class AcctToClassMap < ApplicationRecord
  belongs_to :sum_by_acct_class_setting
  belongs_to :asset_account
  belongs_to :simulation_acct_class

  validates :asset_account_id, presence: true, inclusion: { in: :related_asset_account_ids }, uniqueness: { scope: :sum_by_acct_class_setting }
  validates :simulation_acct_class_id, inclusion: { in: :related_simulation_acct_class_ids }, allow_nil: true

  private

  def related_asset_account_ids
    sum_by_acct_class_setting.sum_by_account_class.simulation_summary.simulation.asset.asset_accounts.pluck(:id)
  end

  def related_simulation_acct_class_ids
    sum_by_acct_class_setting.simulation_acct_classes.pluck(:id)
  end
end
