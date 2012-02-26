require('haml')
require('zappa') ->
  @enable 'serve jquery'
  
  @get '/': ->
    @render index: {layout: './index.haml'}
  
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
