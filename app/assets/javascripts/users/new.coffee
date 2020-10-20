CW.UsersNew = do ->
  init = ->
    handleDisplayProgram()
    onChangeRole()

  handleDisplayProgram = ->
    if $('.role').val() != 'system_admin'
      $('.program').show()

  onChangeRole = ->
    $('.role').off('change')
    $('.role').on 'change', (event) ->
      if event.target.value == 'system_admin'
        $('.program').hide()
        $('.program select').val('')
      else
        $('.program').show()

      if event.target.value == 'staff' || event.target.value == 'guest'
        $('.province-code').show()
      else
        $('.province-code').hide()
        $('.province-code select').val('')

  { init: init }

CW.UsersCreate = CW.UsersNew
CW.UsersEdit = CW.UsersNew
CW.UsersUpdate = CW.UsersNew
