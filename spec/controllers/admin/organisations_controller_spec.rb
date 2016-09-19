require "rails_helper"

RSpec.describe Admin::OrganisationsController, type: :controller do
  describe "All permissions granted" do
    login_admin

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
        get :edit, params: {id: FactoryGirl.create(:cites_ma).id}
        expect(response.status).to eq(200)
      end
    end

    describe "GET show" do
      it "has a 200 status code" do
        get :show, params: {id: FactoryGirl.create(:cites_ma).id}
        expect(response.status).to eq(200)
      end
    end

    describe "POST create" do
      it "creates a organisation" do
        expect do
          post :create, params: {
            organisation: {
              name: 'org_name',
              role: 'CITES MA',
              country_id: FactoryGirl.create(:country).id
            }
          }
        end.to change{ Organisation.count }

        expect(response.status).to eq(302)
      end
    end

    describe "PATCH update" do
      it "updates an organisation's role" do
        organisation = FactoryGirl.create(:cites_ma)
        patch :update, params: {
          id: organisation.id, organisation: {role: Organisation::SYSTEM_MANAGERS}
        }
        organisation.reload
        expect(organisation.role).to eq(Organisation::SYSTEM_MANAGERS)
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

    describe "PATCH update" do
      it "updates own organisation's name" do
        organisation = subject.current_user.organisation
        old_name = organisation.name
        new_name = old_name + ' ZONK'
        patch :update, params: {
          id: organisation.id, organisation: {name: new_name}
        }
        organisation.reload
        expect(organisation.name).to eq(new_name)
        expect(response.status).to eq(302)
      end
      it "does not update another organisation's name" do
        organisation = FactoryGirl.create(:cites_ma)
        old_name = organisation.name
        patch :update, params: {
          id: organisation.id, organisation: {name: old_name + ' ZONK'}
        }
        organisation.reload
        expect(organisation.name).to eq(old_name)
        expect(response.status).to eq(302)
      end
      it "does not update own organisation's role" do
        organisation = subject.current_user.organisation
        patch :update, params: {
          id: organisation.id, organisation: {role: Organisation::SYSTEM_MANAGERS}
        }
        organisation.reload
        expect(organisation.role).to eq(Organisation::CITES_MA)
        expect(response.status).to eq(302)
      end
    end

  end
end
