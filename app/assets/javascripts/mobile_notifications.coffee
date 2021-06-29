CW.Mobile_notificationsNew = do ->
  init = ->
    handleDisplay()
    onKeypressTitle()
    onKeypressBody()
    onClickToggleCollapse()

  onClickToggleCollapse = ->
    $(document).off 'click', ".toggle-trigger"
    $(document).on 'click', ".toggle-trigger", (event)->
      if $('.title').hasClass('text-truncate')
        $('.title').removeClass('text-truncate')
        $('.text-body').removeClass('text-truncate')
        $('.toggle-trigger i').removeClass('fa-chevron-down')
        $('.toggle-trigger i').addClass('fa-chevron-up')
      else
        $('.title').addClass('text-truncate')
        $('.text-body').addClass('text-truncate')
        $('.toggle-trigger i').removeClass('fa-chevron-up')
        $('.toggle-trigger i').addClass('fa-chevron-down')

  handleDisplay = ->
    title = $("[name='mobile_notification[title]']").val();
    body = $("[name='mobile_notification[body]']").val();
    $('.title').html(title || 'Title');
    $('.text-body').html(body || 'Body');

  onKeypressTitle = ->
    $(document).off 'keydown', "[name='mobile_notification[title]']"
    $(document).on 'keydown', "[name='mobile_notification[title]']", (event)->
      setTimeout ->
        $('.title').html(event.target.value)
        $('.title-count').html(event.target.value.length)
      , 150

  onKeypressBody = ->
    $(document).off 'keydown', "[name='mobile_notification[body]']"
    $(document).on 'keydown', "[name='mobile_notification[body]']", (event)->
      setTimeout ->
        $('.text-body').html(event.target.value)
        $('.body-count').html(event.target.value.length)
      , 150

  { init: init }

CW.Mobile_notificationsEdit = CW.Mobile_notificationsNew
CW.Mobile_notificationsUpdate = CW.Mobile_notificationsNew
CW.Mobile_notificationsCreate = CW.Mobile_notificationsNew
