//= require rails-ujs
//= require activestorage
//= require turbolinks

//= require jquery3
//= require popper
//= require bootstrap

//= require sb-admin-2

//= require pumi

//= require application/namespace
//= require application/util

//= require categories

document.addEventListener('turbolinks:load', function() {
  let currentPage = CW.Util.getCurrentPage();
  !!CW[currentPage] && CW[currentPage].init();
})
