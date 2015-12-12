json.array!(@meets) do |meet|
  json.extract! meet, :id, :name, :description, :end_at, :dates
  json.url meet_url(meet, format: :json)
end
