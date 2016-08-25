require "rails_helper"

RSpec.describe Admin::UsersController, type: :controller do
  describe "All permissions granted" do
    login_admin

    let!(:same_org_user) {
      FactoryGirl.create(:user,
        organisation_id: @cites_ma.id
      )
    }

    describe "GET index" do
      it "has a 200 status code" do
        get :index
        expect(response.status).to eq(200)
      end
    end

    describe "GET new" do
      it "has a 200 status code" do
        get :new
        expect(response.status).to eq(200)
      end
    end

    describe "GET edit" do
      it "has a 200 status code" do
        get :edit, id: same_org_user.id
        expect(response.status).to eq(200)
      end
    end

    describe "GET show" do
      it "has a 200 status code" do
        get :show, id: same_org_user.id
        expect(response.status).to eq(200)
      end
    end

    describe "POST create" do
      it "creates a user" do
        expect do
          post :create, params: {
            user: {
              first_name: 'name',
              last_name: 'surname',
              email: 'email@email.com',
              password: 'asdasdasd',
              password_confirmation: 'asdasdasd'
            }
          }
        end.to change{ User.count }

        expect(response.status).to eq(302)
      end
    end

    describe "PATCH update" do
      it "updates a user" do
        patch :update, id: same_org_user.id, user: { first_name: 'asd'}
        same_org_user.reload
        expect(same_org_user.first_name).to eq('asd')
        expect(response.status).to eq(302)
      end
    end

    describe "DELETE destroy" do
      it "destroys a user" do
        expect do
          delete :destroy, id: same_org_user.id
        end.to change{ User.count }

        expect(response.status).to eq(302)
      end
    end
  end

  describe "Restricted permissions" do
    login_user

    describe "GET index" do
      it "should redirect" do
        get :index
        expect(response.status).to eq(302)
      end
    end
  end

end
