FactoryGirl.define do
  factory :adapter do
    name 'Adapters::SimpleAdapter'
    web_service_type 'SOAP'
    wsdl_url { Faker::Internet.url }
    is_available true
  end
end
