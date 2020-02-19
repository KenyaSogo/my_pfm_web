class SimulationsController < ApplicationController
  before_action :set_asset, only: [:index, :new, :create]
  before_action -> { current_users_resource_filter(@asset) }, only: [:index, :new, :create]
  before_action :set_simulation, only: [:show, :edit, :update, :destroy]
  before_action -> { current_users_resource_filter(@simulation.asset) }, only: [:show, :edit, :update, :destroy]

  # GET /simulations
  # GET /simulations.json
  def index
    @simulations = Simulation.where(asset_id: @asset.id)
  end

  # GET /simulations/1
  # GET /simulations/1.json
  def show
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

  private
    def set_asset
      asset_id = params[:asset_id] || params[:simulation][:asset_id]
      @asset = Asset.find(asset_id)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_simulation
      @simulation = Simulation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def simulation_params
      params.require(:simulation).permit(:name)
    end
end
