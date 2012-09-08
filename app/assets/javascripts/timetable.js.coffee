@iUPB.Timetable = {}
@iUPB.Timetable.vars = {}
@iUPB.Timetable.TRUNCATE_LENGTH = 23
@iUPB.Timetable.API_URL = "/timetable.json"

@iUPB.Timetable.populateTimetable = (container, year, week) ->
	$.retrieveJSON(window.iUPB.Timetable.API_URL, {year: year, week:week}, (json, status) ->
		if status is "cached" or status is "success" #is ok
			window.iUPB.Timetable.emptyTimetable(container)	
			monday = window.iUPB.Timetable.weekToDate(year, week, 0)
			friday = window.iUPB.Timetable.weekToDate(year, week, 4)
			$("#day_title").text(I18n.l("date.formats.weekday_date", monday) + " - " + I18n.l("date.formats.weekday_date", friday))
			$.each(json, ->
				start_date = new Date(this.start_time)
				start_compare_time = window.iUPB.Timetable.zeroFill(start_date.getHours(), 2) + window.iUPB.Timetable.zeroFill(start_date.getMinutes(), 2)
				end_date = new Date(this.end_time||this.start_time)
				end_compare_time = window.iUPB.Timetable.zeroFill(end_date.getHours(), 2) + window.iUPB.Timetable.zeroFill(end_date.getMinutes(), 2)
				if this._name.length > window.iUPB.Timetable.TRUNCATE_LENGTH
					name = this._name.substring(0, window.iUPB.Timetable.TRUNCATE_LENGTH - 1) + "…"
				else
					name = this._name
				day = start_date.getDay()
				location = this.location
				id = this._id
				$.each(container.find("div[data-tt-day='" + day + "']"), ->
					if start_compare_time >= $(this).data("tt-start-time") and start_compare_time < $(this).data("tt-end-time")
					  current = $(this)
					  cell = current.find("span.cell").first()
					  time_info = window.iUPB.Timetable.zeroFill(start_date.getHours(), 2) + ":" + window.iUPB.Timetable.zeroFill(start_date.getMinutes(), 2)
					  if end_date > start_date
					    time_info = time_info + "-" + window.iUPB.Timetable.zeroFill(end_date.getHours(), 2) + ":" + window.iUPB.Timetable.zeroFill(end_date.getMinutes(), 2)
					  if location
					    time_info = time_info + "/" + location.replace(" ", "")
					  cell.html(cell.html() + " &#8226;<a href='#" + id + "'>" + name + "</a>" + " <span class='time_info'>(" + time_info + ")</span><br>")
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
	
@iUPB.Timetable.setUpPage = ($timeTable, year, week) ->
  window.iUPB.Timetable.vars.currentYear = year
  window.iUPB.Timetable.vars.currentWeek = week
  window.iUPB.Timetable.populateTimetable($timeTable, window.iUPB.Timetable.vars.currentYear, window.iUPB.Timetable.vars.currentWeek)
  $("#next_link").click((e)->
      e.preventDefault()
      if window.iUPB.Timetable.vars.currentWeek >= 52
        window.iUPB.Timetable.vars.currentWeek = 1
        window.iUPB.Timetable.vars.currentYear++
      else
        window.iUPB.Timetable.vars.currentWeek++
      window.iUPB.Timetable.populateTimetable($timeTable, window.iUPB.Timetable.vars.currentYear, window.iUPB.Timetable.vars.currentWeek)
    )
  $("#prev_link").click((e)->
    e.preventDefault()
    if window.iUPB.Timetable.vars.currentWeek is 1
      window.iUPB.Timetable.vars.currentWeek = 52
      window.iUPB.Timetable.vars.currentYear--
    else
      window.iUPB.Timetable.vars.currentWeek--
    window.iUPB.Timetable.populateTimetable($timeTable, window.iUPB.Timetable.vars.currentYear, window.iUPB.Timetable.vars.currentWeek)
  )
  
#adopted from http://stackoverflow.com/questions/4555324/get-friday-from-week-number-and-year-in-javascript
#Thanks Mic for this beautiful peace of code
@iUPB.Timetable.weekToDate =(year, wn, dayNb) ->
  j10 = new Date( year,0,10,12,0,0)
  j4 = new Date( year,0,4,12,0,0)
  mon1 = j4.getTime() - j10.getDay() * 86400000
  new Date(mon1 + ((wn - 1)  * 7  + dayNb) * 86400000)

@iUPB.Timetable.emptyTimetable = (container) ->
	container.find("div.busy").removeClass("busy")
	container.find("span.cell").text("")
	return

@iUPB.Timetable.zeroFill = 	(number, width) ->
	fillZeroes = "000"
	input = number + ""
	fillZeroes.slice(0, width - input.length) + input