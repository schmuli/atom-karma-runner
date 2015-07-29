dom = require '../utils/dom'

TreeView = require './tree-view'
SliderView = require './slider-view'
LogView = require './log-view'

class ResultsView
    constructor: ->
        @_createElement()

        new SliderView @
        @log = new LogView @
        @tree = new TreeView @, @log

    addBrowser: (browser, info) ->
        @tree.addBrowser browser, info
        @log.addBrowser browser, info
        @_display()
        @

    updateStatus: (browser, specInfo) ->
        @tree.updateStatus browser, specInfo
        @log.updateStatus browser, specInfo
        @

    reset: ->
        @tree.reset()
        @log.reset()
        @

    _display: ->
        return if @visible

        @visible = true
        atom.workspace.addBottomPanel
            item: @element

    _createElement: ->
        @treePane = dom.div 'result-pane tree'
        @slider = dom.div 'slider'
        @logPane = dom.div 'result-pane log'
        @element = dom.div 'karma-results', [
            @treePane
            @slider
            @logPane
        ]

module.exports = ResultsView
