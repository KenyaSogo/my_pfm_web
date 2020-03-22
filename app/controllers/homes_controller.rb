class HomesController < ApplicationController
  before_action :sign_in_required, only: [:show]

  def index
  end

  def show
    simulation = current_user.current_simulation
    if simulation&.simulation_summary.present?
      @simulation_summary = simulation.simulation_summary
      @data = @simulation_summary.main_view_data
    end
  end
end
