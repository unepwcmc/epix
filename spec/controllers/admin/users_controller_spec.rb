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
      it "should filter list by same organisation" do
        same_org_id = subject.current_user.organisation_id
        FactoryGirl.create(:user, organisation_id: same_org_id)
        get :index
        expect(assigns(:users).size).to eq(2)
        expect(response.status).to eq(200)
      end
    end

    describe "PATCH update" do
      it "updates own last name" do
        user = subject.current_user
        old_last_name = user.last_name
        new_last_name = user.last_name + 'ZONK'
        patch :update, id: user.id, user: { last_name: new_last_name}
        user.reload
        expect(user.last_name).to eq(new_last_name)
        expect(response.status).to eq(302)
      end
      it "updates another user's in same organisation last name" do
        user = subject.current_user
        other_user = FactoryGirl.create(:user, organisation: user.organisation)
        old_last_name = other_user.last_name
        new_last_name = other_user.last_name + 'ZONK'
        patch :update, id: other_user.id, user: { last_name: new_last_name}
        other_user.reload
        expect(other_user.last_name).to eq(new_last_name)
        expect(response.status).to eq(302)
      end
      it "does not update another user's in another organisation last name" do
        user = subject.current_user
        other_user = FactoryGirl.create(:user, organisation: FactoryGirl.create(:organisation))
        old_last_name = other_user.last_name
        new_last_name = other_user.last_name + 'ZONK'
        patch :update, id: other_user.id, user: { last_name: new_last_name}
        other_user.reload
        expect(other_user.last_name).to eq(old_last_name)
        expect(response.status).to eq(302)
      end
      it "does not update own organisation" do
        user = subject.current_user
        old_organisation = user.organisation
        new_organisation = FactoryGirl.create(:organisation)
        patch :update, id: user.id, user: { organisation_id: new_organisation.id }
        user.reload
        expect(user.organisation_id).to eq(old_organisation.id)
        expect(response.status).to eq(302)
      end
    end

  end

  describe "Even more restricted permissions" do
    login_unprivileged_user

    describe "PATCH update" do
      it "updates own last name" do
        user = subject.current_user
        old_last_name = user.last_name
        new_last_name = user.last_name + 'ZONK'
        patch :update, id: user.id, user: { last_name: new_last_name}
        user.reload
        expect(user.last_name).to eq(new_last_name)
        expect(response.status).to eq(302)
      end
    end

  end

end
