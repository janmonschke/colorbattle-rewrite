View = require('./view')
RemoteGameInitializer = require('../models/remote_game_initializer')

class MenuView extends View

  template: ->
    """
    <ul class="menu">
      <li class="new_game button">New Game</li>
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

    @socket = io()
    @initializer = new RemoteGameInitializer socket: @socket
    @initializer.initGame()

    @updateWaitingState()

  updateWaitingState: =>
    if @isWaiting
      @$('.waiting_new_game').addClass('show')
    else
      @$('.waiting_new_game').removeClass('show')

module.exports = MenuView
