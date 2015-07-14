fs = require 'fs'
path = require 'path'
dom = require './dom'

exports.projectDetails = (e) ->
    item = getSelected e
    project = projectPath item

    project: project
    karma: getKarmaModule project
    config: getKarmaConfig item, project

getKarmaConfig = (item, project) ->
    if item && path.basename(item) == 'karma.conf.js'
        return item

    getPath project, 'karma.conf.js'

getKarmaModule = (project) ->
    return unless project

    getPath project, 'node_modules', 'karma'

projectPath = (item) ->
    if !item
        return atom.project.getPaths()[0]

    atom.project.relativizePath(item)[0]

getSelected = (e) ->
    if e.detail
        return e.target.dataset.path

    selected = dom.$$ '.tree-view .selected'
    selected.getPath() if selected

getPath = (paths...) ->
    fullpath = path.join paths...
    fs.existsSync(fullpath) && fullpath
