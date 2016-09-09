require "rails_helper"
require 'savon'

RSpec.describe Api::V1::SoapApiController, type: :controller do
  describe "GET get_non_final_cites_certificate" do
    it "returns non empty xml" do
      client = Savon::Client.new(wsdl: "http://localhost:3000/api/v1/soap_api/wsdl")
      result = client.call(:get_non_final_cites_certificate,
                           message: {
                             CertificateNumber: 'permit_id',
                             TokenId: 'token',
                             IsoCountryCode: 'country'
                           }
                       )
      result.body[:get_non_final_cites_certificate_response].should_not be_nil
    end
  end
end
