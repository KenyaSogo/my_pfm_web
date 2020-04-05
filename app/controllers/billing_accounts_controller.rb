class BillingAccountsController < ApplicationController
  before_action :sign_in_required
  before_action :set_simulation, only: [:new, :create]
  before_action -> { current_users_resource_filter(@simulation.asset) }, only: [:new, :create]
  before_action :set_billing_account, only: [:show, :edit, :update, :destroy]
  before_action -> { current_users_resource_filter(@billing_account.simulation.asset) }, only: [:show, :edit, :update, :destroy]

  # GET /billing_accounts/1
  # GET /billing_accounts/1.json
  def show
    @is_billing_complement_activities = params[:is_billing_complement_activities].to_i == 1
    activities = @is_billing_complement_activities ? @billing_account.billing_complement_activities : @billing_account.billing_activities
    @billing_activities = activities.page(params[:page]).per(30).order(transaction_date: :desc)
  end

  # GET /billing_accounts/new
  def new
    @billing_account = BillingAccount.new
  end

  # GET /billing_accounts/1/edit
  def edit
  end

  # POST /billing_accounts
  # POST /billing_accounts.json
  def create
    @billing_account = BillingAccount.new(billing_account_params)
    @billing_account.simulation = @simulation

    respond_to do |format|
      if @billing_account.save
        format.html { redirect_to @billing_account, notice: 'Billing account was successfully created.' }
        format.json { render :show, status: :created, location: @billing_account }
      else
        format.html { render :new }
        format.json { render json: @billing_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /billing_accounts/1
  # PATCH/PUT /billing_accounts/1.json
  def update
    respond_to do |format|
      if @billing_account.update(billing_account_params)
        format.html { redirect_to @billing_account, notice: 'Billing account was successfully updated.' }
        format.json { render :show, status: :ok, location: @billing_account }
      else
        format.html { render :edit }
        format.json { render json: @billing_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /billing_accounts/1
  # DELETE /billing_accounts/1.json
  def destroy
    simulation = @billing_account.simulation
    @billing_account.destroy
    respond_to do |format|
      format.html { redirect_to simulation, notice: 'Billing account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_simulation
      simulation_id = params[:simulation_id] || params[:billing_account][:simulation_id]
      @simulation = Simulation.find(simulation_id)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_billing_account
      @billing_account = BillingAccount.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def billing_account_params
      params.require(:billing_account).permit(:credit_account_id, :billing_closing_day, :withdrawal_day, :withdrawal_month_offset, :billing_item_id, :billing_sub_item_id, :debit_account_id, :debit_item_id, :debit_sub_item_id)
    end
end
