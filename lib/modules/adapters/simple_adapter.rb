class Adapters::SimpleAdapter < Adapters::Base

  def initialize(adapter)
    @params = {
      request_type: 'soap_request',
      wsdl: adapter.web_service_uri,
      timeout: adapter.time_out,
      operation: :get_non_final_cites_certificate,
      options: {},
      auth: {
        username: '',
        password: ''
      }
    }
  end
end
