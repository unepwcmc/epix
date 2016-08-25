FactoryGirl.define do
  factory :organisation do
    sequence(:name) { |n| "#{n}#{Faker::Company.name}" }
    role Organisation::SYSTEM_MANAGERS
    country
    adapter

    Organisation::VALID_ROLES.each do |role|
      role_name = role.downcase.tr(" ", "_")
      factory :"#{role_name}" do
        role role
      end
    end
  end
end
