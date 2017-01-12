class Adapters::CzechAdapter < Adapters::SimpleAdapter

  def initialize(adapter)
    super(adapter)
    @params = @params.merge({
      wsdl: adapter.wsdl_url,
      namespace: adapter.ws_namespace,
      soap_header: {
        'v1:AuthenticationSoapHeader' => {
          'Username' => adapter.auth_username,
          'Password' => adapter.auth_password
        }
      },
      namespace_identifier: :v1
    })
    @operations = {
      get_non_final_cites_certificate: {
        name: :get_document
      }
    }
  end

  private

  def message_for_adapter(operation_sym, message)
    if operation_sym == :get_non_final_cites_certificate
      {
        ID: message[:CertificateNumber]
      }
    else
      message
    end
  end
end
