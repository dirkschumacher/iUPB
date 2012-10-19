@iUPB.fallbackIcons = {}

@iUPB.fontsAvailable = ->
  if window.iUPB.vars.fontsAvailable is undefined
    android_version = /Android (\d+(?:\.\d+)+);/.exec(window.navigator.userAgent)
    if android_version != null and android_version.indexOf("4.0") != -1 
      window.iUPB.vars.fontsAvailable = false
    else
      window.iUPB.vars.fontsAvailable = true
  window.iUPB.vars.fontsAvailable

@iUPB.fallbackIcons.mapping = 
  "icon-plus": "+"
  "icon-chevron-left": "&laquo;"
  "icon-chevron-right": "&raquo;"

@iUPB.fallbackIcons.replace = (fontsAvailable = window.iUPB.fontsAvailable()) ->
  if fontsAvailable is false
    $.each(window.iUPB.fallbackIcons.mapping, (klaas, sub) ->
      $("i." + klaas).replaceWith($('<b style="font-size:22px;">' + sub + '</b>'))
    )
  return