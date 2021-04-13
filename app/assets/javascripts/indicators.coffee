# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

CW.FacilitiesIndicatorsNew = do ->
  init = ->
    CW.TemplatesNew.initTypeahead()
    CW.TemplatesNew.onRemoveAudio()
    CW.TemplatesNew.onChangeAudio()

  { init: init }

CW.FacilitiesIndicatorsCreate = CW.FacilitiesIndicatorsNew
CW.FacilitiesIndicatorsEdit = CW.FacilitiesIndicatorsNew
CW.FacilitiesIndicatorsUpdate = CW.FacilitiesIndicatorsNew

CW.TemplatesIndicatorsNew = CW.FacilitiesIndicatorsNew
CW.TemplatesIndicatorsCreate = CW.FacilitiesIndicatorsNew
CW.TemplatesIndicatorsEdit = CW.FacilitiesIndicatorsNew
CW.TemplatesIndicatorsUpdate = CW.FacilitiesIndicatorsNew
