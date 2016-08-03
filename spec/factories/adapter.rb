FactoryGirl.define do
  factory :adapter do
    country
    name Faker::Superhero.name
    web_service_type 'SOAP'
    web_service_uri Faker::Internet.url
    is_available true
    organisation
  end
end
