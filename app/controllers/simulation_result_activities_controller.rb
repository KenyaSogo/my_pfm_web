class SimulationResultActivitiesController < ApplicationController
  before_action :set_simulation_result_activity, only: [:show, :edit, :update, :destroy]

  # GET /simulation_result_activities
  # GET /simulation_result_activities.json
  def index
    @simulation_result_activities = SimulationResultActivity.all
  end

  # GET /simulation_result_activities/1
  # GET /simulation_result_activities/1.json
  def show
  end

  # GET /simulation_result_activities/new
  def new
    @simulation_result_activity = SimulationResultActivity.new
  end

  # GET /simulation_result_activities/1/edit
  def edit
  end

  # POST /simulation_result_activities
  # POST /simulation_result_activities.json
  def create
    @simulation_result_activity = SimulationResultActivity.new(simulation_result_activity_params)

    respond_to do |format|
      if @simulation_result_activity.save
        format.html { redirect_to @simulation_result_activity, notice: 'Simulation result activity was successfully created.' }
        format.json { render :show, status: :created, location: @simulation_result_activity }
      else
        format.html { render :new }
        format.json { render json: @simulation_result_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /simulation_result_activities/1
  # PATCH/PUT /simulation_result_activities/1.json
  def update
    respond_to do |format|
      if @simulation_result_activity.update(simulation_result_activity_params)
        format.html { redirect_to @simulation_result_activity, notice: 'Simulation result activity was successfully updated.' }
        format.json { render :show, status: :ok, location: @simulation_result_activity }
      else
        format.html { render :edit }
        format.json { render json: @simulation_result_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /simulation_result_activities/1
  # DELETE /simulation_result_activities/1.json
  def destroy
    @simulation_result_activity.destroy
    respond_to do |format|
      format.html { redirect_to simulation_result_activities_url, notice: 'Simulation result activity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_simulation_result_activity
      @simulation_result_activity = SimulationResultActivity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def simulation_result_activity_params
      params.require(:simulation_result_activity).permit(:simulation_entry_detail_id, :asset_account_id, :transaction_date, :description, :amount, :item_id, :sub_item_id, :is_transfer, :is_calculation_target)
    end
end
