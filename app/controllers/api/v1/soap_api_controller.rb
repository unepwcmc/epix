class Api::V1::SoapApiController < Api::V1::BaseController
  soap_service namespace: 'urn:WashOut'

  soap_action :get_final_cites_certificate,
              args: {
                CertificateNumber: :string,
                TokenId: :string,
                IsoCountryCode: :string
              },
              return: :string
  def get_final_cites_certificate
    render soap: (params[:CertificateNumber] + params[:TokenId] + params[:IsoCountryCode])
  end

  soap_action :get_non_final_cites_certificate,
              args: {
                CertificateNumber: :string,
                TokenId: :string,
                IsoCountryCode: :string
              },
              return: :string
  def get_non_final_cites_certificate
    render soap: (params[:CertificateNumber] + params[:TokenId] + params[:IsoCountryCode])
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
      render soap: (params[:CertificateNumber] + params[:TokenId] + params[:IsoCountryCode] + params[:ConfirmedQuantities])
    else
      render soap: "XML structure is not valid. ID must be a token"
    end
  end

  soap_action :service_state,
              args: {},
              return: :string
  def service_state
    render soap: ("a"+"b")
  end

end
