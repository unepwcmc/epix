class Api::V1::BaseController < ApplicationController
  rescue_from Adapters::SoapAdapterException, with: :soap_adapter_exception

  private

  def soap_adapter_exception(e)
    if e.message == "Timeout::Error"
      render_soap_error 'This request took too long to process...'
    else
      render_soap_error 'Something went wrong'
    end
  end

end
