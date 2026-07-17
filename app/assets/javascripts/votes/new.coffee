CW.VotesNew = do ->
  init = ->
    initializeSubmissionToken()
    showDuplicateSubmissionWarning()

    #  Scroll to the first server-rendered error (gender or indicator score)
    firstError = document.querySelector('.text-danger, .invalid-feedback')
    if firstError
      container = firstError.closest('.indicator-item') or firstError.closest('.form-group') or firstError
      if container
        container.focus(preventScroll: true)
        container.scrollIntoView(behavior: 'smooth', block: 'center')
      else
        firstError.scrollIntoView(behavior: 'smooth', block: 'center')

  initializeSubmissionToken = ->
    form = document.getElementById('voting-form')
    return unless form

    tokenField = form.querySelector('[name="public_vote_form[device_submission_token]"]')
    return unless tokenField

    token = submissionTokenFor(form)
    tokenField.value = token if token

  showDuplicateSubmissionWarning = ->
    form = document.getElementById('voting-form')
    return unless form
    return unless form.dataset.duplicateWarningRequired == 'true'

    confirmField = form.querySelector('[name="public_vote_form[confirm_duplicate_submission]"]')
    return if confirmField?.value == 'true'

    messages = [form.dataset.duplicateWarningTitle]

    if parseInt(form.dataset.duplicateDeviceSubmissionCount || 0, 10) > 0
      messages.push(form.dataset.duplicateDeviceMessage)
      messages.push(form.dataset.duplicateDeviceRepeatMessage)

    if parseInt(form.dataset.duplicateProfileSubmissionCount || 0, 10) > 0
      messages.push(form.dataset.duplicateProfileMessage)

    messages.push(form.dataset.duplicateConfirmMessage)

    if window.confirm(messages.join("\n\n"))
      confirmField.value = 'true' if confirmField
      form.requestSubmit()

  submissionTokenFor = (form) ->
    storageKey = "scorecard-vote-submission-token:#{form.dataset.scorecardToken}"
    token = window.localStorage.getItem(storageKey)

    unless token
      token = generateToken()
      window.localStorage.setItem(storageKey, token)

    token

  generateToken = ->
    if window.crypto?.randomUUID
      window.crypto.randomUUID()
    else
      "#{Date.now()}-#{Math.random().toString(36).slice(2, 12)}"

  { init }

CW.VotesCreate = CW.VotesNew
