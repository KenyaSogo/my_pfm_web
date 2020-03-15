class SimulationAcctClassesController < ApplicationController
  before_action :set_simulation_acct_class, only: [:show, :edit, :update, :destroy]

  # GET /simulation_acct_classes
  # GET /simulation_acct_classes.json
  def index
    @simulation_acct_classes = SimulationAcctClass.all
  end

  # GET /simulation_acct_classes/1
  # GET /simulation_acct_classes/1.json
  def show
  end

  # GET /simulation_acct_classes/new
  def new
    @simulation_acct_class = SimulationAcctClass.new
  end

  # GET /simulation_acct_classes/1/edit
  def edit
  end

  # POST /simulation_acct_classes
  # POST /simulation_acct_classes.json
  def create
    @simulation_acct_class = SimulationAcctClass.new(simulation_acct_class_params)

    respond_to do |format|
      if @simulation_acct_class.save
        format.html { redirect_to @simulation_acct_class, notice: 'Simulation acct class was successfully created.' }
        format.json { render :show, status: :created, location: @simulation_acct_class }
      else
        format.html { render :new }
        format.json { render json: @simulation_acct_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /simulation_acct_classes/1
  # PATCH/PUT /simulation_acct_classes/1.json
  def update
    respond_to do |format|
      if @simulation_acct_class.update(simulation_acct_class_params)
        format.html { redirect_to @simulation_acct_class, notice: 'Simulation acct class was successfully updated.' }
        format.json { render :show, status: :ok, location: @simulation_acct_class }
      else
        format.html { render :edit }
        format.json { render json: @simulation_acct_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /simulation_acct_classes/1
  # DELETE /simulation_acct_classes/1.json
  def destroy
    @simulation_acct_class.destroy
    respond_to do |format|
      format.html { redirect_to simulation_acct_classes_url, notice: 'Simulation acct class was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_simulation_acct_class
      @simulation_acct_class = SimulationAcctClass.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def simulation_acct_class_params
      params.require(:simulation_acct_class).permit(:sum_by_acct_class_setting_id, :name)
    end
end
