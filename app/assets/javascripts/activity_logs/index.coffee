CW.Activity_logsIndex = do ->
  init = ->
    initDatepicker()
    onDatepickerApply()
    onDatepickerCancel()
    onReadMe()

  onReadMe = ->
    $(".readme").click (e) ->
      e.preventDefault()
      $content = $(this).prevAll('.content')
      $parent = $(this).parent()
      oldContent = $content.text()
      $content.text($parent.attr("data-content"))
      $parent.attr("data-content", oldContent)
      $parent.find(".readme").toggle()

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