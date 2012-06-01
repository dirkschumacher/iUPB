# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

class @CourseManager
  constructor: (@search_field, @result_list, @search_path, @course_path, @before_search = ->) ->
    @search_field.bind( "change", (event, ui) =>
      @result_list.empty() if @search_field.val().length == 0    
    )
    search_timer = null;
    @search_field.keyup( =>
        clearTimeout(search_timer) if search_timer
        result_list.empty() if @search_field.val().length == 0
        return false if @search_field.val().length < 3
    )
    search_timer = setTimeout( =>
      @before_search()
      $.getJSON(@search_path + '?query=' + encodeURIComponent(search_field.val()), (data) =>
        @result_list.empty()
        @result_list.append($('<li><h3>' + I18n.t("courses.index.no_results") + '</h3></li>')) if(data.length == 0)
        $.each(data, =>
          @process_search_item this
        )
      )
    , 500)
    return true
  process_search_item: (data) =>
    li = $('<li class="well" style="white-space: normal;">')
    link = $('<a data-icon="arrow-r">')
    link.append($('<h4 style="white-space: normal;">' + data.course.title + '</h3>'))
    id = data.course.id
    link.attr('href', @course_path + encodeURIComponent(id))
    next_class = data.course.next_class;
    li.append(link);
    if next_class
      infos = $('<h5>')
      dateText = I18n.l("date.formats.short", next_class.time_from)
      time_from = new Date(Date.parse(next_class.time_from))
      time_to = new Date(Date.parse(next_class.time_to))
      today = new Date()
      tomorrow = new Date()
      tomorrow.setDate(today.getDate() + 1)
      interval =  (time_from - today) / 1000 / 60 / 60;
      class_today = today.getYear() == time_from.getYear() && today.getMonth() == time_from.getMonth() && today.getDay() == time_from.getDay()
      class_tomorrow = tomorrow.getYear() == time_from.getYear() && tomorrow.getMonth() == time_from.getMonth() && tomorrow.getDay() == time_from.getDay()

     if(interval < 24 and class_today)
       dateText = I18n.t("courses.today")
     else if(interval < 48 and class_tomorrow)
       dateText = I18n.t("courses.tomorrow")
       text = I18n.t("courses.next_class", {
         date: dateText,
         time_from: I18n.l("time.formats.very_short", time_from), 
         time_to: I18n.l("time.formats.very_short", time_to),
         place: next_class.room
       })
    infos.text(text);
    li.append(infos);
    @result_list.append(li);
