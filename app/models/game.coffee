
Backbone = require('Backbone')
Field = require('./field')

class Game extends Backbone.Model

  defaults: ->
    nextPlayer: 0     # by default, player with index 0 starts
    moves: [0, 0]     # the amount of moves per player
    mode: 'single'    # the game mode, can either be single or multi
    timeoutTime: 60 * 1000 # maximum time between player moves

  initialize: ->
    super

    @start()

  start: ->
    @setupField()

  setupField: ->
    options =
      playerCount: if @get('mode') is 'single' then 1 else 2

    @field = new Field options

  colorPicked: (color, playerIndex) ->
    @updateField color, playerIndex
    @increaseMoves playerIndex
    isOver = @checkIfOver playerIndex

    if isOver
      @trigger 'over'

  updateField: (color, playerIndex) ->
    @field.playerPicked playerIndex, color

  checkIfOver: (playerIndex) ->
    percentage = @field.getPossessionPercentage playerIndex

    if @get('mode') is 'single'
      percentage is 100
    else
      percentage >= 50

  # Update the current user's moves
  increaseMoves: (playerIndex) ->
    @get('moves')[playerIndex]++

module.exports = Game
