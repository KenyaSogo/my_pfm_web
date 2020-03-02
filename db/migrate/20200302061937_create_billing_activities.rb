class CreateBillingActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :billing_activities do |t|
      t.references :billing_account, foreign_key: true
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
