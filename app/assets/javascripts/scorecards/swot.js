CW.ScorecardsSwotsIndex = (() => {
  function init() {
    CW.ScorecardsIndicatorsIndex.initBestInPlace();
    _onBlurTextArea();
    _onFocusTextArea();
  }

  function _onFocusTextArea() {
    $(document).on('focus', '.best-in-place-textarea', function(e) {
      CW.ScorecardsIndicatorsIndex.hideEditPen(e);
    })
  }

  function _onBlurTextArea() {
    $(document).on('blur', '.best-in-place-textarea', function(e) {
      CW.ScorecardsIndicatorsIndex.showEditPen(e);
    })
  }

  return {
    init
  }
})();
