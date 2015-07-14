root = exports || {}

tags = ['div', 'ul', 'li', 'i', 'p', 'span']

root.addTag = addTag = (tagName) ->
    root[tagName] = (attributes, content) ->
        createTag tagName, attributes, content

tags.forEach (tagName) ->
    addTag tagName

root.tag = createTag = (tagName, attributes, content) ->
    if !content && Array.isArray(attributes)
        content = attributes
        attributes = null

    element = document.createElement tagName
    addAttributes element, attributes
    addContent element, content
    element

root.attributes = addAttributes = (element, attributes) ->
    return unless attributes

    if typeof attributes is 'string'
        attributes =
            'class': attributes

    keys = Object.keys attributes
    keys.forEach (key) ->
        element.setAttribute key, attributes[key]

    element

root.content = addContent = (element, content) ->
    return unless content

    content.forEach (item) ->
        if typeof item is 'string'
            item = document.createTextNode item

        element.appendChild item

    element

root.events = addEvents = (element, events) ->
    return unless events

    keys = Object.keys events
    keys.forEach (key) ->
        element.addEventListener key, events[key]

    element

root.$ = (selector, context = document) ->
    context.querySelectorAll(selector)

root.$$ = (selector, context = document) ->
    context.querySelector(selector)
