Rednote.Views.Comments ||= {}

class Rednote.Views.Comments.EditView extends Backbone.View
  template : JST["backbone/templates/comments/edit"]

  events :
    "submit #edit-comments" : "update"

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success : (comments) =>
        @model = comments
        window.location.hash = "/#{@model.id}"
    )

  render : ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
