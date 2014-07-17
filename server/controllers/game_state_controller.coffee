Games = require('../models/games')
WaitingList = require('../models/waiting_list')

class GameStateController

  @getOpponentFor: (requester) ->
    return if Games.isPlayerInAGame requester
    WaitingList.getOpponentFor requester, (err, opponent) ->
      if opponent
        players = [requester, opponent]
        game = Games.createGameWith players
        for player, index in players
          player.emit 'found_match',
            game: game.toJSON()
            playerIndex: index
      else
        WaitingList.add requester, ->
          requester.emit 'waiting'

  @requestRematch: (socket) ->

module.exports = GameStateController
