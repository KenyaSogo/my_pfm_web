class CreateBillingAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :billing_accounts do |t|
      t.references :simulation, foreign_key: true
      t.references :credit_account, foreign_key: { to_table: :asset_accounts }
      t.integer :billing_closing_day
      t.integer :withdrawal_day
      t.integer :withdrawal_month_offset
      t.references :billing_item, foreign_key: { to_table: :items }
      t.references :billing_sub_item, foreign_key: { to_table: :sub_items }
      t.references :debit_account, foreign_key: { to_table: :asset_accounts }
      t.references :debit_item, foreign_key: { to_table: :items }
      t.references :debit_sub_item, foreign_key: { to_table: :sub_items }

      t.timestamps
    end
  end
end
