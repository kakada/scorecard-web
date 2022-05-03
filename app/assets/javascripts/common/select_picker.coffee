CW.Common.SelectPicker = do ->
  init = ->
    inSelectPicker()
    onChangeSelectPicker()
    onLoadedSelectPicker()

  inSelectPicker = ->
    $('.selectpicker').selectpicker()

  onChangeSelectPicker = ->
    $('.selectpicker').on 'changed.bs.select', (e, clickedIndex, isSelected, previousValue) ->
      setTooltip(e)

  onLoadedSelectPicker = ->
    $('.selectpicker').on 'loaded.bs.select', (e, clickedIndex, isSelected, previousValue) ->
      setTooltip(e)

  setTooltip = (e)->
    selectedOptions = $(e.target).parents('.tooltips').find('select :selected')
    title = selectedOptions.map((i, o) => $(o).html()).toArray().join(', ')
    parentElement = $(e.target).parents('.tooltips')

    if(!!parentElement)
      parentElement.attr('data-original-title', title)

  { init: init }
