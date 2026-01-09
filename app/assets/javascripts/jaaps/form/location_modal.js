CW.JaapLocationModal = (() => {
  return {
    init: init
  }

  function init(getCurrentCell, saveDraftToLocalStorage, tr) {
    const $modal = $('#locationModal');
    const $provinceSelect = $('#modal-province');
    const $districtSelect = $('#modal-district');
    const $communeSelect = $('#modal-commune');
    const $datasetList = $('#dataset-list');
    const $confirmBtn = $('#confirm-location');
    const $clearBtn = $('#clear-location');
    let selectedDataset = null;

    // Helper function to get locale-specific field name
    function getLocaleNameField() {
      const locale = $('[data-language-code]').data('languageCode') || 'en';
      return 'name_' + locale;
    }

    // Helper function to escape HTML (moved up for better organization)
    function escapeHtml(text) {
      const map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;'
      };
      return text ? text.replace(/[&<>"']/g, function(m) { return map[m]; }) : '';
    }

    // Load provinces on modal show
    $modal.on('show.bs.modal', function() {
      resetModal();
      loadProvinces();
    });

    // Province change handler
    $provinceSelect.on('change', function() {
      const provinceId = $(this).val();
      resetDistricts();
      resetCommunes();
      resetDatasets();
      selectedDataset = null;
      $confirmBtn.prop('disabled', true);

      if (provinceId) {
        loadDistricts(provinceId);
      }
    });

    // District change handler
    $districtSelect.on('change', function() {
      const districtId = $(this).val();
      resetCommunes();
      resetDatasets();
      selectedDataset = null;
      $confirmBtn.prop('disabled', true);

      if (districtId) {
        loadCommunes(districtId);
      }
    });

    // Commune change handler
    $communeSelect.on('change', function() {
      const communeId = $(this).val();
      resetDatasets();
      selectedDataset = null;
      $confirmBtn.prop('disabled', true);

      if (communeId) {
        loadDatasets(communeId);
      }
    });

    // Confirm button handler - single binding, no .off()
    $confirmBtn.on('click', function() {
      let currentCell = getCurrentCell();
      if (selectedDataset && currentCell) {
        currentCell.setValue(selectedDataset);
        $modal.modal('hide');
        saveDraftToLocalStorage();
      }
    });

    // Clear button handler - clears the location cell
    $clearBtn.on('click', function() {
      let currentCell = getCurrentCell();
      if (currentCell) {
        currentCell.setValue('');
        $modal.modal('hide');
        saveDraftToLocalStorage();
      }
    });

    // Dataset selection handler (using event delegation) - removed .off()
    $datasetList.on('click', 'a.list-group-item:not(.disabled)', function() {
      $datasetList.find('.list-group-item').removeClass('active');
      $(this).addClass('active');
      selectedDataset = $(this).data('value');
      $confirmBtn.prop('disabled', false);
    });

    function resetModal() {
      $provinceSelect.val('').trigger('change');
      resetDistricts();
      resetCommunes();
      resetDatasets();
      selectedDataset = null;
      $confirmBtn.prop('disabled', true);
    }

    function resetDistricts() {
      $districtSelect.html('<option value="">' + (tr.please_select || 'Please select') + '</option>').prop('disabled', true);
    }

    function resetCommunes() {
      $communeSelect.html('<option value="">' + (tr.please_select || 'Please select') + '</option>').prop('disabled', true);
    }

    function resetDatasets() {
      const msg = tr.select_commune_first || 'Please select a commune to see available datasets';
      $datasetList.html('<div class="text-muted text-center py-3">' + msg + '</div>');
    }

    function loadProvinces() {
      $.ajax({
        url: '/pumi/provinces',
        method: 'GET',
        dataType: 'json',
        success: function(data) {
          const nameField = getLocaleNameField();

          $provinceSelect.html('<option value="">' + (tr.please_select || 'Please select') + '</option>');
          data.forEach(function(province) {
            $provinceSelect.append('<option value="' + escapeHtml(province.id) + '">' + escapeHtml(province[nameField]) + '</option>');
          });
        },
        error: function() {
          console.error('Failed to load provinces');
        }
      });
    }

    function loadDistricts(provinceId) {
      $.ajax({
        url: '/pumi/districts?province_id=' + provinceId,
        method: 'GET',
        dataType: 'json',
        success: function(data) {
          const nameField = getLocaleNameField();

          $districtSelect.html('<option value="">' + (tr.please_select || 'Please select') + '</option>');
          data.forEach(function(district) {
            $districtSelect.append('<option value="' + escapeHtml(district.id) + '">' + escapeHtml(district[nameField]) + '</option>');
          });
          $districtSelect.prop('disabled', false);
        },
        error: function() {
          console.error('Failed to load districts');
        }
      });
    }

    function loadCommunes(districtId) {
      $.ajax({
        url: '/pumi/communes?district_id=' + districtId,
        method: 'GET',
        dataType: 'json',
        success: function(data) {
          const nameField = getLocaleNameField();

          $communeSelect.html('<option value="">' + (tr.please_select || 'Please select') + '</option>');
          data.forEach(function(commune) {
            $communeSelect.append('<option value="' + escapeHtml(commune.id) + '">' + escapeHtml(commune[nameField]) + '</option>');
          });
          $communeSelect.prop('disabled', false);
        },
        error: function() {
          console.error('Failed to load communes');
        }
      });
    }

    function loadDatasets(communeId) {
      $datasetList.html('<div class="text-muted text-center py-3"><i class="fas fa-spinner fa-spin"></i> Loading...</div>');

      // Get the selected commune name for the Commune Administration section
      const communeName = $communeSelect.find('option:selected').text();
      const communeValue = `${tr.commune} ${communeName}`;

      $.ajax({
        url: '/api/v1/datasets?commune_id=' + communeId,
        method: 'GET',
        dataType: 'json',
        success: function(data) {
          const nameField = getLocaleNameField();
          let html = '';

          // Add Commune Administration section first
          const communeAdminLabel = tr.commune_administration || 'Commune Administration';
          html += '<div class="list-group-item list-group-item-secondary font-weight-bold">' +
                  escapeHtml(communeAdminLabel) + '</div>';
          html += '<a class="list-group-item list-group-item-action pl-4" data-value="' +
                  escapeHtml(communeValue) + '">' +
                  escapeHtml(communeName) + '</a>';

          if (data.length === 0) {
            // If no datasets but we have commune, that's fine - commune admin is already shown
            $datasetList.html(html);
          } else {
            // Group datasets by category
            const groupedData = {};

            data.forEach(function(dataset) {
              const category = dataset.category;
              if (category) {
                const categoryName = category[nameField] || category.name_en;
                if (!groupedData[categoryName]) {
                  groupedData[categoryName] = [];
                }
                groupedData[categoryName].push(dataset);
              }
            });

            // Render grouped datasets
            Object.keys(groupedData).sort().forEach(function(categoryName) {
              html += '<div class="list-group-item list-group-item-secondary font-weight-bold">' +
                      escapeHtml(categoryName) + '</div>';

              groupedData[categoryName].forEach(function(dataset) {
                // Use dataset code which includes the prefix (e.g., "មណ្ឌល. ឆ្លូង", "បឋម.")
                const displayValue = escapeHtml(dataset[nameField]);
                const value = `${categoryName} ${displayValue}`;
                html += '<a class="list-group-item list-group-item-action pl-4" data-value="' +
                        value + '">' +
                        displayValue + '</a>';
              });
            });

            $datasetList.html(html);
          }
        },
        error: function() {
          console.error('Failed to load datasets');
          $datasetList.html('<div class="text-danger text-center py-3">Failed to load datasets</div>');
        }
      });
    }
  }
})();
