
class @TransportationManager
  constructor: (@single_list, @mutiple_list) ->
    @buckets = {}
    @resetBuckets()
    @buses = []
  resetBuckets: ->  
    @buckets["Uni/Schöne Aussicht"] = []
    @buckets["MuseumsForum"] = []
    @buckets["Uni/Südring"] = []
  getTheDiffTime: (date1, date2) ->
    (date1.getTime() - date2.getTime())*1000*60
  splitBusData: =>
    for bus in @buses
      do (bus) =>
        @buckets[bus.station] = [] if not @buckets[bus.station]
        @buckets[bus.station].push bus
  load_buses: =>
  	jQuery.ajax({ 
  		url: "http://upbapi.cloudcontrolled.com/busplan.php?callback=?",
  		dataType: "jsonp",
  		type: "GET",
  		jsonp: true,
  		cache: true,
  		jsonpCallback: "success", 
  		success: (data) =>
  			@single_list.empty()
  			@resetBuckets()
  			for bus in data
  			  do (bus) =>
  				  list_item = @build_li_element(bus)
    				@single_list.append list_item
    		@buses = data
    		@splitBusData()
    		for key, bucket of @buckets
    		  do (bucket) =>
    		    @fill_station(key, bucket)
    })
  fill_station: (name, bucket) =>
    bucket_list = @mutiple_list.find('ul[data-bus-list="' + name.trim() + '"]').first()
    if bucket_list
      bucket_list.empty()
      if bucket.length > 0
        bucket_list.append @build_reduced_li_element(bus) for bus in bucket
      else
        bucket_list.append $('<li class="well">' + I18n.t("transportation.index.no_buses_at_station") + '</li>')
        return true
    false
  build_li_element: (bus) ->
    $('<li class="well"><h4>' + I18n.t("transportation.index.trip_at", { "station" : bus.station, "date" : I18n.l("time.formats.very_short", bus.date)}) + '</h4><h5>' + I18n.t("transportation.index.line") + ' <span class="badge badge-info">' + bus.line + '</span> ' + I18n.t("transportation.index.to") + ' <span class="label label-info">' + bus.direction + '</span></h5></li>')
  build_reduced_li_element: (bus) ->
    $('<li class="well"><h4>' + I18n.t("transportation.index.trip_at_reduced", {"date" : I18n.l("time.formats.very_short", bus.date)}) + '</h4><h5>' + I18n.t("transportation.index.line") + ' <span class="badge badge-info">' + bus.line + '</span> ' + I18n.t("transportation.index.to") + ' <span class="label label-info">' + bus.direction + '</span></h5></li>')
