# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

class State
  constructor: ->
  start: ->
    throw "Wrong State"
  end: ->
    throw "Wrong State"
  connect: ->
    throw "Wrong State"
  next: ->
    throw "Wrong State"
  connected: ->
    throw "Wrong State"
  partnerDisconnected: ->
    throw "Wrong State"
  partnerFound: ->
    throw "Wrong State"
  userCountUpdate: ->
    throw "Wrong State"
  readyToChat: ->
    throw "Wrong State"
  connectionFaild: ->
    throw "Wrong State"

class ConnectedButNotReadyForChatState extends State
  readyToChat: ->
    new WaitingState()
  userCountUpdate: ->
    this
  toString: ->
    I18n.t('chatroulette.index.states.connectedButNotReadyForChat')
class WaitingState extends State
  end: ->
    new ConnectedState()
  next: ->
    new WaitingState()
  empty: =>
    this
  partnerFound: ->
    new ConnectedState()
  userCountUpdate: ->
    this
  toString: ->
    I18n.t('chatroulette.index.states.waiting')

class NotReadyState extends State
  start: ->
    new ConnectingState()
  toString: ->
    I18n.t('chatroulette.index.states.notconnected')

class ConnectingState extends State
  connected: ->
    new ConnectedButNotReadyForChatState()
  connectionFaild: ->
    new NotReadyState()
  toString: ->
    I18n.t('chatroulette.index.states.connecting')

class ConnectedState extends State
  next: ->
    new WaitingState()
  partnerDisconnected: ->
    new WaitingState()
  end: ->
    new NotReadyState()
  userCountUpdate: ->
    this
  toString: ->
    I18n.t('chatroulette.index.states.connected')

