class SumByAccountClass < ApplicationRecord
  belongs_to :simulation_summary
  has_one :sum_by_acct_class_setting, dependent: :destroy
  has_many :sum_acct_class_dailies, dependent: :destroy

  before_validation :set_is_active_true, on: :create

  validates :name, presence: true, uniqueness: { scope: :simulation_summary }
  validates :memo, length: { maximum: 400 }

  after_create :create_sum_by_acct_class_setting

  private

  def set_is_active_true
    self.is_active = true
  end

  def create_sum_by_acct_class_setting
    SumByAcctClassSetting.create!(sum_by_account_class_id: id)
  end
end
