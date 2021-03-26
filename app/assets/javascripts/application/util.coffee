CW.Util =
  capitalize: (value) ->
    value.replace /(^|\s)([a-z])/g, (m, p1, p2) ->
      p1 + p2.toUpperCase()

  getCurrentPage: ->
    return "" if(!$("body").attr("id"))
    bodyId = $("body").attr("id").split("-")
    action = @capitalize(bodyId.pop())
    controller = bodyId
    i = 0
    while i < controller.length
      controller[i] = @capitalize(controller[i])
      i++
    pageName = controller.join("") + action

    return pageName

  insertToTextbox: (dom, text) ->
    containerEl = dom
    editorID = containerEl.id
    savedSel = window.savedSelection

    if (!savedSel)
      savedSel = {
        'start': 0,
        'end': 0,
        'type': 'caret',
        'editorID': editorID,
        'anchor': $('#' + editorID).children('div')[0]
      }

    if window.getSelection and document.createRange
      charIndex = 0
      range = document.createRange()

      if !range or !containerEl
        window.getSelection().removeAllRanges()
        return true;

      range.setStart containerEl, 0
      range.collapse true
      nodeStack = [ containerEl ]
      node = undefined
      foundStart = false
      stop = false

      while !stop and (node = nodeStack.pop())
        if node.nodeType == 3
          nextCharIndex = charIndex + node.length
          if !foundStart and savedSel.start >= charIndex and savedSel.start <= nextCharIndex
            range.setStart node, savedSel.start - charIndex
            foundStart = true
          if foundStart and savedSel.end >= charIndex and savedSel.end <= nextCharIndex
            range.setEnd node, savedSel.end - charIndex
            stop = true
          charIndex = nextCharIndex
        else
          i = node.childNodes.length
          while i--
            nodeStack.push node.childNodes[i]

      range.insertNode document.createTextNode(text)

      sel = window.getSelection()
      sel.removeAllRanges()
      sel.addRange range
