//= require rails-ujs
//= require activestorage
//= require turbolinks

//= require jquery3
//= require popper
//= require bootstrap

//= require sb-admin-2

// *** Datetime picker
//= require moment
//= require tempusdominus-bootstrap-4.js
//= require pumi
//= require tagify.min
//= require jquery-sortable
//= require typeahead
//= require bloodhound.min
//= require jquery.richtext

//= require application/namespace
//= require application/util
//= require common/topbar
//= require common/datetime_picker
//= require common/timeago

//= require facilities
//= require templates
//= require indicators
//= require scorecards/datepicker_popup
//= require scorecards/index
//= require scorecards/show
//= require scorecards/new
//= require users/index
//= require users/new
//= require local_ngos
//= require scorecards_settings/rating
//= require scorecards_settings/contact
//= require pdf_templates
//= require program_settings/show
//= require telegram_bots/show
//= require messages

document.addEventListener('turbolinks:load', function() {
  CW.Common.Topbar.init();
  CW.Common.DatetimePicker.init();
  CW.Common.Timeago.init();
  $('[data-toggle="tooltip"]').tooltip();

  let currentPage = CW.Util.getCurrentPage();
  !!CW[currentPage] && CW[currentPage].init();
})
