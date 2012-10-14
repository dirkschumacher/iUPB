# http://stackoverflow.com/questions/12312323/how-to-know-if-a-font-font-face-has-already-been-loaded/12316349#12316349
(($) ->
  $.fn.fontChecker = (callback, config) ->
    checkFont = ->
      loadedFontWidth = tester.offsetWidth
      #if fallbackFontWidth is loadedFontWidth
      if loadedFontWidth == 0
        if config.timeOut < 0
          $this.removeClass config.onLoad
          $this.addClass config.onFail
          window.iUPB.vars.fontsAvailable = false
          callback(false)
        else
          $this.addClass config.onLoad
          window.iUPB.vars.fontsAvailable = undefined
          setTimeout checkFont, config.delay
          config.timeOut = config.timeOut - config.delay
      else
        $this.removeClass config.onLoad
        window.iUPB.vars.fontsAvailable = true
        callback(true)
    $this = $(this)
    defaults =
      font: "FontAwesome" # $this.css("font-family")
      fontAwesome: false
      onLoad: ""
      onFail: ""
      testFont: "Comic Sans MS"
      testString: "QW@HhsXJ"
      testFontAwesome: "icon-glass"
      delay: 50
      timeOut: 2500

    config = $.extend(defaults, config)
    tester = document.createElement("span")
    tester.style.position = "absolute"
    tester.style.top = "-9999px"
    tester.style.left = "-9999px"
    tester.style.visibility = "hidden"
    tester.style.fontFamily = config.testFont
    tester.style.fontSize = "250px"
    if config.fontAwesome is true
      tester.className = config.testFontAwesome
    else
      tester.innerHTML = config.testString
    document.body.appendChild tester
    fallbackFontWidth = tester.offsetWidth
    # tester.style.fontFamily = config.font + "," + config.testFont
    tester.style.fontFamily = config.testFont
    checkFont()
) jQuery