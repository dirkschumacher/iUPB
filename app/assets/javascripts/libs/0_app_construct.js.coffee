@iUPB = {};

jQuery(document).bind("mobileinit", ->
  $.extend(  $.mobile ,
    ajaxEnabled: false
  )
  return
)