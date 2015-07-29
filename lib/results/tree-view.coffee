dom = require '../utils/dom'

class TreeView
    constructor: (@parent, @log) ->
        @toolbar = new TreeToolbarView @, @parent.treePane

        @_createElement()

    reset: ->

    addBrowser: (browser, info) ->

    updateStatus: (browser, specInfo) ->

    onlyFailed: ->

    collapseAll: ->

    expandAll: ->

    _createElement: ->
        @element = dom.ul 'content'

        @parent.treePane.appendChild @element

class TreeToolbarView
    constructor: (@parent, container) ->
        @_createElement container

    _createElement: (container) ->
        onlyFailedButton = dom.button [
            dom.i 'only-failed'
        ]
        dom.events onlyFailedButton,
            click: (e) => @parent.onlyFailed()

        collapseAllButton = dom.button [
            dom.i 'collapse-all'
        ]
        dom.events collapseAllButton,
            click: (e) => @parent.collapseAll()

        expandAllButton = dom.button [
            dom.i 'expand-all'
        ]
        dom.events expandAllButton,
            click: (e) => @parent.expandAll()

        @element = dom.div 'toolbar', [
            onlyFailedButton
            dom.span 'divider'
            collapseAllButton
            expandAllButton
        ]

        container.appendChild @element

module.exports = TreeView
