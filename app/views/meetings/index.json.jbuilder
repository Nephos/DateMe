json.array!(@meetings) do |meeting|
  json.extract! meeting, :id, :name, :description, :end_at, :dates
  json.url meeting_url(meeting, format: :json)
end
