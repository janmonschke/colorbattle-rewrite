# set up Backbone and jQuery
$ = require('jquery')
Backbone = require('backbone')
Backbone.$ = $

# init code
AppController = require('./app_controller')
app = new AppController()

# error reporting
window.onerror = (errorMsg, url, lineNumber) ->
  io().emit 'client_error',
    errorMsg: errorMsg
    url: url
    lineNumber: lineNumber

Backbone.history.start()
