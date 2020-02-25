class SimulationEntryDetailsController < ApplicationController
  before_action :set_simulation_entry, only: [:index, :new, :create]
  before_action -> { current_users_resource_filter(@simulation_entry.simulation.asset) }, only: [:index, :new, :create]
  before_action :set_simulation_entry_detail, only: [:show, :edit, :update, :destroy]
  before_action -> { current_users_resource_filter(@simulation_entry_detail.simulation_entry.simulation.asset) }, only: [:show, :edit, :update, :destroy]

  # GET /simulation_entry_details
  # GET /simulation_entry_details.json
  def index
    @simulation_entry_details = SimulationEntryDetail.where(simulation_entry_id: @simulation_entry.id)
  end

  # GET /simulation_entry_details/1
  # GET /simulation_entry_details/1.json
  def show
    @simulation_result_activities = @simulation_entry_detail.simulation_result_activities.page(params[:page]).per(30).order(transaction_date: :desc)
  end

  # GET /simulation_entry_details/new
  def new
    @simulation_entry_detail = SimulationEntryDetail.new
  end

  # GET /simulation_entry_details/1/edit
  def edit
  end

  # POST /simulation_entry_details
  # POST /simulation_entry_details.json
  def create
    @simulation_entry_detail = SimulationEntryDetail.new(simulation_entry_detail_params)
    @simulation_entry_detail.simulation_entry = @simulation_entry

    respond_to do |format|
      if @simulation_entry_detail.save
        format.html { redirect_to @simulation_entry_detail, notice: 'Simulation entry detail was successfully created.' }
        format.json { render :show, status: :created, location: @simulation_entry_detail }
      else
        format.html { render :new }
        format.json { render json: @simulation_entry_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /simulation_entry_details/1
  # PATCH/PUT /simulation_entry_details/1.json
  def update
    respond_to do |format|
      if @simulation_entry_detail.update(simulation_entry_detail_params)
        format.html { redirect_to @simulation_entry_detail, notice: 'Simulation entry detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @simulation_entry_detail }
      else
        format.html { render :edit }
        format.json { render json: @simulation_entry_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /simulation_entry_details/1
  # DELETE /simulation_entry_details/1.json
  def destroy
    simulation_entry = @simulation_entry_detail.simulation_entry
    @simulation_entry_detail.destroy
    respond_to do |format|
      format.html { redirect_to simulation_entry, notice: 'Simulation entry detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_simulation_entry
      simulation_entry_id = params[:simulation_entry_id] || params[:simulation_entry_detail][:simulation_entry_id]
      @simulation_entry = SimulationEntry.find(simulation_entry_id)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_simulation_entry_detail
      @simulation_entry_detail = SimulationEntryDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def simulation_entry_detail_params
      params.require(:simulation_entry_detail).permit(:asset_account_id, :transaction_date_year, :transaction_date_month, :transaction_date_day, :transaction_date_weekday, :description, :amount, :item_id, :sub_item_id, :is_transfer, :is_calculation_target)
    end
end
