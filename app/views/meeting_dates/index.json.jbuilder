json.array!(@meeting_dates) do |meeting_date|
  json.extract! meeting_date, :id, :date, :meeting_uuid, :note
  json.url meeting_date_url(meeting_date, format: :json)
end
