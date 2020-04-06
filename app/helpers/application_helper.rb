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

  def year_options
    current_year = Time.current.year
    Range.new(current_year - 5, current_year + 5).map { |y| [y, y] }
  end

  def month_options
    Range.new(1, 12).map { |m| [m, m] }
  end

  def weekday_options
    {
      Sun: 1,
      Mon: 2,
      Tue: 3,
      Wed: 4,
      Thu: 5,
      Fri: 6,
      Sat: 7,
    }
  end

  def weekday_name(value)
    weekday_options.key(value)
  end

  def day_options
    Range.new(1, 31).map { |d| [d, d] }
  end

  def nl2br(str)
    return str if str.blank?
    raw(h(str).gsub(/\R/, "<br />"))
  end
end
