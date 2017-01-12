class Api::V1::SoapApiController < Api::V1::BaseController
  soap_service namespace: 'urn:CitesDataExchange'

  before_action :authenticate_client_certificate
  before_action :load_caller_organisation, except: :_generate_wsdl
  before_action :load_callee_organisation, except: :_generate_wsdl
  before_action :load_adapter, except: :_generate_wsdl
  before_action :track_soap_request, except: :_generate_wsdl

  after_action :track_soap_response, except: :_generate_wsdl

  soap_action :get_final_cites_certificate,
              args: {
                CertificateNumber: :string,
                TokenId: :string,
                IsoCountryCode: :string
              },
              return: :string
  def get_final_cites_certificate
    render xml: @adapter_klass.run(
      @adapter,
      :get_final_cites_certificate,
      params.permit(:CertificateNumber, :TokenId, :IsoCountryCode).to_h
    ).to_xml
  end

  soap_action :get_non_final_cites_certificate,
              args: {
                CertificateNumber: :string,
                TokenId: :string,
                IsoCountryCode: :string
              },
              return: :string
  def get_non_final_cites_certificate
    render xml: @adapter_klass.run(
      @adapter,
      :get_non_final_cites_certificate,
      params.permit(:CertificateNumber, :TokenId, :IsoCountryCode).to_h
    ).to_xml
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
      render xml: @adapter_klass.run(
        @adapter,
        :confirm_quantities,
        params.permit(:CertificateNumber, :TokenId, :IsoCountryCode).to_h
      ).to_xml
    else
      render_soap_error "XML structure is not valid. ID must be a token", "Client"
    end
  end

  soap_action :service_state,
              args: {},
              return: :string
  def service_state
    render xml: @adapter_klass.run(@adapter, :service_state).to_xml
  end

  private

  def authenticate_client_certificate
    request.env['HTTP_X_SSL_CLIENT_S_DN'] =~ /C=(.+?)\//
    @caller_country = $1
    if (request.env['HTTP_X_SSL_CLIENT_S_DN'].blank? ||
      @caller_country.blank?) && !Rails.env.development?
      render_soap_error "CertificateMissing" and return false
    end
  end

  def load_caller_organisation
    # TODO: soap_request.headers[:Caller].inspect
    @caller_organisation = Organisation.cites_mas.joins(:country).
      where('countries.iso_code2' => @caller_country).first
    if !@caller_organisation.present?
      render_soap_error "CallerNotFound" and return false
    end
  end

  def load_callee_organisation
    # TODO: soap_request.headers[:Callee].inspect
    @callee_organisation = Organisation.cites_mas.with_available_adapters.
      joins(:country).
      where('countries.iso_code2' => params[:IsoCountryCode]).
      first
    if !@callee_organisation.present?
      render_soap_error "CalleeNotFound" and return false
    end
  end

  def load_adapter
    if !@callee_organisation.adapter.has_country?(@caller_organisation.country_id) &&
      !@caller_organisation.can_access_adapter?(@callee_organisation)
      render_soap_error "AdapterNotAvailable" and return
    else
      @adapter = @callee_organisation.adapter
    end
    @adapter_klass = @adapter.name.constantize
  end

  def track_soap_request
    @hit = Staccato::Pageview.new(tracker, path: request.path)
    GaTracker.add_caller_identification(@hit, request, @caller_organisation)
    GaTracker.add_request_meta_data(@hit, request, action_name, params, @adapter)
    @start_time = Time.now
  end

  def track_soap_response(exception=nil)
    response_time = (Time.now - @start_time).to_f
    GaTracker.add_response_meta_data(@hit, response, response_time, exception)
    GaTracker.add_metrics(@hit)
    @hit.track!
  end
end
