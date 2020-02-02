class RenameUsernameColumnToUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :username, :user_name
  end
end
