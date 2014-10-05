collection @menus
attributes :date, :name, :category, :type, :price, :prices, :counter, :allergens_raw, :badges_raw, :order_info
node(:badges) { |menu| menu.parsed_badges(@locale.to_s) }
node(:allergens) { |menu| menu.parsed_allergens(@locale.to_s) }