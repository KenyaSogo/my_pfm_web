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

  def simulation_entry_detail_date_header_name(simulation_entry_type_id)
    case simulation_entry_type_id
    when 1
      'TransactionDate'
    when 2
      nil
    when 3
      'TransactionWeekday'
    when 4
      'TransactionDay'
    when 5
      'TransactionMonthDay'
    else
      nil
    end
  end

  def simulation_entry_detail_date_value(simulation_entry_type_id, simulation_entry_detail)
    year = simulation_entry_detail.transaction_date_year
    month = simulation_entry_detail.transaction_date_month
    day = simulation_entry_detail.transaction_date_day
    weekday = simulation_entry_detail.transaction_date_weekday

    case simulation_entry_type_id
    when 1
      display_date_string(Date.new(year, month, day))
    when 2
      '-'
    when 3
      weekday_name(weekday)
    when 4
      day
    when 5
      Date.new(2000, month, day).strftime('%m/%d')
    else
      '-'
    end
  end
end
