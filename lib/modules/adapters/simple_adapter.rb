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
    super(adapter)
    @request_type = SOAP
    @params.merge!({
      wsdl: adapter.web_service_uri,
    })
    @operations = {
      get_non_final_cites_certificate: {
        name: :get_non_final_cites_certificate
      },
      get_final_cites_certificate: {
        name: :get_final_cites_certificate
      },
      confirm_quantities: {
        name: :confirm_quantities
      },
      service_state: {
        name: :service_state
      }
    }
  end

end
