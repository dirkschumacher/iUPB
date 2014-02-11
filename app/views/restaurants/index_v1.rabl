collection @menus
attributes :date, :description, :name, :type, :price, :counter
node(:side_dishes) { |menu| menu.parsed_side_dishes(I18n.locale.to_s) }