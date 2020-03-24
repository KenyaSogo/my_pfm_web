class SimulationSummaryByAccountsController < ApplicationController
  before_action :sign_in_required
  before_action :set_simulation_summary_by_account, only: [:show, :edit, :update, :destroy]
  before_action -> { current_users_resource_filter(@simulation_summary_by_account.simulation_summary.simulation.asset) }, only: [:show, :edit, :update, :destroy, :generate]

  # GET /simulation_summary_by_accounts
  # GET /simulation_summary_by_accounts.json
  def index
    @simulation_summary_by_accounts = SimulationSummaryByAccount.all
  end

  # GET /simulation_summary_by_accounts/1
  # GET /simulation_summary_by_accounts/1.json
  def show
    @query = @simulation_summary_by_account.sum_account_dailies.ransack(sum_account_dailies_condition)
    @data = @query.result.pluck(:base_date, :balance)
  end

  # GET /simulation_summary_by_accounts/new
  def new
    @simulation_summary_by_account = SimulationSummaryByAccount.new
  end

  # GET /simulation_summary_by_accounts/1/edit
  def edit
  end

  # POST /simulation_summary_by_accounts
  # POST /simulation_summary_by_accounts.json
  def create
    @simulation_summary_by_account = SimulationSummaryByAccount.new(simulation_summary_by_account_params)

    respond_to do |format|
      if @simulation_summary_by_account.save
        format.html { redirect_to @simulation_summary_by_account, notice: 'Simulation summary by account was successfully created.' }
        format.json { render :show, status: :created, location: @simulation_summary_by_account }
      else
        format.html { render :new }
        format.json { render json: @simulation_summary_by_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /simulation_summary_by_accounts/1
  # PATCH/PUT /simulation_summary_by_accounts/1.json
  def update
    respond_to do |format|
      if @simulation_summary_by_account.update(simulation_summary_by_account_params)
        format.html { redirect_to @simulation_summary_by_account, notice: 'Simulation summary by account was successfully updated.' }
        format.json { render :show, status: :ok, location: @simulation_summary_by_account }
      else
        format.html { render :edit }
        format.json { render json: @simulation_summary_by_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /simulation_summary_by_accounts/1
  # DELETE /simulation_summary_by_accounts/1.json
  def destroy
    @simulation_summary_by_account.destroy
    respond_to do |format|
      format.html { redirect_to simulation_summary_by_accounts_url, notice: 'Simulation summary by account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def sum_account_dailies_condition
      if params[:q].present?
        condition = params[:q][:asset_account_id_eq].blank? ? { asset_account_id_null: true } : { asset_account_id_eq: params[:q][:asset_account_id_eq] }
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
          asset_account_id_eq: @simulation_summary_by_account.sum_account_dailies.select(:asset_account_id).distinct.map(&:asset_account_id).compact.min,
          base_date_gteq: today.ago(3.month),
          base_date_lteq: today.since(3.month),
        }
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_simulation_summary_by_account
      @simulation_summary_by_account = SimulationSummaryByAccount.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def simulation_summary_by_account_params
      params.require(:simulation_summary_by_account).permit(:is_active, :memo, :asset_account_id_eq)
    end
end
