jQuery.cookie.json = true
jQuery ->
  $("a[rel~=popover], .has-popover").popover()
  $(document).on("click", "a.prevent-default", (e) -> e.preventDefault())
  $("a[rel~=tooltip], .has-tooltip, .tooltip").tooltip()
  $(".datepicker").datepicker()
  $(document).on("click", "a.external-confirm", () -> confirm("-> " + $(this).attr("href").replace("http://", "").replace("uni-paderborn.de/", "upb.de/") + "\nOK klicken zum Öffnen / press OK to open"))
  return
