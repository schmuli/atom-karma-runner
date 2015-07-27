module.exports = class Results
    addBrowserInfo: (browser, info) ->
        console.log 'adding browser info', browser.name, info

    updateStatus: (browser, specResult, log) ->
        console.log 'update status ', browser.name
        console.log '   spec result', specResult
        console.log '   browser    ', browser.lastResult
        console.log '   log        ', log

    reset: ->
        console.log 'reseting'
