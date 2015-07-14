project = require './utils/project'

module.exports = (subscriptions) ->
    subscriptions.add atom.commands.add 'atom-workspace', 'atom-karma-runner:start', start

start = (e) ->
    details = project.projectDetails e

    console.log details
