class Meeting < ActiveRecord::Base
  has_many :meeting_dates
  has_many :user_dates, through: :meeting_dates
  belongs_to :user
end
