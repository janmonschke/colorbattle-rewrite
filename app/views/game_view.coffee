View = require('./view')
FieldView = require('./field_view')

class GameView extends View
  class: 'game'

  template: ->
    """
    <div class="field"><div>
    """

  initialize: ->
    super

    # create the field subview
    @subView new FieldView
      model: @model.field
      game: @model
      playerIndex: @options.playerIndex
      el: '.field'

module.exports = GameView
