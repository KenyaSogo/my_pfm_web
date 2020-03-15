module SummaryByAssetTypesHelper
  def summary_by_asset_type_options(summary_by_asset_type)
    asset_type_ids = summary_by_asset_type.sum_asset_type_dailies.select(:asset_type_id).distinct.pluck(:asset_type_id)

    result_options = {}
    result_options.merge!({'-': nil}) if asset_type_ids.include?(nil)
    actual_asset_type_options = AssetType.where(id: asset_type_ids.compact).map { |asset_type| [asset_type.name, asset_type.id] }&.to_h
    result_options.merge!(actual_asset_type_options) if actual_asset_type_options.present?

    result_options
  end
end
