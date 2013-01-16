@iUPB.fallbackIcons = {}

@iUPB.fontsAvailable = ->
  if window.iUPB.vars.fontsAvailable is undefined
    android_version = /Android (\d+(?:\.\d+)+);/.exec(window.navigator.userAgent)
    if ((android_version != null) and (android_version[1])) and ((android_version[1].indexOf("4.0") != -1) or (android_version[1].indexOf("4.2") != -1))
      window.iUPB.vars.fontsAvailable = false
    else
      window.iUPB.vars.fontsAvailable = true
  window.iUPB.vars.fontsAvailable

@iUPB.fallbackIcons.mapping = 
  "icon-plus": "+"
  "icon-chevron-left": "&laquo;"
  "icon-chevron-right": "&raquo;"
  "icon-heart": "&hearts;"
  "icon-list": "&equiv; "
  "icon-ok": "&#x2713;"

@iUPB.fallbackIcons.replace = (fontsAvailable = window.iUPB.fontsAvailable()) ->
  if fontsAvailable is false
    $.each(window.iUPB.fallbackIcons.mapping, (klaas, sub) ->
      if klaas is "icon-heart"
        $("i." + klaas).replaceWith($('<b class="icon-love" style="font-size:11px;">' + sub + '</b>'))
      else  
        $("i." + klaas).replaceWith($('<b style="font-size:22px;">' + sub + '</b>'))
    )
  return