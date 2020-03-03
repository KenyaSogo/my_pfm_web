module AssetsHelper
  def result_activity_counts(simulation)
    simulation_result_activity_counts = simulation.simulation_entries.joins(simulation_entry_details: :simulation_result_activities).size
    billing_activity_counts = simulation.billing_accounts.joins(:billing_activities).size
    billing_activity_counts += simulation.billing_accounts.joins(:billing_complement_activities).size

    simulation_result_activity_counts + billing_activity_counts
  end
end
