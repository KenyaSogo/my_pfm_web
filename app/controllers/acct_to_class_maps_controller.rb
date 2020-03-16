class AcctToClassMapsController < ApplicationController
  before_action :set_acct_to_class_map, only: [:edit, :update]
  before_action -> { current_users_resource_filter(@acct_to_class_map.sum_by_acct_class_setting.sum_by_account_class.simulation_summary.simulation.asset) }, only: [:edit, :update]

  def edit
  end

  def update
    respond_to do |format|
      if @acct_to_class_map.update(acct_to_class_map_params)
        format.html { redirect_to @acct_to_class_map.sum_by_acct_class_setting, notice: 'Asset account classification was successfully updated.' }
        format.json { render :show, status: :ok, location: @acct_to_class_map.sum_by_acct_class_setting }
      else
        format.html { render :edit }
        format.json { render json: @acct_to_class_map.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_acct_to_class_map
    @acct_to_class_map = AcctToClassMap.find(params[:id])
  end

  def acct_to_class_map_params
    params.require(:acct_to_class_map).permit(:simulation_acct_class_id)
  end
end
