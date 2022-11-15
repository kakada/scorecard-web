CW.ScorecardsNew = (() => {
  let firstLoading;

  return {
    init,
    handleDisplaySubset
  }

  function init() {
    firstLoading = true;
    handleDisplaySubset($('.facility').val());
    onChangeFacility();
    onClickFacility();
  }

  function onChangeFacility() {
    $('.facility').on('change', (event) => {
      handleDisplaySubset(event.target.value);
    })
  }

  function onClickFacility() {
    $('.facility').on('click', (event) => {
      firstLoading = false;
      $('.facility').off('click');
    })
  }

  function handleDisplaySubset(value) {
    let facilities = $('.facility-wrapper').data('facilities');
    let facility = facilities.filter(f => f.id == value)[0];

    if (!facility) {
      hideHierarchies();
    } else if (facility.category_id) {
      handleDisplayDataset(facility);
    } else {
      handleDefaultLocation();
    }
  }

  function clearProvince() {
    if (!firstLoading) {
      $('#province select').val('').change();
    }
  }

  function handleDisplayDataset(facility) {
    let category = $('#dataset').data('categories').filter(cate => cate.id == facility.category_id)[0];

    clearProvince();
    diplayHierarchies(category.hierarchies);
    setDatasetTitle(category.name);
    setDatasetCollectionUrl(category);
    setHierarchiesSelectTarget(category.hierarchies)
  }

  function handleDefaultLocation() {
    clearProvince();

    $('#district').removeClass('d-none');
    $('#commune').removeClass('d-none');
    $('#district select').data('pumiSelectTarget', 'commune')
  }

  function hideHierarchies() {
    let hierarchyDoms = $(".hierarchy");
    hierarchyDoms.find('select').val('');
    hierarchyDoms.addClass('d-none');
  }

  function setDatasetCollectionUrl(category) {
    let datasetSelect = $('#dataset select');
    let parentLocation = category.hierarchies[category.hierarchies.length - 1];
    let url = datasetSelect.data('pumiSelectCollectionUrl').split('?')[0];
    url += '?category_id=' + category.id + '&' + parentLocation + '_id=FILTER';

    datasetSelect.data('pumiSelectCollectionUrl', url);
  }

  function setHierarchiesSelectTarget(hierarchies) {
    for(let i = 0; i < hierarchies.length; i++) {
      let pumiSelectTarget = hierarchies[i + 1] || 'dataset';
      $(`#${hierarchies[i]} select`).attr('data-pumi-select-target', pumiSelectTarget);
      $(`#${hierarchies[i]} select`).data('pumiSelectTarget', pumiSelectTarget);
    }
  }

  function diplayHierarchies(hierarchies) {
    let doms = $(".hierarchy");

    for(let i=0; i < doms.length; i++) {
      if (hierarchies.includes(doms[i].id)) {
        $(doms[i]).removeClass('d-none');
      }
    }

    $('#dataset').removeClass('d-none');
  }

  function setDatasetTitle(title) {
    $('#dataset .title').html(title);
  }
})();

CW.ScorecardsEdit = CW.ScorecardsNew
CW.ScorecardsCreate = CW.ScorecardsNew
CW.ScorecardsUpdate = CW.ScorecardsNew
