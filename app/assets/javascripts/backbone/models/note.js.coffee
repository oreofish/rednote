class Rednote.Models.Note extends Backbone.Model
  paramRoot: 'note'

  defaults:
    user_id: null
    summary: null
    message: null

class Rednote.Collections.NotesCollection extends Backbone.Collection
  model: Rednote.Models.Note
  url: '/notes'
