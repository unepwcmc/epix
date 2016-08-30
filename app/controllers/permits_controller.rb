class PermitsController < ApplicationController
  before_action :sanitise_params, only: [:index, :show]
  before_action :load_adapter, only: [:show]

  def index
    if @country && @permit_identifier
      redirect_to(permit_path(
        country: @country, permit_identifier: @permit_identifier
      )) && return
    end
    @countries = Organisation.cites_mas.with_available_adapters.
      joins(:country).
      select('countries.iso_code2, countries.name').
      group('countries.iso_code2, countries.name')
  end

  def show
    @response = Adapters::SimpleAdapter.run(
      @adapter, {
        certificate_number: @permit_identifier,
        token_id: '?',
        country: @country
      }
    )
    @permit = Permit.new(@response.body[:get_non_final_cites_certificate_response])
  end

  private

  def sanitise_params
    @country = params[:country] && params[:country].strip[0..1]
    @permit_identifier = params[:permit_identifier]
  end

  def load_adapter
    organisation = Organisation.cites_mas.with_available_adapters.
      joins(:country).where('countries.iso_code2' => params[:country]).
      first
    unless organisation.present?
      flash.alert = 'Adapter not found or not available'
      redirect_to(permits_path) && return
    end
    @adapter = organisation.adapter
  end


end
