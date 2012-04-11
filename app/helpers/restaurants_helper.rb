module RestaurantsHelper
  def side_dishes_for(menu)
    if menu[:side_dishes][I18n.locale.to_s]
			side_dishes = menu[:side_dishes][I18n.locale.to_s]
		else
			side_dishes = menu[:side_dishes]["de"]
		end
		
		JSON.parse(side_dishes) # we should put something like that rather in the model... TODO
  end
end
