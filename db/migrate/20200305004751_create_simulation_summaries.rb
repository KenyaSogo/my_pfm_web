class CreateSimulationSummaries < ActiveRecord::Migration[5.0]
  def change
    create_table :simulation_summaries do |t|
      t.references :simulation, foreign_key: true
      t.datetime :summarized_at

      t.timestamps
    end
  end
end
