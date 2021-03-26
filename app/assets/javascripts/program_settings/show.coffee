CW.ProgramsSettingsShow = do ->
  init = ->
    onChangeEmailToggle()

  onChangeEmailToggle = ->
    $(document).off 'change', "[name='program[enable_email_notification]']"
    $(document).on 'change', "[name='program[enable_email_notification]']", (event)->
      isChecked = !!$("[name='program[enable_email_notification]']:checked").length
      _updateProgram({ enable_email_notification: isChecked })

  _updateProgram = (params={}, callback)->
    $.ajax({
      url: $('.edit_program').attr('action'),
      data: {
        authenticity_token: $('[name="authenticity_token"]').val(),
        program: params
      },
      type: 'PUT',
      success: (result) ->
        !!callback && callback()
    });

  { init: init }
