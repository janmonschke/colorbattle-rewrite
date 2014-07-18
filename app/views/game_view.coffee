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
    <div class="info animated"></div>
    <div class="field"><div>
    """

  statusToMessage:
    'you_lost': 'You lost!'
    'you_won': 'You won!'
    'normal': ''
    'opponent_left': 'Your opponent left.'
    'opponent_timeout': 'Your opponent timed out.'
    'you_timeout': 'You timed out.'

  initialize: ->
    super

    # create the field subview
    @subView new FieldView
      model: @model.field
      game: @model
      el: '.field'

    @listenTo @model, 'change:nextPlayer', @updateNextPlayerMessage
    @listenTo @model, 'you_lost', (reason) => @showGameOverMessage('you_lost', reason)
    @listenTo @model, 'you_won', (reason) => @showGameOverMessage('you_won', reason)

  afterRender: ->
    @updateNextPlayerMessage()

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

  # displays an info message and applies an effect when showing it
  displayMessage: (message, effect) ->
    infoElement = @$('.info')
    infoElement.text message

    if effect
      infoElement.addClass effect
      infoElement.one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
        infoElement.removeClass effect

  # show who's turn it is
  updateNextPlayerMessage: ->
    nextPlayerText = ""

    # change the text depending on the next player variable
    if @model.get('nextPlayer') is @options.playerIndex
      nextPlayerText = "It's your turn :)"
    else
      nextPlayerText = "Waiting for the opponent ;)"

    @displayMessage nextPlayerText, 'bounce'

  # show a message when the game is over
  showGameOverMessage: (who, reason) ->
    text = ""
    console.log reason, @statusToMessage
    if who is 'you_won'
      message = "#{@statusToMessage[who]}"
      message = "#{message} #{@statusToMessage[reason]}" if @statusToMessage[reason]
      @displayMessage message, 'tada'
    else
      message = "#{@statusToMessage[who]}"
      @displayMessage message, 'hinge'

module.exports = GameView
