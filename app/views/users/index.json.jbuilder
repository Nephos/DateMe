json.array!(@users) do |user|
  json.extract! user, :id, :uuid, :email, :roles
  json.url user_url(user, format: :json)
end
