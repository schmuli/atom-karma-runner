# Register context-menu item for karma.conf.js files
{CompositeDisposable} = require 'atom'

commands = require './commands'

module.exports = new
class AtomKarmaRunner
    activate: ->
        @subscriptions = new CompositeDisposable

        commands @subscriptions

    deactivate: ->
        @subscriptions?.dispose()

    serialize: ->
        atomKarmaRunnerViewState: null
