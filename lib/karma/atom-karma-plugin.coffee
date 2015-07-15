AtomKarmaReporter = require './atom-karma-reporter'

extensions = {}
extensions["reporter:#{ AtomKarmaReporter.name }"] = ['type', AtomKarmaReporter]

module.exports = extensions
