CW.Common.DatetimePicker = do ->
  init = ->
    format = (!!$('[data-date-format]') && $('[data-date-format]').data('dateFormat')) || 'YYYY-MM-DD'

    $('.datetimepicker').datetimepicker({format: format});

  { init: init }
