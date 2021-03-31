CW.MessagesIndex = do ->
  init = ->
    onChangeToggleActived()
    initTruncate()

  onChangeToggleActived = ->
    $("[name='message[actived]']").on 'change', (e)->
      $(this).parents('form').submit()

  initTruncate = ->
    $('.fv-body-wrapper').each (index, dom)->
      if dom.scrollHeight > 54
        $(dom).parents('.value').addClass('overflow-content')

    onClickBtnTruncate()

  onClickBtnTruncate = ->
    $('.btn-truncate').on 'click', ->
      $(this).parents('.value').toggleClass('detail-on')

  { init: init }
