@iUPB.Timetable = {}
@iUPB.Timetable.vars = {}
@iUPB.Timetable.TRUNCATE_LENGTH = 23

@iUPB.Timetable.populateTimetable = (container) ->
	$.retrieveJSON("/timetable.json", (json, status) ->
		if status == "cached" || status == "success" # TODO is this ok to use?
			window.iUPB.Timetable.emptyTimetable(container)
			$.each(json, ->
				course = this.course_id
				start_date = new Date(this.start_time)
				start_compare_time = window.iUPB.Timetable.zeroFill(start_date.getHours(), 2) + window.iUPB.Timetable.zeroFill(start_date.getMinutes(), 2)
				end_date = new Date(this.end_time||this.start_time)
				end_compare_time = window.iUPB.Timetable.zeroFill(end_date.getHours(), 2) + window.iUPB.Timetable.zeroFill(end_date.getMinutes(), 2)
				if this.name.length > window.iUPB.Timetable.TRUNCATE_LENGTH
					name = this.name.substring(0, window.iUPB.Timetable.TRUNCATE_LENGTH - 1) + "…"
				else
					name = this.name
				day = start_date.getDay()
				location = this.location
				$.each(container.find("div[data-tt-day='" + day + "']"), ->
					if start_compare_time >= $(this).data("tt-start-time") and start_compare_time < $(this).data("tt-end-time")
					  current = $(this)
					  cell = current.find("span.cell").first()
					  time_info = window.iUPB.Timetable.zeroFill(start_date.getHours(), 2) + ":" + window.iUPB.Timetable.zeroFill(start_date.getMinutes(), 2)
					  if end_date > start_date
					    time_info = time_info + "-" + window.iUPB.Timetable.zeroFill(end_date.getHours(), 2) + ":" + window.iUPB.Timetable.zeroFill(end_date.getMinutes(), 2)
					  if location
					    time_info = time_info + "/" + location.replace(" ", "")
					  if course
					    cell.html(cell.html() + " &#8226;<a href='/courses/" + course + "'>" + name + "</a>")
					  else
					    cell.html(cell.html() + " &#8226;" + name)
					  cell.html(cell.html() + " <span class='time_info'>(" + time_info + ")</span>")
					  current.addClass("busy")
					if end_compare_time > $(this).data("tt-start-time") and end_compare_time <= $(this).data("tt-end-time") \
					or start_compare_time < $(this).data("tt-start-time") and end_compare_time > $(this).data("tt-end-time")
						$(this).addClass("busy")
					return
				)
			)
			return
		else # server error or so
			alert "Error receiving timetable data. Please try again later, we're really sorry!"
			return
	)
	return

@iUPB.Timetable.emptyTimetable = (container) ->
	container.find("div.busy").removeClass("busy")
	container.find("span.cell").text("")
	return

@iUPB.Timetable.zeroFill = 	(number, width) ->
	fillZeroes = "000"
	input = number + ""
	fillZeroes.slice(0, width - input.length) + input