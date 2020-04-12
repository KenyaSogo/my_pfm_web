class SumByAcctClassSettingsController < ApplicationController
  before_action :sign_in_required
  before_action :set_sum_by_acct_class_setting, only: [:show]
  before_action -> { current_users_resource_filter(@sum_by_acct_class_setting.sum_by_account_class.simulation_summary.simulation.asset) }, only: [:show]
  before_action :set_current_menu

  # GET /sum_by_acct_class_settings/1
  # GET /sum_by_acct_class_settings/1.json
  def show
    @asset_accounts = @sum_by_acct_class_setting.sum_by_account_class.simulation_summary.simulation.asset.asset_accounts
    @acct_to_class_maps = @sum_by_acct_class_setting.acct_to_class_maps

    (@asset_accounts.pluck(:id) - @acct_to_class_maps.pluck(:asset_account_id)).each do |asset_account_id|
      AcctToClassMap.create!(sum_by_acct_class_setting_id: @sum_by_acct_class_setting.id, asset_account_id: asset_account_id)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sum_by_acct_class_setting
      @sum_by_acct_class_setting = SumByAcctClassSetting.find(params[:id])
    end

    def set_current_menu
      @current_menu = :summary
    end
end
