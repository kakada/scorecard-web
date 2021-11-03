CW.Common.Sidebar = do ->
  init = ->
    handleToggleSidebar();
    onClickSidebarToggle();

  handleToggleSidebar = ->
    if localStorage.getItem('maxiSidebar') != 'true'
      $('#accordionSidebar').addClass('toggled')
      $('body').addClass 'sidebar-toggled'

  onClickSidebarToggle = ->
    $('#sidebarToggle').on 'click', ->
      localStorage.setItem('maxiSidebar', !$('#accordionSidebar').hasClass('toggled'));

  { init: init }
