_           = require 'underscore'
Game        = require '../../app/models/game'

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

  start: =>
    super

    players = @get('players')
    for player in players
      @trackPlayer player

    @started = true

    @currentPlayer = players[0]
    @moveTimeout = setTimeout @playerTimedOut, @get('timeoutTime')

  trackPlayer: (player) ->
    player.on 'pick_color', (color) => @colorPicked color, player
    player.on 'disconnect', => @playerLeft player

  gameOver: =>
    @set('over', true)
    for player, playerIndex in @get('players')
      if @field.isOver playerIndex
        player.emit 'you_won', 'normal'
      else
        player.emit 'you_lost'

  colorPicked: (color, player) ->
    return if @get('over') or not @get('started')
    return unless _.contains @get('players'), player
    return if player isnt @currentPlayer

    players = @get('players')
    playerIndex = players.indexOf(player)

    # use base Game object's method to determine over-state
    super color, playerIndex

    # game might be over now
    return if @get('over')

    @currentPlayer = if @currentPlayer is players[0] then players[1] else players[0]

    for playerSocket in players
      playerSocket.emit 'field_changed', @field.toJSON()

    clearTimeout @moveTimeout
    @moveTimeout = setTimeout @playerTimedOut, @field.timeoutTime

  playerTimedOut: =>
    return if @get('over')
    @set('over', true)

    # the current player needed to long for its move
    @currentPlayer.emit 'you_lost', 'opponent_timeout'

    # the other player has won now
    players = @get('players')
    otherPlayer = if @currentPlayer is players[1] then players[0] else players[1]
    otherPlayer.emit 'you_won', 'opponent_timeout'

  playerLeft: (leavingPlayer) ->
    return if @get('over')

    for player in @get('players')
      if player isnt leavingPlayer
        player.emit 'you_won', 'opponent_left'

  toJSON: ->
    console.log 'toJSON, server game'
    id: @id
    field: @field.toJSON()

module.exports = ServerGame
