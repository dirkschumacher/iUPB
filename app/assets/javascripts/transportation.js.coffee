@iUPB.Transportation = {}

  
@iUPB.Transportation.vars = {}
@iUPB.Transportation.vars.buses = []
@iUPB.Transportation.vars.buckets = {}

  
@iUPB.Transportation.helper = {}
@iUPB.Transportation.helper.getTheDiffTime = (date1, date2) ->
  (date1.getTime() - date2.getTime())*1000*60



@iUPB.Transportation.helper.splitBusData = =>
  buckets = {}
  for bus in @iUPB.Transportation.vars.buses
    do (bus) ->
      buckets[bus.station] = [] if not buckets[bus.station]
      buckets[bus.station].push bus
  @iUPB.Transportation.vars.buckets = buckets  
  
@iUPB.Transportation.load_buses = =>
	jQuery.ajax({ 
		url: "https://upbapi.cloudcontrolled.com/busplan.php?callback=?",
		dataType: "jsonp",
		type: "GET",
		jsonp: true,
		cache: true,
		jsonpCallback: "success", 
		success: (data) =>
			single_list = $("#bus_data_list")
			single_list.empty()
			for bus in data
			  do (bus) =>
				  list_item = @iUPB.Transportation.helper.build_li_element(bus)
  				single_list.append list_item
  		@iUPB.Transportation.vars.buses = data
  		@iUPB.Transportation.helper.splitBusData()
  		for key, bucket of @iUPB.Transportation.vars.buckets
  		  do (bucket) =>
  		    @iUPB.Transportation.helper.fill_station(bucket)
  })
  
@iUPB.Transportation.helper.fill_station = (bucket) =>
  bucket_list = $("#bus-all").find('ul[data-bus-list="' + bucket[0].station.trim() + '"]').first()
  if bucket_list
    bucket_list.empty()
    if bucket.length > 0
      bucket_list.append @iUPB.Transportation.helper.build_reduced_li_element(bus) for bus in bucket
    else
		    bucket_list.append $('<li class="well">' + I18n.t("transportation.index.no_buses_at_station") + '</li')
		  true
        

@iUPB.Transportation.helper.build_li_element = (bus) ->
  $('<li class="well"><h4>' + I18n.t("transportation.index.trip_at", { "station" : bus.station, "date" : I18n.l("time.formats.very_short", bus.date)}) + '</h4><h5>' + I18n.t("transportation.index.line") + ' <span class="badge badge-info">' + bus.line + '</span> ' + I18n.t("transportation.index.to") + ' <span class="label label-info">' + bus.direction + '</span></h5></li>')

@iUPB.Transportation.helper.build_reduced_li_element = (bus) ->
  $('<li class="well"><h4>' + I18n.t("transportation.index.trip_at_reduced", {"date" : I18n.l("time.formats.very_short", bus.date)}) + '</h4><h5>' + I18n.t("transportation.index.line") + ' <span class="badge badge-info">' + bus.line + '</span> ' + I18n.t("transportation.index.to") + ' <span class="label label-info">' + bus.direction + '</span></h5></li>')
    
    