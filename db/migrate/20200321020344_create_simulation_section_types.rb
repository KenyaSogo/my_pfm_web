class CreateSimulationSectionTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :simulation_section_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
