# set up Backbone and jQuery
$ = require('jquery')
Backbone = require('backbone')
Backbone.$ = $

# init code
AppController = require('./app_controller')
app = new AppController()

Backbone.history.start()
