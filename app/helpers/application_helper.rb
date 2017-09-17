module ApplicationHelper
  def display_date(datetime)
    datetime.nil? ? '' : datetime.strftime('%B %d, %Y')
  end
end
