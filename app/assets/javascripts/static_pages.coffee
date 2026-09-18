CW.Static_pagesNew = do ->
  init = ->
    bindPreview()
    bindLanguageTabs()
    bindVariableTokens()
    bindSlugPreview()
    requestPreview(activeEditorValue())

  bindSlugPreview = ->
    updateSlugPreview($("#static_page_slug").val())

    $(document).off "input", "#static_page_slug"
    $(document).on "input", "#static_page_slug", ->
      updateSlugPreview($(this).val())

  updateSlugPreview = (value) ->
    slug = (value || "").replace(/^\/+/, "")
    $("#static-page-url-preview").text("/" + slug)

  bindPreview = ->
    $(document).off "input", ".static-page-editor"
    $(document).on "input", ".static-page-editor", ->
      return unless $(this).is(":visible")

      queuePreview($(this).val())

  bindLanguageTabs = ->
    $(document).off "shown.bs.tab", "[data-preview-source]"
    $(document).on "shown.bs.tab", "[data-preview-source]", ->
      requestPreview(activeEditorValue())

  bindVariableTokens = ->
    $(document).off "click", ".static-page-variable-token"
    $(document).on "click", ".static-page-variable-token", (e) ->
      editor = activeEditor()
      token = $(this).data("token")
      return unless editor? && token?

      CW.Util.insertToTextArea(editor.id, token)
      requestPreview($(editor).val())
      e.preventDefault()

  activeEditorValue = ->
    $(activeEditor()).val() || ""

  activeEditor = ->
    $(".tab-pane.active .static-page-editor")[0]

  queuePreview = (content) ->
    clearTimeout(window.staticPagePreviewTimer)
    window.staticPagePreviewTimer = setTimeout((-> requestPreview(content)), 250)

  requestPreview = (content) ->
    previewArea = $("[data-static-page-preview]")
    previewUrl = previewArea.data("preview-url")
    return renderPreview(content) unless previewUrl?

    $.ajax
      url: previewUrl
      type: "POST"
      data:
        content: content || ""
      headers:
        "X-CSRF-Token": $('meta[name="csrf-token"]').attr("content")
      success: (html) ->
        renderPreview(html)

  renderPreview = (content) ->
    $("[data-static-page-preview]").html(content || "")

  { init: init }

CW.Static_pagesCreate = CW.Static_pagesNew
CW.Static_pagesEdit = CW.Static_pagesNew
CW.Static_pagesUpdate = CW.Static_pagesNew
