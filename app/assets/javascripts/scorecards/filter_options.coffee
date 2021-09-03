CW.FilterOptions = do ->
  init = ->
    onOpenFilter();
    onFilterChange();
    onSaveFilter();
    onCancelFilter();
    onDeleteFilterItem();
    onBackdropClick();

  getAddedItems = ->
    return $(".add-filter__saved_items_container").children(".add-filter__item")

  onOpenFilter = ->
    $("#add-filter__link").click (e)->
      e.preventDefault()
      $("<div class=\"filter-backdrop\"></div>").appendTo("body")
      $("#add-filter__modal").fadeToggle()

  onBackdropClick = ->
    $("body").on "click", ".filter-backdrop", ->
      resetFilter()

  onSaveFilter = ->
    $(".add-filter__save").click (e)->
      e.preventDefault()
      if isValid()
        appendFilterItem()
        resetFilter()
        formSubmit()

  isValid = ->
    return dataItem().value not in ["", null, undefined]

  formSubmit = ->
    Rails.fire($("#form")[0], "submit")

  appendFilterItem = ->
    container = $(".add-filter__saved_items_container")
    appendable = true
    if getAddedItems().length > 0
      $.each getAddedItems(), (_, item)->
        if $(item).data("field") == newItem().data("field")
          mergeFilterValue(item)
          appendable = false
    if appendable
      container.append newItem()

  mergeFilterValue = (item)->
    existing = $(item).find(".display-value").text()
    if !existing.match(///#{newDisplayText()}///)
      $(item).find(".display-value").append(comma(), space(), newDisplayText())
      $(item).append(newHiddenInput())

  newHiddenInput = ->
    return newItem().find("input[type=\"hidden\"]")

  newDisplayText = ->
    return newItem().find(".display-value").text()

  resetDate = ->
    $(".start_date, .start-date-input-backup").val ""

  resetFilter = ->
    $(".field-value").val ""
    $("#add-filter__field").val ""
    $("#add-filter__field").trigger "change"
    $("#add-filter__modal").hide()
    $(".filter-backdrop").remove()

  onDeleteFilterItem = ->
    $(document).on "click", ".add-filter__delete_item", (e)->
      e.preventDefault()
      resetDate()
      resetFilter()
      $(this).closest(".add-filter__item").remove()
      formSubmit()

  onCancelFilter = ->
    $(".add-filter__cancel").click (e)->
      e.preventDefault()
      resetFilter()

  onFilterChange = ->
    $("#add-filter__field").change ->
      field = $(this).val()
      $(".btn-reset").trigger "click"
      $("#add-filter__modal .form-group:not(#add-filter__field)[data-field_attribute]").hide()
      $("[data-field_attribute=\"#{field}\"").show()

  newItem = ->
    $item = getStyledItem()
    $data = dataItem()
    $item.append displayItem()
    $item.append hiddenInput($data.field, $data.value)
    $item.append space()
    $item.append delBtn()
    return $item
  
  displayItem = ->
    $span = $("<span class=\"display-item\"></span>")
    $span.append displayField()
    $span.append separator()
    $span.append space()
    $span.append displayValue()
    return $span

  separator = -> ":"
  space = -> "&nbsp;"
  comma = -> ","

  displayField = ->
    return "<span class=\"display-field\">#{dataItem().displayField}</span>"

  displayValue = ->
    return "<span class=\"display-value\">#{dataItem().displayValue}</span>"

  dataItem = ->
    _displayValue = getFilterValue()
    if selectedDom().is("select")
      _displayValue = selectedDom().find("option:selected").text()
    return { field: getFilterField(), value: getFilterValue(), displayField: getDisplayField(), displayValue: _displayValue }

  selectedDom = ->
    return getDataField().find(".#{getDom()}")

  getDisplayField = ->
    return getDataField().data("display_field")

  getFilterValue = ->
    return selectedDom().val()

  getFilterField = ->
    return $("#add-filter__field").val()

  getDom = ->
    return getDataField().data("dom")

  getDataField = ->
    return $("[data-field_attribute=\"#{getFilterField()}\"]")

  hiddenInput = (field, value)->
    $input = $("<input type=\"hidden\" />")
    $input.attr
      name: "#{field}[]"
      value: value
    return $input

  delBtn = ->
    delSign = "<i class=\"fa fa-times text-danger\"></i>"
    $delBtn = $("<a href=\"#\" class=\"add-filter__delete_item\"></span>")
    $delBtn.append delSign
    return $delBtn

  getStyledItem = ->
    templateHtml = $(".add-filter__saved_item_template").html()
    template = $(templateHtml)
    template.addClass "badge badge-pill badge-light border"
    template.attr("data-field", getFilterField())
    return template

  { init: init }
