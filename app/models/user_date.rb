class UserDate < ActiveRecord::Base

  STATE = {
    "yes" => "bg-success",
    "no" => "bg-danger",
    "maybe" => "bg-warning"
  }

  belongs_to :user
  belongs_to :meeting_date
end
