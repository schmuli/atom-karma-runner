Results = require '../results'

class AtomKarmaReporter
    onRunStart: (browsers) ->
        if @results
            @results.reset()
        else
            @results = new Results()

    onBrowserStart: (browser, info) ->
        @results.addBrowserInfo browser, info

    onBrowserLog: (browser, log, type) ->
        @log ?= new LogManager()
        @log.append log

    onSpecComplete: (browser, specResult) ->
        accumulatedLog = @log.toString() if @log

        @results.updateStatus browser, specResult, accumulatedLog

    onRunComplete: ->
        @log = null

class LogManager
    constructor: ->
        @log = []

    append: (message) ->
        @log.push message

    toString: ->
        @log.join '\r'

AtomKarmaReporter.name = 'AtomKarmaReporter'
AtomKarmaReporter.$inject = []

module.exports = AtomKarmaReporter
