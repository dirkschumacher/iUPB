class @Twitter
  constructor: (@element) ->
  parseUsername: (text) ->
    text.replace /[@]+[A-Za-z0-9-_]+/g, (u) ->
      u.link 'https://twitter.com/' + user.replace('@','')
  
  parseHashtag: (text) ->
    text.replace /[#]+[A-Za-z0-9-_]+/g, (t) ->
      tag = t.replace '#','%23'
      t.link 'https://search.twitter.com/search?q=' + tag
  
  profileLink: (userid) ->
    'https://twitter.com/#!/' + userid
      
  displayFeed: (post_event) ->
      self = this
      $.ajax({ 
        url: "https://search.twitter.com/search.json?q=%23upb&lang=de&callback=?",
        dataType: "jsonp",
        type: "GET",
        jsonp: true,
        cache: true,
        jsonpCallback: "success", 
        success: (data) ->
          self.element.empty()
          tweets = data.results
          for tweet in tweets
            item = $ '<li>'
            avatar = $ '<a class="twitter_avatar">'
            avatar.attr('href', self.profileLink tweet.from_user)
            user_image = $ '<img>'
            user_image.attr('src', tweet.profile_image_url_https)
            user_image.addClass 'box_round'
            avatar.append user_image
            textWrap = $ '<h4>'
            detailsWrap = $ '<h6>'
            textWrap.html self.parseUsername(self.parseHashtag(self.parseURL(tweet.text)))
            date = Date.parse tweet.created_at
            detailsWrap.html $.timeago(tweet.created_at) + ' ' + I18n.t('pages.twitter.by') + ' <a href="' +  self.profileLink tweet.from_user + '" target="_blank">' + tweet.from_user + '</a>'
            messageContainer = $ '<div class="twitter_message well">'
            item.append avatar
            messageContainer.append textWrap
            messageContainer.append detailsWrap
            item.append messageContainer
            self.element.append item
          post_event()
        })
        
   parseURL: (text)->
     text.replace /[A-Za-z]+:\/\/[A-Za-z0-9-_]+\.[A-Za-z0-9-_:%&\?\/.=]+/g, (url) ->
       url.link url
