CW.Activity_logsIndex = do ->
  init = ->
    initDatepicker()
    onDatepickerApply()
    onDatepickerCancel()

  initDatepicker = ->
    $(".daterange").daterangepicker {
      opens: "left",
      autoUpdateInput: false,
      autoApply: false,
    }, (s, e, l) ->
      setStartDate s.format("L")
      setEndDate e.format("L")
      return

  onDatepickerApply = ->
    $(".daterange").on "apply.daterangepicker", (ev, picker) ->
      $(this).val picker.startDate.format("L") + " - " + picker.endDate.format("L")
      return

  onDatepickerCancel = ->
    $(".daterange").on "cancel.daterangepicker", (ev, picker) ->
      $(this).val ""
      setStartDate ""
      setEndDate ""
      return

  setStartDate = (startDate)->
    $("#q_start_date").val startDate

  setEndDate = (endDate)->
    $("#q_end_date").val endDate

  { init: init }