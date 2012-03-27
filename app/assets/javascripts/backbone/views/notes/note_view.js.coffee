Rednote.Views.Notes ||= {}

class Rednote.Views.Notes.NoteView extends Backbone.View
  template: JST["backbone/templates/notes/note"]

  events:
    "click .destroy" : "destroy"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
