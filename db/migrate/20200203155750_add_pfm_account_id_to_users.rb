class AddPfmAccountIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :pfm_account_id, :string
  end
end
