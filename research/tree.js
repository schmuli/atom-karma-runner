var util = require('util');
var dom = require('./dom');

var root;

module.exports = Tree;

function Tree() {
    this.element = root;
    this.browers = {};
}

Tree.attachTo = function (container) {
    root = container;
};

Tree.prototype.reset = function () {
    Object.keys(this.browsers)
        .forEach(function (browser) {
            this.browsers[browser].reset();
        }, this);
};

Tree.prototype.getBrowser = function (id) {
    return this.browsers[id] || null;
};

Tree.prototype.addBrowser = function (browserId, browserName, specs) {
    var existing = this.browsers[browser.id];
    if (!existing) {
        this.browsers[browser.id] = new Browser(browser.id, browser.name, specs, this);
    } else {
        existing.updateSpecs(specs);
    }
};

function TreeNode(specs, parent, type) {
    this.parent = parent;
    this.suites = {};
    this.specs = {};

    this._createElement(type);

    this.updateSpecs(specs);
}

TreeNode.prototype._createElement = function (type) {
    this.textElement = dom.span();
    this.element = dom.ul();

    var listItem = dom.li('closed', [
        dom.div([
            dom.i('icon-' + type),
            this.textElement
        ]),
        this.element
    ]);
    dom.on(listItem, {
        'click': function (e) {
            e.stopPropagation();

            var classes = e.currentTarget.classList;
            classes.toggle('closed');
        }
    });
    this.parent.element.appendChild(listItem);
};

TreeNode.prototype._updateText = function (text) {
    this.textElement.innerHTML = text;
}

TreeNode.prototype.updateSpecs = function (specs) {
    Object.keys(specs)
        .forEach(function (key) {
            if (key === '_') {
                this._updateSpecs(specs[key]);
            } else {
                this._updateSuite(key, specs[key]);
            }
        }, this);
};

TreeNode.prototype._updateSpecs = function (specs) {
    specs.forEach(function (spec) {
        var existing = this.specs[spec];
        if (!existing) {
            this.specs[spec] = new Spec(spec, this);
        }
    }, this);
};

TreeNode.prototype._updateSuite = function (suiteName, suite) {
    var existing = this.suites[suiteName];
    if (existing) {
        existing.updateSpecs(suite);
    } else {
        existing = new Suite(suiteName, suite, this);
    }
};

TreeNode.prototype.reset = function () {
    // body...
    this.resetStatus();

    Object.keys(this.suites)
        .concat(Object.keys(this.specs))
        .forEach(function (child) {
            child.reset();
        }, this);
};

TreeNode.prototype.resetStatus = function () {
    // body...
};

function Browser(id, name, specs, tree) {
    TreeNode.call(this, specs, tree, 'browser');

    this.id = id;
    this.name = name;

    this._updateText(name);
}
util.inherits(Browser, TreeNode);

function Suite(name, specs, parent) {
    TreeNode.call(this, specs, parent, 'suite');

    this.name = name;
    this._updateText(name);
}
util.inherits(Suite, TreeNode);

function Spec(name, parent) {
    this.name = name;
    this.parent = parent;
    this._createElement();
}

Spec.prototype._createElement = function () {
    this.element = dom.li([
        dom.i('icon-spec'),
        this.name
    ]);

    dom.on(this.element, {
        'click': function (e) {
            e.stopPropagation();

            e.currentTarget.classList.toggle('selected');
        }
    });

    this.parent.element.appendChild(this.element);
};

Spec.prototype.reset = function () {
    // Reset status
};
