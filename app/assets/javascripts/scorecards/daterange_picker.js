CW.DaterangPicker = (() => {
  function init() {
    handleDisplayDate();
    initDateRangePicker();

    onApplyDateRange();
    onCancelDateRange();
  }

  function handleDisplayDate() {
    let start = $('.start-date').val();
    let end = $('.end-date').val();

    if (!!start && !!end) {
      displayDate(moment(start), moment(end));
    }
  }

  function initDateRangePicker() {
    let options = {
      ranges: {
         'Today': [moment(), moment()],
         'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
         'Last 7 Days': [moment().subtract(6, 'days'), moment()],
         'Last 30 Days': [moment().subtract(29, 'days'), moment()],
         'This Month': [moment().startOf('month'), moment().endOf('month')],
         'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
      },
      locale: {
        cancelLabel: 'Clear'
      },
      alwaysShowCalendars: true
    }

    let start = $('.start-date').val();
    let end = $('.end-date').val();

    if (!!start && !!end) {
      options.startDate = moment(start);
      options.endDate = moment(end);
    }

    $('#reportrange').daterangepicker(options, displayDate);
  }

  function onApplyDateRange() {
    $('#reportrange').on('apply.daterangepicker', function(ev, picker) {
      displayDate(picker.startDate, picker.endDate);

      $('.start-date').val(picker.startDate.format('YYYY-MM-DD'));
      $('.end-date').val(picker.endDate.format('YYYY-MM-DD'));
    });
  }

  function onCancelDateRange() {
    $('#reportrange').on('cancel.daterangepicker', function(ev, picker) {
      displayDate('', '');

      $('.start-date').val('');
      $('.end-date').val('');
    });
  }

  function displayDate(start, end) {
    let display = $('#reportrange span').data('placeholder');

    if (!!start && !!end) {
      display = start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY');
    }

    $('#reportrange span').html(display);
  }

  return {
    init
  }
})();
