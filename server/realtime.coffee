GameStateController = require('./controllers/game_state_controller')

module.exports = (io) ->
  io.on 'connection', (socket) ->
    socket.on 'requestOpponent', -> GameStateController.getOpponentFor socket

    socket.on 'requestRematch', -> GameStateController.requestRematch socket
