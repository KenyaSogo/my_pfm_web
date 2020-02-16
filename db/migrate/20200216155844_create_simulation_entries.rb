class CreateSimulationEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :simulation_entries do |t|
      t.references :simulation, foreign_key: true
      t.string :name
      t.references :simulation_entry_type, foreign_key: true
      t.date :apply_from
      t.date :apply_to

      t.timestamps
    end
  end
end
