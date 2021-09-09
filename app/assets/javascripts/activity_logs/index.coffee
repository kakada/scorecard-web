CW.Activity_logsIndex = do ->
  init = ->
    initReadMe()
    initDatepicker()
    onDatepickerApply()
    onDatepickerCancel()

  initDatepicker = ->
    $(".daterange").daterangepicker {
      opens: "left",
      autoUpdateInput: false,
      autoApply: false,
    }, (startDate, endDate) ->
      setStartDate startDate.format("L")
      setEndDate endDate.format("L")

  onDatepickerApply = ->
    $(".daterange").on "apply.daterangepicker", (ev, picker) ->
      $(this).val picker.startDate.format("L") + " - " + picker.endDate.format("L")

  onDatepickerCancel = ->
    $(".daterange").on "cancel.daterangepicker", (ev, picker) ->
      $(this).val ""
      setStartDate ""
      setEndDate ""

  setStartDate  = (startDate) -> $("#q_start_date").val startDate
  setEndDate    = (endDate)   -> $("#q_end_date").val endDate

  initReadMe = ->
    $(".readme").click (e) ->
      e.preventDefault()
      $content = $(this).prevAll(".content")
      $parent = $(this).parent()
      oldContent = $content.text()
      $content.text $parent.attr("data-content")
      $parent.attr "data-content", oldContent
      $parent.find(".readme").toggle()

  { init: init }