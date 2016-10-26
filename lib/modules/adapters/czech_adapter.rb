class Adapters::CzechAdapter < Adapters::Base

  def self.run(adapter, message = {})
    instance = self.new(adapter)
    message = {ID: message[:CertificateNumber]}
    instance.request(message)
  end

  def initialize(adapter)
    @params = {
      request_type: 'soap_request',
      wsdl: adapter.web_service_uri,
      timeout: adapter.time_out,
      operation: :get_document,
      auth: {
        soap_header: {
          'AuthenticationSoapHeader' => {
            'Username' => adapter.auth_username,
            'Password' => adapter.auth_password
          }
        },
      }
    }
  end
end
