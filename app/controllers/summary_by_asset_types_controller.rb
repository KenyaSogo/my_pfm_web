class SummaryByAssetTypesController < ApplicationController
  before_action :set_summary_by_asset_type, only: [:show, :edit, :update, :destroy]
  before_action -> { current_users_resource_filter(@summary_by_asset_type.simulation_summary.simulation.asset) }, only: [:show, :edit, :update, :destroy, :generate]

  # GET /summary_by_asset_types
  # GET /summary_by_asset_types.json
  def index
    @summary_by_asset_types = SummaryByAssetType.all
  end

  # GET /summary_by_asset_types/1
  # GET /summary_by_asset_types/1.json
  def show
    @query = @summary_by_asset_type.sum_asset_type_dailies.ransack(asset_type_id_condition)
    @data = @query.result.pluck(:base_date, :balance)
  end

  # GET /summary_by_asset_types/new
  def new
    @summary_by_asset_type = SummaryByAssetType.new
  end

  # GET /summary_by_asset_types/1/edit
  def edit
  end

  # POST /summary_by_asset_types
  # POST /summary_by_asset_types.json
  def create
    @summary_by_asset_type = SummaryByAssetType.new(summary_by_asset_type_params)

    respond_to do |format|
      if @summary_by_asset_type.save
        format.html { redirect_to @summary_by_asset_type, notice: 'Summary by asset type was successfully created.' }
        format.json { render :show, status: :created, location: @summary_by_asset_type }
      else
        format.html { render :new }
        format.json { render json: @summary_by_asset_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /summary_by_asset_types/1
  # PATCH/PUT /summary_by_asset_types/1.json
  def update
    respond_to do |format|
      if @summary_by_asset_type.update(summary_by_asset_type_params)
        format.html { redirect_to @summary_by_asset_type, notice: 'Simulation summary by asset type was successfully updated.' }
        format.json { render :show, status: :ok, location: @summary_by_asset_type }
      else
        format.html { render :edit }
        format.json { render json: @summary_by_asset_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /summary_by_asset_types/1
  # DELETE /summary_by_asset_types/1.json
  def destroy
    @summary_by_asset_type.destroy
    respond_to do |format|
      format.html { redirect_to summary_by_asset_types_url, notice: 'Summary by asset type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def asset_type_id_condition
      if params[:q]&.has_key?(:asset_type_id_eq)
        if params[:q][:asset_type_id_eq].present?
          params[:q]
        else
          { asset_type_id_null: true }
        end
      else
        { asset_type_id_eq: @summary_by_asset_type.sum_asset_type_dailies.select(:asset_type_id).distinct.map(&:asset_type_id).compact.min }
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_summary_by_asset_type
      @summary_by_asset_type = SummaryByAssetType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def summary_by_asset_type_params
      params.require(:summary_by_asset_type).permit(:is_active, :memo)
    end
end
