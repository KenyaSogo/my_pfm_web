module AssetsHelper
  def last_aggregated_at(asset)
    aggregated_at = asset.last_aggregate_succeeded_at
    aggregated_at.blank? ? '-' : aggregated_at.strftime('%Y/%m/%d %H:%M:%S')
  end
end
