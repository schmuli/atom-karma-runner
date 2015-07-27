path = require 'path'

exports.projectDetails = null

exports.start = (project) ->
    exports.projectDetails = project

    karma = requireKarma()
    {major, minor} = parseVersion karma.VERSION
    if major > 0 || minor >= 13 # API changed in v0.13.0
        server = new karma.Server
            configFile: require.resolve './karma-conf'
        , -> console.log 'karma completed'
        server.start()
    else
        karma.server.start
            configFile: require.resolve '.karma-conf'

requireKarma = ->
    {allowUnsafeEval} = require 'loophole'
    allowUnsafeEval -> require exports.projectDetails.karma

parseVersion = (version) ->
    parts = version.split '.'

    major: parts[0]
    minor: parts[1]
    build: parts[2]
