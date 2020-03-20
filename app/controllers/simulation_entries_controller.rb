class SimulationEntriesController < ApplicationController
  before_action :set_simulation, only: [:index, :new, :create]
  before_action -> { current_users_resource_filter(@simulation.asset) }, only: [:index, :new, :create]
  before_action :set_simulation_entry, only: [:show, :edit, :update, :destroy]
  before_action -> { current_users_resource_filter(@simulation_entry.simulation.asset) }, only: [:show, :edit, :update, :destroy]

  # GET /simulation_entries
  # GET /simulation_entries.json
  def index
    @simulation_entries = SimulationEntry.where(simulation_id: @simulation.id)
  end

  # GET /simulation_entries/1
  # GET /simulation_entries/1.json
  def show
    @simulation_entry_details = @simulation_entry.simulation_entry_details.page(params[:page]).per(30)
      .order(transaction_date_year: :desc)
      .order(transaction_date_month: :desc)
      .order(transaction_date_day: :desc)
      .order(transaction_date_weekday: :desc)
    @result_activity_counts_by_entry_detail = SimulationEntry.where(id: @simulation_entry.id)
      .joins(simulation_entry_details: :simulation_result_activities).group('simulation_entry_details.id').size
  end

  # GET /simulation_entries/new
  def new
    @simulation_entry = SimulationEntry.new
  end

  # GET /simulation_entries/1/edit
  def edit
  end

  # POST /simulation_entries
  # POST /simulation_entries.json
  def create
    @simulation_entry = SimulationEntry.new(simulation_entry_params)
    @simulation_entry.simulation = @simulation

    respond_to do |format|
      if @simulation_entry.save
        format.html { redirect_to @simulation_entry, notice: 'Simulation entry was successfully created.' }
        format.json { render :show, status: :created, location: @simulation_entry }
      else
        format.html { render :new }
        format.json { render json: @simulation_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /simulation_entries/1
  # PATCH/PUT /simulation_entries/1.json
  def update
    respond_to do |format|
      if @simulation_entry.update(simulation_entry_params)
        format.html { redirect_to @simulation_entry, notice: 'Simulation entry was successfully updated.' }
        format.json { render :show, status: :ok, location: @simulation_entry }
      else
        format.html { render :edit }
        format.json { render json: @simulation_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /simulation_entries/1
  # DELETE /simulation_entries/1.json
  def destroy
    simulation = @simulation_entry.simulation
    @simulation_entry.destroy
    respond_to do |format|
      format.html { redirect_to simulation, notice: 'Simulation entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_simulation
      simulation_id = params[:simulation_id] || params[:simulation_entry][:simulation_id]
      @simulation = Simulation.find(simulation_id)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_simulation_entry
      @simulation_entry = SimulationEntry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def simulation_entry_params
      params.require(:simulation_entry).permit(:name, :simulation_entry_type_id, :apply_from, :apply_to)
    end
end
