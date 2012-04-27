# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$("#loading").ajaxStart ->
	$(this).show()

$("#loading").ajaxStart ->
	$(this).hide()

window.Restaurant = {};

window.Restaurant.updateMenus = ->
	$.retrieveJSON("/restaurants/index.json", (json, status) ->
		$("#menus").empty()
		$.each(json, ->
			menu = $(this)[0].menu
			item = $("<li>")
			item.append($("<h3>").text(menu.description))
			if(menu.name)
				item.append($("<p>").html("<strong>" + menu.name + "</strong>"))
			if(menu.type)
				item.append($("<p>").html("<i>" + menu.type + "</i>"))
			sd = $('<p id="side_dishes">')
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
			$("#menus").listview('refresh')
			return
		)
		return
	)