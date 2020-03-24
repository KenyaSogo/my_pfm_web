class SumByAcctClassSettingsController < ApplicationController
  before_action :sign_in_required
  before_action :set_sum_by_acct_class_setting, only: [:show, :edit, :update, :destroy]

  # GET /sum_by_acct_class_settings
  # GET /sum_by_acct_class_settings.json
  def index
    @sum_by_acct_class_settings = SumByAcctClassSetting.all
  end

  # GET /sum_by_acct_class_settings/1
  # GET /sum_by_acct_class_settings/1.json
  def show
  end

  # GET /sum_by_acct_class_settings/new
  def new
    @sum_by_acct_class_setting = SumByAcctClassSetting.new
  end

  # GET /sum_by_acct_class_settings/1/edit
  def edit
  end

  # POST /sum_by_acct_class_settings
  # POST /sum_by_acct_class_settings.json
  def create
    @sum_by_acct_class_setting = SumByAcctClassSetting.new(sum_by_acct_class_setting_params)

    respond_to do |format|
      if @sum_by_acct_class_setting.save
        format.html { redirect_to @sum_by_acct_class_setting, notice: 'Sum by acct class setting was successfully created.' }
        format.json { render :show, status: :created, location: @sum_by_acct_class_setting }
      else
        format.html { render :new }
        format.json { render json: @sum_by_acct_class_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sum_by_acct_class_settings/1
  # PATCH/PUT /sum_by_acct_class_settings/1.json
  def update
    respond_to do |format|
      if @sum_by_acct_class_setting.update(sum_by_acct_class_setting_params)
        format.html { redirect_to @sum_by_acct_class_setting, notice: 'Sum by acct class setting was successfully updated.' }
        format.json { render :show, status: :ok, location: @sum_by_acct_class_setting }
      else
        format.html { render :edit }
        format.json { render json: @sum_by_acct_class_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sum_by_acct_class_settings/1
  # DELETE /sum_by_acct_class_settings/1.json
  def destroy
    @sum_by_acct_class_setting.destroy
    respond_to do |format|
      format.html { redirect_to sum_by_acct_class_settings_url, notice: 'Sum by acct class setting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sum_by_acct_class_setting
      @sum_by_acct_class_setting = SumByAcctClassSetting.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sum_by_acct_class_setting_params
      params.require(:sum_by_acct_class_setting).permit(:sum_by_account_class_id)
    end
end
