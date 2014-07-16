Backbone = require('backbone')

class RemoteGameInitializer extends Backbone.Model

  initialize: ->
    socket = @get('socket')
    socket.on 'waiting', @waiting
    socket.on 'found_match', @foundMatch

  initGame: ->
    @get('socket').emit('request_opponent')

  waiting: =>
    Backbone.trigger 'waiting'

  foundMatch: (data) =>
    Backbone.trigger 'found_match', data

module.exports = RemoteGameInitializer
