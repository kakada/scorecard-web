//= require rails-ujs
//= require activestorage
//= require turbolinks

//= require jquery3
//= require popper
//= require bootstrap
//= require bootstrap-select

//= require sb-admin-2

// *** Datetime picker
//= require moment
//= require moment-with-locales
//= require tempusdominus-bootstrap-4.js
//= require pumi
//= require tagify.min
//= require jquery-sortable
//= require typeahead
//= require bloodhound.min
//= require jquery.richtext
//= require daterangepicker
//= require best_in_place

//= require application/namespace
//= require application/util
//= require common/topbar
//= require common/sidebar
//= require common/datetime_picker
//= require common/timeago
//= require common/select_picker
//= require common/import_file

//= require facilities
//= require templates
//= require indicators
//= require scorecards/locale
//= require scorecards/daterange_picker
//= require scorecards/index
//= require scorecards/show
//= require scorecards/new
//= require scorecards/indicator
//= require scorecards/swot
//= require users/index
//= require users/new
//= require local_ngos/new
//= require scorecards_settings/rating
//= require scorecards_settings/contact
//= require pdf_templates
//= require program_settings/show
//= require program_settings/dashboard_accessibility
//= require program_settings/data_publication
//= require telegram_bots/show
//= require messages/index
//= require messages/new
//= require programs/new
//= require mobile_notifications
//= require activity_logs
//= require request_changes/new

document.addEventListener("turbolinks:load", function () {
  CW.Common.Topbar.init();
  CW.Common.Sidebar.init();
  CW.Common.DatetimePicker.init();
  CW.Common.Timeago.init();
  CW.Common.SelectPicker.init();
  CW.Common.ImportFile.init();

  $("[role='tooltip']").remove();
  $('[data-toggle="tooltip"]').tooltip({ trigger: "hover" });
  $('[data-toggle="popover"]').popover();

  let currentPage = CW.Util.getCurrentPage();
  !!CW[currentPage] && CW[currentPage].init();
});
