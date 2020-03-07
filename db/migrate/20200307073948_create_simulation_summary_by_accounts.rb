class CreateSimulationSummaryByAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :simulation_summary_by_accounts do |t|
      t.references :simulation_summary, foreign_key: true
      t.boolean :is_active
      t.text :memo

      t.timestamps
    end
  end
end
