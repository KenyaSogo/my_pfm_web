class SumByAccountClassesController < ApplicationController
  before_action :set_sum_by_account_class, only: [:show, :edit, :update, :destroy]

  # GET /sum_by_account_classes
  # GET /sum_by_account_classes.json
  def index
    @sum_by_account_classes = SumByAccountClass.all
  end

  # GET /sum_by_account_classes/1
  # GET /sum_by_account_classes/1.json
  def show
  end

  # GET /sum_by_account_classes/new
  def new
    @sum_by_account_class = SumByAccountClass.new
  end

  # GET /sum_by_account_classes/1/edit
  def edit
  end

  # POST /sum_by_account_classes
  # POST /sum_by_account_classes.json
  def create
    @sum_by_account_class = SumByAccountClass.new(sum_by_account_class_params)

    respond_to do |format|
      if @sum_by_account_class.save
        format.html { redirect_to @sum_by_account_class, notice: 'Sum by account class was successfully created.' }
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
        format.html { redirect_to @sum_by_account_class, notice: 'Sum by account class was successfully updated.' }
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
    @sum_by_account_class.destroy
    respond_to do |format|
      format.html { redirect_to sum_by_account_classes_url, notice: 'Sum by account class was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sum_by_account_class
      @sum_by_account_class = SumByAccountClass.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sum_by_account_class_params
      params.require(:sum_by_account_class).permit(:simulation_summary_id, :name, :is_active, :memo, :summarized_at)
    end
end
