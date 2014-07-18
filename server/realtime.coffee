GameStateController = require('./controllers/game_state_controller')

module.exports = (io) ->
  io.on 'connection', (socket) ->
    socket.on 'request_opponent', -> GameStateController.getOpponentFor socket

    socket.on 'request_rematch', -> GameStateController.requestRematch socket

    socket.on 'client_error', (data) -> console.log 'client error:', data
