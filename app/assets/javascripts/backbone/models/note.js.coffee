class Rednote.Models.Note extends Backbone.RelationalModel
  paramRoot: 'note'

  relations: [
    {
      type: Backbone.HasMany
      key: 'comments'
      relatedModel: 'Rednote.Models.Comment'
      collectionType: 'Rednote.Collections.CommentsCollection'
      reverseRelation:
        type: Backbone.HashOne
        key: 'note'
    }
    {
      type: Backbone.HasOne
      key: 'user'
      relatedModel: 'Rednote.Models.User'
    }
  ]

  defaults:
    summary: null
    attachments: null
    tag_list: null

class Rednote.Collections.NotesCollection extends Backbone.Collection
  model: Rednote.Models.Note
  url: '/notes'
