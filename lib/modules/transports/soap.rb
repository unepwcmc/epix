class Transports::Soap < Transports::Base

  def self.request(wsdl, operation, timeout, auth={}, message={})
    begin
      Timeout::timeout(timeout) {
        client = get_client(wsdl, auth)

        result = client.call(operation, message: message)
      }
    rescue => e
      raise Adapters::SoapAdapterException, e.class
    end
  end

  private

  def self.get_client(wsdl, auth)
    common_options = {
      wsdl: wsdl,
      convert_request_keys_to: :none,
      ssl_verify_mode: :none # TODO: temporary self-signed cert for dummy WS
    }
    Savon::Client.new(common_options) if auth.empty?
    if auth['token_auth'].present?
      Savon::Client.new(
        common_options.merge({
          soap_header: auth[:token_auth]
        })
      )
    else
      Savon::Client.new(
        common_options.merge({
          wsse_auth: [auth['username'], auth['password']]
        })
      )
    end
  end
end
