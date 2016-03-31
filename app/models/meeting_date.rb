class MeetingDate < ActiveRecord::Base
  belongs_to :meeting
  has_many :user_dates
end
