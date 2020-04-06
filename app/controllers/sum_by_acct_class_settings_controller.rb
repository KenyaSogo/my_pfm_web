class SumByAcctClassSettingsController < ApplicationController
  before_action :sign_in_required
  before_action :set_sum_by_acct_class_setting, only: [:show]
  before_action -> { current_users_resource_filter(@sum_by_acct_class_setting.sum_by_account_class.simulation_summary.simulation.asset) }, only: [:show]

  # GET /sum_by_acct_class_settings/1
  # GET /sum_by_acct_class_settings/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sum_by_acct_class_setting
      @sum_by_acct_class_setting = SumByAcctClassSetting.find(params[:id])
    end
end
