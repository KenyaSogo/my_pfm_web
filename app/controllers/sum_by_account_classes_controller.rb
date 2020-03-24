class SumByAccountClassesController < ApplicationController
  before_action :sign_in_required
  before_action :set_simulation_summary, only: [:index, :new, :create]
  before_action -> { current_users_resource_filter(@simulation_summary.simulation.asset) }, only: [:index, :new, :create]
  before_action :set_sum_by_account_class, only: [:show, :edit, :update, :destroy]
  before_action -> { current_users_resource_filter(@sum_by_account_class.simulation_summary.simulation.asset) }, only: [:show, :edit, :update, :destroy]

  # GET /sum_by_account_classes
  # GET /sum_by_account_classes.json
  def index
    @sum_by_account_classes = SumByAccountClass.all
  end

  # GET /sum_by_account_classes/1
  # GET /sum_by_account_classes/1.json
  def show
    @query = @sum_by_account_class.sum_acct_class_dailies.ransack(sum_acct_class_dailies_condition)
    @data = @query.result.pluck(:base_date, :balance)
  end

  # GET /sum_by_account_classes/new
  def new
    @sum_by_account_class = SumByAccountClass.new(is_active: true)
  end

  # GET /sum_by_account_classes/1/edit
  def edit
  end

  # POST /sum_by_account_classes
  # POST /sum_by_account_classes.json
  def create
    @sum_by_account_class = SumByAccountClass.new(sum_by_account_class_params)
    @sum_by_account_class.simulation_summary = @simulation_summary

    respond_to do |format|
      if @sum_by_account_class.save
        format.html { redirect_to @sum_by_account_class, notice: 'Summary by account class was successfully created.' }
        format.json { render :show, status: :created, location: @sum_by_account_class }
      else
        format.html { render :new }
        format.json { render json: @sum_by_account_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sum_by_account_classes/1
  # PATCH/PUT /sum_by_account_classes/1.json
  def update
    respond_to do |format|
      if @sum_by_account_class.update(sum_by_account_class_params)
        format.html { redirect_to @sum_by_account_class, notice: 'Summary by account class was successfully updated.' }
        format.json { render :show, status: :ok, location: @sum_by_account_class }
      else
        format.html { render :edit }
        format.json { render json: @sum_by_account_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sum_by_account_classes/1
  # DELETE /sum_by_account_classes/1.json
  def destroy
    simulation_summary = @sum_by_account_class.simulation_summary
    respond_to do |format|
      if @sum_by_account_class.destroy
        format.html { redirect_to simulation_summary, notice: 'by account class was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to simulation_summary, alert: @sum_by_account_class.errors.full_messages.join('. ') }
        format.json { render json: @sum_by_account_class.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def sum_acct_class_dailies_condition
      if params[:q].present?
        condition = params[:q][:simulation_acct_class_id_eq].blank? ? { simulation_acct_class_id_null: true } : { simulation_acct_class_id_eq: params[:q][:simulation_acct_class_id_eq] }
        condition.merge!(
          {
            'base_date_gteq(1i)': params[:q]['base_date_gteq(1i)'],
            'base_date_gteq(2i)': params[:q]['base_date_gteq(2i)'],
            'base_date_gteq(3i)': params[:q]['base_date_gteq(3i)'],
            'base_date_lteq(1i)': params[:q]['base_date_lteq(1i)'],
            'base_date_lteq(2i)': params[:q]['base_date_lteq(2i)'],
            'base_date_lteq(3i)': params[:q]['base_date_lteq(3i)'],
          }
        )
      else
        today = Date.today
        {
          simulation_acct_class_id_eq: @sum_by_account_class.sum_acct_class_dailies.select(:simulation_acct_class_id).distinct.map(&:simulation_acct_class_id).compact.min,
          base_date_gteq: today.ago(3.month),
          base_date_lteq: today.since(3.month),
        }
      end
    end

    def set_simulation_summary
      simulation_summary_id = params[:simulation_summary_id] || params[:sum_by_account_class][:simulation_summary_id]
      @simulation_summary = SimulationSummary.find(simulation_summary_id)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_sum_by_account_class
      @sum_by_account_class = SumByAccountClass.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sum_by_account_class_params
      params.require(:sum_by_account_class).permit(:name, :is_active, :memo)
    end
end
