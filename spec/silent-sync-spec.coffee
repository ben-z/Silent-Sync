SilentSync = require '../lib/main'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "SilentSync", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('silent-sync')

  describe "when the silent-sync:toggle event is triggered", ->
    it "activates and deactivates the package", ->
      # Package is activated automatically but there is no configuration file
      expect(workspaceElement.querySelector('.silent-sync')).not.toExist()

      # Activate again, still no configuration file
      atom.commands.dispatch workspaceElement, 'silent-sync:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(workspaceElement.querySelector('.silent-sync')).not.toExist()

        silentSyncElement = workspaceElement.querySelector('.silent-sync')
        expect(silentSyncElement).not.toExist()
