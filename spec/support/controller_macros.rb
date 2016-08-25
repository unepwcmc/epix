module ControllerMacros
  def login_user
    create_organisations
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(:cites_ma_user)
      sign_in user
    end
  end

  def login_admin
    create_organisations
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(:user,
        is_admin: true,
        organisation_id: @system_managers.id
      )
      sign_in user
    end
  end

  def create_organisations
    before(:each) do
      Organisation::VALID_ROLES.each do |role|
        role_name = role.downcase.tr(" ", "_")
        organisation = FactoryGirl.create(role_name.to_sym)
        instance_variable_set("@#{role_name}", organisation)
      end
    end
  end
end
