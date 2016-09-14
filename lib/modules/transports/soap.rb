class Transports::Soap < Transports::Base

  def self.request(wsdl, operation, auth={}, options={})
    client = get_client(wsdl, auth)

    result = client.call(operation, message: options)
  end

  private

  def self.get_client(wsdl, auth)
    Savon::Client.new(
      wsdl: wsdl,
      convert_request_keys_to: :none
    ) if auth.empty?
    if auth['token_auth'].present?
      Savon::Client.new(
        wsdl: wsdl,
        soap_header: auth[:token_auth],
        convert_request_keys_to: :none
      )
    else
      Savon::Client.new(
        wsdl: wsdl,
        wsse_auth: [auth['username'], auth['password']],
        convert_request_keys_to: :none
      )
    end
  end
end
