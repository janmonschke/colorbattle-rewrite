AsyncRouter = require('./async_router')
MenuView = require('./views/menu_view')

class AppController extends AsyncRouter

  routes:
    "": "menu"

  menu: ->
    @switchToView new MenuView()

module.exports = AppController
