# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

CW.CategoriesIndicatorsNew = do ->
  init = ->
    onRemoveAudio()
    onChangeAudio()

  onRemoveAudio = ->
    $(document).on 'click', '.remove-audio', (e) =>
      wrapper = $(e.target).parents('.audio-wrapper')
      window.me = wrapper
      wrapper.find('.audio-input').removeClass('d-none')
      wrapper.find('.audio-input-destroy').val(1)
      wrapper.find('.remove-audio-wrapper').hide()

  onChangeAudio = ->
    $(document).on 'change', '.audio-input', (e) =>
      wrapper = $(e.target).parents('.audio-wrapper')
      !!wrapper.find('.audio-input-destroy') && wrapper.find('.audio-input-destroy').val(1)

  { init: init }

CW.CategoriesIndicatorsCreate = CW.CategoriesIndicatorsNew
CW.CategoriesIndicatorsEdit = CW.CategoriesIndicatorsNew
CW.CategoriesIndicatorsUpdate = CW.CategoriesIndicatorsNew

CW.TemplatesIndicatorsNew = CW.CategoriesIndicatorsNew
CW.TemplatesIndicatorsCreate = CW.CategoriesIndicatorsNew
CW.TemplatesIndicatorsEdit = CW.CategoriesIndicatorsNew
CW.TemplatesIndicatorsUpdate = CW.CategoriesIndicatorsNew
