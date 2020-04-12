module SimulationsHelper
  def latest_generate_status(simulation)
    return '-' if simulation.last_job_id.blank?
    ActiveJob::Status.get(simulation.last_job_id)&.status.presence || '-'
  end
end
