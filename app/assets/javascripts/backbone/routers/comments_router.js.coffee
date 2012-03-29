class Rednote.Routers.CommentsRouter extends Backbone.Router
  initialize: (options) ->
    @commentsArray = {}

  routes:
    "/comments/note:note_id" : "index"

  index: (note_id) ->
    note = noteRouter.notes.get(note_id)
    if not @commentsArray[note_id]
      @commentsArray[note_id] = new Rednote.Views.Comments.IndexView(comments: note.get('comments'))

    $("#comments_list#{note.id}").html(@commentsArray[note_id].render().el)

