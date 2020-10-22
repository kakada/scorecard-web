CW.Sidebar = do ->
  init = ->
    switchLanguage()

  switchLanguage = ->
    $('#switch-language').on 'ajax:success', ->
      window.location.reload()

  { init: init }
