class CreateSumByAccountClasses < ActiveRecord::Migration[5.0]
  def change
    create_table :sum_by_account_classes do |t|
      t.references :simulation_summary, foreign_key: true
      t.string :name
      t.boolean :is_active
      t.text :memo
      t.datetime :summarized_at

      t.timestamps
    end
  end
end
