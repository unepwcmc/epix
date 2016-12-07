class Adapters::CzechAdapter < Adapters::SimpleAdapter

  def initialize(adapter)
    super(adapter)
    @params = @params.merge({
      wsdl: adapter.web_service_uri,
      soap_header: {
        'AuthenticationSoapHeader' => {
          'Username' => adapter.auth_username,
          'Password' => adapter.auth_password
        }
      }
    })
    @operations = {
      get_non_final_cites_certificate: {
        name: :get_document
      }
    }
  end

  private

  def message_for_adapter(message)
    {
      ID: message[:CertificateNumber]
    }
  end
end
