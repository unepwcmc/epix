module ApplicationHelper

  # parses datetime string and returns date string
  def date_format(datetime_string)
    begin
      Date.parse(datetime_string).strftime("%d-%m-%Y")
    rescue ArgumentError
      datetime_string
    end
  end
end
