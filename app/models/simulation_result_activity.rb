class SimulationResultActivity < ApplicationRecord
  belongs_to :simulation_entry_detail
  belongs_to :asset_account
  belongs_to :item
  belongs_to :sub_item
end
