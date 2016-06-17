class Adapters::Base
  attr_reader :response

  TIMEOUT = 10

  def soap_request(wsdl, operation, auth, options)
    begin
      Timeout::timeout(TIMEOUT) {
       @response = Transports::Soap.request(wsdl, operation, auth, options)
      }
    rescue => e
      if e.is_a?(Timeout::Error)
        p 'This request took too long to process...'
      else
        p 'Something went wrong'
      end
    end
  end

  def to_hash
    @response.to_hash
  end

  def to_json
    @response.to_json
  end
end
