CW.FacilitiesNew = (() => {
  return {
    init
  }

  function init() {
    onKeyupFacilityName();
    onKeyupFacilityCode();
    handleDisplayDataset($('#facility_parent_id').val());
    onChangeFacility();
    onSwitchHasChild();
  }

  function onSwitchHasChild() {
    $("[name='facility[has_child]']").on("change", (e) => {
      let hasChild = !!$("[name='facility[has_child]']:checked").length;
      $("#facility_category_id").attr("disabled", !hasChild);
    })
  }

  function handleDisplayDataset(value) {
    let dom = $('.dataset');

    $("[name='facility[has_child]']").attr("disabled", !value);

    if(!!value) {
      dom.removeClass('d-none');
    } else {
      dom.find('select').val('');
      dom.addClass('d-none');
    }
  }

  function onChangeFacility() {
    $('#facility_parent_id').off('change')
    $('#facility_parent_id').on('change', (event) => {
      handleDisplayDataset(event.target.value);
    })
  }

  function onKeyupFacilityName() {
    $(document).off('keyup', '#facility_name_en')
    $(document).on('keyup', '#facility_name_en', function(event) {
      let value = event.target.value.toUpperCase().split(" ").map(x => x.charAt(0)).join('')

      $('#facility_code').val(value)
    });
  }

  function onKeyupFacilityCode() {
    $(document).off('keyup', '#facility_code')
    $(document).on('keyup', '#facility_code', function(event) {
      $(document).off('keyup', '#facility_name_en');
    });
  }

})();


CW.FacilitiesCreate = CW.FacilitiesNew
CW.FacilitiesEdit = CW.FacilitiesNew
CW.FacilitiesUpdate = CW.FacilitiesNew
