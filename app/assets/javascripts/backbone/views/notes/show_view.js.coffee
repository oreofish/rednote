Rednote.Views.Notes ||= {}

class Rednote.Views.Notes.ShowView extends Backbone.View
  template: JST["backbone/templates/notes/show"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
