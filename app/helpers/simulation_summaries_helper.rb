module SimulationSummariesHelper
  def simulation_summary_breakdown_type_name(breakdown)
    case
    when breakdown.is_a?(SimulationSummaryByAccount)
      'ByAccount'
    when breakdown.is_a?(SummaryByAssetType)
      'ByAssetType'
    when breakdown.is_a?(SumByAccountClass)
      'ByAccountClass'
    else
      '-'
    end
  end

  def main_breakdown_options(simulation_summary)
    SimulationBreakdownType.all.each_with_object({}) do |breakdown_type, h|
      case breakdown_type.id
      when 1 # by_account
        h[breakdown_type.name] = breakdown_type.id.to_s + '_' + simulation_summary.simulation_summary_by_account.id.to_s
      when 2 # by_asset_class
        h[breakdown_type.name] = breakdown_type.id.to_s + '_' + simulation_summary.summary_by_asset_type.id.to_s
      when 3 # by_account_class
        simulation_summary.sum_by_account_classes.each do |sum_by_account_class|
          h["#{breakdown_type.name}: #{sum_by_account_class.name}"] = breakdown_type.id.to_s + '_' + sum_by_account_class.id.to_s
        end
      end
    end
  end

  def selected_main_breakdown(simulation_summary)
    simulation_summary.main_breakdown_type_id.to_s + '_' + simulation_summary.main_breakdown_id.to_s
  end

  def main_section_options(simulation_summary)
    SimulationSectionType.all.each_with_object({}) do |section_type, h|
      case section_type.id
      when 1 # asset_account
        AssetAccount.where(
          id: SimulationSummary.where(id: simulation_summary.id).joins(simulation_summary_by_account: :sum_account_dailies)
                .select(sum_account_dailies: :asset_account_id).distinct.pluck(:asset_account_id).compact.sort
        ).pluck(:id, :name)
          .each do |asset_account_id, asset_account_name|
            h["#{section_type.name}: #{asset_account_name}"] = section_type.id.to_s + '_' + asset_account_id.to_s
          end
      when 2 # asset_type
        AssetType.where(
          id: SimulationSummary.where(id: simulation_summary.id).joins(simulation_summary_by_account: { sum_account_dailies: :asset_account })
                .select(asset_accounts: :asset_type_id).distinct.pluck(:asset_type_id).compact.sort
        ).pluck(:id, :name)
          .each do |asset_type_id, asset_type_name|
            h["#{section_type.name}: #{asset_type_name}"] = section_type.id.to_s + '_' + asset_type_id.to_s
          end
      when 3 # asset_account_class
        SimulationAcctClass.where(
          id: SimulationSummary.where(id: simulation_summary.id).joins(sum_by_account_classes: :sum_acct_class_dailies)
                .select(sum_acct_class_dailies: :simulation_acct_class_id).distinct.pluck(:simulation_acct_class_id).compact.sort
        ).joins(sum_by_acct_class_setting: :sum_by_account_class).pluck('sum_by_account_classes.name', 'simulation_acct_classes.id', 'simulation_acct_classes.name')
          .each do |sum_by_account_classes_name, account_class_id, account_class_name|
            h["#{section_type.name}: #{sum_by_account_classes_name}: #{account_class_name}"] = section_type.id.to_s + '_' + account_class_id.to_s
          end
      end
    end
  end

  def selected_main_section(simulation_summary)
    simulation_summary.main_section_type_id.to_s + '_' + simulation_summary.main_section_id.to_s
  end

  def simulation_summary_search_from_options
    [['today', 0]] + (1..12).map { |i| ["#{i}_months_ago", - i] }
  end

  def simulation_summary_search_to_options
    (1..12).map { |i| ["#{i}_months_ahead", i] }
  end

  def main_breakdown_name(simulation_summary)
    case simulation_summary.main_breakdown_type_id
    when 1, 2 # by_account, by_asset_type
      simulation_summary.main_breakdown_type.name
    when 3 # by_account_class
      "#{simulation_summary.main_breakdown_type.name}: #{SumByAccountClass.find(simulation_summary.main_breakdown_id).name}"
    else
      '-'
    end
  end

  def main_section_name(simulation_summary)
    case simulation_summary.main_section_type_id
    when 1 # asset_account
      AssetAccount.find(simulation_summary.main_section_id).name
    when 2 # asset_type
      AssetType.find(simulation_summary.main_section_id).name
    when 3 # asset_account_class
      SimulationAcctClass.find(simulation_summary.main_section_id).name
    else
      '-'
    end
  end

  def simulation_summary_search_from_name(id)
    return '-' if id.blank?
    simulation_summary_search_from_options.to_h.key(id)
  end

  def simulation_summary_search_to_name(id)
    return '-' if id.blank?
    simulation_summary_search_to_options.to_h.key(id)
  end
end
