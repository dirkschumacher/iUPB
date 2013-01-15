# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
@iUPB.Ads = {}

@iUPB.Ads.generateGrid = (elements, options = {}) ->
	default_options = {"columns": 4, "column_class": "span3", "row_class": "row", "end_class": ""}
	options = jQuery.extend(default_options, options)
	column_count = 1
	grid = $('<div class="generic-grid"></div>');
	current_row = null
	
	div_column = (content, end) -> 
		$('<div class="' + options["column_class"] + (if end then " " + options["end_class"] else "")	+ '"></div>').append(content)
	
	jQuery.each(elements, (index, val) ->
		if !current_row
			current_row = $('<div class="' + options.row_class + '"></div>')
		current_row.append(div_column(val, (column_count == options["columns"] or index == elements.length - 1)))
		if column_count == options["columns"] or index == elements.length - 1
			grid.append(current_row)
			current_row = false
			column_count = 1
		else
			column_count++
		return
	)
	return grid
