FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "#{n}#{Faker::Internet.email}" }
    password { Faker::Internet.password(10, 20) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    is_admin false
    organisation { FactoryGirl.create(:cites_ma) }

    Organisation::VALID_ROLES.each do |role|
      role_name = role.downcase.tr(" ", "_")
      factory :"#{role_name}_user" do
        organisation { FactoryGirl.create(role_name.to_sym) }
        is_admin true
      end
    end
  end
end

