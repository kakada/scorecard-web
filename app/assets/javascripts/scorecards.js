CW.ScorecardsShow = (() => {
  return {
    init
  }

  function init() {
    showScorecardModal();
    onClickBtnCopy();
  }

  function onClickBtnCopy() {
    $(document).off('click', '.btn-copy');
    $(document).on('click', '.btn-copy', function(event) {
      $(this).prev('input.input-for-copy').select();
      document.execCommand("copy");

      event.preventDefault();
      $('.toast').toast('show')
    })
  }


  function showScorecardModal() {
    !!$("#scorecardModal") && $("#scorecardModal").modal('show');
  }

})();

CW.ScorecardsIndex = CW.ScorecardsShow
