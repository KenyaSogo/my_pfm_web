class AddInitialBalanceBaseDateToAssetAccount < ActiveRecord::Migration[5.0]
  def change
    add_column :asset_accounts, :initial_balance_base_date, :datetime
  end
end
