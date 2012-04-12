# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('body').on('keypress', '#comment_comment', (e)->
    if e.ctrlKey and (e.which == 13 or e.which == 10)
      $(this).parent('form').find(':submit').trigger('click')
    console.log e
  )
