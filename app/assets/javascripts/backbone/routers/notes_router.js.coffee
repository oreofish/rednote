class Rednote.Routers.NotesRouter extends Backbone.Router
  initialize: (options) ->
    @notes = new Rednote.Collections.NotesCollection()
    @notes.reset options.notes
    @current_user = options.current_user

  routes:
    "/index"    : "index"
    "/:id/edit" : "edit"
    "/:id"      : "show"
    ".*"        : "index"

  index: ->
    @view = new Rednote.Views.Notes.IndexView(notes: @notes)
    $("#main-contents").html(@view.render().el)

  show: (id) ->
    note = @notes.get(id)

    @view = new Rednote.Views.Notes.ShowView(model: note)
    $("#main-contents").html(@view.render().el)

  edit: (id) ->
    note = @notes.get(id)

    @view = new Rednote.Views.Notes.EditView(model: note)
    $("#main-contents").html(@view.render().el)
