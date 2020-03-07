class SimulationSummaryByAccountsController < ApplicationController
  before_action :set_simulation_summary_by_account, only: [:show, :edit, :update, :destroy]

  # GET /simulation_summary_by_accounts
  # GET /simulation_summary_by_accounts.json
  def index
    @simulation_summary_by_accounts = SimulationSummaryByAccount.all
  end

  # GET /simulation_summary_by_accounts/1
  # GET /simulation_summary_by_accounts/1.json
  def show
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
    # Use callbacks to share common setup or constraints between actions.
    def set_simulation_summary_by_account
      @simulation_summary_by_account = SimulationSummaryByAccount.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def simulation_summary_by_account_params
      params.require(:simulation_summary_by_account).permit(:simulation_summary_id, :is_active, :memo)
    end
end
