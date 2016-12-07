require 'rails_helper'

describe Adapters::SimpleAdapter do
  it "returns a response using soap request" do
    adapter = Adapter.new({web_service_uri: 'some_uri'})
    instance = described_class.new(adapter)
    allow(instance).to receive(:soap_request).and_return("<response id='id'>value</response>")
    expect(instance.request(:test, {})).to eq("<response id='id'>value</response>")
  end
end
