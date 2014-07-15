Game = require('./server_game')

games = []

module.exports =

  isPlayerInAGame: (player) ->
    isInAGame = false
    for game in games
      if game.get('players').indexOf(player) isnt -1
        isInAGame = true
        break
    return isInAGame

  createGameWith: (players) ->
    game = new Game
      id: "#{new Date().getTime()}-#{Math.random()*395472234}"
      players: players

    games.push game

    return game

  remove: (game) ->
    index = games.indexOf game
    if index > -1
      games.splice index, 1
