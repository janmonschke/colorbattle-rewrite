Game = require('./game')

class RemoteGame extends Game

  defaults: ->
    defaults = super
    defaults.socket = null      # the socket for the game communication
    defaults

  colorPicked: (color, playerIndex) ->
    @get('socket').emit 'pick_color', color
