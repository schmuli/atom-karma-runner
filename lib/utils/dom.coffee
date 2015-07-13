root = exports || {}

root.tag = createTag
root.addTag = addTag
root.attributes = addAttributes
root.content = addContent
root.on = addEvents

tags = ['div', 'ul', 'li', 'i', 'p', 'span']
tags.forEach (tagName) ->
    addTag tagName

addTag = (tagName) ->
    root[tagName] = (attributes, content) ->
        createTag tagName, attributes, content

createTag = (tagName, attributes, content) ->
    if !content && Array.isArray(attributes)
        content = attributes
        attributes = null

    element = document.createElement tagName

    addAttributes element, attributes

    addContent element, content

    element

addAttributes = (element, attributes) ->
    return if !attributes

    if typeof attributes is 'string'
        attributes =
            'class': attributes

    keys = Object.keys attributes
    keys.forEach (key) ->
        element.setAttribute key, attributes[key]

    element

addContent = (element, content) ->
    return if !content

    content.forEach (item) ->
        if typeof item is 'string'
            item = document.createTextNode item

        element.appendChild item

    element

addEvents = (element, events) ->
    return if !events

    keys = Object.keys events
    keys.forEach (key) ->
        element.addEventListener key, events[key]

    element
