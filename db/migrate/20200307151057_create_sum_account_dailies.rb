class CreateSumAccountDailies < ActiveRecord::Migration[5.0]
  def change
    create_table :sum_account_dailies do |t|
      t.references :simulation_summary_by_account, foreign_key: true
      t.date :base_date
      t.references :asset_account, foreign_key: true
      t.bigint :balance

      t.timestamps
    end
  end
end
