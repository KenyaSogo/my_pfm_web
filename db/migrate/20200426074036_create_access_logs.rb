class CreateAccessLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :access_logs do |t|
      t.datetime :accessed_at
      t.integer :user_id
      t.integer :asset_id
      t.integer :simulation_id
      t.string :controller_name
      t.string :action_name
      t.string :accessed_url
      t.string :referer_url

      t.timestamps
    end
  end
end
