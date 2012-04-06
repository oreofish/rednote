# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('#calendar').fullCalendar({
    # put your options and callbacks here
    editable: true,
    defaultView: 'agendaWeek',
    slotMinutes: 15,
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    },

    loading: (bool) ->
      if (bool) 
        $('#loading').show()
      else 
        $('#loading').hide()

    weekends: false # will hide Saturdays and Sundays
    height: 600
    weekMode: 'variable'
    events: "/events/get_events",
    timeFormat: 'h:mm t{ - h:mm t} ',
    dragOpacity: "0.5",

    dayClick: (view) ->
      alert('a day has been clicked!' + view.title)

    eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc) ->
      if (confirm("Are you sure about this change?"))
        moveEvent(event, dayDelta, minuteDelta, allDay)
      else
        revertFunc()

    eventResize: (event, dayDelta, minuteDelta, revertFunc) ->
      if (confirm("Are you sure about this change?"))
        resizeEvent(event, dayDelta, minuteDelta)
      else
        revertFunc()
    
    eventClick: (event, jsEvent, view) ->
      showEventDetails(event);
  })
