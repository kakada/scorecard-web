CW.ScorecardsIndicatorsIndex = (() => {
  function init() {
    initBestInPlace();
    _onFocusTextArea();
    _onKeydownTextArea();
  }

  // Public method
  function initBestInPlace() {
    jQuery(".best_in_place").best_in_place();
  }

  function hideEditPen(e) {
    $(e.target).parents('.best_in_place').removeClass('add-space');
    $(e.target).parents('.best_in_place').next().hide();
    $(e.target).parents('.tip').addClass('flex-grow-1');
  }

  function onClickCancel(e) {
    $('.btn-cancel').on('click', function(){
      _handleShowingEditPen(e);
    })
  }

  function onClickSave(e) {
    $('.btn-save').on('click', function(){
      _handleShowingEditPen(e);
    })
  }

  // Private method
  function _onFocusTextArea() {
    $(document).on('focus', '.best-in-place-textarea', function(e) {
      _setTextAreaMaxlength(e);
      _appendTextCount(e);
      _setTextCount(e);

      hideEditPen(e);
      onClickCancel(e);
      onClickSave(e);
    })
  }

  function _handleShowingEditPen(e) {
    _hideTextCount(e);
    _hideToolTip();
    _showEditPen(e);
  }

  function _showEditPen(e) {
    $(e.target).parents('.best_in_place').addClass('add-space');
    $(e.target).parents('.best_in_place').next().show();
    $(e.target).parents('.tip').removeClass('flex-grow-1');
  }

  function _hideToolTip() {
    $('.tooltip.show').removeClass('show');
  }

  function _onKeydownTextArea() {
    $(document).on('keydown', '.best-in-place-textarea', function(e) {
      setTimeout(function() {
        _setTextCount(e);
      }, 150)
    })
  }

  function _setTextAreaMaxlength(e) {
    $(e.target).attr('maxlength', 255);
  }

  function _setTextCount(e) {
    $(e.target).parents('.review-indicator').find('.count').html(e.target.value.length);
  }

  function _appendTextCount(e) {
    if ($(e.target).parents('.review-indicator').find('.text-count').length) {
      return;
    }

    $(e.target).parents('.review-indicator').find('.best-in-place-textarea').after(_renderTextCountDom());
  }

  function _hideTextCount(e) {
    $(e.target).parents('.review-indicator').find('.text-count').addClass('d-none');
  }

  function _renderTextCountDom() {
    return  '<div class="d-flex justify-content-end text-muted text-count">' +
              '<small>' +
                '<span class="count">0</span>' +
                '<span class="mx-1">/</span>' +
                '<span>255</span>' +
              '</small>' +
            '</div>';
  }

  return {
    init,
    initBestInPlace,
    hideEditPen,
    onClickSave,
    onClickCancel
  }
})();
