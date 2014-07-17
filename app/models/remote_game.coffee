Game = require('./game')

class RemoteGame extends Game

  defaults: ->
    defaults = super
    defaults.socket = null      # the socket for the game communication
    defaults

  initialize: ->
    super

    socket = @get('socket')
    socket.on 'field_changed', @fieldChanged
    socket.on 'you_won', (reason) -> alert "You won! reason: #{reason}"
    socket.on 'you_lost', (reason) -> alert "You lost! reason: #{reason}"

  updateField: (playerIndex, color) ->
    @get('socket').emit 'pick_color', color

  fieldChanged: (field) =>
    @field.set field
    @field.trigger 'change'

module.exports = RemoteGame
