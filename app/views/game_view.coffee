View = require('./view')
FieldView = require('./field_view')

class GameView extends View
  className: 'game'

  events:
    'click .field .color': 'markOrSelectNeighbours'
    'touchstart .field .color': 'markOrSelectNeighbours'

  template: ->
    """
    <div class="index">#{@options.playerIndex}</div>
    <div class="nextPlayer animated"></div>
    <div class="field"><div>
    """

  initialize: ->
    super

    # create the field subview
    @subView new FieldView
      model: @model.field
      game: @model
      el: '.field'

    @listenTo @model, 'change:nextPlayer', @updateNextPlayerField

  afterRender: ->
    @updateNextPlayerField()

  unhighlight: ->
    @$('.highlight').removeClass('highlight')

  markOrSelectNeighbours: (event) =>
    isHighlighted = @$(event.target).hasClass('highlight')

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
    @unhighlight()
    width = @model.field.get('width')
    positions = @model.field.getFreePositionsByPlayerAndColor @options.playerIndex, color
    for position in positions
      @$(".color:eq(#{position.x + position.y * width})").addClass('highlight')

  updateNextPlayerField: ->
    nextPlayerText = ""
    nextPlayerElement = @$('.nextPlayer')

    # make it bounce
    nextPlayerElement.addClass('bounce')
    nextPlayerElement.one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
      nextPlayerElement.removeClass('bounce')

    # change the text
    if @model.get('nextPlayer') is @options.playerIndex
      nextPlayerText = "It's your turn :)"
    else
      nextPlayerText = "Waiting for the opponent ;)"
    nextPlayerElement.text nextPlayerText

module.exports = GameView
