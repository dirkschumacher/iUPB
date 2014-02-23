collection @courses
attributes :title, :next_class
node(:id) { |o| o.id.to_s }