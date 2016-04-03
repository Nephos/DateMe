class MeetingDate < ActiveRecord::Base
  belongs_to :meeting
  has_many :user_dates, :dependent => :delete_all # no dependencies
end
