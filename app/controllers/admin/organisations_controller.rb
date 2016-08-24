class Admin::OrganisationsController < Admin::BaseController
  respond_to :html

  before_action :load_countries

  def index
    @organisations = Organisation.select(
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
    params.require(:organisation).permit(:name, :role, :country_id)
  end

  def load_countries
    @countries_for_dropdown = Country.all.map { |c| [c.name, c.id] }
  end
end
