CW.ScorecardsShow = (() => {
  return {
    init
  }

  function init() {
    showScorecardModal();

    CW.ScorecardsIndex.initAddSuggestionTooltip();
  }

  function showScorecardModal() {
    !!$("#scorecardModal") && $("#scorecardModal").modal('show');
  }

})();
