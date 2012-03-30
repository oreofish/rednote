Rednote.Views.Notes ||= {}

class Rednote.Views.Notes.IndexView extends Backbone.View
  template: JST["backbone/templates/notes/index"]

  initialize: () ->
    @options.notes.bind('reset', @addAll)
    @options.notes.bind('createNote',  (note) =>
      @prependOne(note)
    )
    @new_view = new Rednote.Views.Notes.NewView(collection: @options.notes)

  addAll: () =>
    @options.notes.each(@addOne)

  prependOne: (note) =>
    view = new Rednote.Views.Notes.NoteView({model: note})
    @$("#notes").prepend(view.render().el)
    @$("#note#{note.id}").hide().fadeIn(1000)

  addOne: (note) =>
    view = new Rednote.Views.Notes.NoteView({model : note})
    @$("#notes").append(view.render().el)

  render: =>
    $(@el).html(@template(notes: @options.notes.toJSON() ))
    # without `@`, it won't work!
    @$('#create_note').html(@new_view.render().el)
    @addAll()

    return this
