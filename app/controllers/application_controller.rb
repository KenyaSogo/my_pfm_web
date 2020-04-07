class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    homes_show_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name, :pfm_account_id, :pfm_account_password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:user_name, :pfm_account_id, :pfm_account_password])
  end

  private

  def sign_in_required
    redirect_to homes_index_path unless user_signed_in?
  end

  def current_users_resource_filter(resource)
    redirect_to homes_show_path, alert: 'Unknown resource requested.' if resource&.user_id != current_user.id
  end
end
