module.exports = (app, io) ->

  app.get '/t', (req, res) ->
    res.json ok: true
