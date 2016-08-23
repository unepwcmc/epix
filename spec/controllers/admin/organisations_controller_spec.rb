require "rails_helper"

RSpec.describe Admin::OrganisationsController, type: :controller do
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
      get :edit, id: FactoryGirl.create(:organisation).id
      expect(response.status).to eq(200)
    end
  end

  describe "GET show" do
    it "has a 200 status code" do
      get :show, id: FactoryGirl.create(:organisation).id
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
    it "updates a organisation" do
      organisation = FactoryGirl.create(:organisation)
      patch :update, id: organisation.id, organisation: { name: 'asd'}
      organisation.reload
      expect(organisation.name).to eq('asd')
      expect(response.status).to eq(302)
    end
  end

  describe "DELETE destroy" do
    it "destroys a organisation" do
      organisation = FactoryGirl.create(:organisation)
      expect do
        delete :destroy, id: organisation.id
      end.to change{ Organisation.count }

      expect(response.status).to eq(302)
    end
  end
end
