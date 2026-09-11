CW.Static_pagesNew = do ->
  init = ->
    bindPreview()
    bindLanguageTabs()
    renderPreview(activeEditorValue())

  bindPreview = ->
    $(document).off "input", ".static-page-editor"
    $(document).on "input", ".static-page-editor", ->
      return unless $(this).is(":visible")

      renderPreview($(this).val())

  bindLanguageTabs = ->
    $(document).off "shown.bs.tab", "[data-preview-source]"
    $(document).on "shown.bs.tab", "[data-preview-source]", ->
      renderPreview(activeEditorValue())

  activeEditorValue = ->
    $(".tab-pane.active .static-page-editor").val() || ""

  renderPreview = (content) ->
    $("[data-static-page-preview]").html(content || "")

  { init: init }

CW.Static_pagesCreate = CW.Static_pagesNew
CW.Static_pagesEdit = CW.Static_pagesNew
CW.Static_pagesUpdate = CW.Static_pagesNew
