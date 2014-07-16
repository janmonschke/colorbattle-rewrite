_ = require('underscore')
Backbone = require('backbone')
Field = require('./field')

class Game extends Backbone.Model

  defaults: ->
    nextPlayer: 0     # by default, player with index 0 starts
    moves: [0, 0]     # the amount of moves per player
    mode: 'single'    # the game mode, can either be single or multi
    timeoutTime: 60 * 1000 # maximum time between player moves

  initialize: (@options = {}) ->
    super

    @start()

  start: ->
    @setupField()

  setupField: ->
    fieldOptions =
      playerCount: if @get('mode') is 'single' then 1 else 2

    # if a field has been specified, use that
    if @options.field?
      _.extend fieldOptions, @options.field
      # remove traces from the field
      delete @options.field
      @set('field', null)

    @field = new Field fieldOptions

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
