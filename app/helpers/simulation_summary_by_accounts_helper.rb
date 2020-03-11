module SimulationSummaryByAccountsHelper
  def asset_account_options(simulation_summary_by_account)
    asset_account_ids = simulation_summary_by_account.sum_account_dailies.select(:asset_account_id).distinct.pluck(:asset_account_id)
    AssetAccount.where(id: asset_account_ids).map { |asset_account| [asset_account.name, asset_account.id] }.to_h
  end
end
