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

  $('body').on('mouseover', '.task-todo', ()->
    $(this).find(".small-link").attr style: ""
    console.log "muhh"
  )

  $('body').on('mouseout', '.task-todo', ()->
    $(this).find(".small-link").attr style: "display:none;"
  )

  $('#taskprogresslink').click()
  $('#latest_commentslink').click()
