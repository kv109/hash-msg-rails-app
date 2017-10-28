class @TextSelector
  constructor: ->
    @bindEvents()

  bindEvents: ->
    @getElements().on('click', @select)

  getElements: -> $('[data-selectable]')

  select: (event) ->
    htmlElement = event.currentTarget
    if document.selection
      range = document.body.createTextRange()
      range.moveToElementText(htmlElement)
      range.select()
    else if window.getSelection
      range = document.createRange()
      range.selectNode(htmlElement)
      window.getSelection().removeAllRanges()
      window.getSelection().addRange range

$ ->
  new TextSelector()
