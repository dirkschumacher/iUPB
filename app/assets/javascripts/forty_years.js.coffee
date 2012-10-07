@iUPB.FortyYears = {}
@iUPB.FortyYears.vars = {}
@iUPB.FortyYears.TRUNCATE_LENGTH = 23
@iUPB.FortyYears.API_URL = "/40jahre.json"
@iUPB.FortyYears.FACT_API_URL = "/40jahre_fact"
@iUPB.FortyYears.FACT_CSS_CONTAINER = "#forty-year-fact-container"
@iUPB.FortyYears.FACT_CSS_40YR_LINK = "#top-40-link"
@iUPB.FortyYears.HEADER_CONTAINER = "#header-container"

@iUPB.FortyYears.displayRandomFact = ->
  #if Math.random() <= 0.3
    $.getJSON(window.iUPB.FortyYears.FACT_API_URL, (json, status) ->
        $(window.iUPB.FortyYears.FACT_CSS_CONTAINER).text json.id
        popover_container = if $("span.icon-bar").is(":hidden") then window.iUPB.FortyYears.FACT_CSS_40YR_LINK else window.iUPB.FortyYears.HEADER_CONTAINER
        $(popover_container).popover title: "Fakt über die Uni Nr.: " + json.id, content:json.text, placement: "bottom", trigger:"manual"
        $(window.iUPB.FortyYears.FACT_CSS_CONTAINER).unbind "click"
        $(window.iUPB.FortyYears.FACT_CSS_CONTAINER).click (e)->
          e.stopPropagation()
          $(popover_container).popover "toggle"
        event = if navigator.userAgent.match(/iPad/i) or navigator.userAgent.match(/iPhone/i) then "touchstart" else "click" 
        $(document).on event, (e) ->
          if $(e.target).closest(".popover").length is 0
            $(popover_container).popover("hide") 
            $(document).unbind event
        $(window.iUPB.FortyYears.FACT_CSS_CONTAINER).show()
      )
@iUPB.FortyYears.populateTimetable = (container) ->
  offset = -2 # GMT / UTC difference. 
  $.retrieveJSON(window.iUPB.FortyYears.API_URL, (json, status) ->
  	if status == "cached" || status == "success" # TODO is this ok to use?
  		window.iUPB.FortyYears.emptyTimetable(container)
  		$.each(json, ->
  			start_date = new Date(this.start_time)
  			start_compare_time = window.iUPB.FortyYears.zeroFill(start_date.getHours() + offset, 2) + window.iUPB.FortyYears.zeroFill(start_date.getMinutes(), 2)
  			end_date = new Date(this.end_time||this.start_time)
  			end_compare_time = window.iUPB.FortyYears.zeroFill(end_date.getHours() + offset, 2) + window.iUPB.FortyYears.zeroFill(end_date.getMinutes(), 2)
  			if this.name.length > window.iUPB.FortyYears.TRUNCATE_LENGTH
  				name = this.name.substring(0, window.iUPB.FortyYears.TRUNCATE_LENGTH - 1) + "…"
  			else
  				name = this.name
  			day = start_date.getDate()
  			location = this.location
  			id = this._id
  			$.each(container.find("div[data-tt-day='" + day + "']"), ->
  				if start_compare_time >= $(this).data("tt-start-time") and start_compare_time < $(this).data("tt-end-time")
  				  current = $(this)
  				  cell = current.find("span.cell").first()
  				  time_info = window.iUPB.FortyYears.zeroFill(start_date.getHours() + offset, 2) + ":" + window.iUPB.FortyYears.zeroFill(start_date.getMinutes(), 2)
  				  if end_date > start_date
  				    time_info = time_info + "-" + window.iUPB.FortyYears.zeroFill(end_date.getHours() + offset, 2) + ":" + window.iUPB.FortyYears.zeroFill(end_date.getMinutes(), 2)
  				  if location
  				    time_info = time_info + "/" + location.replace(" ", "")
  				  cell.html(cell.html() + " &#8226;<a href='#" + id + "' onclick='document.getElementById(\"" + id + "\").scrollIntoView(true);return false;'>" + name + "</a>" + " <span class='time_info'>(" + time_info + ")</span><br>")
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

@iUPB.FortyYears.emptyTimetable = (container) ->
  container.find("div.busy").removeClass("busy")
  container.find("span.cell").text("")
  return

@iUPB.FortyYears.zeroFill = 	(number, width) ->
  fillZeroes = "000"
  input = number + ""
  fillZeroes.slice(0, width - input.length) + input