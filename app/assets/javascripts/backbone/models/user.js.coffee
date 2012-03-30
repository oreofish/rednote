class Rednote.Models.User extends Backbone.RelationalModel
  urlRoot: "/users"
  paramRoot: 'user'

  defaults:
    email: null
    nickname: null
    avatar: null

class Rednote.Collections.UsersCollection extends Backbone.Collection
  model: Rednote.Models.User
  url: '/users'
