class CreateAcctToClassMaps < ActiveRecord::Migration[5.0]
  def change
    create_table :acct_to_class_maps do |t|
      t.references :sum_by_acct_class_setting, foreign_key: true
      t.references :asset_account, foreign_key: true
      t.references :simulation_acct_class, foreign_key: true

      t.timestamps
    end
  end
end
