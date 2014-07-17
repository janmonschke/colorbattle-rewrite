Backbone = require('backbone')
AsyncRouter = require('./async_router')
MenuView = require('./views/menu_view')
GameView = require('./views/game_view')
RemoteGame = require('./models/remote_game')

class AppController extends AsyncRouter

  routes:
    "": "menu"

  initialize: ->
    @listenTo Backbone, 'found_match', @showGame

  menu: ->
    @switchToView new MenuView()

  showGame: (gameData) ->
    gameData.game.socket = io()
    game = new RemoteGame gameData.game

    @switchToView new GameView
      model: game
      playerIndex: gameData.playerIndex

module.exports = AppController
