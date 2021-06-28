CW.ProgramsNew = do ->
  init = ->
    assignShortName()
    onKeypressShortName()

  onKeypressShortName = ->
    $(document).off 'keydown', "[name='program[shortcut_name]']"
    $(document).on 'keydown', "[name='program[shortcut_name]']", (event)->
      assignShortName()

  assignShortName = ->
    setTimeout ->
      $('.short-name-count').html($("[name='program[shortcut_name]']").val().length)
    , 150

  { init: init }

CW.ProgramsEdit = CW.ProgramsNew
CW.ProgramsUpdate = CW.ProgramsNew
CW.ProgramsCreate = CW.ProgramsNew
