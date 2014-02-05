class Menu
  include Mongoid::Document
  field :date, type: Date
  field :name, type: String, localize: true
  field :type, type: String, localize: true
  field :description, type: String, localize: true
  field :counter, type: String, localize: true
  field :price, type: String
  field :side_dishes, type: Array, localize: true
  field :badges, type: Array
  embedded_in :restaurant
  
  def bagde
    badges.join(", ")
  end
  
  def parsed_side_dishes(locale = nil)
    result = {}
      if self[:side_dishes].respond_to?(:each)
        self[:side_dishes].each do |key, val|
        result[key] = JSON.parse(val) if val
      end
    end
    if locale
      result[locale]||result["de"]
    else
      result
    end
  end
end
