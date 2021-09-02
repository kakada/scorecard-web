CW.FilterOptions = do ->
  init = ->
    onOpenFilter();
    onFilterChange();
    onSaveFilter();
    onCancelFilter();
    onDeleteFilterItem();

  onOpenFilter = ->
    $("#add-filter__link").click (e)->
      e.preventDefault()
      $("#add-filter__modal").fadeToggle()

  onSaveFilter = ->
    $('.add-filter__save').click (e)->
      e.preventDefault()
      if isValid()
        appendFilterItem()
        resetFilter()
        formSubmit()

  isValid = ->
    return dataItem().value != ""

  formSubmit = ->
    Rails.fire($("#form")[0], "submit")

  appendFilterItem = ->
    container = $('.add-filter__saved_items_container')
    container.append newItem()

  resetDate = ->
    $('.start_date, .start-date-input-backup').val ''

  resetFilter = ->
    $('.field-value').val ''
    $('#add-filter__field').val ''
    $('#add-filter__field').trigger 'change'
    $('#add-filter__modal').hide()

  onDeleteFilterItem = ->
    $(document).on 'click', '.add-filter__delete_item', (e)->
      e.preventDefault()
      resetDate()
      resetFilter()
      $(this).closest('.add-filter__item').remove()
      formSubmit()

  onCancelFilter = ->
    $('.add-filter__cancel').click (e)->
      e.preventDefault()
      $('#add-filter__modal').hide()

  onFilterChange = ->
    $('#add-filter__field').change ->
      field = $(this).val()
      $('#add-filter__modal .form-group:not(#add-filter__field)[data-field_attribute]').hide()
      $("[data-field_attribute='#{field}'").show()

  newItem = ->
    $item = getStyledItem()
    $data = dataItem()
    $item.append "#{$data.field}: #{$data.displayText} "
    $item.append hiddenInput($data.field, $data.value)
    $item.append delBtn()
    return $item

  dataItem = ->
    displayText = getFilterValue()
    if getFilterField() == 'province_id'
      displayText = getDataField().find(".#{getDom()} option:selected").text()
    return { field: getFilterField(), value: getFilterValue(), displayText: displayText }

  getFilterValue = ->
    return getDataField().find(".#{getDom()}").val()

  getFilterField = ->
    return $('#add-filter__field').val()

  getDom = ->
    return getDataField().data('dom')

  getDataField = ->
    return $("[data-field_attribute='#{getFilterField()}']")

  hiddenInput = (field, value)->
    $input = $('<input type="hidden" />')
    $input.attr
      name: "#{field}[]"
      value: value
    return $input

  delBtn = ->
    delSign = '<i class="fa fa-times"></i>'
    $delBtn = $('<a href="#" class="add-filter__delete_item"></span>')
    $delBtn.append delSign
    return $delBtn

  getStyledItem = ->
    templateHtml = $('.add-filter__saved_item_template').html()
    template = $(templateHtml)
    template.addClass 'badge badge-dark'
    return template

  { init: init }
