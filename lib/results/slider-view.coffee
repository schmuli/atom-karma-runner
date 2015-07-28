dom = require '../utils/dom'

MINIMUM_WIDTH = 100;

class SliderView
    constructor: (@parent) ->
        @_createElement()

    _update: (e) ->
        x = coerce(e.x);
        @target.style.flex = 'none';
        @target.style.width = x + 'px';

    _mouseUp: (e) ->
        @_update e
        @disposables.mousemove()
        @disposables.mouseup()

    _mouseDown: (e) ->
        @disposables = dom.events document,
            mousemove: (e) => @update e,
            mouseup: (e) => @mouseUp e

    _coerce: (x) ->
        return MINIMUM_WIDTH if x < MINIMUM_WIDTH

        parentWidth = target.parentElement.clientWidth;
        maximumWidth = parentWidth - MINIMUM_WIDTH
        return actualWidth if x > maximumWidth

        x;

    _createElement: ->
        @element = dom.div [
            dom.div()
            dom.div()
            dom.div()
        ]

        dom.events @element,
            mousedown: (e) => @mouseDown e

        @parent.slider.appendChild @element
        @target = @parent.treePane

module.exports = SliderView
