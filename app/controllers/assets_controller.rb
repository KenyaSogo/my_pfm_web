class AssetsController < ApplicationController
  before_action :sign_in_required
  before_action :set_asset, only: [:show, :edit, :update, :destroy, :aggregate, :aggregate_status]
  before_action -> { current_users_resource_filter(@asset) }, only: [:show, :edit, :update, :destroy, :aggregate, :aggregate_status]
  before_action :set_current_menu

  # GET /assets
  # GET /assets.json
  def index
    @assets = Asset.where(user_id: current_user.id)
    @asset_activity_counts = @assets.joins(asset_accounts: :asset_activities).group(:id).size
  end

  # GET /assets/1
  # GET /assets/1.json
  def show
    current_user.current_asset = @asset
    current_user.current_simulation = nil if current_user.current_asset_id_changed?
    current_user.save!

    @asset_activity_count = Asset.where(id: @asset.id).joins(asset_accounts: :asset_activities).size
    @asset_activity_counts_by_account = Asset.where(id: @asset.id).joins(asset_accounts: :asset_activities).group('asset_accounts.id').size
    @entry_detail_counts_by_simulation = Asset.where(id: @asset.id).joins(simulations: { simulation_entries: :simulation_entry_details }).group('simulations.id').size
    @result_activity_counts_by_simulation = Asset.where(id: @asset.id).joins(simulations: { simulation_entries: { simulation_entry_details: :simulation_result_activities } }).group('simulations.id').size
    @billing_account_counts_by_simulation = Asset.where(id: @asset.id).joins(simulations: :billing_accounts).group('simulations.id').size
    billing_activity_counts_by_simulation = Asset.where(id: @asset.id).joins(simulations: { billing_accounts: :billing_activities }).group('simulations.id').size
    billing_complement_activity_counts_by_simulation = Asset.where(id: @asset.id).joins(simulations: { billing_accounts: :billing_complement_activities }).group('simulations.id').size
    @billing_activity_counts_by_simulation = (billing_activity_counts_by_simulation.keys | billing_complement_activity_counts_by_simulation.keys).each_with_object({}) do |simulation_id, h|
      h[simulation_id] = (billing_activity_counts_by_simulation[simulation_id].presence || 0) + (billing_complement_activity_counts_by_simulation[simulation_id].presence || 0)
    end
  end

  # GET /assets/new
  def new
    @asset = Asset.new
  end

  # GET /assets/1/edit
  def edit
  end

  # POST /assets
  # POST /assets.json
  def create
    @asset = Asset.new(asset_params)
    @asset.user = current_user

    respond_to do |format|
      if @asset.save
        format.html { redirect_to @asset, notice: 'Asset was successfully created.' }
        format.json { render :show, status: :created, location: @asset }
      else
        format.html { render :new }
        format.json { render json: @asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assets/1
  # PATCH/PUT /assets/1.json
  def update
    respond_to do |format|
      if @asset.update(asset_params)
        format.html { redirect_to @asset, notice: 'Asset was successfully updated.' }
        format.json { render :show, status: :ok, location: @asset }
      else
        format.html { render :edit }
        format.json { render json: @asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assets/1
  # DELETE /assets/1.json
  def destroy
    @asset.destroy
    respond_to do |format|
      format.html { redirect_to assets_url, notice: 'Asset was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def aggregate
    job = ScrapeMyPfmJob.perform_later(@asset.user.id, @asset.id)
    @asset.update!(last_job_id: job.job_id)

    respond_to do |format|
      format.html { redirect_to @asset, notice: 'Asset Aggregation was successfully kicked.' }
      format.json { head :no_content }
    end
  end

  def aggregate_status
    render partial: 'aggregate_status'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_asset
      if params[:from_menu]
        @asset = Asset.where(id: params[:id]).first || current_user.assets.first
        if @asset.blank?
          redirect_to assets_url, notice: 'There is no assets.'
        end
      else
        @asset = Asset.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asset_params
      params.require(:asset).permit(:name)
    end

    def set_current_menu
      @current_menu = :asset
    end
end
