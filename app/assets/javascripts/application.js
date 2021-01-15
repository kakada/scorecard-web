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

//= require application/namespace
//= require application/util
//= require common/topbar
//= require common/datetime_picker

//= require facilities
//= require templates
//= require indicators
//= require scorecards
//= require users/index
//= require users/new
//= require local_ngos
//= require scorecards_settings/rating
//= require scorecards_settings/contact

document.addEventListener('turbolinks:load', function() {
  CW.Common.Topbar.init();
  CW.Common.DatetimePicker.init();
  $('[data-toggle="tooltip"]').tooltip();

  let currentPage = CW.Util.getCurrentPage();
  !!CW[currentPage] && CW[currentPage].init();
})
