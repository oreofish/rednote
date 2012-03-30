class Rednote.Models.Comment extends Backbone.RelationalModel
  paramRoot: 'comment'

  relations: [
    {
      type: Backbone.HasOne
      key: 'user'
      relatedModel: 'Rednote.Models.User'
    }
  ]

  defaults:
    comment: null
    commentable_id: null
    created_at: null
    updated_at: null

class Rednote.Collections.CommentsCollection extends Backbone.Collection
  model: Rednote.Models.Comment
  #url: '/comments'
  url: () =>
    console.log "request comments url"
    return "/comments?note_id=#{@note.id}"


