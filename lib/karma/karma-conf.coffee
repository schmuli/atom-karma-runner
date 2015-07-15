# Use the currently active project's config file
# 1. Load the current config file
# 2. Extract the relevant details, ignoring stuff that would prevent the plugin from working
# 3. Set the config to the valid values
path = require 'path'
karmaServer = require './server'
AtomKarmaReporter = require './atom-karma-reporter'

projectDetails = karmaServer.projectDetails

module.exports = (config) ->
    runOriginalConfig config

    config.reporters = [AtomKarmaReporter.name]

    plugins = config.plugins || ['karma-*'];
    plugins.push require.resolve './atom-karma-plugin'
    config.plugins = plugins

    # Exclude the original configuration file
    config.excludes ?= []
    config.excludes.push projectDetails.config

    config.singleRun = false
    config.autoWatch = true

    setBasePath config

runOriginalConfig = (config) ->
    originalConfig = require projectDetails.config
    originalConfig config

setBasePath = (config) ->
    basePath = config.basePath || '.'
    originalConfigDir = path.dirname projectDetails.config
    config.basePath = path.resolve originalConfigDir, basePath
