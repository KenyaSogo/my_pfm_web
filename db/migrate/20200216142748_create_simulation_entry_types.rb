class CreateSimulationEntryTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :simulation_entry_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
