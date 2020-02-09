module ApplicationHelper
  def user_display_name(user)
    user.user_name.blank? ? user.email : user.user_name
  end
end
