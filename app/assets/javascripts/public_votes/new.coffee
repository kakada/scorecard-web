CW.Public_votesNew = do ->
  init = ->
    #  Scroll to the first server-rendered error (gender or indicator score)
    firstError = document.querySelector('.text-danger, .invalid-feedback')
    if firstError
      container = firstError.closest('.indicator-item') or firstError.closest('.form-group') or firstError
      if container
        # Make container focusable for accessibility and focus then scroll
        unless container.hasAttribute('tabindex')
          container.setAttribute('tabindex', '-1')
        container.focus(preventScroll: true)
        container.scrollIntoView(behavior: 'smooth', block: 'center')
      else
        firstError.scrollIntoView(behavior: 'smooth', block: 'center')

  { init }

CW.Public_votesCreate = CW.Public_votesNew
