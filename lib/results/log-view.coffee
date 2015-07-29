dom = require '../utils/dom'

class LogView
    constructor: (@parent) ->
        @toolbar = new LogToolbarView @, @parent.logPane

        @_createElement()

    reset: ->
        @toolbar.reset()
        @element.innerHTML = ''

    addBrowser: (browser, info) ->
        @toolbar.addBrowser browser, info

    updateStatus: (browser, specInfo) ->
        @toolbar.updateStatus browser, specInfo

    showLog: (log) ->
        @element.innerHTML = log

    _createElement: ->
        @element = dom.div 'content'

        @parent.logPane.appendChild @element

class LogToolbarView
    constructor: (@parent, container) ->
        @_createElement container
        @reset false

    reset: (elements = true)->
        @total = 0
        @success = 0
        @failed = 0
        @skipped = 0
        @time = 0

        return if not elements

        @element.classList.remove 'has-failures'
        @textElement.innerHTML = ''
        @progressElement.style.width = '0'

    addBrowser: (browser, info) ->
        console.log 'adding browser', info

        @total += info.total
        @_updateText()

    updateStatus: (browser, specInfo) ->
        if specInfo.skipped
            @skipped += 1
        else if specInfo.success
            @success += 1
        else
            @failed += 1

        @time += specInfo.time

        @_updateText()
        @_updateProgress()
        @_updateStatus()

    _updateText: ->
        time = @time / 1000
        @textElement.innerHTML = "Total: #{@total}, Passed: #{@success}, Failed: #{@failed}, Skipped: #{@skipped} (#{time} s)"

    _updateProgress: ->
        actual = @skipped + @success + @failed
        width = (@total / actual) * 100
        @progressElement.style.width = width + '%'

    _updateStatus: ->
        if !@element.classList.contains 'has-failures' && @failed > 0
            @element.classList.add 'has-failures'

    _createElement: (container) ->
        @textElement = dom.span()
        @progressElement = dom.div()
        progress = dom.div 'progress', [
            @progressElement
        ]
        @element = dom.div 'toolbar', [
            @textElement,
            progress
        ]

        container.appendChild @element

module.exports = LogView
