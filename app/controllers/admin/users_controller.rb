class Admin::UsersController < Admin::BaseController
  def index
    @users = User.select(:id, :email, :organisation_id)
  end
end