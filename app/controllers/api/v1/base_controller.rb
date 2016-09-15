class Api::V1::BaseController < ApplicationController
  rescue_from Adapters::SoapAdapterException, with: :soap_adapter_exception

  private

  def soap_adapter_exception(e)
    if e.cause.is_a?(Timeout::Error)
      render_soap_error 'This request took too long to process...'
    elsif e.cause.is_a?(Savon::SOAPFault)
      render xml: e.cause.xml
    else
      render_soap_error 'Something went wrong'
    end
  end

end
