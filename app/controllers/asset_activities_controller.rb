class AssetActivitiesController < ApplicationController
  before_action :sign_in_required
  before_action :set_asset_activity, only: [:show, :edit, :update, :destroy]
  before_action -> { current_users_resource_filter(@asset_activity.asset_account.asset) }, only: [:show, :edit, :update, :destroy]

  # GET /asset_activities
  # GET /asset_activities.json
  def index
    if params[:asset_id].present?
      asset = Asset.find(params[:asset_id])
      current_users_resource_filter(asset)
      @asset_activities = AssetActivity.where(asset_account_id: asset.asset_accounts.map(&:id)).page(params[:page]).per(30).order(transaction_date: :desc)
    end
  end

  # GET /asset_activities/1
  # GET /asset_activities/1.json
  def show
  end

  # GET /asset_activities/new
  def new
    @asset_activity = AssetActivity.new
  end

  # GET /asset_activities/1/edit
  def edit
  end

  # POST /asset_activities
  # POST /asset_activities.json
  def create
    @asset_activity = AssetActivity.new(asset_activity_params)

    respond_to do |format|
      if @asset_activity.save
        format.html { redirect_to @asset_activity, notice: 'Asset activity was successfully created.' }
        format.json { render :show, status: :created, location: @asset_activity }
      else
        format.html { render :new }
        format.json { render json: @asset_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /asset_activities/1
  # PATCH/PUT /asset_activities/1.json
  def update
    respond_to do |format|
      if @asset_activity.update(asset_activity_params)
        format.html { redirect_to @asset_activity, notice: 'Asset activity was successfully updated.' }
        format.json { render :show, status: :ok, location: @asset_activity }
      else
        format.html { render :edit }
        format.json { render json: @asset_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /asset_activities/1
  # DELETE /asset_activities/1.json
  def destroy
    @asset_activity.destroy
    respond_to do |format|
      format.html { redirect_to asset_activities_url, notice: 'Asset activity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_asset_activity
      @asset_activity = AssetActivity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asset_activity_params
      params.require(:asset_activity).permit(:asset_account_id, :transaction_date, :description, :amount, :item_id, :sub_item_id, :is_transfer, :is_calculation_target)
    end
end
