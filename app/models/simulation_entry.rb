class SimulationEntry < ApplicationRecord
  belongs_to :simulation
  belongs_to :simulation_entry_type
  has_many :simulation_entry_details, dependent: :destroy
end
