CW.Common.Timeago = do ->
  init = ->
    onClickDate();

  onClickDate = ->
    $(document).off('click', '.timeago')
    $(document).on 'click', '.timeago', (event)->
      $(this).html($(this).data('date'))
      $(this).off 'click'

  { init: init }
