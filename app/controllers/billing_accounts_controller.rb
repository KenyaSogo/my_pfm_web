class BillingAccountsController < ApplicationController
  before_action :set_billing_account, only: [:show, :edit, :update, :destroy]

  # GET /billing_accounts
  # GET /billing_accounts.json
  def index
    @billing_accounts = BillingAccount.all
  end

  # GET /billing_accounts/1
  # GET /billing_accounts/1.json
  def show
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
    @billing_account.destroy
    respond_to do |format|
      format.html { redirect_to billing_accounts_url, notice: 'Billing account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_billing_account
      @billing_account = BillingAccount.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def billing_account_params
      params.require(:billing_account).permit(:simulation_id, :credit_account_id, :billing_closing_day, :withdrawal_day, :withdrawal_month_offset, :billing_item_id, :billing_sub_item_id, :debit_account_id, :debit_item_id, :debit_sub_item_id)
    end
end
