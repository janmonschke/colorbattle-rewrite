express = require('express')
serveStatic = require('serve-static')
favicon = require('serve-favicon')
bodyParser = require('body-parser')
cookieParser = require('cookie-parser')
morgan = require('morgan')

module.exports = (app, io) ->
  # user jade for templating
  app.set 'view engine', 'jade'
  app.set 'views', __dirname + '/views'

  # serve the public folder
  app.use serveStatic 'public'

  # default favicon to reduce 404s
  # server.use favicon()
  console.log('specify a favicon')

  # parse bodies
  app.use bodyParser.urlencoded(extended: false)
  app.use bodyParser.json()

  # parse cookies
  app.use cookieParser()

  # log everything
  app.use morgan('dev')

  app.disable('x-powered-by')
