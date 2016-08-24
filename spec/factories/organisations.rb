FactoryGirl.define do
  factory :organisation do
    name { Faker::Company.name }
    role Organisation::CITES_MA
    country
    adapter
  end
end
