FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "#{n}#{Faker::Internet.email}" }
    password Faker::Internet.password(10, 20)
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    is_admin false
  end
end

