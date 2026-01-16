CW.JaapsNew = (() => {
  let STORAGE_KEY = null;
  let table = null;
  let tr = null;
  const SAMPLE_DATA = CW.JaapSampleData || [];
  let currentCell = null; // Track the current cell being edited

  return {
    init: init,
    buildTableColumns: buildTableColumns
  }

  function init() {
    STORAGE_KEY = `jaap_draft_user_${getUserId()}`;
    const { initialData, dataSource } = getInitialData();

    initLocale();
    initStatus(dataSource);
    toggleSampleButton(dataSource, initialData);
    initJaapTable(initialData);
    initTableStateControl();  // Add table state control
    initProvinceFilter();     // Add province filtering for LNGO users
    onSubmitJaapForm();
    onCellEdit();
    onClickCancel();

    // This handle reference file uploads/removals
    CW.JaapReferenceFile.init(tr);
    // This is for clicking location cells in the table
    CW.JaapLocationModal.init(getCurrentCell, saveDraftToLocalStorage, tr);
  }

  function initStatus(dataSource) {
    if (dataSource === 'draft') {
      updateStatus(tr.draft_restored, 'draft');
    } else if (dataSource === 'server') {
      updateStatus(tr.loaded_from_server, 'server');
    }
  }

  function initLocale() {
    const locale = getLocale();
    tr = CW.JaapLocale[locale] || {};
    tr.locale = locale;
  }

  function getLocale() {
    return ($('[data-language-code]').data('languageCode') || 'en');
  }

  function getUserId() {
    return getJaapId() || $('[data-user-id]').data('userId');
  }

  function getJaapId() {
    return $('[data-jaap-id]').data('jaapId');
  }

  function getCurrentCell() {
    return currentCell;
  }

  function updateStatus(text, type) {
    const el = document.getElementById("data-status");
    el.innerText = text;
    el.className = `status-badge ${type}`;
  }

  function onClickCancel() {
    $('.btn-cancel').off('click').on('click', function (e) {
      e.preventDefault();

      if (hasDraft()) {
        if (!confirmUnsavedChanges()) { return; }
        clearDraftFromLocalStorage();
      }

      navigateTo(this);
    });
  }

  function hasDraft() {
    return !!localStorage.getItem(STORAGE_KEY);
  }

  function confirmUnsavedChanges() {
    const message = (tr && tr.unsaved_changes_confirm) || "You have unsaved changes. Are you sure you want to leave this page?";
    return window.confirm(message);
  }

  function navigateTo(el) {
    const href = el.getAttribute('href');
    const backUrl = el.dataset ? el.dataset.backUrl : null;
    if (href) {
      window.location.href = href;
    } else if (backUrl) {
      window.location.href = backUrl;
    } else {
      window.history.back();
    }
  }

  function onCellEdit() {
    table.on("cellEdited", function (cell) {
      saveDraftToLocalStorage();
      updateStatus(tr.draft_changes, "draft");
    });
  }

  function saveDraftToLocalStorage() {
    const data = table.getData();
    localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
    hideSampleButton();
  }

  function onSubmitJaapForm() {
    $('#submit-jaap').off('click').on('click', function (e) {
      $('#jaap_data_field').val(JSON.stringify(table.getData()));
      clearDraftFromLocalStorage();
    });
  }

  function clearDraftFromLocalStorage() {
    localStorage.removeItem(STORAGE_KEY);
  }

  function initJaapTable(initialData) {
    table = new Tabulator("#jaap-table", {
      height: 520,
      layout: "fitColumns",
      dataTree: true,
      dataTreeStartExpanded: true,
      clipboard: true,
      clipboardPasteAction: "insert",
      columnHeaderVertAlign: "middle",
      columnHeaderHozAlign: "center",
      data: initialData,
      columns: buildTableColumns(true),
      rowContextMenu: [
        {
          label: tr.add_child,
          action: function (e, row) {
            row.addTreeChild({
              no: "",
              priority_activity: "",
              proposer: ""
            }, false);
            saveDraftToLocalStorage();
          }
        },
        {
          label: tr.add_sibling,
          action: function (e, row) {
            var parent = row.getTreeParent();
            var emptyRow = {};

            if (parent) {
              parent.addTreeChild(emptyRow, false);
            } else {
              row.getTable().addRow(emptyRow);
            }
            saveDraftToLocalStorage();
          }
        },
        { separator: true },
        {
          label: tr.delete,
          action: function (e, row) {
            var msg = row.getTreeChildren().length > 0
              ? tr.delete_confirm_with_children
              : tr.delete_confirm;
            if (confirm(msg)) {
              row.delete();
              saveDraftToLocalStorage();
            }
          }
        }
      ]
    });
  }

  function initTableStateControl() {
    const $communeSelect = $('#jaap_commune_id');
    const $tableContainer = $('#jaap-table');
    
    // Check initial state
    updateTableState();
    
    // Monitor commune selection changes
    $communeSelect.on('change', function() {
      updateTableState();
    });
    
    function updateTableState() {
      const communeId = $communeSelect.val();
      const hasCommune = communeId && communeId.length > 0;
      
      if (hasCommune) {
        // Enable table
        $tableContainer.css('opacity', '1').css('pointer-events', 'auto');
      } else {
        // Disable table
        $tableContainer.css('opacity', '0.5').css('pointer-events', 'none');
      }
    }
  }

  function setTableEditable(editable) {
    if (!table) return;
    
    // Update columns with new editable state
    table.setColumns(buildTableColumns(editable));
  }

  function buildTableColumns(editable) {
    const locale = $('[data-language-code]').data('languageCode') || 'en';
    tr = CW.JaapLocale[locale] || {};
    tr.locale = locale;

    return [
      { headerSort: false, width: 50, rowHandle: false, frozen: true  },
      { title: tr.no, field: "no", width: 60, frozen: true, headerSort: false, editor: editable ? "input" : false },
      { title: tr.priority_activity, field: "priority_activity", width: 300, frozen: true, headerSort: false, editor: editable ? "input" : false },
      { title: tr.proposer, field: "proposer", width: 80, headerSort: false, editor: editable ? "input" : false },
      { title: tr.target_response, field: "target_response", width: 120, headerSort: false, editor: editable ? "input" : false },
      {
        title: tr.location,
        field: "location",
        width: 180,
        headerSort: false,
        editor: false,
        cellClick: editable ? function(e, cell) {
          currentCell = cell;
          $('#locationModal').modal('show');
        } : undefined
      },
      {
        title: tr.results,
        columns: [
          { title: tr.result_quantity, field: "result_quantity", width: 90, headerSort: false, editor: editable ? "number" : false },
          { title: tr.result_unit, field: "result_unit", width: 90, headerSort: false, editor: editable ? "input" : false }
        ]
      },
      {
        title: tr.time,
        columns: [
          { title: tr.start_date, field: "start_date", width: 120, headerSort: false, editor: editable ? "input" : false },
          { title: tr.end_date, field: "end_date", width: 120, headerSort: false, editor: editable ? "input" : false }
        ]
      },

      {
        title: tr.beneficiary,
        columns: [
          { title: tr.beneficiary_total, field: "beneficiary_total", width: 100, headerSort: false, editor: editable ? "number" : false },
          { title: tr.beneficiary_female, field: "beneficiary_female", width: 100, headerSort: false, editor: editable ? "number" : false }
        ]
      },

      { title: tr.estimated_cost, field: "estimated_cost", width: 180, headerSort: false, editor: editable ? "number" : false },
      { title: tr.implementer, field: "implementer", width: 260, headerSort: false, editor: editable ? "input" : false }
    ];
  }



  function getInitialData() {
    const draftData = localStorage.getItem(STORAGE_KEY);
    const serverDataAttr = document.getElementById('jaap-table').getAttribute('data-content') || '[]';
    let initialData = draftData ? JSON.parse(draftData) : JSON.parse(serverDataAttr);
    let dataSource = draftData ? 'draft' : (getJaapId() ? 'server' : '');

    if (!Array.isArray(initialData) || initialData.length === 0) { initialData = [{}]; }
    return { initialData, dataSource };
  }

  function toggleSampleButton(dataSource, initialData) {
    const $btn = $('#load-sample');
    if (!$btn.length) return;

    const empty = Array.isArray(initialData) && initialData.length === 1 && Object.keys(initialData[0]).length === 0;
    const shouldShow = !hasDraft() && (dataSource !== 'draft') && empty;

    $btn.toggle(shouldShow);
    if (shouldShow ) {
      onClickLoadSample($btn);
    }
  }

  function onClickLoadSample($btn) {
    $btn.off('click.loadSample').on('click.loadSample', function (e) {
      e.preventDefault();
      const msg = (tr && tr.load_sample_confirm) || 'This action will override your current table. Do you want to load a sample plan to get started?';
      if (!window.confirm(msg)) return;
      loadSample();
    });
  }

  function loadSample() {
    if (table && typeof table.setData === 'function') {
      table.setData(SAMPLE_DATA);
    } else {
      // Fallback: rebuild table if setData is unavailable
      table = new Tabulator('#jaap-table', Object.assign({}, table.options, { data: SAMPLE_DATA }));
    }
    updateStatus(tr.draft_changes, 'draft');
    saveDraftToLocalStorage();
    hideSampleButton();
  }

  function hideSampleButton() {
    const $btn = $('#load-sample');
    if ($btn.length) { $btn.hide(); }
  }

  function initProvinceFilter() {
    const PROVINCE_LOAD_TIMEOUT = 5000; // Maximum time to wait for provinces to load
    const PROVINCE_CHECK_INTERVAL = 100; // Check every 100ms
    
    const $viewCenter = $('.view-center');
    const userRole = $viewCenter.data('userRole');
    const targetProvinceIds = $viewCenter.data('targetProvinceIds');
    
    // Only filter if user is LNGO and has target provinces
    if (userRole === 'lngo' && targetProvinceIds) {
      const allowedIds = targetProvinceIds.split(',').filter(id => id.length > 0);
      
      if (allowedIds.length > 0) {
        const $provinceSelect = $('#jaap_province_id');
        
        // Wait for provinces to be populated, then filter
        const checkInterval = setInterval(function() {
          const optionCount = $provinceSelect.find('option').length;
          
          if (optionCount > 1) { // More than just the "Please select" option
            clearInterval(checkInterval);
            
            // Filter out provinces not in the allowed list
            $provinceSelect.find('option').each(function() {
              const optionValue = $(this).val();
              if (optionValue && !allowedIds.includes(optionValue)) {
                $(this).remove();
              }
            });
          }
        }, PROVINCE_CHECK_INTERVAL);
        
        // Clear interval after timeout to prevent infinite loop
        setTimeout(function() {
          clearInterval(checkInterval);
        }, PROVINCE_LOAD_TIMEOUT);
      }
    }
  }
})();

CW.JaapsCreate = CW.JaapsNew
CW.JaapsEdit = CW.JaapsNew
CW.JaapsUpdate = CW.JaapsNew
