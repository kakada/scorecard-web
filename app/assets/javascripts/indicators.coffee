# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

CW.FacilitiesIndicatorsNew = do ->
  init = ->
    onRemoveAudio()
    onChangeAudio()

  onRemoveAudio = ->
    $(document).on 'click', '.remove-audio', (e) =>
      wrapper = $(e.target).parents('.audio-wrapper')

      wrapper.find('.audio-input').parent().removeClass('d-none')
      wrapper.find('.audio-input-destroy').val(1)
      wrapper.find('.remove-audio-wrapper').hide()

  onChangeAudio = ->
    $(document).on 'change', '.audio-input', (e) =>
      wrapper = $(e.target).parents('.audio-wrapper')
      !!wrapper.find('.audio-input-destroy') && wrapper.find('.audio-input-destroy').val(0)

  { init: init }

CW.FacilitiesIndicatorsCreate = CW.FacilitiesIndicatorsNew
CW.FacilitiesIndicatorsEdit = CW.FacilitiesIndicatorsNew
CW.FacilitiesIndicatorsUpdate = CW.FacilitiesIndicatorsNew

CW.TemplatesIndicatorsNew = CW.FacilitiesIndicatorsNew
CW.TemplatesIndicatorsCreate = CW.FacilitiesIndicatorsNew
CW.TemplatesIndicatorsEdit = CW.FacilitiesIndicatorsNew
CW.TemplatesIndicatorsUpdate = CW.FacilitiesIndicatorsNew
