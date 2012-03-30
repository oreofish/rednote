Rednote.Views.Notes ||= {}

class Rednote.Views.Notes.NoteView extends Backbone.View
  template: JST["backbone/templates/notes/note"]

  initialize: () ->
    @model.set({'user': @model.get('user_id')})
    @model.fetchRelated('user')

    @commentsLoaded = false
    @model.get('comments').fetch(
      success: (collection) =>
        @commentsLoaded = true
        @render()

      error: (collection, resp) =>
        console.log "getting comments failed with response"
        consoel.log resp
    )

  events:
    "click .destroy" : "destroy"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    if @commentsLoaded
      $(@el).html(@template(@model.toJSON() ))
      @$("#comments_link#{ @model.id } > span").text @model.get('comments').length
    return this
