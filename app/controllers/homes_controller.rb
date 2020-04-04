class HomesController < ApplicationController
  before_action :sign_in_required, only: [:show]

  def index
  end

  def show
    simulation_summary = current_user.current_or_first_simulation&.simulation_summary
    if simulation_summary.present?
      @simulation_summary = simulation_summary
      @data = @simulation_summary.main_view_data
    end
  end
end
