module GaTracker
  DIMENSIONS = {
    "IP": 1,
    "user_id": 2,
    "organisation_id": 3,
    "country_iso_code": 4,
    "method_name": 5,
    "provider_organisation_id": 6,
    "provider_country_iso_code": 7,
    "request_parameters": 8,
    "time": 9,
    "response_time": 10,
    "response_status": 11,
    "failure_details": 12,
    "timeout": 13
  }
  METRICS = {
    "counter": 1
  }

  def self.add_caller_identification(hit, request, user)
    hit.add_custom_dimension(DIMENSIONS[:IP], request.ip)
    hit.add_custom_dimension(DIMENSIONS[:user_id], user.id)
    hit.add_custom_dimension(DIMENSIONS[:organisation_id], user.organisation_id)
    hit.add_custom_dimension(DIMENSIONS[:country_iso_code], user.organisation.country.iso_code2)
  end

  def self.add_request_meta_data(hit, request, action_name, params, adapter)
    hit.add_custom_dimension(DIMENSIONS[:method_name], action_name)
    hit.add_custom_dimension(DIMENSIONS[:provider_organisation_id], adapter.organisation_id)
    hit.add_custom_dimension(DIMENSIONS[:provider_country_iso_code], adapter.organisation.country.iso_code2)
    hit.add_custom_dimension(DIMENSIONS[:request_parameters], params)
    hit.add_custom_dimension(DIMENSIONS[:time], Date.today)
  end

  def self.add_response_meta_data(hit, response, response_time, exception)
    hit.add_custom_dimension(DIMENSIONS[:response_time], response_time)
    hit.add_custom_dimension(DIMENSIONS[:response_status], response.status)
    failure_details = exception.present? ? exception.message : ' '
    hit.add_custom_dimension(DIMENSIONS[:failure_details], failure_details)
    timeout = exception.present? ? exception.cause.is_a?(Tiemout::Error) : false
    hit.add_custom_dimension(DIMENSIONS[:timeout], timeout)
  end

  def self.add_metrics(hit)
    hit.add_custom_metric(METRICS[:counter], 1)
  end
end
