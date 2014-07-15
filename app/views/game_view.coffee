View = require('./view')

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
      el: '.field'

module.exports = GameView
