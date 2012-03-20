# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  # modal question show in _index.html.haml
  $('.question-show').live('show', ()->
    console.log($(this).attr("id"))
    url = "/questions/" + $(this).attr("id")
    $.get(url, {}, (data, textStatus)->
      this;
      eval(data);
    )
  )

