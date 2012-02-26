#require('hamljs')
require('zappa') ->
  #@app.register ".haml", require("hamljs")
  @set 'view engine': 'hamljs', views: "#{__dirname}/views"
  @app.register('.haml', require('hamljs'));
  @enable 'serve jquery'
  
  @get '/': -> @render 'index.haml': {foo: 'bar'}
  
  @on said: ->
    @broadcast said: {nickname: @client.nickname, text: @data.text}
    @emit said: {nickname: @client.nickname, text: @data.text}
  
  @client '/index.js': ->
    @connect()

    @on said: ->
      $('#panel').append "<p>#{@data.nickname} said: #{@data.text}</p>"
    
    $ =>
      @emit 'set nickname': {nickname: prompt 'Pick a nickname!'}
      
      $('#box').focus()
      
      $('button').click (e) =>
        @emit said: {text: $('#box').val()}
        $('#box').val('').focus()
        e.preventDefault()
