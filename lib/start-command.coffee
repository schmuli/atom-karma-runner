# add command
# add conditional context-menu
# add command handler
#     if e.details => context-menu
#     if !e.details => package menu

module.exports = (subscriptions) ->
    subscriptions.add atom.commands.add 'atom-workspace', 'atom-karma-runner:start', start

    subscriptions.add atom.contextMenu.add {
        '.tree-view':
            'label': 'Start Karma'
            'command': 'atom-karma-runner:start'
            'shouldDisplay': shouldDisplay
    }

start = (e) ->
    details = if e.details then getDetails e else getProjectDetails()

getDetails = (e) ->
    config: e.target.dataset.path
    karma: null

getProjectDetails = ->


shouldDisplay = (e) ->
    name = getFileName e.target
    name? && name == 'karma.conf.js'

getFileName = (elm) ->
    if elm.hasAttribute 'is'
        elm = elm.firstElementChild

    elm.dataset.name || null
