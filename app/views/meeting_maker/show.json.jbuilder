json.extract! @meeting, :uuid, :name, :description, :end_at, :user_id, :created_at, :updated_at
json.dates @meeting.meeting_dates.select(:id, :date)
json.subscriptions @meeting.user_dates.select(:id, :user_id, :meeting_date_id, :state)
json.users @meeting.users.select(:id, :email)
