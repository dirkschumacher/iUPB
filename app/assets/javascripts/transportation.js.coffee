@iUPB.Transportation = {}

  
@iUPB.Transportation.vars = {}
@iUPB.Transportation.vars.buses = []
@iUPB.Transportation.helper = {}
@iUPB.Transportation.helper.getTheDiffTime = (date1, date2) ->
  (date1.getTime() - date2.getTime())*1000*60



@iUPB.Transportation.helper.resetBuckets = =>
  @iUPB.Transportation.vars.buckets = {}
  @iUPB.Transportation.vars.buckets["Uni/Schöne Aussicht"] = []
  @iUPB.Transportation.vars.buckets["MuseumsForum"] = []
  @iUPB.Transportation.vars.buckets["Uni/Südring"] = []

@iUPB.Transportation.helper.resetBuckets()

@iUPB.Transportation.helper.splitBusData = =>
  for bus in @iUPB.Transportation.vars.buses
    do (bus) ->
      @iUPB.Transportation.vars.buckets[bus.station] = [] if not @iUPB.Transportation.vars.buckets[bus.station]
      @iUPB.Transportation.vars.buckets[bus.station].push bus
  
@iUPB.Transportation.load_buses = =>
	jQuery.ajax({ 
		url: "http://upbapi.cloudcontrolled.com/busplan.php?callback=?",
		dataType: "jsonp",
		type: "GET",
		jsonp: true,
		cache: true,
		jsonpCallback: "success", 
		success: (data) =>
			single_list = $("#bus_data_list")
			single_list.empty()
			@iUPB.Transportation.helper.resetBuckets()
			for bus in data
			  do (bus) =>
				  list_item = @iUPB.Transportation.helper.build_li_element(bus)
  				single_list.append list_item
  		@iUPB.Transportation.vars.buses = data
  		console.log @iUPB.Transportation.vars.buckets
  		@iUPB.Transportation.helper.splitBusData()
  		console.log @iUPB.Transportation.vars.buckets
  		for key, bucket of @iUPB.Transportation.vars.buckets
  		  do (bucket) =>
  		    @iUPB.Transportation.helper.fill_station(key, bucket)
  })
  
@iUPB.Transportation.helper.fill_station = (name, bucket) =>
  bucket_list = $("#bus-all").find('ul[data-bus-list="' + name.trim() + '"]').first()
  if bucket_list
    bucket_list.empty()
    if bucket.length > 0
      bucket_list.append @iUPB.Transportation.helper.build_reduced_li_element(bus) for bus in bucket
    else
		    bucket_list.append $('<li class="well">' + I18n.t("transportation.index.no_buses_at_station") + '</li>')
		  return true
	  false
        

@iUPB.Transportation.helper.build_li_element = (bus) ->
  $('<li class="well"><h4>' + I18n.t("transportation.index.trip_at", { "station" : bus.station, "date" : I18n.l("time.formats.very_short", bus.date)}) + '</h4><h5>' + I18n.t("transportation.index.line") + ' <span class="badge badge-info">' + bus.line + '</span> ' + I18n.t("transportation.index.to") + ' <span class="label label-info">' + bus.direction + '</span></h5></li>')

@iUPB.Transportation.helper.build_reduced_li_element = (bus) ->
  $('<li class="well"><h4>' + I18n.t("transportation.index.trip_at_reduced", {"date" : I18n.l("time.formats.very_short", bus.date)}) + '</h4><h5>' + I18n.t("transportation.index.line") + ' <span class="badge badge-info">' + bus.line + '</span> ' + I18n.t("transportation.index.to") + ' <span class="label label-info">' + bus.direction + '</span></h5></li>')
    
    