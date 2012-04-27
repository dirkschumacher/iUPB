checkNetworkStatus = ->
	if (navigator.onLine)
		$("offline").hide()
	else
		$("offline").show()

jQuery(document).ready ->
	$(document.body).bind("online", checkNetworkStatus)
	$(document.body).bind("offline", checkNetworkStatus);