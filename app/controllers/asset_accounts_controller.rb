class AssetAccountsController < ApplicationController
  before_action :sign_in_required
  before_action :set_asset_account, only: [:show, :edit, :update]
  before_action -> { current_users_resource_filter(@asset_account.asset) }, only: [:show, :edit, :update]

  # GET /asset_accounts/1
  # GET /asset_accounts/1.json
  def show
    @asset_activities = @asset_account.asset_activities.page(params[:page]).per(30).order(transaction_date: :desc)
  end

  # GET /asset_accounts/1/edit
  def edit
  end

  # PATCH/PUT /asset_accounts/1
  # PATCH/PUT /asset_accounts/1.json
  def update
    respond_to do |format|
      if @asset_account.update(asset_account_params)
        format.html { redirect_to @asset_account, notice: 'Asset account was successfully updated.' }
        format.json { render :show, status: :ok, location: @asset_account }
      else
        format.html { render :edit }
        format.json { render json: @asset_account.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_asset_account
      @asset_account = AssetAccount.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asset_account_params
      params.require(:asset_account).permit(:asset_type_id, :initial_balance, :initial_balance_base_date)
    end
end
