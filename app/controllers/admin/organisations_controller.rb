class Admin::OrganisationsController < Admin::BaseController
  def index
    @organisations = Organisation.select(
      :id, :name, :role, :country_id
    )
  end
end