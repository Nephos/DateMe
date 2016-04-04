json.extract! @meeting, :id, :name, :description, :end_at, :user_id, :created_at, :updated_at
json.dates @meeting.meeting_dates.select(:id, :date)
json.subscriptions @meeting.user_dates.select(:user_id, :meeting_date_id, :state)
