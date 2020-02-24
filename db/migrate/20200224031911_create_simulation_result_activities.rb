class CreateSimulationResultActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :simulation_result_activities do |t|
      t.references :simulation_entry_detail, foreign_key: true
      t.references :asset_account, foreign_key: true
      t.date :transaction_date
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
