json.array!(@profiles) do |profile|
  json.extract! profile, :id, :first_name, :last_name, :years_of_experience, :price
  json.url profile_url(profile, format: :json)
end
