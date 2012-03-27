class Rednote.Models.User extends Backbone.Model
  paramRoot: 'user'

  defaults:
    email: null
    nickname: null

class Rednote.Collections.UsersCollection extends Backbone.Collection
  model: Rednote.Models.User
  url: '/users'
