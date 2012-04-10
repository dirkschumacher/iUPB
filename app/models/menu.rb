class Menu
  include Mongoid::Document
  field :date, type: Date
  field :name, type: String, localize: true
  field :type, type: String, localize: true
  field :description, type: String, localize: true
  field :counter, type: String, localize: true
  field :price, type: String
  field :side_dishes, type: Array, localize: true
  embedded_in :restaurant
end
