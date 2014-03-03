collection @menus
attributes :date, :description, :name, :type, :price, :counter, :allergens, :order_info
node(:badges) { |menu| menu.parsed_badges(@locale.to_s) }
# node(:allergens) { |menu| menu.parsed_allergens(@locale.to_s) }