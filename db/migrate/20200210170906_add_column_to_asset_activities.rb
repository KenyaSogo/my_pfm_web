class AddColumnToAssetActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :asset_activities, :unique_key, :string, after: :is_calculation_target
  end
end
