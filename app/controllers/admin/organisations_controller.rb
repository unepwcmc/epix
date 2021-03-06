class Admin::OrganisationsController < Admin::BaseController
  load_and_authorize_resource
  respond_to :html

  before_action :load_countries_for_dropdown, only: [:new, :create, :edit, :update]
  before_action :load_available_countries, only: [:new, :edit, :update, :show]

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
    @adapter = @organisation.try(:adapter)
    if @adapter.present?
      @available_countries_for_dropdown = @available_countries.
        order(:name).map { |c| [c.name, c.id] }
      @selected_countries_with_access = @adapter.countries_with_access.
        map{ |c| {id: c.id, text: c.name} }
    end
  end

  def create
    @organisation = Organisation.new(organisation_params)

    flash[:notice] = 'Organisation was successfully created' if @organisation.save

    respond_with :admin, @organisation
  end

  def update
    disable_error_correction = organisation_params[:trade_reporting_enabled] == '0'
    new_org_params = organisation_params

    if disable_error_correction
      new_org_params = organisation_params.merge({
        trade_error_correction_in_sandbox_enabled: '0'
      })
    end

    if @organisation.update_attributes(new_org_params)
      flash[:notice] = 'Organisation was successfully updated.'
    end

    respond_with :admin, @organisation
  end

  private

  def organisation_params
    if current_user.is_system_managers?
      params.require(:organisation).permit(:name, :role, :country_id, :trade_reporting_enabled,
                                             :trade_error_correction_in_sandbox_enabled,
                                             adapter_attributes:
                                               [:id, :blanket_permission, countries_with_access_ids: []]
                                          )
    elsif current_user.is_cites_ma? && current_user.is_admin?
      params.require(:organisation).permit(:name, :country_id, :trade_reporting_enabled,
                                             :trade_error_correction_in_sandbox_enabled,
                                             adapter_attributes:
                                               [:id, :blanket_permission, countries_with_access_ids: []]
                                          )
    else
      params.require(:organisation).permit(:name, :country_id)
    end
  end

  def load_countries_for_dropdown
    @countries_for_dropdown = Country.select(
      :id, :name
    ).
    order(:name).map { |c| [c.name, c.id] }
  end

  def load_available_countries
    @available_countries = Country.with_organisations.
      where("countries.id != #{@organisation.country_id}")
  end

end
