CW.FacilitiesNew = (() => {
  let predefinedFacilities = [];

  return {
    init
  }

  function init() {
    onKeyupFacilityName();
    onKeyupFacilityCode();
    handleDisplayDataset($('#facility_parent_id').val());
    onChangeFacility();
    onSwitchHasChild();
    loadPredefinedFacilities();
    handleTabSwitch();
  }

  function handleTabSwitch() {
    $('a[href="#predefined-facility"]').on('shown.bs.tab', function() {
      if (predefinedFacilities.length === 0) {
        loadPredefinedFacilities();
      }
    });
  }

  function loadPredefinedFacilities() {
    $.ajax({
      url: '/facilities/predefined_facilities',
      method: 'GET',
      success: function(data) {
        predefinedFacilities = data;
        renderPredefinedFacilities(data);
      },
      error: function() {
        $('#predefined-facilities-container').html(
          '<div class="alert alert-danger">Error loading predefined facilities</div>'
        );
      }
    });
  }

  function renderPredefinedFacilities(facilities) {
    const container = $('#predefined-facilities-container');
    const checkboxContainer = $('#predefined-checkboxes');
    
    if (facilities.length === 0) {
      container.html('<div class="alert alert-info">All predefined facilities have been added to this program.</div>');
      $('#submit-predefined').prop('disabled', true);
      return;
    }

    // Group facilities by parent
    const roots = facilities.filter(f => f.root);
    const children = facilities.filter(f => !f.root);

    let html = '<table class="table table-bordered"><tbody>';
    
    roots.forEach(parent => {
      html += renderFacilityRow(parent, 0);
      
      // Find and render children
      const parentChildren = children.filter(c => c.parent_code === parent.code);
      parentChildren.forEach(child => {
        html += renderFacilityRow(child, 1);
      });
    });

    html += '</tbody></table>';
    container.html(html);

    // Handle checkbox interactions
    $('.predefined-checkbox').on('change', handleCheckboxChange);
    
    // Disable children checkboxes by default
    $('.child-checkbox').prop('disabled', true);
  }

  function renderFacilityRow(facility, level) {
    const indent = level === 0 ? '' : 'style="padding-left: 30px;"';
    const checkboxClass = level === 0 ? 'parent-checkbox' : 'child-checkbox';
    const rowClass = level === 0 ? '' : 'bg-light';
    
    return `
      <tr class="${rowClass}">
        <td width="40" class="text-center">
          <input type="checkbox" 
                 class="predefined-checkbox ${checkboxClass}" 
                 name="predefined_facility_codes[]" 
                 value="${facility.code}"
                 data-code="${facility.code}"
                 data-parent-code="${facility.parent_code || ''}"
                 id="facility_${facility.code}">
        </td>
        <td ${indent}>
          <label for="facility_${facility.code}" class="mb-0">
            <strong>${facility.code}</strong> | ${facility.name_en}
          </label>
        </td>
        <td>${facility.name_km}</td>
        <td>${facility.parent_code || '—'}</td>
        <td>${facility.category_code || '—'}</td>
      </tr>
    `;
  }

  function handleCheckboxChange(e) {
    const checkbox = $(e.target);
    const code = checkbox.data('code');
    const isParent = checkbox.hasClass('parent-checkbox');
    
    if (isParent) {
      // When parent is checked/unchecked, auto-select/deselect children
      const children = $(`.child-checkbox[data-parent-code="${code}"]`);
      children.prop('checked', checkbox.is(':checked'));
      children.prop('disabled', !checkbox.is(':checked'));
    }
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
