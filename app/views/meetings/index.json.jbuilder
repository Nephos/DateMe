json.array!(@meetings) do |meeting|
  json.extract! meeting, :id, :uuid, :name, :description, :end_at, :user_id
  json.url meeting_url(meeting, format: :json)
end
