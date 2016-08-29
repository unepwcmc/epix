class Adapters::SimpleAdapter < Adapters::Base

  #Example on how to invoke the adapter
  #
  #  adapter = Organisation.find(organisation_id).adapter
  #  if adapter.is_available
  #    @res = adapter.name.constantize.run(adapter)
  #  else
  #    #Return unavailable message
  #  end
  def initialize(adapter)
    @params = {
      request_type: 'soap_request',
      wsdl: adapter.web_service_uri,
      timeout: adapter.time_out,
      operation: :get_non_final_cites_certificate,
      auth: {
        username: '',
        password: ''
      }
    }
  end
end
