class AddInitialBalanceToAssetAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :asset_accounts, :initial_balance, :bigint
  end
end
