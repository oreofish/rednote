class Rednote.Routers.NotesRouter extends Backbone.Router
  initialize: (options) ->
    @notes = new Rednote.Collections.NotesCollection()
    @notes.reset options.notes

  routes:
    "/new"      : "newNote"
    "/index"    : "index"
    "/:id/edit" : "edit"
    "/:id"      : "show"
    ".*"        : "index"

  newNote: ->
    @view = new Rednote.Views.Notes.NewView(collection: @notes)
    $("#notes").html(@view.render().el)

  index: ->
    @view = new Rednote.Views.Notes.IndexView(notes: @notes)
    $("#notes").html(@view.render().el)

  show: (id) ->
    note = @notes.get(id)

    @view = new Rednote.Views.Notes.ShowView(model: note)
    $("#notes").html(@view.render().el)

  edit: (id) ->
    note = @notes.get(id)

    @view = new Rednote.Views.Notes.EditView(model: note)
    $("#notes").html(@view.render().el)
