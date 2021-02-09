CW.FacilitiesNew = (() => {
  return {
    init
  }

  function init() {
    onKeyupFacilityName();
    onKeyupFacilityCode();
    handleDisplaySubset($('#facility_parent_id').val());
    onChangeFacility();
  }

  function handleDisplaySubset(value) {
    let subsetDom = $('.subset');

    if(!!value) {
      subsetDom.removeClass('d-none');
    } else {
      subsetDom.find('select').val('');
      subsetDom.addClass('d-none');
    }
  }

  function onChangeFacility() {
    $('#facility_parent_id').off('change')
    $('#facility_parent_id').on('change', (event) => {
      handleDisplaySubset(event.target.value);
    })
  }

  function onKeyupFacilityName() {
    $(document).off('keyup', '#facility_name')
    $(document).on('keyup', '#facility_name', function(event) {
      let value = event.target.value.toUpperCase().split(" ").map(x => x.charAt(0)).join('')

      $('#facility_code').val(value)
    });
  }

  function onKeyupFacilityCode() {
    $(document).off('keyup', '#facility_code')
    $(document).on('keyup', '#facility_code', function(event) {
      $(document).off('keyup', '#facility_name');
    });
  }

})();


CW.FacilitiesCreate = CW.FacilitiesNew
CW.FacilitiesEdit = CW.FacilitiesNew
CW.FacilitiesUpdate = CW.FacilitiesNew
