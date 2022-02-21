CW.ScorecardsIndicatorsIndex = (() => {
  function init() {
    initBestInPlace();
    _onFocusTextArea();
    _onBlurTextArea();
    _onKeydownTextArea();
  }

  // Public method
  function initBestInPlace() {
    jQuery(".best_in_place").best_in_place();
  }

  function showEditPen(e) {
    $(e.target).parents('.best_in_place').addClass('add-space');
    $(e.target).parents('.best_in_place').next().show();
    $(e.target).parents('.tip').removeClass('flex-grow-1');
  }

  function hideEditPen(e) {
    $(e.target).parents('.best_in_place').removeClass('add-space');
    $(e.target).parents('.best_in_place').next().hide();
    $(e.target).parents('.tip').addClass('flex-grow-1');
  }

  // Private method
  function _onFocusTextArea() {
    $(document).on('focus', '.best-in-place-textarea', function(e) {
      hideEditPen(e);
      _setTextAreaMaxlength(e);
      _showTextCount(e);
      _setTextCount(e);
    })
  }

  function _onKeydownTextArea() {
    $(document).on('keydown', '.best-in-place-textarea', function(e) {
      setTimeout(function() {
        _setTextCount(e);
      }, 150)
    })
  }

  function _onBlurTextArea() {
    $(document).on('blur', '.best-in-place-textarea', function(e) {
      showEditPen(e);
      _hideTextCount(e);
    })
  }

  function _setTextAreaMaxlength(e) {
    $(e.target).attr('maxlength', 255);
  }

  function _setTextCount(e) {
    $(e.target).parents('.review-indicator').find('.count').html(e.target.value.length);
  }

  function _showTextCount(e) {
    $(e.target).parents('.review-indicator').find('.text-count').removeClass('d-none');
  }

  function _hideTextCount(e) {
    $(e.target).parents('.review-indicator').find('.text-count').addClass('d-none');
  }

  return {
    init,
    initBestInPlace,
    hideEditPen,
    showEditPen
  }
})();
