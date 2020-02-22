module SimulationEntriesHelper
  def simulation_entry_type_options
    @simulation_entry_type_options ||= SimulationEntryType.all.map { |r| [r.name, r.id] }
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
      weekday
    when 4
      day
    when 5
      Date.new(1901, month, day).strftime('%m/%d')
    else
      '-'
    end
  end
end
