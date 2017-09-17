module ApplicationHelper
  def display_date(datetime)
    datetime.nil? ? '' : datetime.strftime('%m/%d, %Y')
  end
end
