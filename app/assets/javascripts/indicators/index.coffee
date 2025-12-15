CW.FacilitiesIndicatorsIndex = do ->
  init = ->
    $('#indicator-file-input').on 'change', ->
      submitBtn = $('#import-submit-btn')
      if @files? and @files.length > 0
        submitBtn.prop 'disabled', false
      else
        submitBtn.prop 'disabled', true

    # Reset form when modal is closed
    $('#importModalIndicator').on 'hidden.bs.modal', ->
      $('#import-indicator-form')[0].reset()
      $('#import-submit-btn').prop 'disabled', true

  { init: init }
