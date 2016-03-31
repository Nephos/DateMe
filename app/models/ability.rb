class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    can :read, Meeting
    can :read, MeetingDate
    can :read, UserDate
    can :manage, Meeting, :user_id => user.id

    can :manage, :all if user.admin?
    #can :manage, :all, user.is_admin => true
    #cannot :manage, :all, user.is_admin => false

    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
