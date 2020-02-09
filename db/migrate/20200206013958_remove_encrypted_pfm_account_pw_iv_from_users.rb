class RemoveEncryptedPfmAccountPwIvFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :encrypted_pfm_account_pw_iv, :string
  end
end
