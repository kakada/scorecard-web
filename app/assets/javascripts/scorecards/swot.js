CW.ScorecardsSwotsIndex = (() => {
  function init() {
    CW.ScorecardsIndicatorsIndex.initBestInPlace();
    _onFocusTextArea();
  }

  function _onFocusTextArea() {
    $(document).on('focus', '.best-in-place-textarea', function(e) {
      CW.ScorecardsIndicatorsIndex.hideEditPen(e);
      CW.ScorecardsIndicatorsIndex.onClickCancel(e);
      CW.ScorecardsIndicatorsIndex.onClickSave(e);
    })
  }

  return {
    init
  }
})();
