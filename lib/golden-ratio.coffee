{CompositeDisposable} = require 'atom'

module.exports = GoldenRatio =
  subscriptions: null
  paneSubscription: null
  active: false

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    @paneSubscription = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'golden-ratio:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()
    @paneSubscription?.dispose()

  subscribePane: ->
    @paneSubscription.add atom.workspace.onDidChangeActivePane => @activePaneChanged()

  unSubscribePane: ->
    @paneSubscription.dispose()

  toggle: ->
    @active = !@active
    if @active
      @subscribePane()
      @resizePanes atom.workspace.getActivePane()
    else
      @unSubscribePane()
      @resetPanes atom.workspace.paneContainer.root

  activePaneChanged: ->
    if @active
      @resizePanes atom.workspace.getActivePane()

  resizePanes: (pane)->
    parent = pane.getParent()
    if parent.children
      parent.children.map (item) -> item.setFlexScale(1)
      pane.setFlexScale parent.children.length
      @resizePanes parent

  resetPanes: (pane)->
    pane.setFlexScale 1
    if pane.children
      pane.children.map @resetPanes, @

  workspaceView: ->
    atom.views.getView atom.workspace