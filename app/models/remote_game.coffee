Game = require('./game')

class RemoteGame extends Game

  defaults: ->
    defaults = super
    defaults.socket = null      # the socket for the game communication
    defaults

  initialize: ->
    super

    socket = @get('socket')
    socket.on 'next_round', @nextRound
    socket.on 'you_won', (reason) => @trigger 'you_won', reason
    socket.on 'you_lost', (reason) => @trigger 'you_lost', reason

  updateField: (playerIndex, color) ->
    @get('socket').emit 'pick_color', color

  nextRound: (nextRoundData) =>
    @field.set nextRoundData.field
    @field.trigger 'change'
    @set 'nextPlayer', nextRoundData.nextPlayer

module.exports = RemoteGame
