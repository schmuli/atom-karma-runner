var util = require('util');
var fs = require('fs');

var Tree = require('./tree');

module.exports = {
    'reporter:test': ['type', TestReporter]
};

function LogManager() {
    this.log = [];
}

LogManager.prototype.append = function (log) {
    this.log.push(log);
}

LogManager.prototype.toString = function () {
    return this.log.join('\r');
};

function TestReporter(helper) {
    var log;
    var tree;

    this.onRunStart = function (browsers) {
        // FIRST: Create tree
        // REST:  Clear test count, Clear status from each node
        if (!tree) {
            tree = new Tree();
        } else {
            tree.reset();
        }
    };

    this.onBrowserStart = function (browser, info) {
        // FIRST: Add browser (browser.id, browser.name) with initial hierarchy (info.specs), increment test count (info.total)
        // REST:  Update test count (info.total), Update hierarchy (info.specs)

        tree.incrementTests(info.total);

        var b = tree.getBrowser(browser.id);
        if (b) {
            b.updateSpecs(info.specs);
        } else {
            tree.addBrowser(browser.id, browser.name, info.specs);
        }
    };

    this.onBrowserLog = function (browser, log, type) {
        // Accumulate log, until next spec_complete for browser
        if (!log) {
            log = new LogManager();
        }

        log.append(log);
    };

    this.onSpecComplete = function (browser, specResult) {
        // Update spec (specResult.suite + specResult.description) with result status (specresult) and accumulated log
        // Update completed tests (browser.lastResult.success + browser.lastResult.failed + browser.lastResult.skipped)

        var accumulatedLog = '';
        if (log) {
            accumulatedLog = log.toString();
            log = null;
        }

        tree.getBrowser(browserId)
            .updateStatus(specResults, accumulatedLog);
        tree.updateCompleted(browser.lastResult);
    };

    this.onRunComplete = function (browsers) {
        // Clean up
        if (log) {
            // TODO: Log without spec
            log = null;
        }
    };

    function decorate(self) {
        var log = '';

        Object.keys(self)
            .filter(function (key) {
                return helper.isFunction(self[key]);
            })
            .forEach(function (method) {
                var original = self[method];
                self[method] = function () {
                    log += method + ' METHOD: ' + util.inspect(arguments, {
                        depth: null
                    });
                    log += '\r\n';
                    original.apply(self, arguments);
                    if (method === 'onRunComplete') {
                        fs.writeFile('log.txt', log, 'utf-8');
                    }
                };
            });
    }

    decorate(this);
}
TestReporter.$inject = ['helper'];

// var tree = (function () {
//     var nextId = 1;
//
//     function Node(id, name) {
//         this.id = id;
//         this.name = name;
//     }
//
//     function SuiteNode(id, name) {
//         Node.call(this, id, name);
//
//         this.children = [];
//         this.lookupMap = Object.create(null);
//     }
//
//     util.inherits(SuiteNode, Node);
//
//     SuiteNode.prototype.hasChild = function (id) {
//         return !!this.lookupMap[id];
//     }
//
//     SuiteNode.prototype.addChild = function (id, name, type) {};
//
//     function SpecNode(id) {
//         Node.call(this, id);
//     }
//
//     util.inherits(SpecNode, Node);
//
//     SpecNode.prototype.setStatus = function (status, duration, message) {
//         this.status = status;
//         this.duration = duration;
//         this.message = message;
//     };
//
//     return function () {
//         return new SuiteNode('root');
//     }
// }());
