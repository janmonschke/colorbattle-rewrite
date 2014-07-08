# set up Backbone and jQuery
$ = require('jquery')
Backbone = require('backbone')
Backbone.$ = $

# init code
Game = require('./models/game')

window.g = new Game()
