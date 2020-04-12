class SimulationsController < ApplicationController
  before_action :sign_in_required
  before_action :set_asset, only: [:new, :create]
  before_action -> { current_users_resource_filter(@asset) }, only: [:new, :create]
  before_action :set_simulation, only: [:show, :edit, :update, :destroy, :generate]
  before_action -> { current_users_resource_filter(@simulation.asset) }, only: [:show, :edit, :update, :destroy, :generate]

  # GET /simulations/1
  # GET /simulations/1.json
  def show
    current_user.current_simulation = @simulation
    current_user.save!

    @entry_detail_counts_by_simulation_entry = Simulation.where(id: @simulation.id)
      .joins(simulation_entries: :simulation_entry_details).group('simulation_entries.id').size
    @result_activity_counts_by_simulation_entry = Simulation.where(id: @simulation.id)
      .joins(simulation_entries: { simulation_entry_details: :simulation_result_activities }).group('simulation_entries.id').size
    billing_activity_counts_by_billing_account = Simulation.where(id: @simulation.id)
      .joins(billing_accounts: :billing_activities).group('billing_accounts.id').size
    billing_complement_activity_counts_by_billing_account = Simulation.where(id: @simulation.id)
      .joins(billing_accounts: :billing_complement_activities).group('billing_accounts.id').size
    @billing_activity_counts_by_billing_account = (billing_activity_counts_by_billing_account.keys | billing_complement_activity_counts_by_billing_account.keys).each_with_object({}) do |billing_account_id, h|
      h[billing_account_id] = (billing_activity_counts_by_billing_account[billing_account_id].presence || 0) + (billing_complement_activity_counts_by_billing_account[billing_account_id].presence || 0)
    end
  end

  # GET /simulations/new
  def new
    @simulation = Simulation.new
  end

  # GET /simulations/1/edit
  def edit
  end

  # POST /simulations
  # POST /simulations.json
  def create
    @simulation = Simulation.new(simulation_params)
    @simulation.asset = @asset

    respond_to do |format|
      if @simulation.save
        format.html { redirect_to @simulation, notice: 'Simulation was successfully created.' }
        format.json { render :show, status: :created, location: @simulation }
      else
        format.html { render :new }
        format.json { render json: @simulation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /simulations/1
  # PATCH/PUT /simulations/1.json
  def update
    respond_to do |format|
      if @simulation.update(simulation_params)
        format.html { redirect_to @simulation, notice: 'Simulation was successfully updated.' }
        format.json { render :show, status: :ok, location: @simulation }
      else
        format.html { render :edit }
        format.json { render json: @simulation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /simulations/1
  # DELETE /simulations/1.json
  def destroy
    asset = @simulation.asset
    @simulation.destroy
    respond_to do |format|
      format.html { redirect_to asset, notice: 'Simulation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def generate
    if @simulation.asset.asset_accounts.any? { |a| a.asset_type.blank? }
      respond_to do |format|
        format.html { redirect_to @simulation, alert: 'There is unset asset account.' and return }
        format.json { head :no_content }
      end
    end

    job = SimulationResultGenerateJob.perform_later(@simulation.id)
    @simulation.update!(last_job_id: job.job_id)

    respond_to do |format|
      format.html { redirect_to @simulation, notice: 'Simulation generate was successfully kicked.' }
      format.json { head :no_content }
    end
  end

  private
    def set_asset
      asset_id = params[:asset_id] || params[:simulation][:asset_id]
      @asset = Asset.find(asset_id)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_simulation
      if params[:from_menu]
        @simulation = Simulation.where(id: params[:id]).first || current_user.current_asset&.simulations&.first
        if @simulation.blank?
          redirect_to homes_show_path, alert: 'Simulation is not exists.'
        end
      else
        @simulation = Simulation.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def simulation_params
      params.require(:simulation).permit(:name)
    end
end
