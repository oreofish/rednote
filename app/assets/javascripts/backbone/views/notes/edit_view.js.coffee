Rednote.Views.Notes ||= {}

class Rednote.Views.Notes.EditView extends Backbone.View
  template : JST["backbone/templates/notes/edit"]

  events :
    "submit #edit-note" : "update"

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success : (note) =>
        @model = note
        window.location.hash = "/#{@model.id}"
    )

  render : ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
