class AssetAccountsController < ApplicationController
  before_action :sign_in_required
  before_action :set_asset_account, only: [:show, :edit, :update, :destroy]
  before_action -> { current_users_resource_filter(@asset_account.asset) }, only: [:show, :edit, :update, :destroy]

  # GET /asset_accounts
  # GET /asset_accounts.json
  def index
    # @asset_accounts = AssetAccount.all
  end

  # GET /asset_accounts/1
  # GET /asset_accounts/1.json
  def show
    @asset_activities = @asset_account.asset_activities.page(params[:page]).per(30).order(transaction_date: :desc)
  end

  # GET /asset_accounts/new
  def new
    @asset_account = AssetAccount.new
  end

  # GET /asset_accounts/1/edit
  def edit
  end

  # POST /asset_accounts
  # POST /asset_accounts.json
  def create
    @asset_account = AssetAccount.new(asset_account_params)

    respond_to do |format|
      if @asset_account.save
        format.html { redirect_to @asset_account, notice: 'Asset account was successfully created.' }
        format.json { render :show, status: :created, location: @asset_account }
      else
        format.html { render :new }
        format.json { render json: @asset_account.errors, status: :unprocessable_entity }
      end
    end
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

  # DELETE /asset_accounts/1
  # DELETE /asset_accounts/1.json
  def destroy
    @asset_account.destroy
    respond_to do |format|
      format.html { redirect_to asset_accounts_url, notice: 'Asset account was successfully destroyed.' }
      format.json { head :no_content }
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
