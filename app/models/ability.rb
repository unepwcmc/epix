class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.is_admin
      if user.is_system_managers?
        can :manage, :all
      elsif user.is_cites_ma?
        can :update, Organisation, id: user.organisation.id
        can :update, Adapter, id: user.organisation.try(:adapter).try(:id)
        can :manage, User, organisation_id: user.organisation_id
      elsif user.is_customs_ea?
        can :update, Organisation, id: user.organisation.id
        can :manage, User, organisation_id: user.organisation_id
      else
        can :update, User, id: user.id
      end
    else
      can :update, User, id: user.id
    end
  end
end
