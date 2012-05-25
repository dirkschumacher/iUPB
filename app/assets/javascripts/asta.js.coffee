# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
class @AStANews
  constructor: (@element, @dataSourceURL) ->
  reload:
    $.getJSON(@dataSourceURL, (data) ->
      @element.empty
      list_items = for key, val of data
        @buildNewsItem(val)
      @element.append list_items
    )
  buildNewsItem: (item) ->
    listItem = $ '<li class="well">'
    listItem.append $('<h4>' + item['title'] + '</h4>')
    listItem.append $('<h6>' + item['title'] + '</h4>')
    
#    <li class="well">
#      <h4><%= item['title'] %></h4>
#      <div class="asta-meta">
#      <h6 class="asta-time"><%= time_ago_in_words item['date'] %> <%= t '.old' %></h6>
#      </div>
#      <div class="asta-text"><%= item['description'] %></div>
#      <a class="button button-info" target="_blank" href="<%= item['link'] %>"><%= t ".read_original" %></a>
#    </li>
    