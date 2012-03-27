class Rednote.Models.Note extends Backbone.Model
  paramRoot: 'note'

  defaults:
    summary: null
    attachments: null
    tag_list: null
    #created_at: null

class Rednote.Collections.NotesCollection extends Backbone.Collection
  model: Rednote.Models.Note
  url: '/notes'
