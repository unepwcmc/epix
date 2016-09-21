require "rails_helper"

RSpec.describe PermitsController, type: :controller do
  describe "GET index" do
    login_user
    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end
  end
end
