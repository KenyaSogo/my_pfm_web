class RenameEncryptedPfmAccountPwColumnToUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :encrypted_pfm_account_pw, :encrypted_pfm_account_password
    rename_column :users, :encrypted_pfm_account_pw_iv, :encrypted_pfm_account_password_iv
  end
end
