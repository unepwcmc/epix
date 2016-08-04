FactoryGirl.define do
  factory :organisation do
    name Faker::Company.name
    role 'CITES MA'
    country
  end
end
