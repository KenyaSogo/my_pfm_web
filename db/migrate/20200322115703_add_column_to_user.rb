class AddColumnToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :current_asset_id, :integer
    add_column :users, :current_simulation_id, :integer
  end
end
