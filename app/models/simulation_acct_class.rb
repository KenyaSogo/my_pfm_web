class SimulationAcctClass < ApplicationRecord
  belongs_to :sum_by_acct_class_setting

  validates :name, presence: true, uniqueness: { scope: :sum_by_acct_class_setting }
end
