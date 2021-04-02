CW.TelegramBotsShow = do ->
  init = ->
    handleDisplayToggle()
    onChangeTelegramToggle()

  onChangeTelegramToggle = ->
    $(document).off 'change', "[name='program[telegram_bot_attributes][enabled]']"
    $(document).on 'change', "[name='program[telegram_bot_attributes][enabled]']", (event)->
      handleDisplayToggle()

  handleDisplayToggle = ->
    isChecked = !!$("[name='program[telegram_bot_attributes][enabled]']:checked").length
    $('.tokens').toggle(isChecked)

  { init: init }
