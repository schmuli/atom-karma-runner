exports.tag = createTag;
exports.addTag = addTag;
exports.attributes = addAttributes;
exports.content = addContent;
exports.on = addEvents;

var tags = ['div', 'ul', 'li', 'span', 'p'];
tags.foreach(function (tag) {
    addTag(tag);
});

function addTag(tagName) {
    exports[tagName] = function (attributes, content) {
        return createTag(tagName, attributes, content);
    }
}

function createTag(tagName, attributes, content) {
    if (!content && Array.isArray(attributes)) {
        content = attributes;
        attributes = {};
    }

    var element = document.createElement(tagName);
    addAttributes(element, attributes);
    addContent(element, content);
    return element;
}

function addAttributes(element, attributes) {
    if (typeof attributes === 'string') {
        attributes = {
            class: attributes
        }
    }
    Object.keys(attributes)
        .forEach(function (attribute) {
            element.setAttribute(attribute, attributes[attribute]);
        });
}

function addContent(element, content) {
    if (!content) {
        return;
    }

    content.forEach(function (elm) {
        if (typeof elm === 'string') {
            elm = document.createTextNode(elm);
        }

        element.appendChild(elm);
    });
}

function addEvents(elements, events) {
    Object.keys(events)
        .forEach(function (event) {
            element.addEventListener(event, events[event]);
        });
}
