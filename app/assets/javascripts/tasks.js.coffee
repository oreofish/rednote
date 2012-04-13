# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('#task_deadline').datepicker();
  $('.best_in_place').best_in_place();

  # modal task view in _note.html.erb
  $('.taskeditview').live('show', ()->
    console.log($(this).attr("id"))
    url = "/tasks/" + $(this).attr("taskid")
    $.get(url, {}, (data, textStatus)->
      this;
      eval(data);
    )
  )

  # draggable task item in _note.html.erb
  $( ".taskitem" ).live('mouseover', ()->
    $(this).draggable({
      distance: 20,
      revert: true,
      opacity: 0.7,
      cursor: "move",
      cursorAt: { top: 20, left: 20 },
      helper: ( event ) ->
         $( "<img src='/images/todo-note.jpg'>" );
      }
    )
  )
  $('body').on('click', ".js-change-status" , ()->
    url = $(this).attr("data-url")
    $.get(url, {})
  )

  $('body').on('click',".edittaskcontent", ()->
    id = $(this).attr("taskid")
    $('#task'+id).find('.js-add-throughline').attr "style", "display:none;"
    $('#task'+id).find('.js-editable').attr "style", ""
    $('#task'+id).find('.js-change-status').attr "disabled", "false"
  )

  $('body').on('blur',".form_in_place", (e)->
    id = $(this).parent().attr("id").match(/\d+/)
    $('#task'+id).find('.js-change-status').removeAttr "disabled"
    $('#task'+id).find('.js-add-throughline').attr "style", ""
    $('#task'+id).find('.js-editable').attr "style", "display:none;"
  )

  $('body').on('change', ".js-editable", (e)->
    id = $(this).find('.best_in_place').attr("id").match(/\d+/)
    $('#task'+id).find('.js-add-throughline a').text(e.target.value)
  )

  $('#taskprogresslink').click()
  $('#latest_commentslink').click()
  $('#documentfiles').click()
