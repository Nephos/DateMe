class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.admin?
      can :manage, :all
    else
      cannot :manage, Meeting
      cannot :manage, MeetingDate
      cannot :manage, UserDate
      cannot :manage, User
      cannot :manage, Comment
    end

    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
