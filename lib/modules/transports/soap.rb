class Transports::Soap < Transports::Base

  def self.request(wsdl, operation, auth={}, options={})
    client = get_client(wsdl, auth)

    result = client.call(operation, message: options)
  end

  private

  def self.get_client(wsdl, auth)
    Savon::Client.new(wsdl: wsdl) if auth.empty?
    if auth['token_auth'].present?
      Savon::Client.new(wsdl: wsdl, soap_header: auth[:token_auth])
    else
      Savon::Client.new(wsdl: wsdl, wsse_auth: [auth['username'], auth['password']])
    end
  end
end
