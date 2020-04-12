class SimulationAcctClassesController < ApplicationController
  before_action :sign_in_required
  before_action :set_sum_by_acct_class_setting, only: [:index, :new, :create]
  before_action -> { current_users_resource_filter(@sum_by_acct_class_setting.sum_by_account_class.simulation_summary.simulation.asset) }, only: [:index, :new, :create]
  before_action :set_simulation_acct_class, only: [:edit, :update, :destroy]
  before_action -> { current_users_resource_filter(@simulation_acct_class.sum_by_acct_class_setting.sum_by_account_class.simulation_summary.simulation.asset) }, only: [:edit, :update, :destroy]
  before_action :set_current_menu

  # GET /simulation_acct_classes
  # GET /simulation_acct_classes.json
  def index
    @simulation_acct_classes = @sum_by_acct_class_setting.simulation_acct_classes
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
    @simulation_acct_class.sum_by_acct_class_setting = @sum_by_acct_class_setting

    respond_to do |format|
      if @simulation_acct_class.save
        format.html { redirect_to simulation_acct_classes_path(sum_by_acct_class_setting_id: @sum_by_acct_class_setting.id), notice: 'Account class was successfully created.' }
        format.json { render :index, status: :created, location: @sum_by_acct_class_setting.simulation_acct_classes }
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
        format.html { redirect_to simulation_acct_classes_path(sum_by_acct_class_setting_id: @simulation_acct_class.sum_by_acct_class_setting.id), notice: 'Account class was successfully updated.' }
        format.json { render :index, status: :ok, location: @simulation_acct_class.sum_by_acct_class_setting.simulation_acct_classes }
      else
        format.html { render :edit }
        format.json { render json: @simulation_acct_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /simulation_acct_classes/1
  # DELETE /simulation_acct_classes/1.json
  def destroy
    sum_by_acct_class_setting = @simulation_acct_class.sum_by_acct_class_setting
    respond_to do |format|
      if @simulation_acct_class.destroy
        format.html { redirect_to simulation_acct_classes_path(sum_by_acct_class_setting_id: sum_by_acct_class_setting.id), notice: 'Account class was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to simulation_acct_classes_path(sum_by_acct_class_setting_id: sum_by_acct_class_setting.id), alert: @simulation_acct_class.errors.full_messages.join('. ') }
        format.json { render json: @simulation_acct_class.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_sum_by_acct_class_setting
      sum_by_acct_class_setting_id = params[:sum_by_acct_class_setting_id] || params[:simulation_acct_class][:sum_by_acct_class_setting_id]
      @sum_by_acct_class_setting = SumByAcctClassSetting.find(sum_by_acct_class_setting_id)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_simulation_acct_class
      @simulation_acct_class = SimulationAcctClass.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def simulation_acct_class_params
      params.require(:simulation_acct_class).permit(:name)
    end

    def set_current_menu
      @current_menu = :summary
    end
end
