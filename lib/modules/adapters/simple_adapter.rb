class Adapters::SimpleAdapter < Adapters::Base

  def initialize
    initialise_params
    request
  end

  private

  def initialise_params
    @params = {
      request_type: 'SOAP',
      adapter: 'Adapters::SimpleAdapter',
      operation: :get_non_final_cites_certificate,
      options: {},
      auth: {
        username: '',
        password: ''
      }
    }
  end
end
