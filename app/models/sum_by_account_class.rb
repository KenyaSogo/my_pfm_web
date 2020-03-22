class SumByAccountClass < ApplicationRecord
  belongs_to :simulation_summary

  before_destroy :abort_destroy_if_mapped_to_simulation_summary

  has_many :sum_acct_class_dailies, dependent: :destroy
  has_one :sum_by_acct_class_setting, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :simulation_summary }
  validates :memo, length: { maximum: 400 }

  after_create :create_sum_by_acct_class_setting

  private

  def abort_destroy_if_mapped_to_simulation_summary
    if simulation_summary.main_breakdown_type_id == 3 && simulation_summary.main_breakdown_id == id
      errors.add(:base, 'ByAccountClass selected to main_breakdown cant destroy')
      throw(:abort)
    end
  end

  def create_sum_by_acct_class_setting
    SumByAcctClassSetting.create!(sum_by_account_class_id: id)
  end
end
