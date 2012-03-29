Rednote.Views.Comments ||= {}

class Rednote.Views.Comments.IndexView extends Backbone.View
  template: JST["backbone/templates/comments/index"]

  initialize: () ->
    @options.comments.bind('reset', @addAll)
    @options.comments.bind('createComment', @addOne)
    @new_view = new Rednote.Views.Comments.NewView(collection: @options.comments)

  addAll: () =>
    console.log "add all"
    @options.comments.each(@addOne)

  addOne: (comment) =>
    view = new Rednote.Views.Comments.CommentView({model : comment})
    @$("ul").append(view.render().el)

  render: =>
    $(@el).html(@template(comments: @options.comments.toJSON() ))
    @addAll()
    @$('.js-create_comment').html(@new_view.render().el)

    return this
