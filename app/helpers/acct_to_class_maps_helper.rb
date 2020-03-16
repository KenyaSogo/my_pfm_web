module AcctToClassMapsHelper
  def simulation_acct_class_options(acct_to_class_map)
    acct_to_class_map.sum_by_acct_class_setting.simulation_acct_classes.map { |c| [c.name, c.id] }.to_h
  end
end
