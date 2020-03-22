class SimulationAcctClass < ApplicationRecord
  belongs_to :sum_by_acct_class_setting

  before_destroy :abort_destroy_if_mapped_to_asset_account
  before_destroy :abort_destroy_if_mapped_to_simulation_summary

  validates :name, presence: true, uniqueness: { scope: :sum_by_acct_class_setting }

  private

  def abort_destroy_if_mapped_to_simulation_summary
    simulation_summary = sum_by_acct_class_setting.sum_by_account_class.simulation_summary
    if simulation_summary.main_section_type_id == 3 && simulation_summary.main_section_id == id
      errors.add(:base, 'Account class mapped to main_section cant destroy')
      throw(:abort)
    end
  end

  def abort_destroy_if_mapped_to_asset_account
    if sum_by_acct_class_setting.acct_to_class_maps.where(simulation_acct_class_id: id).exists?
      errors.add(:base, 'Account class mapped to asset_account cant destroy')
      throw(:abort)
    end
  end
end
