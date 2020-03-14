class CreateSumAssetTypeDailies < ActiveRecord::Migration[5.0]
  def change
    create_table :sum_asset_type_dailies do |t|
      t.references :summary_by_asset_type, foreign_key: true
      t.date :base_date
      t.references :asset_type, foreign_key: true
      t.bigint :balance

      t.timestamps
    end
  end
end
