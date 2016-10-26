class Transports::Soap < Transports::Base

  def self.request(wsdl, operation, timeout, auth={}, skip_ssl_verification=false, message={})
    begin
      Timeout::timeout(timeout) {
        client = get_client(wsdl, auth, skip_ssl_verification)

        result = client.call(operation, message: message)
      }
    rescue => e
      raise Adapters::SoapAdapterException, e.class
    end
  end

  private

  def self.get_client(wsdl, auth, skip_ssl_verification)
    common_options = {
      wsdl: wsdl,
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
    if skip_ssl_verification
      # for self-signed certs
      common_options.merge!({ ssl_verify_mode: :none })
    end
    return Savon::Client.new(common_options) if auth.empty?

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
