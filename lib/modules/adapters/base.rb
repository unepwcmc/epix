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
    Transports::Soap.request(wsdl, operation, timeout, auth, message)
  end

  def rest_request(message = {})
  end

end
