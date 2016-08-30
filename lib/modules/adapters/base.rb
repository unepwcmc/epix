class Adapters::Base
  attr_reader :params

  def self.run(adapter, message = {})
    instance = self.new(adapter)
    instance.request(message)
  end

  def initialize(adapter)
    @params = {}
  end

  def request(message = {})
    send(@params[:request_type], message)
  end

  private

  def soap_request(message = {})
    wsdl = @params[:wsdl]
    operation = @params[:operation]
    auth = @params[:auth]
    timeout = @params[:timeout]
    begin
      Timeout::timeout(timeout) {
       Transports::Soap.request(wsdl, operation, auth, message)
      }
    rescue => e
      if e.is_a?(Timeout::Error)
        p 'This request took too long to process...'
      else
        p 'Something went wrong'
      end
    end
  end

  def rest_request(message = {})
  end

end
