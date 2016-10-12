class Api::V1::SoapApiController < Api::V1::BaseController
  soap_service namespace: 'urn:WashOut', wsse_auth_callback: ->(email, password) {
    user = User.find_by(email: email)
    return false unless user.present?
    return user.valid_password?(password)
  }

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
    render xml: Adapters::SimpleAdapter.run(@adapter, params).to_xml
  end

  soap_action :get_non_final_cites_certificate,
              args: {
                CertificateNumber: :string,
                TokenId: :string,
                IsoCountryCode: :string
              },
              return: :string
  def get_non_final_cites_certificate
    render xml: Adapters::SimpleAdapter.run(@adapter, params).to_xml
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
      render xml: Adapters::SimpleAdapter.run(@adapter, params).to_xml
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
    @user = get_user
    if !organisation.present?
      render_soap_error "AdapterNotFound"
    elsif !organisation.adapter.has_country?(@user.organisation.country_id) &&
      !@user.can_access_adapter?(organisation.country_id)
      render_soap_error "AdapterNotAvailable"
    else
      @adapter = organisation.adapter
    end
  end

  def track_soap_request
    #to get the action just use `action_name`
    @hit = Staccato::Pageview.new(tracker, path: request.path)
    GaTracker.add_caller_identification(@hit, request, @user)
    GaTracker.add_request_meta_data(@hit, request, action_name, params, @adapter)
    @start_time = Time.now
  end

  def track_soap_response(exception=nil)
    response_time = (Time.now - @start_time).to_f
    GaTracker.add_response_meta_data(@hit, response, response_time, exception)
    GaTracker.add_metrics(@hit)
    @hit.track!
  end

  def get_user
    wsse_token = request.env['WSSE_TOKEN']
    user_email = wsse_token.values_at(:username, :Username).compact.first
    User.find_by_email(user_email)
  end
end
