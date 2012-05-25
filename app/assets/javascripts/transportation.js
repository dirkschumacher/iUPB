window.iUPB.Transportation = {};

window.iUPB.Transportation.helper = {};
window.iUPB.Transportation.helper.getTheDiffTime = function(date1, date2) {
    return (date1.getTime() - date2.getTime())*1000*60;
}

window.iUPB.Transportation.load_buses = function() {
	jQuery.ajax({ 
		url: "https://upbapi.cloudcontrolled.com/busplan.php?callback=?",
		dataType: "jsonp",
		type: "GET",
		jsonp: true,
		cache: false,
		jsonpCallback: "success", 
		success: function(data){
			var list = $("#bus_data_list");
			list.empty();
			for(var i = 0; i < data.length; i++)
			{
				var list_item = $('<li class="well"><h4>'
				+ I18n.t("transportation.index.trip_at", {
					"station" : data[i].station, 
					"date" : I18n.l("time.formats.very_short", data[i].date)
				}) 
				+ '</h4><h5>'
				+ I18n.t("transportation.index.line") 
				+ ' <span class="badge badge-info">' 
				+ data[i].line 
				+ '</span>  ' 
				+ I18n.t("transportation.index.to") 
				+ ' <span class="label label-info">' 
				+ data[i].direction 
				+ '</span></h5></li>');
				list.append(list_item);
			}
		}
	});
};