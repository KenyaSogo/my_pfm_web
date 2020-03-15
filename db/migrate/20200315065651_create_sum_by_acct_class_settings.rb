class CreateSumByAcctClassSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :sum_by_acct_class_settings do |t|
      t.references :sum_by_account_class, foreign_key: true

      t.timestamps
    end
  end
end
