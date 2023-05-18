module ApplicationHelper
  def date_or_today(datetime)
    if datetime.beginning_of_day == Time.zone.now.beginning_of_day
      "today"
    else
      datetime.strftime("%B %d, %Y")
    end
  end
end
