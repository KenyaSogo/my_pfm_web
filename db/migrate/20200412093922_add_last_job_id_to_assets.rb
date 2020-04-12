class AddLastJobIdToAssets < ActiveRecord::Migration[5.0]
  def change
    add_column :assets, :last_job_id, :string
  end
end
