class Application extends Backbone.Router

  console.log 'hogaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaae'

  routes:
    '': 'index'

  initialize: ->
    Backbone.history.start pushState: on

  index: ->
    $ =>
      ($ 'p').text 'routing index'

app = new Application()
