# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@iUPB.loadjscssfile = (filename, filetype)->
  if (filetype=="js") #if filename is a external JavaScript file
    fileref=document.createElement('script')
    fileref.setAttribute("type","text/javascript")
    fileref.setAttribute("src", filename)
  else if (filetype=="css") #if filename is an external CSS file
    fileref=document.createElement("link")
    fileref.setAttribute("rel", "stylesheet")
    fileref.setAttribute("type", "text/css")
    fileref.setAttribute("href", filename)
  if (typeof fileref!="undefined")
    document.getElementsByTagName("head")[0].appendChild(fileref)
  return