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
      raise Adapters::AdapterException, e.class
    end
  end

  def rest_request(message = {})
  end

end
