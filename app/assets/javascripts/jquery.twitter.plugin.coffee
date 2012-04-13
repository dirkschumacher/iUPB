$ = jQuery

$.fn.twitterFeed = ->
    self = this
    url = "/twitter/data"
    $.getJSON url, (data) ->
      tweets = data.results
      for tweet in tweets
        item = $ "<li>"
        authorWrap = $ '<div class="tweet_author_wrap">'
        divAuthor = $ '<div class="tweet_author">'
        imgAvatar = $ '<img>'
        imgAvatar.attr 'src', tweet.profile_image_url_https
        authorLink = $ '<a>'
        authorLink.attr 'href', 'https://twitter.com/#!/' + tweet.from_user
        authorLink.attr 'rel', 'external nofollow'
        authorLink.attr 'target', 'top'
        authorLink.append imgAvatar
        authorLinkText = $ '<a>'
        authorLinkText.attr 'href', 'https://twitter.com/#!/' + tweet.from_user
        authorLinkText.attr 'rel', 'external nofollow'
        authorLinkText.attr 'target', 'top'
        authorLinkText.text tweet.from_user
        divAuthor.append authorLink
        divTime = $ '<div class="tweet_time"></div>'
        divTime.append $('<time>').text tweet.created_at
        authorWrap.append divTime
        authorWrap.append divAuthor
        divTweet = $ '<div class="tweet_text">'
        divTweet.text tweet.text
        divTweet.prepend $('<span class="tweet_author_name_link">').append authorLinkText
        item.append authorWrap
        item.append divTweet
        self.append item
    true
    