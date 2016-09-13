require 'rails_helper'

require 'savon/mock/spec_helper'

describe Transports::Soap do
  include Savon::SpecHelper

  before(:all) { savon.mock! }
  after(:all) { savon.unmock! }

  it "returns a response using Savon" do
    wsdl = File.read(Rails.root.join("spec/fixtures/transports/", "fake.wsdl"))
    savon.expects(:say_hello).with(message: :any).returns("response")
    service = Transports::Soap.request(wsdl, :say_hello, 0)

    expect(service).to be_successful
    expect(service.to_s).to eq("response")
  end

  it "returns a soap fault timeout error" do
    wsdl = File.read(Rails.root.join("spec/fixtures/transports/", "fake.wsdl"))
    allow(Timeout).to receive(:timeout).and_raise(Timeout::Error)
    expect{ Transports::Soap.request(wsdl, :say_hello, 0.00001) }.
      to raise_error(Adapters::SoapAdapterException, "Timeout::Error")
  end
end
