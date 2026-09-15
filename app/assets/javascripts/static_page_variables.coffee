CW.StaticPageVariablesForm = do ->
  init = ->
    toggleFields()
    bindVariableType()

  bindVariableType = ->
    $(document).off "change", "#static_page_variable_variable_type"
    $(document).on "change", "#static_page_variable_variable_type", ->
      toggleFields()

  toggleFields = ->
    variableType = $("#static_page_variable_variable_type").val()
    textField = $(".js-static-page-variable-text-field")
    imageField = $(".js-static-page-variable-image-field")
    isImage = variableType == "image"

    textField.toggle(!isImage)
    textField.find("input, textarea").prop("disabled", isImage)
    imageField.toggle(isImage)
    imageField.find("input").prop("disabled", !isImage)

  { init: init }

CW.Static_page_variablesNew = CW.StaticPageVariablesForm
CW.Static_page_variablesCreate = CW.StaticPageVariablesForm
CW.Static_page_variablesEdit = CW.StaticPageVariablesForm
CW.Static_page_variablesUpdate = CW.StaticPageVariablesForm
