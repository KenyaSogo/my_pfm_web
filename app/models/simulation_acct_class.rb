class SimulationAcctClass < ApplicationRecord
  belongs_to :sum_by_acct_class_setting

  before_destroy :abort_destroy_if_mapped_to_asset_account

  validates :name, presence: true, uniqueness: { scope: :sum_by_acct_class_setting }

  private

  def abort_destroy_if_mapped_to_asset_account
    if sum_by_acct_class_setting.acct_to_class_maps.where(simulation_acct_class_id: id).exists?
      errors.add(:base, 'Account class mapped to asset_account cant destroy')
      throw(:abort)
    end
  end
end
