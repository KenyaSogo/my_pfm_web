module HomesHelper
  def profile_completed?
    return false unless current_user

    current_user.pfm_account_id.present? && current_user.pfm_account_password.present?
  end

  def asset_aggregate_completed?
    return false unless profile_completed?
    return false unless current_user.current_or_first_asset

    succeeded_at = current_user.current_or_first_asset.last_aggregate_succeeded_at
    return false if succeeded_at.blank?

    succeeded_at > Date.new(2000, 1, 1)
  end

  def asset_accounts_setting_completed?
    return false unless asset_aggregate_completed?
    return false unless current_user.current_or_first_asset

    current_user.current_or_first_asset.asset_accounts.all? { |a| a.asset_type.present? }
  end

  def simulation_generate_completed?
    return false unless asset_accounts_setting_completed?
    return false unless current_user.current_or_first_simulation

    generated_at = current_user.current_or_first_simulation.last_generated_at
    return false if generated_at.blank?

    generated_at > Date.new(2000, 1, 1)
  end
end
