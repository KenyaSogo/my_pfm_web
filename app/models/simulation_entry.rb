class SimulationEntry < ApplicationRecord
  belongs_to :simulation
  belongs_to :simulation_entry_type
end
