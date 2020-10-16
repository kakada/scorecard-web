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

//= require application/namespace
//= require application/util

//= require categories
//= require indicators

document.addEventListener('turbolinks:load', function() {
  $('.datetimepicker').datetimepicker({format: 'YYYY-MM-DD'});

  let currentPage = CW.Util.getCurrentPage();
  !!CW[currentPage] && CW[currentPage].init();
})
