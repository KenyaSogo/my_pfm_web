module SumByAccountClassesHelper
  def simulation_acct_class_search_options(sum_by_account_class)
    simulation_acct_class_ids = sum_by_account_class.sum_acct_class_dailies.select(:simulation_acct_class_id).distinct.pluck(:simulation_acct_class_id)

    result_options = {}
    result_options.merge!({'-': nil}) if simulation_acct_class_ids.include?(nil)
    actual_account_class_options = SimulationAcctClass.where(id: simulation_acct_class_ids.compact).map { |acct_class| [acct_class.name, acct_class.id] }&.to_h
    result_options.merge!(actual_account_class_options) if actual_account_class_options.present?

    result_options
  end
end
