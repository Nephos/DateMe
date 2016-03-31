class UserDate < ActiveRecord::Base
  belongs_to :user
  belongs_to :meeting_date
end
