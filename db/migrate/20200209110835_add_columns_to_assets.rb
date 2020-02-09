class AddColumnsToAssets < ActiveRecord::Migration[5.0]
  def change
    add_column :assets, :name, :string
  end
end
