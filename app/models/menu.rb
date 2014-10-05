class Menu
  include Mongoid::Document
  field :date, type: Date
  field :name, type: String, localize: true
  field :type, type: String, localize: true
  field :category, type: String
  field :counter, type: String, localize: true
  field :price, type: String
  field :prices, type: Hash
  field :side_dishes, type: Array, localize: true # :legacy:
  field :badges, type: Array
  field :allergens, type: Array
  field :allergens_raw, type: Array
  field :badges_raw, type: Array
  field :order_info, type: Integer, default: 1
  field :dinner, type: Boolean
  embedded_in :restaurant
  
  def bagde # :legacy:
    parsed_badges.join(", ")
  end
  
  def parsed_allergens(locale = nil)
    self.allergens.map do |_allergen|
      _allergen[locale.try(:to_s) || 'de'] if _allergen
    end.compact
  end
  
  def parsed_badges(locale = nil)
    self.badges.map do |_badge|
      _badge[locale.try(:to_s) || 'de']
    end
  end
  
  def parsed_side_dishes(locale = nil) # :legacy:
    parsed_field :side_dishes, locale, true
  end
  
  def parsed_field(field, locale = nil, json_field = false)
    # mongoid bug in our version that doesn't deep localizes arrays
    result = {}
      if self[field].respond_to?(:each)
        self[field].each do |key, val|
          if json_field
            result[key] = JSON.parse(val) if val
          else
            result[key] = val
          end
      end
    end
    puts result
    if locale
      result[locale.to_s]||result["de"]
    else
      result
    end
  end
  
  # constants for sorting from MensaUPB for the :order_info field:
  SORT_MAIN_DISHES = 0
  SORT_SOUP = 5
  SORT_HK = 20
  SORT_GRILL = 25
  SORT_SALAD = 30
  SORT_DESSERT = 32
  SORT_BUFFET = 35
  SORT_DISH_EXPENSIVE = 40
  SORT_SMALL_SOUP = 60
  SORT_DESSERT_EXPENSIVE = 90
  
  
end
