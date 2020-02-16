class SimulationEntryDetailsController < ApplicationController
  before_action :set_simulation_entry_detail, only: [:show, :edit, :update, :destroy]

  # GET /simulation_entry_details
  # GET /simulation_entry_details.json
  def index
    @simulation_entry_details = SimulationEntryDetail.all
  end

  # GET /simulation_entry_details/1
  # GET /simulation_entry_details/1.json
  def show
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
    @simulation_entry_detail.destroy
    respond_to do |format|
      format.html { redirect_to simulation_entry_details_url, notice: 'Simulation entry detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_simulation_entry_detail
      @simulation_entry_detail = SimulationEntryDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def simulation_entry_detail_params
      params.require(:simulation_entry_detail).permit(:simulation_entry_id, :asset_account_id, :transaction_date_year, :transaction_date_month, :transaction_date_day, :transaction_date_weekday, :description, :amount, :item_id, :sub_item_id, :is_transfer, :is_calculation_target)
    end
end
