module.exports = (app, io) ->

  app.get '/', (req, res) ->
    res.render 'index'

  app.get '/t', (req, res) ->
    res.json ok: true
