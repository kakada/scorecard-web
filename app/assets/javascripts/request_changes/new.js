CW.ScorecardsRequest_changesNew = (() => {
  return {
    init
  }

  function init() {
    CW.ScorecardsNew.handleDisplaySubset($('.facility').val());
  }

})();

CW.ScorecardsRequest_changesEdit = CW.ScorecardsRequest_changesNew;
CW.ScorecardsRequest_changesCreate = CW.ScorecardsRequest_changesNew;
CW.ScorecardsRequest_changesUpdate = CW.ScorecardsRequest_changesNew;
