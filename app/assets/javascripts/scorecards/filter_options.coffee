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
      container = $('.add-filter__saved_items_container')
      container.append buildTemplate()
      resetFilter()

  resetFilter = ->
    $('.field-value').val ''
    $('#add-filter__field').val ''
    $('#add-filter__field').trigger 'change'
    $('#add-filter__modal').hide()

  onDeleteFilterItem = ->
    $(document).on 'click', '.add-filter__delete_item', (e)->
      e.preventDefault()
      $(this).closest('.add-filter__item').remove()
      return
    return

  onCancelFilter = ->
    $('.add-filter__cancel').click (e)->
      e.preventDefault()
      $('#add-filter__modal').hide()
      return
    return

  onFilterChange = ->
    $('#add-filter__field').change ->
      field = $(this).val()
      $('#add-filter__modal .form-group:not(#add-filter__field)[data-field_attribute]').hide()
      $("[data-field_attribute='#{field}'").show()
      return
    return

  buildTemplate = ->
    $template = formatTemplate()
    $view     = buildView()
    $delBtn   = buildDelButton()
    $input    = buildValue($view.field, $view.value)
    display   = "#{$view.field}: #{$view.displayText} "

    $template.append display
    $template.append $input
    $template.append $delBtn
    return $template

  buildView = ->
    field = $('#add-filter__field').val()
    $dataField = $("[data-field_attribute='#{field}']")
    fieldValue = $dataField.data('field_value')
    value = $dataField.find(".#{fieldValue}").val()
    displayText = value
    if field == 'province_id'
      displayText = $dataField.find(".#{fieldValue} option:selected").text()
    return { field: field, value: value, displayText: displayText }

  buildValue = (field, value)->
    $input = $('<input type="hidden" />')
    $input.attr
      name: "#{field}[]"
      value: value
    return $input

  buildDelButton = ->
    delSign = '<i class="fa fa-times"></i>'
    $delBtn = $('<a href="#" class="add-filter__delete_item"></span>')
    $delBtn.append delSign
    return $delBtn

  formatTemplate = ->
    templateHtml = $('.add-filter__saved_item_template').html()
    template = $(templateHtml)
    template.css border: '1px solid #ccc'

    return template

  { init: init }
