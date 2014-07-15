# set up Backbone and jQuery
$ = require('jquery')
Backbone = require('backbone')
Backbone.$ = $

# init code
AppController = require('./app_controller')
new AppController()

Backbone.history.start()

Game = require('./models/game')

window.g = new Game()
window.socket = io()

debugger
