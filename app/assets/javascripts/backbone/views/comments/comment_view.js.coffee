Rednote.Views.Comments ||= {}

class Rednote.Views.Comments.CommentView extends Backbone.View
  template: JST["backbone/templates/comments/comment"]

  initialize: () ->
    @model.set({'user': @model.get('user_id')})
    @model.fetchRelated('user')

  events:
    "click .destroy" : "destroy"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    console.log @model.toJSON()
    $(@el).html(@template(@model.toJSON() ))
    return this
