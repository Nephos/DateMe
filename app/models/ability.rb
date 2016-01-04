class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    # You can read if you have the url
    can :read, Meeting
    can :read, MeetingDate
    can :read, UserDate

    # You can manage if you created this
    can :manage, Meeting, :user_id => user.id
    can :manage, MeetingDate, :meeting => {:user_id => user.id}
    can :manage, UserDate, :meeting_date => { :meeting => {:user_id => user.id}}

    # Add new data to an existing meeting
    can :new, MeetingDate
    can :create, MeetingDate, :meeting => {:user_id => user.id}
    can :create, UserDate, :user_id => user.id

    can :manage, :all if user.admin?

    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
