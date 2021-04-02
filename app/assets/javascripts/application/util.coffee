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

  insertToTextArea: (areaId, text) ->
    txtarea = document.getElementById(areaId)
    if !txtarea
      return
    scrollPos = txtarea.scrollTop
    strPos = 0
    br = if txtarea.selectionStart or txtarea.selectionStart == '0' then 'ff' else if document.selection then 'ie' else false
    if br == 'ie'
      txtarea.focus()
      range = document.selection.createRange()
      range.moveStart 'character', -txtarea.value.length
      strPos = range.text.length
    else if br == 'ff'
      strPos = txtarea.selectionStart
    front = txtarea.value.substring(0, strPos)
    back = txtarea.value.substring(strPos, txtarea.value.length)
    txtarea.value = front + text + back
    strPos = strPos + text.length
    if br == 'ie'
      txtarea.focus()
      ieRange = document.selection.createRange()
      ieRange.moveStart 'character', -txtarea.value.length
      ieRange.moveStart 'character', strPos
      ieRange.moveEnd 'character', 0
      ieRange.select()
    else if br == 'ff'
      txtarea.selectionStart = strPos
      txtarea.selectionEnd = strPos
      txtarea.focus()
    txtarea.scrollTop = scrollPos
    return

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
