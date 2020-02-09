class AddPfmAccountPasswordToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :encrypted_pfm_account_password, :string
    add_column :users, :encrypted_pfm_account_password_iv, :string
  end
end
