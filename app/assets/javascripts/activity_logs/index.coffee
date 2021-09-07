CW.Activity_logsIndex = do ->
  init = ->
    initDatepicker()

  initDatepicker = ->
    $("#start_date").datetimepicker({
      format: 'L'
    })
    $("#end_date").datetimepicker({
      format: 'L'
    })

  { init: init }