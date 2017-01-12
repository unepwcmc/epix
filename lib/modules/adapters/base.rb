class Adapters::Base
  attr_reader :params

  SOAP = 'soap_request'
  REST = 'rest_request'

  def self.run(adapter, operation, message = {})
    instance = self.new(adapter)
    instance.request(operation, message)
  end

  def initialize(adapter)
    @adapter = adapter
    @request_type = nil
    @params = {}
    if adapter.skip_ssl_verification
      @params.merge!({
        ssl_verify_mode: :none
      })
    end
    @operations = {}
  end

  def request(operation, message = {})
    send(@request_type, operation, message)
  end

  private

  def soap_request(operation_sym, message = {})
    operation = operation_for_adapter(operation_sym)
    message = message_for_adapter(message)
    raise Adapters::OperationNotAvailableException unless operation.present?
    soap_action = @operations[operation_sym] && @operations[operation_sym][:soap_action]
    request_params = {soap_action: soap_action} if soap_action
    Transports::Soap.request(@params, request_params || {}, operation, message, @adapter.time_out)
  end

  def rest_request(operation, message = {})
  end

  def operation_for_adapter(operation_sym)
    @operations[operation_sym] && @operations[operation_sym][:name]
  end

  def message_for_adapter(message)
    message
  end

end
