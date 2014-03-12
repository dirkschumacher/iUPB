@iUPB.Restaurant = {}
@iUPB.Restaurant.vars = {}

@iUPB.Restaurant.indicateCurrentRestaurant = (restaurant) ->
  $("#restaurantSelector .long-text").text(restaurant);
  $(".restaurant-name").text(restaurant);
  $("#restaurantList li a.active").removeClass("active");
  $("a[data-restaurant-name='" + restaurant + "']").addClass("active");
  return

@iUPB.Restaurant.updateMenus = ($menu, date, restaurant)->
	url = "/" + (I18n?.locale || "de") + "/restaurants/" + restaurant + ".json"
	if date
		url += "?date="+date.format("dd-mm-yyyy")
	  
	#$.xhrPool.abortAll() # we don't care about old pending requests when a new menu is requested
	$.retrieveJSON(url, (json, status) ->
		$menu.empty()
		got_any = false
		$.each(json, ->
			got_any = true
			menu = $(this)[0].menu
			item = $("<li class='well'>")
			item.append($("<h4>").text(menu.name))
			$category = $("<h6>")
			append_cat = false
			if menu.category
				$category.text(menu.category)
				append_cat = true
			if menu.badges
				$.each(menu.badges, (index, value) ->
					if value?.length
						$category .append($.parseHTML(' <span class="label label-info">' + value + '</span>'))
						append_cat = true
						return
				)
			if append_cat
				item.append($category)
			if menu.type
				item.append($("<p>").html("<i>" + menu.type + "</i>"))
			if(menu.price)
				item.append($("<p>").append($("<small>").text(menu.price)))
			if(menu.counter)
				item.append($("<p>").text(menu.counter))

			$menu.append(item)
			return
		)
		if(!got_any)
			item = $("<li class='well'>")
			item.append($("<h3>").text("---"))
			$menu.append(item)
		return
	)

@iUPB.Restaurant.loadNextDay = ($menu, today, restaurant) ->
		day = new Date(today.getTime() + (24 * 60 * 60 * 1000))
		window.iUPB.Restaurant.updateMenus($menu, day, restaurant)
		return day

@iUPB.Restaurant.loadPrevDay = ($menu, today, restaurant) ->
	day = new Date(today.getTime() - (24 * 60 * 60 * 1000))
	window.iUPB.Restaurant.updateMenus($menu, day, restaurant)
	return day