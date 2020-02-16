class SimulationEntryDetail < ApplicationRecord
  belongs_to :simulation_entry
  belongs_to :asset_account
  belongs_to :item
  belongs_to :sub_item
end
