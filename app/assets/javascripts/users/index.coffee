CW.UsersIndex = do ->
  init = ->
    onClickBtnCopyConfirmLink()
    onClickDate()

  onClickBtnCopyConfirmLink = ->
    $(document).off('click', '.btn-copy')
    $(document).on 'click', '.btn-copy', (event)->
      input = $(this).prev('input.confirm-link')
      input.select()
      document.execCommand("copy")

      event.preventDefault()
      $('.toast').toast('show')

  onClickDate = ->
    $(document).off('click', '.date')
    $(document).on 'click', '.date', (event)->
      $(this).html($(this).data('date'))
      $(this).off 'click'

  { init: init }
