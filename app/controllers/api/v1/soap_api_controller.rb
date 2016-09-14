class Api::V1::SoapApiController < Api::V1::BaseController
  soap_service namespace: 'urn:WashOut', wsse_auth_callback: ->(email, password) {
    user = User.find_by(email: email)
    return false unless user.present?
    return user.valid_password?(password)
  }

  before_action do
    load_adapter if request.original_url.split('/').last != 'wsdl'
  end

  soap_action :get_final_cites_certificate,
              args: {
                CertificateNumber: :string,
                TokenId: :string,
                IsoCountryCode: :string
              },
              return: :string
  def get_final_cites_certificate
    render xml: Adapters::SimpleAdapter.run(@adapter).to_xml
  end

  soap_action :get_non_final_cites_certificate,
              args: {
                CertificateNumber: :string,
                TokenId: :string,
                IsoCountryCode: :string
              },
              return: :string
  def get_non_final_cites_certificate
    render xml: Adapters::SimpleAdapter.run(@adapter).to_xml
  end

  soap_action :confirm_quantities,
              args: {
                CertificateNumber: :string,
                TokenId: :string,
                IsoCountryCode: :string,
                ConfirmedQuantities: WashOut::Types::CitesPositionsType
              },
              return: :string
  def confirm_quantities
    if WashOut::Types::CitesPositionsType.valid?(params[:ConfirmedQuantities][:CitesPosition])
      render xml: Adapters::SimpleAdapter.run(@adapter).to_xml
    else
      render_soap_error "XML structure is not valid. ID must be a token", "Client"
    end
  end

  soap_action :service_state,
              args: {},
              return: :string
  def service_state
    render xml: Adapters::SimpleAdapter.run(@adapter).to_xml
  end

  private

  def load_adapter
    organisation = Organisation.cites_mas.with_available_adapters.
      joins(:country).where('countries.iso_code2' => params[:IsoCountryCode]).
      first
    unless organisation.present?
      render_soap_error "AdapterNotFound"
    else
      @adapter = organisation.adapter
    end
  end
end
