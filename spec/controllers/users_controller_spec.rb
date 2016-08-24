require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  create_organisations
  login_user

  it "should have a current_user" do
    expect(subject.current_user).to_not eq(nil)
  end
end
