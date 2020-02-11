class AddColumnToAsset < ActiveRecord::Migration[5.0]
  def change
    add_column :assets, :last_aggregate_started_at, :datetime, after: :name
    add_column :assets, :last_aggregate_succeeded_at, :datetime, after: :last_aggregate_started_at
  end
end
