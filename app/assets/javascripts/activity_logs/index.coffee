CW.Activity_logsIndex = do ->
  init = ->
    initReadMe()
    initDatepicker()
    onDatepickerApply()
    onDatepickerCancel()
    onClearQuery()

  initDatepicker = ->
    $(".daterange").daterangepicker {
      opens: "left",
      autoUpdateInput: false,
      autoApply: false,
      alwaysShowCalendars: true,
      showCustomRangeLabel: true,
      ranges: {
        'Today': [moment(), moment()],
        'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
        'Last 7 Days': [moment().subtract(6, 'days'), moment()],
        'Last 30 Days': [moment().subtract(29, 'days'), moment()],
        'This Month': [moment().startOf('month'), moment().endOf('month')],
        'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
      }
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

  onClearQuery = ->
    $(".ico-clear").click ->
      $("#q_query").val("").focus()

  { init: init }