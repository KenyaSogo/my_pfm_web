class SimulationSummariesController < ApplicationController
  before_action :set_simulation_summary, only: [:show, :edit, :update, :destroy]
  before_action -> { current_users_resource_filter(@simulation_summary.simulation.asset) }, only: [:show, :edit, :update, :destroy, :generate]

  # GET /simulation_summaries
  # GET /simulation_summaries.json
  def index
    @simulation_summaries = SimulationSummary.all
  end

  # GET /simulation_summaries/1
  # GET /simulation_summaries/1.json
  def show
  end

  # GET /simulation_summaries/new
  def new
    @simulation_summary = SimulationSummary.new
  end

  # GET /simulation_summaries/1/edit
  def edit
  end

  # POST /simulation_summaries
  # POST /simulation_summaries.json
  def create
    @simulation_summary = SimulationSummary.new(simulation_summary_params)

    respond_to do |format|
      if @simulation_summary.save
        format.html { redirect_to @simulation_summary, notice: 'Simulation summary was successfully created.' }
        format.json { render :show, status: :created, location: @simulation_summary }
      else
        format.html { render :new }
        format.json { render json: @simulation_summary.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /simulation_summaries/1
  # PATCH/PUT /simulation_summaries/1.json
  def update
    respond_to do |format|
      if @simulation_summary.update(simulation_summary_params)
        format.html { redirect_to @simulation_summary, notice: 'Simulation summary was successfully updated.' }
        format.json { render :show, status: :ok, location: @simulation_summary }
      else
        format.html { render :edit }
        format.json { render json: @simulation_summary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /simulation_summaries/1
  # DELETE /simulation_summaries/1.json
  def destroy
    @simulation_summary.destroy
    respond_to do |format|
      format.html { redirect_to simulation_summaries_url, notice: 'Simulation summary was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_simulation_summary
      @simulation_summary = SimulationSummary.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def simulation_summary_params
      permitted_params = params.require(:simulation_summary).permit(:main_breakdown, :main_section, :search_from, :search_to).to_h

      resolved_params = {}
      if permitted_params.has_key?(:main_breakdown)
        if permitted_params[:main_breakdown].present?
          main_breakdown_params = permitted_params[:main_breakdown].split('_')
          resolved_params.merge!(main_breakdown_type_id: main_breakdown_params[0], main_breakdown_id: main_breakdown_params[1])
        else
          resolved_params.merge!(main_breakdown_type_id: '', main_breakdown_id: '')
        end
      end
      if permitted_params.has_key?(:main_section)
        if permitted_params[:main_section].present?
          main_section_params = permitted_params[:main_section].split('_')
          resolved_params.merge!(main_section_type_id: main_section_params[0], main_section_id: main_section_params[1])
        else
          resolved_params.merge!(main_section_type_id: '', main_section_id: '')
        end
      end
      resolved_params.merge!(permitted_params.slice(:search_from, :search_to))
    end
end
