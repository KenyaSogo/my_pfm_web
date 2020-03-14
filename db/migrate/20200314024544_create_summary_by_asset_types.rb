class CreateSummaryByAssetTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :summary_by_asset_types do |t|
      t.references :simulation_summary, foreign_key: true
      t.boolean :is_active
      t.text :memo
      t.datetime :summarized_at

      t.timestamps
    end
  end
end
