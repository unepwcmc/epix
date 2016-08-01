class Admin::UsersController < ApplicationController
  def index
    @users = User.select(:id, :email)
  end
end