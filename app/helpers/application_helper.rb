module ApplicationHelper
  def user_display_name(user)
    user.user_name.blank? ? user.email : user.user_name
  end
  def display_datetime_string(datetime)
    datetime.blank? ? '-' : datetime.strftime('%Y/%m/%d %H:%M:%S')
  end
  def display_date_string(date)
    date.blank? ? '-' : date.strftime('%Y/%m/%d')
  end
end
