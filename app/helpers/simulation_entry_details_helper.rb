module SimulationEntryDetailsHelper
  def asset_account_options(asset)
    asset.asset_accounts.map { |a| [a.name, a.id] }
  end
  def item_options(asset)
    asset.items.map { |i| [i.name, i.id] }
  end
  def sub_item_options(asset)
    item_ids = asset.items.map(&:id)
    SubItem.where(item_id: item_ids).includes(:item).map { |s| ["#{s.name} (#{s.item.name})", s.id] }
  end
end
