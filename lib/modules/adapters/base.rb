class Adapters::Base
  attr_reader :response, :params

  TIMEOUT = 10

  def request
    request_type = "#{@params[:request_type].downcase}_request".to_sym
    send(request_type)
  end

  def to_hash
    @response.to_hash
  end

  def to_json
    @response.to_json
  end

  private

  def initialise_params; end

  def soap_request
    adapter = Adapter.find_by_name(@params[:adapter])
    wsdl = adapter.web_service_uri
    operation = @params[:operation]
    auth = @params[:auth]
    options = @params[:options]
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

  def rest_request
  end

end
