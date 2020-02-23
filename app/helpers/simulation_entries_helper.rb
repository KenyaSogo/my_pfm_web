module SimulationEntriesHelper
  def simulation_entry_type_options
    @simulation_entry_type_options ||= SimulationEntryType.all.map { |r| [r.name, r.id] }
  end
end
