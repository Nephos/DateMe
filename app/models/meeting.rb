class Meeting < ActiveRecord::Base
  has_many :meeting_dates
end
