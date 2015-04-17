SilentSyncView = require './silent-sync-view'
{CompositeDisposable, Notification} = require 'atom'
# # sync = require './sync.coffee'
fs = require 'fs'

module.exports =
  config:
    useConfigFile:
      title: 'Use configuration file'
      description: 'Use `silent-sync.json` instead of this panel, recommended for individual projects. See documentation for more details.'
      type: 'boolean'
      default: false
      order: 1
    notifyMissingConfig:
      title: 'Missing configuration file notification'
      description: 'When \'Use configuration file\' is selected, notify if `silent-sync.json` is missing.'
      type: 'boolean'
      default: false
      order: 2
    enabled:
      title: 'Enabled'
      description: 'Only works when \'Use configuration file\' is off. Enable Silent Sync for your project'
      type: 'boolean'
      default: true
      order: 3
    host:
      title: 'Host'
      description: 'eg. somedomain.com'
      type: 'string'
      default: ''
      order: 4
    port:
      title: 'Port'
      type: 'integer'
      default: 22
      order: 5
    username:
      title: 'Username'
      description: 'eg. someone'
      type: 'string'
      default: ''
      order: 6
    remoteDir:
      title: 'Remote Directory'
      description: 'The absolute path of the remote server (without the backslash). eg. /home/someone/Projects/myproject'
      type: 'string'
      default: '/home/someone/Projects/myproject'
      order: 7
    exclude:
      title: 'Excluded files'
      description: 'Excluded files, relative to project root. (with first backslash, separated by commas) eg. /node_modules, /someDir, /someSubDir'
      type: 'array'
      default: ['/someDir']
      items:
        type: 'string'
      order: 8
    include:
      title: 'Included files'
      description: 'Included files (that are excluded above, eg. subdirectories/files of excluded), same format as the excluded'
      type: 'array'
      default: ['/someDir/something','aaaaa']
      items:
        type: 'string'
      order: 9
    deleteRemoteFiles:
      title: 'Delete Remote Files'
      description: 'Remove any remote files that aren\'t present locally'
      type: 'boolean'
      default: false
      order: 10
    rsyncFlags:
      title: 'Flags'
      description: 'Specify rsync flags.  Default flags are \'avz\'. eg. archive, verbose, and compress file data on transfer'
      type: 'string'
      default: 'avz'
      order: 11
  activate: (state)->
    atom.packages.once 'activated', =>
      @silentSyncView = new SilentSyncView

  deactivate: ->
    @silentSyncView.destroy()

  serialize: ->
    SilentSyncView: @silentSyncView.serialize()

  toggle: ->
    @silentSyncView.toggle()

  consumeStatusBar: (statusBar) ->
    console.log 'The status bar is being used.'
