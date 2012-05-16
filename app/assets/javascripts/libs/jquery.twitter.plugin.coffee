$ = jQuery

parseUsername = (text) ->
  text.replace /[@]+[A-Za-z0-9-_]+/g, (u) ->
    u.link 'http://twitter.com/' + user.replace('@','')

parseHashtag = (text) ->
  text.replace /[#]+[A-Za-z0-9-_]+/g, (t) ->
    tag = t.replace '#','%23'
    t.link 'http://search.twitter.com/search?q=' + tag
    
$.fn.twitterFeed = (post_event) ->
    self = this
    url = "/twitter/data"
    $.getJSON url, (data) ->
      self.empty()
      tweets = data.results
      for tweet in tweets
        item = $ '<li class="well">'
        textWrap = $ '<h4>'
        detailsWrap = $ '<h6>'
        textWrap.html parseUsername(parseHashtag(parseURL(tweet.text)))
        date = Date.parse tweet.created_at
        detailsWrap.html 'Posted ' + $.timeago(tweet.created_at) + ' by <a href="https://twitter.com/#!/' + tweet.from_user + '" target="_blank">' + tweet.from_user + '</a>'
        item.append textWrap
        item.append detailsWrap
        self.append item
      post_event()
    
parseURL = (text)->
  text.replace /[A-Za-z]+:\/\/[A-Za-z0-9-_]+\.[A-Za-z0-9-_:%&\?\/.=]+/g, (url) ->
    url.link url;
