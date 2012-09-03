class Restaurant 
  include Mongoid::Document
  field :name, type: String
  field :location, type: String
  field :feed_url, type: String
  embeds_many :menus
  accepts_nested_attributes_for :menus
end
