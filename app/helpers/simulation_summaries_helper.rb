module SimulationSummariesHelper
  def simulation_summary_breakdown_type_name(breakdown)
    case
    when breakdown.is_a?(SimulationSummaryByAccount)
      'ByAccount'
    else
      '-'
    end
  end
end
