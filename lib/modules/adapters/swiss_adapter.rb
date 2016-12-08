class Adapters::SwissAdapter < Adapters::SimpleAdapter

  def initialize(adapter)
    super(adapter)
    @params.delete(:wsdl) # TODO
    @params = @params.merge({
      endpoint: 'TODO', 
      namespace: 'TODO',
      ssl_cert_file: adapter.cert_path,
      ssl_cert_key_file: adapter.cert_key_path,
      ssl_cert_key_password: adapter.cert_passphrase,
      env_namespace: :soapenv,
      namespace_identifier: :v1
    })
    @operations = {
      get_non_final_cites_certificate: {
        name: :GetNonFinalCitesCertificateRequest,
        soap_action: 'urn:GetNonFinalCitesCertificate'
      },
      get_final_cites_certificate: {
        name: :GetFinalCitesCertificateRequest,
        soap_action: 'urn:GetFinalCitesCertificate'
      },
      confirm_quantities: {
        name: :ConfirmQuantitiesRequest,
        soap_action: 'urn:ConfirmQuantities'
      },
      service_state: {
        name: :ServiceStateRequest,
        soap_action: 'urn:ServiceState'
      }
    }
  end
end
