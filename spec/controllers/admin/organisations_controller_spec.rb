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
      it "adds all countries to access list" do
        organisation = subject.current_user.organisation
        available_countries = Country.with_organisations
        patch :update, params: {
          id: organisation.id,
          organisation: {
            adapter_attributes: {
              id: organisation.adapter.id,
              countries_with_access: [""]
            }
          },
          access_to_all: 1
        }
        organisation.reload
        adapter = organisation.adapter
        expect(adapter.countries_with_access_ids.count).to eq(available_countries.count)
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

  describe "Cites_ma user" do
    login_user

    describe "PATCH update" do
      it "can update access list of countries" do
        organisation = subject.current_user.organisation
        patch :update, id: organisation.id,
          organisation: {
            adapter_attributes: {
              id: organisation.adapter.id,
              countries_with_access_ids: [1, 2]
            }
          }
        organisation.reload
        expect(organisation.adapter.countries_with_access_ids).to eq([1, 2])
      end
    end
  end

  describe "Not cites_ma user" do
    login_user("customs_ea")

    describe "PATCH update" do
      it "cannot update access list of countries" do
        organisation = subject.current_user.organisation
        patch :update, id: organisation.id,
          organisation: {
            adapter_attributes: {
              id: organisation.adapter.id,
              countries_with_access_ids: [1, 2]
            }
          }
        organisation.reload
        expect(organisation.adapter.countries_with_access_ids).to eq([])
      end
    end
  end
end
