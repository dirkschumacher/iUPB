@iUPB.checkNetworkStatus = ->
	if (navigator.onLine)
		$("offline").hide()
	else
		$("offline").show()

jQuery(document).ready ->
	$(document.body).bind("online", window.iUPB.checkNetworkStatus)
	$(document.body).bind("offline", window.iUPB.checkNetworkStatus);
	


@iUPB.enableLoadingIndicator = ->
	jQuery(document).ready ->
		$("#spinner").ajaxStart ->
			$(this).spin(window.iUPB.default_spinner_opts)
			return
		$("#spinner").ajaxStop ->
			$(this).spin(false)
			return
		return