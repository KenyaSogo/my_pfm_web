class BillingActivitiesController < ApplicationController
  before_action :sign_in_required
  before_action :set_billing_activity, only: [:show, :edit, :update, :destroy]

  # GET /billing_activities
  # GET /billing_activities.json
  def index
    @billing_activities = BillingActivity.all
  end

  # GET /billing_activities/1
  # GET /billing_activities/1.json
  def show
  end

  # GET /billing_activities/new
  def new
    @billing_activity = BillingActivity.new
  end

  # GET /billing_activities/1/edit
  def edit
  end

  # POST /billing_activities
  # POST /billing_activities.json
  def create
    @billing_activity = BillingActivity.new(billing_activity_params)

    respond_to do |format|
      if @billing_activity.save
        format.html { redirect_to @billing_activity, notice: 'Billing activity was successfully created.' }
        format.json { render :show, status: :created, location: @billing_activity }
      else
        format.html { render :new }
        format.json { render json: @billing_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /billing_activities/1
  # PATCH/PUT /billing_activities/1.json
  def update
    respond_to do |format|
      if @billing_activity.update(billing_activity_params)
        format.html { redirect_to @billing_activity, notice: 'Billing activity was successfully updated.' }
        format.json { render :show, status: :ok, location: @billing_activity }
      else
        format.html { render :edit }
        format.json { render json: @billing_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /billing_activities/1
  # DELETE /billing_activities/1.json
  def destroy
    @billing_activity.destroy
    respond_to do |format|
      format.html { redirect_to billing_activities_url, notice: 'Billing activity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_billing_activity
      @billing_activity = BillingActivity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def billing_activity_params
      params.require(:billing_activity).permit(:billing_account_id, :asset_account_id, :transaction_date, :description, :amount, :item_id, :sub_item_id, :is_transfer, :is_calculation_target)
    end
end
