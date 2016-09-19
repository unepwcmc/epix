class Admin::OrganisationsController < Admin::BaseController
  load_and_authorize_resource
  respond_to :html

  before_action :load_countries_for_dropdown, only: [:new, :create, :edit, :update]
  before_action :load_available_countries, only: [:new, :edit, :show]

  def index
    @organisations = @organisations.includes(:country).select(
      :id, :name, :role, :country_id
    )
  end

  def new
    @organisation = Organisation.new
  end

  def show
    @adapter = @organisation.try(:adapter)
  end

  def edit
    @organisation = Organisation.find(params[:id])
    @adapter = @organisation.try(:adapter)
    if @adapter.present?
      country_ids = @adapter.countries_with_access_ids
      @selected_countries_with_access = Country.where(id: country_ids).order(:name).
        map{ |c| {id: c.id, text: c.name} }
    end
  end

  def create
    @organisation = Organisation.new(organisation_params)

    flash[:notice] = 'Organisation was successfully created' if @organisation.save

    respond_with :admin, @organisation
  end

  def update
    @organisation = Organisation.find(params[:id])

    if @organisation.update_attributes(organisation_params)
      flash[:notice] = 'Organisation was successfully updated.'
    end

    respond_with :admin, @organisation
  end

  private

  def organisation_params
    if current_user.is_system_managers?
      params.require(:organisation).permit(:name, :role, :country_id, adapter_attributes: [:id, countries_with_access_ids: []])
    else
      params.require(:organisation).permit(:name, :country_id, adapter_attributes: [:id, countries_with_access_ids: []])
    end
  end

  def load_countries_for_dropdown
    @countries_for_dropdown = Country.select(
      :id, :name
    ).
    order(:name).map { |c| [c.name, c.id] }
  end

  def load_available_countries
    @available_countries = Country.with_organisations
  end
end
