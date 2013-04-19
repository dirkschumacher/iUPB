jQuery.cookie.json = true
jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
  $(document).on("click", "a.prevent-default", (e) -> e.preventDefault())
  $(".datepicker").datepicker()
  $(document).on("click", "a.external-confirm", () -> confirm("-> " + $(this).attr("href").replace("http://", "").replace("uni-paderborn.de/", "upb.de/") + "\nOK klicken zum Öffnen / press OK to open"))
  
  