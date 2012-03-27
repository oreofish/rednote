Rednote.Views.Notes ||= {}

class Rednote.Views.Notes.NewView extends Backbone.View
  template: JST["backbone/templates/notes/new"]

  events:
    "submit #new-note": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (note) =>
        @$('form')[0].reset()
        @model = new @collection.model()
        @$("form").backboneLink(@model)
        @collection.trigger('createNote', note)

      error: (note, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    this.$("form").backboneLink(@model)

    return this
