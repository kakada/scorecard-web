CW.Common.Timeago = do ->
  init = ->
    onClickDate();

  onClickDate = ->
    $(document).off('click', '.date')
    $(document).on 'click', '.date', (event)->
      $(this).html($(this).data('date'))
      $(this).off 'click'

  { init: init }
