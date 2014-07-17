View = require('./view')
FieldView = require('./field_view')

class GameView extends View
  class: 'game'

  events:
    'click .field .color': 'markOrSelectNeighbours'
    'touchstart .field .color': 'markOrSelectNeighbours'

  template: ->
    """
    <div class="index">#{@options.playerIndex}</div>
    <div class="field"><div>
    """

  initialize: ->
    super

    # create the field subview
    @subView new FieldView
      model: @model.field
      game: @model
      el: '.field'

  unhighlight: ->
    @$('.highlight').removeClass('highlight')

  markOrSelectNeighbours: (event) =>
    isHighlighted = @$(event.target).hasClass('highlight')
    @unhighlight()

    x = parseInt event.target.getAttribute('data-x'), 10
    y = parseInt event.target.getAttribute('data-y'), 10
    color = @model.field.get('colors')[y][x]

    if isHighlighted
      @selectNeighbours event.target, x, y, color
    else
      @markNeighbours event.target, x, y, color

    event.stopPropagation()
    event.preventDefault()

  selectNeighbours: (element, x, y, color) ->
    @model.updateField @options.playerIndex, color

  markNeighbours: (element, x, y, color) ->
    width = @model.field.get('width')
    positions = @model.field.getFreePositionsByPlayerAndColor @options.playerIndex, color
    for position in positions
      @$(".color:eq(#{position.x + position.y * width})").addClass('highlight')

module.exports = GameView
