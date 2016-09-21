FactoryGirl.define do
  factory :country do
    name { Faker::Address.country }
    iso_code2 { Faker::Address.country_code }
  end
end
