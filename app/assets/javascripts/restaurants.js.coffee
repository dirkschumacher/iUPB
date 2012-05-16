@iUPB.Restaurant = {}
@iUPB.Restaurant.vars = {}


@iUPB.Restaurant.indicateCurrentRestaurant = (restaurant) ->
  $("#restaurantSelector .long-text").text(restaurant);
  $("#restaurantList li a.active").removeClass("active");
  $("a[data-restaurant-name='" + restaurant + "']").addClass("active");
  return

@iUPB.Restaurant.updateMenus = (date, restaurant)->
	url = "/restaurants/"+restaurant+".json"
	if(date)
		url += "?date="+date.format("dd-mm-yyyy")
	$.xhrPool.abortAll() # we don't care about old pending requests when a new menu is requested
	$.retrieveJSON(url, (json, status) ->
		$("#menus").empty()
		got_any = false
		$.each(json, ->
			got_any = true
			menu = $(this)[0].menu
			item = $("<li class='well'>")
			item.append($("<h4>").text(menu.description))
			if(menu.name)
				item.append($("<h6>").text(menu.name))
			if(menu.type)
				item.append($("<p>").html("<i>" + menu.type + "</i>"))
			sd = $('<p id="side_dishes">')
			if(menu.side_dishes)
				$.each(menu.side_dishes, (index, value) ->
					sd.html(sd.html() + "&#8226; " + value +  "<br/>")
					return
				)
			
			item.append(sd)
			if(menu.price)
				item.append($("<p>").text(menu.price))
			if(menu.counter)
				item.append($("<p>").text(menu.counter))
				
			$("#menus").append(item)
			return
		)
		$("#day_title").text(I18n.l("date.formats.weekday_date", date))
		if(!got_any)
			item = $("<li>")
			item.append($("<h3>").text("---"))
			$("#menus").append(item)
		window.iUPB.Restaurant.indicateCurrentRestaurant(restaurant)
		return
	)

@iUPB.Restaurant.loadNextDay = (today, restaurant) ->
		day = new Date(today.getTime() + (24 * 60 * 60 * 1000))
		window.iUPB.Restaurant.updateMenus(day, restaurant)
		return day

@iUPB.Restaurant.loadPrevDay = (today, restaurant) ->
	day = new Date(today.getTime() - (24 * 60 * 60 * 1000))
	window.iUPB.Restaurant.updateMenus(day, restaurant)
	return day