@iUPB.Timetable = {}
@iUPB.Timetable.vars = {}
@iUPB.Timetable.TRUNCATE_LENGTH = 23
@iUPB.Timetable.API_URL = "/timetable.json"
#parses a date
#adopted from http://stackoverflow.com/a/5805595
@iUPB.Timetable.parseDate = (dateString) ->
  rx = /^(\d{4}\-\d\d\-\d\d([tT][\d:\.]*)?)([zZ]|([+\-])(\d\d):(\d\d))?$/
  p = rx.exec(s) || []
  if p[1]
      day= p[1].split(/\D/).map((itm) ->
          return parseInt(itm, 10) || 0
      )
      day[1] -= 1
      day = new Date(Date.UTC.apply(Date, day))
      return NaN unless day.getDate()
      if p[5]
          tz = parseInt(p[5], 10)*60
          tz += parseInt(p[6], 10) if p[6]
          tz *= -1 if p[4] is "+"
          day.setUTCMinutes(day.getUTCMinutes()+ tz) if tz
      return day
  return NaN
@iUPB.Timetable.populateTimetable = (container, year, week, course_path) ->
	$.retrieveJSON(window.iUPB.Timetable.API_URL, {year: year, week:week}, (json, status) ->
		if status is "cached" or status is "success" #is ok
			window.iUPB.Timetable.emptyTimetable(container)	
			monday = window.iUPB.Timetable.weekToDate(year, week, 0)
			friday = window.iUPB.Timetable.weekToDate(year, week, 4)
			$("#day_title").text(I18n.l("date.formats.weekday_date", monday) + " - " + I18n.l("date.formats.weekday_date", friday))
			$eventsList = $("#events_overview")
			$eventsList.empty()
			$.each(json, ->
				start_date = window.Timetable.parseDate(this.start_time_utc)
				start_compare_time = window.iUPB.Timetable.zeroFill(start_date.getHours(), 2) + window.iUPB.Timetable.zeroFill(start_date.getMinutes(), 2)
				end_date = window.Timetable.parseDate(this.end_time_utc||this.start_time_utc)
				end_compare_time = window.iUPB.Timetable.zeroFill(end_date.getHours(), 2) + window.iUPB.Timetable.zeroFill(end_date.getMinutes(), 2)
				if this.short_title?
				  if this.short_title.length > window.iUPB.Timetable.TRUNCATE_LENGTH
  					name = this.short_title.substring(0, window.iUPB.Timetable.TRUNCATE_LENGTH - 1) + "…"
  				else
  					name = this.short_title
  			else
  			  name = this._name
			  long_title = this._name
				day = start_date.getDay()
				location = this.location
				id = this._id
				courseId = this.course_id
				$.each(container.find("div[data-tt-day='" + day + "']"), ->
					if start_compare_time >= $(this).data("tt-start-time") and start_compare_time < $(this).data("tt-end-time")
					  current = $(this)
					  cell = current.find("span.cell").first()
					  time_info = window.iUPB.Timetable.zeroFill(start_date.getHours(), 2) + ":" + window.iUPB.Timetable.zeroFill(start_date.getMinutes(), 2)
					  if end_date > start_date
					    time_info = time_info + "-" + window.iUPB.Timetable.zeroFill(end_date.getHours(), 2) + ":" + window.iUPB.Timetable.zeroFill(end_date.getMinutes(), 2)
					  if location
					    time_info = time_info + "/" + location.replace(" ", "")
					  cell.html(cell.html() + " &#8226;<a href='#" + id + "' onclick='document.getElementById(\"" + id + "\").scrollIntoView(true);return false;'>" + name + "</a>" + " <span class='time_info'>(" + time_info + ")</span><br>")
					  current.addClass("busy")
					if end_compare_time > $(this).data("tt-start-time") and end_compare_time <= $(this).data("tt-end-time") \
					or start_compare_time < $(this).data("tt-start-time") and end_compare_time > $(this).data("tt-end-time")
						$(this).addClass("busy")
					return
				)
				
				#update the list as well
				$li = $('<li  id="' + id + '" class="well single_event"></li>')
				$li.append($('<h6>' + long_title + '</h6>'))
				$optionsContainer = $ '<div class="pull-right dropdown">'
				$optionsButton = $('<a id="dropdown-' + id + '" data-toggle="dropdown" role="button"  href="#">')
				$optionsButton.addClass "btn"
				$optionsButton.addClass "btn-primary"
				$optionsButton.addClass "btn-dropdown-toggle"
				$optionsButton.html('<span class="caret"></span>')
				$optionsDropDown = $('
	        <ul role="menu" aria-labelledby="dropdown-' + id + '" class="dropdown-menu">
            <li><a id="link-view-details-' + id + '" href="' + course_path + courseId + '"><i class="icon-eye-open"></i>' + I18n.t("timetable.index.view_course_details") + '</a></li>
            <li><a id="link-deleteone-' + id + '" href="#"><i class="icon-remove"></i>' + I18n.t("timetable.index.delete_one") + '</a></li>
            <li><a id="link-deleteall-' + id + '" href="#"><i class="icon-trash"></i>' + I18n.t("timetable.index.delete_all") + '</a></li>
          </ul>
        ')
				$optionsContainer.append $optionsButton
				$optionsContainer.append $optionsDropDown
				$li.append $optionsContainer
				$timeBlock = $("<p>")
				$descriptionBlock = $('<p class="expandeble">')
				$linkBlock = $ "<p>"
				$timeBlock.text I18n.l("date.formats.weekday_date", start_date) + " " + I18n.l("time.formats.very_short", start_date) + if end_date? and start_date < end_date then " - " + I18n.l("time.formats.very_short", end_date) else ""
				$timeBlock.text $timeBlock.text() + " / " + location
				$descriptionBlock.text this.description
				$linkBlock.append($('<a href="' + this.link + '">&raquo; ' + I18n.t("timetable.index.details") + '</a>'))
				$li.append $timeBlock
				$li.append $descriptionBlock
				$li.append $linkBlock if this.link?
				$eventsList.append($li)
				
			  #add some logic
				$('#link-deleteone-' + id + '').click (e)->
			    if confirm I18n.t("timetable.index.deleteoneconfirm")
			      $.ajax("/timetable/destroy", {type: "delete", data: "id=" + id}).success( ->
			          window.iUPB.Timetable.populateTimetable(container, year, week)
			        )
			    e.preventDefault()
				$('#link-deleteall-' + id + '').click (e)->
  			  if confirm I18n.t("timetable.index.deleteallconfirm")
			      $.ajax("/timetable/destroy_course", {type: "delete", data: "id=" + id}).success( ->
			          window.iUPB.Timetable.populateTimetable(container, year, week)
			        )
			    e.preventDefault()
			)
			return
		else # server error or so
			alert "Error receiving timetable data. Please try again later, we're really sorry!"
			return
	)
	return
	
@iUPB.Timetable.setUpPage = ($timeTable, year, week, course_path) ->
  window.iUPB.Timetable.vars.currentYear = year
  window.iUPB.Timetable.vars.currentWeek = week
  window.iUPB.Timetable.populateTimetable($timeTable, window.iUPB.Timetable.vars.currentYear, window.iUPB.Timetable.vars.currentWeek, course_path)
  $("#next_link").click((e)->
      e.preventDefault()
      if window.iUPB.Timetable.vars.currentWeek >= 52
        window.iUPB.Timetable.vars.currentWeek = 1
        window.iUPB.Timetable.vars.currentYear++
      else
        window.iUPB.Timetable.vars.currentWeek++
      window.iUPB.Timetable.populateTimetable($timeTable, window.iUPB.Timetable.vars.currentYear, window.iUPB.Timetable.vars.currentWeek, course_path)
    )
  $("#prev_link").click((e)->
    e.preventDefault()
    if window.iUPB.Timetable.vars.currentWeek is 1
      window.iUPB.Timetable.vars.currentWeek = 52
      window.iUPB.Timetable.vars.currentYear--
    else
      window.iUPB.Timetable.vars.currentWeek--
    window.iUPB.Timetable.populateTimetable($timeTable, window.iUPB.Timetable.vars.currentYear, window.iUPB.Timetable.vars.currentWeek, course_path)
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