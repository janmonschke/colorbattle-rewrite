_           = require 'underscore'
Field       = require '../../app/models/field'
Game        = require('./game')

class ServerGame extends Game

  maxPlayers: 2

  defaults: ->
    defaults = super
    defaults.players = []          # the array for the player objects
    defaults.currentPlayer = null  # the current player object
    defaults.over = false          # is the current game over?
    defaults.started = false       # has the game started?
    defaults.id =
    defaults

  addPlayer: (player) ->
    console.log 'addPlayer1'
    return if @players.length is @maxPlayers
    console.log 'addPlayer2'
    return if _.contains @players, player
    console.log 'addPlayer3'

    player.playerIndex = @players.length

    @players.push player

    # register to player events
    game = this
    player.socket.on 'pick_color', (color) ->
      game.colorPicked color, player
    player.socket.on 'disconnect', ->
      game.playerLeft player

    # notify that the player joined
    player.socket.emit 'joined', @toJSON()

    # start game when two players joined
    _.delay(@start, 5000) if @players.length is 2

  start: =>
    @id = "#{new Date().getTime()}-#{Math.random()*398472}"
    console.log 'start', @players.length
    @started = true
    @field.on 'over', @gameOver
    @currentPlayer = @players[0]
    @moveTimeout = setTimeout @playerTimedOut, @field.timeoutTime

    for player in @players
      player.socket.emit 'game_start', {field: @field.toJSON(), playerIndex: player.playerIndex}

  gameOver: =>
    @over = true
    for player in @players
      if @field.isOver(player.playerIndex)
        player.socket.emit 'you_won', 'normal'
      else
        player.socket.emit 'you_lost'

  colorPicked: (color, player) ->
    return if @over or not @started
    return unless _.contains @players, player
    return if player != @currentPlayer

    @field.playerPicked player.playerIndex, color

    @currentPlayer = if @currentPlayer is @players[0] then @players[1] else @players[0]

    for player in @players
      player.socket.emit 'field_changed', @field.toJSON()

    clearTimeout @moveTimeout
    @moveTimeout = setTimeout @playerTimedOut, @field.timeoutTime

  playerTimedOut: =>
    return if @over
    @over = true

    # the current player needed to long for his move
    @currentPlayer.socket.emit 'you_lost', 'opponent_timeout'

    # the other player has won now
    otherPlayer = if @currentPlayer is @players[1] then @players[0] else @players[1]
    otherPlayer.socket.emit 'you_won', 'opponent_timeout'

  playerLeft: (leavingPlayer) ->
    return if @over

    for player in @players
      if player isnt leavingPlayer
        player.socket.emit 'you_won', 'opponent_left'

  toJSON: ->
    id: @id
    name: @name
    mode: 'multi'

module.exports = Game
