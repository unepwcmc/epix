FactoryGirl.define do
  factory :adapter do
    sequence(:name) { |n| "#{n}#{Faker::Superhero.name}" }
    web_service_type 'SOAP'
    web_service_uri { Faker::Internet.url }
    is_available true
  end
end
