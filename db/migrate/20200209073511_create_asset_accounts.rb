class CreateAssetAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :asset_accounts do |t|
      t.references :asset, foreign_key: true
      t.references :asset_type, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
