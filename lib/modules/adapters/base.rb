class Adapters::Base
  attr_reader :params

  def self.run(adapter)
    instance = self.new(adapter)
    instance.request
  end

  def initialize(adapter)
    @params = {}
  end

  def request
    send(@params[:request_type])
  end

  private

  def soap_request
    wsdl = @params[:wsdl]
    operation = @params[:operation]
    auth = @params[:auth]
    options = @params[:options]
    timeout = @params[:timeout]
    begin
      Timeout::timeout(timeout) {
       Transports::Soap.request(wsdl, operation, auth, options)
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
