class Admin::UsersController < Admin::BaseController
  def index
    @users = User.select(
      :id, :first_name, :last_name, :email, :organisation_id, :is_admin
    )
  end
end