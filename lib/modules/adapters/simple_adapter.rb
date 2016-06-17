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
    @response = soap_request(wsdl, operation, auth, options)
  end

  def to_hash
    @response.to_hash
  end

  def to_json
    @response.to_json
  end
end
