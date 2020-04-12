class SummaryByAssetTypesController < ApplicationController
  before_action :sign_in_required
  before_action :set_summary_by_asset_type, only: [:show, :edit, :update]
  before_action -> { current_users_resource_filter(@summary_by_asset_type.simulation_summary.simulation.asset) }, only: [:show, :edit, :update]
  before_action :set_current_menu

  # GET /summary_by_asset_types/1
  # GET /summary_by_asset_types/1.json
  def show
    @query = @summary_by_asset_type.sum_asset_type_dailies.ransack(sum_asset_type_dailies_condition)
    @data = @query.result.pluck(:base_date, :balance)
  end

  # GET /summary_by_asset_types/1/edit
  def edit
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

  private
    def sum_asset_type_dailies_condition
      if params[:q].present?
        condition = params[:q][:asset_type_id_eq].blank? ? { asset_type_id_null: true } : { asset_type_id_eq: params[:q][:asset_type_id_eq] }
        condition.merge!(
          {
            base_date_gteq: params[:q][:base_date_gteq],
            base_date_lteq: params[:q][:base_date_lteq],
          }
        )
      else
        today = Date.today
        {
          asset_type_id_eq: @summary_by_asset_type.sum_asset_type_dailies.select(:asset_type_id).distinct.map(&:asset_type_id).compact.min,
          base_date_gteq: today.ago(3.month),
          base_date_lteq: today.since(3.month),
        }
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

    def set_current_menu
      @current_menu = :summary
    end
end
