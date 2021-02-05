CW.UsersNew = do ->
  init = ->
    initDisplayProgram()
    initDisplayLocalNgo()
    onChangeRole()

  initDisplayLocalNgo = ->
    if !!$('.role').val() && $('.role').val() == 'lngo'
      showLocalNgo()

  initDisplayProgram = ->
    if !!$('.role').val() && $('.role').val() != 'system_admin'
      showProgram()

  onChangeRole = ->
    $('.role').off('change')
    $('.role').on 'change', (event) ->
      role = event.target.value
      handleProgram(role)
      handleLocalNgo(role)

  handleProgram = (role) ->
    if role == 'system_admin'
      hideProgram()
    else
      showProgram()

  handleLocalNgo = (role) ->
    if role == 'lngo'
      showLocalNgo()
    else
      hideLocalNgo()

  showLocalNgo = ->
    $('.local-ngo').removeClass('d-none')

  hideLocalNgo = ->
    $('.local-ngo').addClass('d-none')
    $('.local-ngo select').val('')

  showProgram = ->
    $('.program').removeClass('d-none')

  hideProgram = ->
    $('.program').addClass('d-none')
    $('.program select').val('')

  { init: init }

CW.UsersCreate = CW.UsersNew
CW.UsersEdit = CW.UsersNew
CW.UsersUpdate = CW.UsersNew
