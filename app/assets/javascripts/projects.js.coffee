# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('#calendar').fullCalendar({
    # put your options and callbacks here
    weekends: false # will hide Saturdays and Sundays
    height: 600
    weekMode: 'variable'
    dayClick: (view) ->
      alert('a day has been clicked!' + view.title)
    events: [
      {
        title  : 'event1',
        start  : '2012-03-02'
      },
      {
        title  : 'event2',
        start  : '2012-03-05',
        end    : '2012-03-07'
      },
      {
        title  : 'event3',
        start  : '2012-03-09 12:30:00',
        allDay : false # will make the time show
      }
    ]
    editable: true,
    eventDrop: (event,dayDelta,minuteDelta,allDay,revertFunc) ->
      alert(event.title+" was moved "+dayDelta + " days and " + minuteDelta + " minutes.")
      if (allDay)
        alert("Event is now all-day")
      else
        alert("Event has a time-of-day")

      if (!confirm("Are you sure about this change?"))
        revertFunc()
  })
