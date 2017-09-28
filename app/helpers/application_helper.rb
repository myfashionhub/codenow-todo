module ApplicationHelper
  def display_date(datetime)
    datetime.nil? ? '' : datetime.strftime('%B %d, %Y')
  end

  def display_form_date(datetime)
    datetime.nil? ? '' : datetime.strftime('%Y-%m-%d')
  end
end
