path = require 'path'
project = require './utils/project'
karmaServer = require './karma/server'

module.exports = (subscriptions) ->
    subscriptions.add atom.commands.add 'atom-workspace', 'atom-karma-runner:start', start

start = (e) ->
    details = project.projectDetails e

    console.log details

    if !details.config
        atom.notifications.addError 'Karma configuration not found',
            details: "The karma configuration file 'karma.conf.js' was not found in the #{ path.basename details.project } project."
    else if !details.karma
        atom.notifications.addError 'Karma is not installed',
            details: "The karma module was not found in the #{ path.basename details.project } project."
    else
        karmaServer.start details
