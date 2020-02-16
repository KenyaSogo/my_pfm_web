class CreateSimulationEntryDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :simulation_entry_details do |t|
      t.references :simulation_entry, foreign_key: true
      t.references :asset_account, foreign_key: true
      t.integer :transaction_date_year
      t.integer :transaction_date_month
      t.integer :transaction_date_day
      t.integer :transaction_date_weekday
      t.text :description
      t.bigint :amount
      t.references :item, foreign_key: true
      t.references :sub_item, foreign_key: true
      t.boolean :is_transfer
      t.boolean :is_calculation_target

      t.timestamps
    end
  end
end
