Rednote.Views.Comments ||= {}

class Rednote.Views.Comments.NewView extends Backbone.View
  template: JST["backbone/templates/comments/new"]

  events:
    "submit #new-comment": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")
    @model.set "commentable_id": @collection.note.id

    @collection.create(@model.toJSON(),
      success: (comment) =>
        @$('form')[0].reset()
        @model = new @collection.model()
        @$("form").backboneLink(@model)
        @collection.trigger('createComment', comment)

      error: (comment, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    this.$("form").backboneLink(@model)

    return this
