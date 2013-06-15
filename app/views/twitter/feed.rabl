collection @tweets
attributes :text, :created_at, :profile_image_url_https
child :user do
  attributes :id, :name, :screen_name
end