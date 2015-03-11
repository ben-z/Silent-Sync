{$, View} = require 'atom-space-pen-views'
fs = require 'fs'
watch = require 'watch'
Rsync = require 'rsync'

module.exports =
class SilentSyncView extends View

  @content: ->
    @div class: 'status-stats inline-block silent-sync', =>
      @a outlet: 'scriptLink', href: '#', =>
        @span 'SilentSync: '
        @span class: 'ss-status'

  initialize: (serializeState) ->
    # @root is the project root path
    @root = atom.project.getPaths()[0]
    @state = {
      status: '' # disconnected, ready, syncing
      connected: false
      statusBarTile: null
      errorMsg: ''
    }

    @toggle()
    atom.commands.add 'atom-workspace', 'silent-sync:toggle', => @toggle()

  initUpload: ->
    @changeStatus('Connecting')
    @rsync = new Rsync()
      .shell 'ssh'
      .flags 'avz'
      .source @root + '/'
      .destination(
        @config.username + '@' +
        @config.host + ':' +
        @config.remoteDir
      )
      .delete()
    @rsync.exclude @config.exclude if @config.exclude
    @rsync.include @config.include if @config.include

  upload: ()->
    @changeStatus('Syncing')
    @rsync.execute (error, code, cmd) =>
      error.code = code if error
      console.log code
      console.log cmd
      @handleUpload(error)


  handleUpload: (err)->
    if err
      atom.notifications.addError('Silent Sync Error: ' + err.message)
      @state.errorCode = err.code
      @changeStatus('Error')
    else
      @changeStatus('Ready')


  startWatch: ->
    filterFunc = (filePath) =>
      !(@config.exclude.indexOf(filePath.replace(@root + '/','')) > - 1)

    watch.watchTree @root, {filter: filterFunc} , (f, curr, prev) =>
      @upload()

  stopWatch: ->
    watch.unwatchTree(@root)

  attachStatus: ->
    statusBar = document.querySelector("status-bar")
    if statusBar?
      @state.statusBarTile = statusBar.addRightTile(item: this, priority: 100)
      @changeStatus('Disconnected')

  detachStatus: ->
    @state.statusBarTile?.destroy()

  changeStatus: (status)->
    # console.log 'Status: '+status
    @state.status = status
    # @find '.ss-status'
    #   .text "#{status}"

    $('.ss-status').removeClass('disconnected connecting error ready syncing')
    $('.ss-status').addClass(status.toLowerCase())

    @tooltip?.dispose()
    $('.silent-sync')?.off 'click'
    if status == 'Error'
      @tooltip = atom.tooltips?.add document.querySelector('.silent-sync'),{title: 'Error Code: ' + @state.errorCode}
      $('.silent-sync').on 'click', (e)=>
        e.preventDefault()
        atom.clipboard.write String(@state.errorCode)
        $('.tooltip-inner')?.html('Copied: 255')
  toggle: ->
    if @state.connected
      # Switch off
      @detachStatus()
      @stopWatch()
      @state.connected = false
      # console.log 'stopped'
    else
      # Switch on
      # Check if silent-sync.json exists
      # if fs.existsSync @root + '/silent-sync.json'
        # Read config if exists
        # @config = JSON.parse(fs.readFileSync(@root + '/silent-sync.json'))
      docsUrl = 'https://github.com/ben-z/Silent-Sync'

      if atom.config.get('silent-sync.useConfigFile')
        if fs.existsSync @root + '/silent-sync.json'
          @config = JSON.parse(fs.readFileSync(@root + '/silent-sync.json'))
          proceed = true
        else if atom.config.get('silent-sync.notifyMissingConfig')
          atom.notifications.addWarning('\'silent-sync.json\' is to be used but cannot be found. [Read the docs]('+docsUrl+')')
      else
        @config = atom.config.get('silent-sync')
        proceed = true

      if proceed && @config.enabled && !@config.host
        atom.notifications.addWarning('\'Host\' field is missing in settings. [Read the docs]('+docsUrl+')')
        proceed = false
      if proceed && @config.enabled && !@config.username
        atom.notifications.addWarning('\'Username\' field is missing in settings. [Read the docs]('+docsUrl+')')
        proceed = false

      if proceed && @config.enabled
        @attachStatus() # status = disconnected
        @initUpload() # status = connecting
        @startWatch() # status = syncing -> ready
        @state.connected = true

  serialize: ->
    JSON.stringify @state
  # Tear down any state and detach
  destroy: ->
    @state.connected = true
    @toggle()
