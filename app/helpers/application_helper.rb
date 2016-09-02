module ApplicationHelper
  def date_format(datetime_string)
    begin
      Date.parse(datetime_string).strftime("%d-%m-%Y")
    rescue ArgumentError
      ''
    end
  end
end
