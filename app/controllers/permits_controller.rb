class PermitsController < ApplicationController
  before_action :sanitise_params, only: [:index, :show]
  before_action :authenticate_user!
  before_action :load_caller_organisation, only: [:show]
  before_action :load_callee_organisation, only: [:show]
  before_action :load_adapter, only: [:show]

  rescue_from Adapters::SoapAdapterException, with: :soap_adapter_exception

  def index
    if @country && @permit_identifier
      redirect_to(permit_path(
        country: @country, permit_identifier: @permit_identifier,
        security_token: @security_token
      )) && return
    end
    @countries = Organisation.cites_mas.with_available_adapters.
      joins(:country).
      select('countries.iso_code2, countries.name').
      group('countries.iso_code2, countries.name')
  end

  def show
    @response = @adapter_klass.run(
      @adapter,
      :get_non_final_cites_certificate,
      {
        CertificateNumber: @permit_identifier,
        TokenId: @security_token,
        IsoCountryCode: @country
      }
    )

    xml = Nokogiri::XML(@response.to_xml)
    xml.remove_namespaces!
    @permit = if @adapter.cites_toolkit_v2?
                Cites::V2::Permit.new(xml)
              else
                Cites::V1::Permit.new(xml)
              end
  end

  private

  def sanitise_params
    @country = params[:country] && params[:country].strip[0..1]
    @permit_identifier = params[:permit_identifier]
    @security_token = params[:security_token]
  end

  def load_caller_organisation
    @caller_organisation = current_user.organisation
    if !@caller_organisation.present?
      flash.alert = 'Caller not found'
      redirect_to(permits_path) and return false
    end
  end

  def load_callee_organisation
    @callee_organisation = Organisation.cites_mas.with_available_adapters.
      joins(:country).
      where('countries.iso_code2' => params[:country].try(:upcase)).
      first
    if !@callee_organisation.present?
      flash.alert = 'Callee not found'
      redirect_to(permits_path) and return false
    end
  end

  def load_adapter
    unless @callee_organisation.adapter && (
        @callee_organisation.adapter.has_country?(@caller_organisation.country_id) ||
        @caller_organisation.can_access_adapter?(@callee_organisation)
      )
      flash.alert = 'Web Service access denied'
      redirect_to(permits_path) and return false
    end
    @adapter = @callee_organisation.adapter
    @adapter_klass = @adapter.name.constantize
  end

  def soap_adapter_exception(e)
    message = if e.cause.is_a?(Timeout::Error)
                'This request took too long to be processed...'
              elsif e.cause.is_a?(Savon::SOAPFault)
                """
                SOAP error:
                #{e.cause.to_s}
                """
              else
                """
                Internal error:
                #{e.cause.to_s}
                """
              end
    redirect_to permits_path, flash: { alert: message }
  end


end
