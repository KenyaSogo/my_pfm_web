class CreateSumAcctClassDailies < ActiveRecord::Migration[5.0]
  def change
    create_table :sum_acct_class_dailies do |t|
      t.references :sum_by_account_class, foreign_key: true
      t.date :base_date
      t.references :simulation_acct_class, foreign_key: true
      t.bigint :balance

      t.timestamps
    end
  end
end