class @RouletteClient
  constructor: (@address, @port, @apiKey, @rootElement, @publisherDivId, @subscriberDivId, @debug = false) ->
    @chatLogElement = @rootElement.find('ul[data-role="chat-log"]')
    @userCountElement = @rootElement.find('span[data-role="user-count"]')
    throw "TB not loaded" if not TB
    throw "No chat-log defined" if not @chatLogElement
    TB.setLogLevel(TB.DEBUG) if @debug
    @changeState(new NotReadyState())
    #TB.addEventListener("exception", @tokExceptionHandler);
    @socket = null

  connectToServer: =>
    @changeState(@state.start())
    @socket = io.connect(@address, {port: @port, rememberTransport: false})
    if @socket
      @changeState(@state.connected())
    else
      @changeState(@state.connectionFailed())
    if @userCountElement
      @socket.on('user_update', (user_count) =>
        @numberOfUsersUpdated user_count
        @changeState(@state.userCountUpdate())
      )
    @socket.on('clientRegistered', (data) =>
      sessionId = data.sessionId
      token = data.token
      @clearLog()
      @init(sessionId, token)
    )
    @socket.on('subscribe', (data) =>
      sessionId = data.sessionId
      token = data.token
      @clearLog()
      @subscribe(sessionId, token)
    )
    @socket.on('disconnectPartners', (data) =>
      @changeState(@state.partnerDisconnected())
      @wait()
      @clearLog()
    )
    @socket.on('empty', (data) =>
      @changeState(@state.empty())
      @wait()
      @clearLog()
    )
    @socket.on('receive', (message) =>
      @receiveMessage(message)
    )
  readyToChat: =>
    @socket.emit('readyToChat')
  setStateChangeEventListener: (@eventListener) ->

  changeState: (@state) =>
    @eventListener(@state) if @eventListener
    @log(@state instanceof State)
    @log('state changed to ' + @state)

  raiseError: (error) =>
    #if @debug
    #  @log(error)
    #else
    throw error

  tokExceptionHandler: (event) =>
    # Retry session connect
    @log(event)
    if event.code == 1006 or event.code == 1008 or event.code == 1014
      @log @mySession
      @log @partnerSession
      callbackPartner = =>
        @partnerSession.connecting = false
        @partnerSession.connect(@apiKey, @partnerToken)
      callbackMe = =>
        @mySession.connecting = false
        @mySession.connect(@apiKey, @myToken)
      setTimeout callbackPartner, 200 if @partnerSession and not @partnerSession.connected
      setTimeout callbackPartner, 200 if @mySession and not @mySession.connected

  clearLog: ->
    @chatLogElement.empty()
    @log("log cleared")
  getCurrentState: ->
    @state
  sendMessage: (message) =>
    if message.length > 0 and @partnerSession
      @socket.emit('send', message)
      @chatLogElement.prepend @createMessageListItem('You', message)
    return false

  receiveMessage: (message) =>
    @chatLogElement.prepend @createMessageListItem('Stranger', message)
    @log("Received Message " + message)

  numberOfUsersUpdated: (user_count) =>
    @userCountElement.text(user_count) if @userCountElement

  createMessageListItem: (name, message) =>
    $('<li>' + name + ':' + message + '</li>')

  next: ->
    @raiseError('"Next" executed in the wrong state') unless @state instanceof ConnectedState or @state instanceof WaitingState
    @clearLog()
    @mySession.forceDisconnect(@partnerConnection) if @mySession and @partnerConnection
    @partnerSession.disconnect() if @partnerSession
    @findPartner(@mySession.sessionId) if @mySession

  subscribe: (sessionId, @partnerToken) =>
    @log("Partner: " + sessionId)
    @log("Partner token: " + @partnerToken)
    @partnerSession = TB.initSession(sessionId)
    @partnerSession.addEventListener('sessionConnected', @partnerSessionConnectedHandler)
    @partnerSession.addEventListener('sessionDisconnected', @partnerSessionDisconnectedHandler)
    @partnerSession.addEventListener('streamDestroyed', @partnerStreamDestroyedHandler)
    @partnerSession.connect(@apiKey, @partnerToken)
    @changeState(@state.partnerFound())

  init: (sessionId, @myToken) =>
    @log("My: " + sessionId)
    @log("My token: " + @myToken)
    @mySession = TB.initSession(sessionId)
    @mySession.addEventListener('sessionConnected', @mySessionConnectedHandler)
    @mySession.addEventListener('connectionCreated', @connectionCreatedHandler)
    @mySession.addEventListener('connectionDestroyed', @connectionDestroyedHandler)
    @mySession.connect(@apiKey, @myToken)
  log: (message) =>
    console.log message if @debug
  wait: =>
    console.log("wait for other")

  findPartner: (mySessionId) =>
    console.log("find partner")
    @socket.emit('next', {
    sessionId: mySessionId
    })

  partnerDisconnected: =>
    @changeState(@state.partnerDisconnected())
    @partnerSession = null

  accessAllowedHandler: (event) =>
    @changeState(@state.readyToChat())
    #@findPartner(@mySession.sessionId)
  accessDeniedHandler: (event) =>
    #@changeState(@state.readyToChat())
    #@findPartner(@mySession.sessionId)

  connectionCreatedHandler: (event) =>
    @partnerConnection = event.connections[0]

  mySessionConnectedHandler: (event) =>
    publisher = @mySession.publish(@publisherDivId)
    publisher.addEventListener('accessAllowed', @accessAllowedHandler)
    publisher.addEventListener('accessDenied', @accessDeniedHandler)

  connectionDestroyedHandler: (event) =>
    @partnerDisconnected()

  removePartnerEventLister: =>
    @partnerSession.removeEventListener('sessionConnected', @partnerSessionConnectedHandler)
    @partnerSession.removeEventListener('sessionDisconnected', @partnerSessionDisconnectedHandler)
    @partnerSession.removeEventListener('streamDestroyed', @partnerStreamDestroyedHandler)

  partnerStreamDestroyedHandler: (event) =>
    #@partnerSession.disconnect()

  partnerSessionConnectedHandler: (event) =>
    @partnerSession.subscribe(event.streams[0], @subscriberDivId) if event.streams[0]

  partnerSessionDisconnectedHandler: (event) =>
    @removePartnerEventLister()
    @partnerDisconnected()

  partnerStreamDestroyedHandler: (event) =>
    #@removePartnerEventLister()
    #@findPartner(@mySession.sessionId)
    #@partnerSession = null
