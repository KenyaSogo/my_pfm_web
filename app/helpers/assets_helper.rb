module AssetsHelper
  def display_date_string(datetime)
    datetime.blank? ? '-' : datetime.strftime('%Y/%m/%d %H:%M:%S')
  end
end
