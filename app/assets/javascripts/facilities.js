CW.FacilitiesNew = (() => {
  return {
    init
  }

  function init() {
    onKeyupFacilityName()
    onKeyupFacilityCode()
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
