CW.ScorecardsShow = (() => {
  return {
    init
  }

  function init() {
    showScorecardModal();
  }

  function showScorecardModal() {
    !!$("#scorecardModal") && $("#scorecardModal").modal('show');
  }

})();
