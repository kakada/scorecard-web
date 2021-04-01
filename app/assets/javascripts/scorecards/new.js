CW.ScorecardsNew = (() => {
  return {
    init
  }

  function init() {
    handleDisplaySubset($('.facility').val());
    onChangeFacility();
  }

  function handleDisplaySubset(value) {
    let facilities = $('.facility-wrapper').data('facilities');
    let facility = facilities.filter(f => f.id == value)[0];
    let datasetDom = $('.dataset');

    if(!!facility && !!facility.dataset) {
      datasetDom.removeClass('d-none');
    } else {
      datasetDom.find('select').val('');
      datasetDom.addClass('d-none');
    }
  }

  function onChangeFacility() {
    $('.facility').off('change')
    $('.facility').on('change', (event) => {
      handleDisplaySubset(event.target.value);
    })
  }

})();

CW.ScorecardsEdit = CW.ScorecardsNew
CW.ScorecardsCreate = CW.ScorecardsNew
CW.ScorecardsUpdate = CW.ScorecardsNew
