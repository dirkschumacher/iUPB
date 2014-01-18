class @Twitter
  constructor: (@element) ->
  parseUsername: (text) ->
    text.replace /[@]+[A-Za-z0-9-_]+/g, (u) =>
      u = @createLink('https://twitter.com/' + encodeURIComponent(u.replace('@','')), u)
  
  parseHashtag: (text) ->
    text.replace /[#]+[A-Za-z0-9-_]+/g, (t) =>
      t = @createLink('https://twitter.com/search?q=' + encodeURIComponent(t), t)
      
  createLink: (url, text) ->
    '<a target="_blank" rel="nofollow" href="' + url + '">' + text + '</a>'
    
  profileLink: (screen_name) ->
    'https://twitter.com/' + screen_name
      
  displayFeed: (post_event) =>
      
      
      $.ajax({ 
        url: "/api/v1/twitter?callback=?",
        dataType: "jsonp",
        type: "GET",
        jsonp: true,
        cache: true,
        jsonpCallback: "success", 
        success: (data) =>
          @element.empty()
          tweets = data
          for tweet in tweets
            tweet = tweet["twitter::tweet"]  
            item = $ '<li>'
            avatar = $ '<a class="twitter_avatar">'
            avatar.attr('href', @profileLink tweet["twitter::user"].screen_name)
            user_image = $ '<img>'
            user_image.attr('src', tweet.profile_image_url_https)
            user_image.addClass 'box_round'
            avatar.append user_image
            textWrap = $ '<h4>'
            detailsWrap = $ '<h6>'
            textWrap.html @parseUsername(@parseHashtag(@parseURL(tweet.text)))
            date = Date.parse tweet.created_at
            detailsWrap.html $.timeago(tweet.created_at) + ' ' + I18n.t('pages.twitter.by') + ' <a rel="nofollow" href="' +  @profileLink tweet["twitter::user"].screen_name + '" target="_blank">' + tweet["twitter::user"].name + '</a>'
            messageContainer = $ '<div class="twitter_message well">'
            item.append avatar
            messageContainer.append textWrap
            messageContainer.append detailsWrap
            item.append messageContainer
            @element.append item
          post_event()
        })
        
   parseURL: (text) =>
     text.replace /[A-Za-z]+:\/\/[A-Za-z0-9-_]+\.[A-Za-z0-9-_:%&\?\/.=]+/g, (url) =>
       t = @createLink(url, url.replace('http://','').replace('https://',''))
