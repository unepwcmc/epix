class Admin::OrganisationsController < Admin::BaseController
  load_and_authorize_resource
  respond_to :html

  before_action :load_countries_for_dropdown, only: [:new, :create, :edit, :update]

  def index
    @organisations = Organisation.includes(:country).select(
      :id, :name, :role, :country_id
    )
  end

  def new
    @organisation = Organisation.new
  end

  def edit
    @organisation = Organisation.find(params[:id])
    @adapter = @organisation.try(:adapter)
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
      params.require(:organisation).permit(:name, :role, :country_id)
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
end
