module AssetsHelper
  def latest_aggretate_status(asset)
    return '-' if asset.last_job_id.blank?
    ActiveJob::Status.get(asset.last_job_id)&.status.presence || '-'
  end
end
