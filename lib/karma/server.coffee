path = require 'path'

exports.projectDetails = null

exports.start = (project) ->
    exports.projectDetails = project

    karma = getKarmaServer()
    karma.start
        configFile: require.resolve './karma-conf'
    , -> # Just so it doesn't use process.exit

getKarmaServer = ->
    karma = requireKarma()

    {major, minor} = parseVersion karma.VERSION
    if major > 0 || minor >= 13 # API changed in v0.13.0
        new karma.Server()
    karma.server

requireKarma = ->
    {allowUnsafeEval} = require 'loophole'
    allowUnsafeEval -> require exports.projectDetails.karma

parseVersion (version) ->
    parts = version.split '.'

    major: parts[0]
    minor: parts[1]
    build: parts[2]
