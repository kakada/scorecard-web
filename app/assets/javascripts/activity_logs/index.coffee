CW.Activity_logsIndex = do ->
  init = ->
    initDatepicker()

  initDatepicker = ->
    $(".dateinput").datetimepicker({
      format: 'L'
    })

  { init: init }