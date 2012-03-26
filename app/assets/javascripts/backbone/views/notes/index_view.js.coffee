Rednote.Views.Notes ||= {}

class Rednote.Views.Notes.IndexView extends Backbone.View
  template: JST["backbone/templates/notes/index"]

  initialize: () ->
    @options.notes.bind('reset', @addAll)

  addAll: () =>
    @options.notes.each(@addOne)

  addOne: (note) =>
    view = new Rednote.Views.Notes.NoteView({model : note})
    @$("tbody").append(view.render().el)

  render: =>
    $(@el).html(@template(notes: @options.notes.toJSON() ))
    @addAll()

    return this
