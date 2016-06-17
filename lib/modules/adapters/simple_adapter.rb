class Adapters::SimpleAdapter < Adapters::Base

  def initialize
    adapter = Adapter.find_by_name('Adapters::SimpleAdapter')
    operation = :get_non_final_cites_certificate
    options = {}
    auth = {
      username: '',
      password: ''
    }
    wsdl = adapter.web_service_uri
    soap_request(wsdl, operation, auth, options)
  end
end
