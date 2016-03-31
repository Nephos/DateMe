json.array!(@user_dates) do |user_date|
  json.extract! user_date, :id, :user_id, :meeting_date_id
  json.url user_date_url(user_date, format: :json)
end
