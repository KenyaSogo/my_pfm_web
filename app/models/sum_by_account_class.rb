class SumByAccountClass < ApplicationRecord
  belongs_to :simulation_summary
  has_one :sum_by_acct_class_setting, dependent: :destroy

  before_validation :set_is_active_true, on: :create

  validates :name, presence: true, uniqueness: { scope: :simulation_summary }
  validates :memo, length: { maximum: 400 }

  private

  def set_is_active_true
    self.is_active = true
  end
end
