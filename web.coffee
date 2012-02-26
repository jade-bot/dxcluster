require('zappa') ->
  zmq = require('zmq');
  zmqsock = zmq.socket('pull');
  zmqsock.connect('tcp://127.0.0.1:8765')


  #@set 'view engine': 'hamljs', views: "#{__dirname}/views"
  #@app.register('.haml', require('hamljs'));
  @enable 'serve jquery'

  @on connection: (sock) ->
    @emit message: 'ohai there'

  zmqsock.on "message", (data) ->
    ## this is displaying a log to the console, but not sending
    ## to the browser via socket.io yet :(
    ## see http://zappajs.org/docs/crashcourse/
    ## and http://socket.io/#how-to-use
    @emit welcome: {spot: data.toString()}
    console.log(data.toString())
  
  @get '/': ->
    @render 'index'


  @client '/index.js': ->
    @connect()
    @on welcome: ->
      #alert(@data)

    @on message: ->
      #alert(@data)
      $('#dx_spots').append "<p>#{@data}</p>"
      console.log(@data)
      

  @view index: ->
    div '#dx_spots', ''
  
  @view layout: ->
    doctype 5
    html ->
      head ->
        title 'DX Cluster'
        script src: '/socket.io/socket.io.js'
        script src: '/zappa/jquery.js'
        script src: '/zappa/zappa.js'
        script src: '/index.js'
    body @body
  
