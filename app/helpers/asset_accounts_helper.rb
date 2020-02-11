module AssetAccountsHelper
  def asset_type_options
    @asset_type_options ||= AssetType.all.map { |r| [r.name, r.id] }
  end
end
