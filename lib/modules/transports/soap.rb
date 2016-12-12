class Transports::Soap < Transports::Base

  def self.request(adapter_options, request_options, operation, message={}, timeout)
    client = get_client(adapter_options)
    begin
      Timeout::timeout(timeout) {
        result = client.call(operation, {message: message}.merge(request_options))
      }
    rescue => e
      raise Adapters::SoapAdapterException, e.class
    end
  end

  private

  def self.get_client(adapter_options)
    common_options = {
      convert_request_keys_to: :none
    }
    if Rails.env.development?
      common_options.merge!({
        log: true,
        log_level: :debug,
        logger: Logger.new('./log/soap.log'),
        pretty_print_xml: true
      })
    end
    common_options.merge!(adapter_options)
    Savon::Client.new(common_options)
  end
end
