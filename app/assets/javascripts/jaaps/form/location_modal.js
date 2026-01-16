CW.JaapLocationModal = (() => {
  return {
    init: init
  }

  function init(getCurrentCell, saveDraftToLocalStorage, tr) {
    const $modal = $('#locationModal');
    const $datasetList = $('#dataset-list');
    const $confirmBtn = $('#confirm-location');
    const $clearBtn = $('#clear-location');
    let selectedDataset = null;
    let previouslySelectedDataset = null;

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

    // Load datasets on modal show based on commune from main form
    $modal.on('show.bs.modal', function() {
      // Get current cell value to restore previous selection
      let currentCell = getCurrentCell();
      previouslySelectedDataset = currentCell ? currentCell.getValue() : null;
      
      resetModal();
      
      // Get commune from main form
      const communeId = $('#jaap_commune_id').val();
      
      if (communeId) {
        loadDatasets(communeId);
      } else {
        $datasetList.html('<div class="text-muted text-center py-3">' + (tr.select_commune_in_form || 'Please select a commune in the main form first') + '</div>');
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
      resetDatasets();
      selectedDataset = null;
      $confirmBtn.prop('disabled', true);
    }

    function resetDatasets() {
      const msg = tr.select_commune_first || 'Please select a commune to see available datasets';
      $datasetList.html('<div class="text-muted text-center py-3">' + msg + '</div>');
    }

    function loadDatasets(communeId) {
      $datasetList.html('<div class="text-muted text-center py-3"><i class="fas fa-spinner fa-spin"></i> Loading...</div>');

      // Get the selected commune name for the Commune Administration section
      const communeName = $('#jaap_commune_id option:selected').text();
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
          
          // Restore previously selected dataset if it exists
          if (previouslySelectedDataset) {
            $datasetList.find('a.list-group-item').each(function() {
              if ($(this).data('value') === previouslySelectedDataset) {
                $(this).addClass('active');
                selectedDataset = previouslySelectedDataset;
                $confirmBtn.prop('disabled', false);
              }
            });
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
