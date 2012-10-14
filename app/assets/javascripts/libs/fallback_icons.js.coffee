@iUPB.fallbackIcons = {}
@iUPB.fallbackIcons.mapping = 
  "icon-plus": "+"
  "icon-chevron-left": "&laquo;"
  "icon-chevron-right": "&raquo;"
@iUPB.fallbackIcons.replace = (fontsAvailable) ->
  unless fontsAvailable
  	$.each(window.iUPB.fallbackIcons.mapping, (klaas, sub) ->
      $("i." + klaas).html(sub)
    )
  return