class Admin::UsersController < Admin::BaseController
  def index
    @users = User.select(:id, :email)
  end
end