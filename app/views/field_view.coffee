_ = require('underscore')
View = require('./view')
Field = require('../models/field')

class FieldView extends View
  maxFieldWidth: 460

  initialize: ->
    super

    @listenTo @model, 'change', @updateField

  afterRender: =>
    width = @model.get('width')
    height = @model.get('height')
    colors = @model.get('colors')
    possessions = @model.get('possessions')

    fieldWidth = Math.min @maxFieldWidth, window.innerWidth
    size = Math.floor fieldWidth / width
    actualWidth = size * width
    @$el.width actualWidth

    # iterate over the field and create elements -> colors and possessions
    for y in [0...height]
      for x in [0...width]
        color = "color#{colors[y][x]}"
        color = "player#{possessions[y][x]}" if possessions[y][x] isnt Field.free
        @$el.append "<div class='color #{color}' data-x='#{x}' data-y='#{y}' style='width:#{size}px; height:#{size}px;'>"

    console.log "color-elements in the DOM: #{@$('.color').length}"

  updateField: =>
    width = @model.get('width')
    height = @model.get('height')
    possessions = @model.get('possessions')

    colorElementsList = @$('.color')
    colorRegex = /color[\d]+/

    for y in [0...height]
      for x in [0...width]
        # get the current element
        element = colorElementsList.eq y * height + x
        # check if the field is still free
        matches = element.attr('class').match(colorRegex)

        # only check for color fields and not for player fields
        if matches? and possessions[y][x] isnt Field.free
          # remove the color
          element.removeClass matches[0]
          # add the owner's color
          element.addClass "player#{possessions[y][x]}"

module.exports = FieldView
