class RenameEncryptedPfmAccountPasswordColumnToUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :encrypted_pfm_account_password, :encrypted_pfm_account_pw
    rename_column :users, :encrypted_pfm_account_password_iv, :encrypted_pfm_account_pw_iv
  end
end
