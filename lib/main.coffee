SilentSyncView = require './silent-sync-view'
{CompositeDisposable, Notification} = require 'atom'

module.exports = SilentSync =
  ssView: null
  statusElement: null
  subscriptions: null

  activate: (state)->
    console.log "Activating"
    @ssView = new SilentSyncView(state.ssViewState)
    @statusElement = atom.workspace.addModalPanel(
      item: @ssView.getElement(), visible: false)

    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace', 'silent-sync:toggle': => @toggle()

    # atom.packages.once 'activated', =>
      # @silentSyncView = new SilentSyncView

  deactivate: ->
    @statusElement = null
    @subscriptions.dispose()
    @ssView.destroy()

  serialize: ->
    ssViewState: @ssView.serialize()

  toggle: ->
    if @statusElement.isVisible()
      @statusElement.hide()
    else
      @statusElement.show()

  consumeStatusBar: (statusBar) ->
    console.log 'Status bar is being used'
