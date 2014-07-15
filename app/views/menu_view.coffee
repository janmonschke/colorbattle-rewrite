View = require('./view')

class MenuView extends View

  template: ->
    """
    <ul class="menu">
      <li class="new_game">New Game</li>
      <li class="waiting_new_game">waiting...</li>
    </ul>
    """

  events:
    'click .new_game': 'initNewGame'

  initialize: ->
    super
    @isWaiting = false

  initNewGame: ->
    return if @isWaiting
    @isWaiting = true

    @updateWaitingState()

  updateWaitingState: ->
    if @isWaiting
      @$('.waiting_new_game').addClass('show')
    else
      @$('.waiting_new_game').removeClass('show')

module.exports = MenuView
