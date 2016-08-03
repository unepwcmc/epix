require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    @user = FactoryGirl.create(:user)
  end

  test "logged in user should get index" do
    sign_in @user
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end
end
