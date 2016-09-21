require "rails_helper"
# require "savon/mock/spec_helper"

RSpec.describe PermitsController, type: :controller do
  # include Savon::SpecHelper

  # before(:all) { savon.mock! }
  # after(:all) { savon.unmock! }

  describe "GET index" do
    login_user
    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end

    it "redirects to permit page if country and permit identifier given" do
      get :index, params: {country: 'CH', permit_identifier: '123'}
      expect(response).to redirect_to(
        permit_path(country: 'CH', permit_identifier: '123')
      )
    end
  end

  describe "GET show" do
    let(:cites_ma){
      FactoryGirl.create(:cites_ma)
    }
    let(:savon_response){
      instance_double(Savon::Response)
    }

    context "when country adapter does not exist" do
      it "redirects to permits" do
        get :show, params: {
          country: 'XX',
          permit_identifier: '123'
        }
        expect(response).to redirect_to(permits_path)
      end
    end

    context "when country adapter supports CITES Toolkit V1" do
      let!(:adapter){
        FactoryGirl.create(:adapter, organisation: cites_ma, cites_toolkit_version: 1)
      }
      let(:fixture){
        File.read("spec/fixtures/v1/get_non_final_cites_certificate.xml")
      }
      it "shows a CITES Toolkit V1 Permit" do
        expect(Adapters::SimpleAdapter).to receive(:run).and_return(savon_response)
        expect(savon_response).to receive(:to_xml).and_return(fixture)
        get :show, params: {
          country: cites_ma.country.iso_code2,
          permit_identifier: '123'
        }
        expect(assigns[:permit]).to be_a(Cites::V1::Permit)
        expect(response.status).to eq(200)
      end
    end

    context "when country adapter supports CITES Toolkit V2" do
      let!(:adapter){
        FactoryGirl.create(:adapter, organisation: cites_ma, cites_toolkit_version: 2)
      }
      let(:fixture){
        File.read("spec/fixtures/v2/get_non_final_cites_certificate.xml")
      }
      it "shows a CITES Toolkit V2 Permit" do
        expect(Adapters::SimpleAdapter).to receive(:run).and_return(savon_response)
        expect(savon_response).to receive(:to_xml).and_return(fixture)
        get :show, params: {
          country: cites_ma.country.iso_code2,
          permit_identifier: '123'
        }
        expect(assigns[:permit]).to be_a(Cites::V2::Permit)
        expect(response.status).to eq(200)
      end
    end

    context "when connection times out" do
      let!(:adapter){
        FactoryGirl.create(:adapter)
      }
      it "redirects to permits with an error" do
        allow_any_instance_of(Savon::Client).to receive(:call).and_raise(Timeout::Error)
        get :show, params: {
          country: cites_ma.country.iso_code2,
          permit_identifier: '123'
        }
        expect(response).to redirect_to(permits_path)
        expect(flash[:error]).to eq('This request took too long to be processed...')
      end
    end

    context "when some other error" do
      let!(:adapter){
        FactoryGirl.create(:adapter)
      }
      it "redirects to permits with an error" do
        allow_any_instance_of(Savon::Client).to receive(:call).and_raise(StandardError)
        get :show, params: {
          country: cites_ma.country.iso_code2,
          permit_identifier: '123'
        }
        expect(response).to redirect_to(permits_path)
        expect(flash[:error]).to eq('Something went wrong')
      end
    end

  end
end
