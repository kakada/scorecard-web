CW.JaapsNew = (() => {
  let STORAGE_KEY = null;
  let table = null;
  let tr = null;
  const SAMPLE_DATA = CW.JaapSampleData || [];
  const MAX_FILE_SIZE_MB = 5; // Must match JaapReferenceUploader::MAX_FILE_SIZE_MB

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
    onSubmitJaapForm();
    onCellEdit();
    onClickCancel();
    onFileInputChange();
    onClickRemoveReference();
  }

  function onClickRemoveReference() {
    // remove existing file
    $(document).on("click", ".js-remove-reference", function () {
      var wrapper = $(this).closest(".reference-wrapper")

      wrapper.find(".reference-existing").addClass("d-none")
      wrapper.find(".reference-input").val("").removeClass("d-none")

      wrapper.find("input[name*='[remove_reference]']").val("1")

      // IMPORTANT: clear file input value
      var fileInput = wrapper.find(".js-reference-input")
      fileInput.val("")

      wrapper.find(".reference-filename").text("")
    })
  }

  function onFileInputChange() {
    // file selected (NEW form fix)
    $(document).on("change", ".js-reference-input", function () {
      var wrapper = $(this).closest(".reference-wrapper")
      var file = this.files && this.files.length > 0 ? this.files[0] : null

      if (!file) return

      // Check file size limit (must match JaapReferenceUploader::MAX_FILE_SIZE_MB)
      var maxSizeBytes = MAX_FILE_SIZE_MB * 1024 * 1024
      if (file.size > maxSizeBytes) {
        var defaultErrorMsg = `File size exceeds ${MAX_FILE_SIZE_MB}MB limit. Please choose a smaller file.`
        var errorMsg = (tr && tr.file_size_error) || defaultErrorMsg
        alert(errorMsg)
        $(this).val("") // Clear the file input
        return
      }

      var fileName = file.name

      // Add icon based on file extension
      var icon = getFileTypeIcon(fileName)
      wrapper.find(".reference-filename").html(icon + ' ' + fileName)
      wrapper.find(".reference-existing").removeClass("d-none")
      wrapper.find(".reference-input").addClass("d-none")

      // user selected a new file → ensure we are NOT removing it
      wrapper.find("input[name*='[remove_reference]']").val("0")
    })
  }

  function getFileTypeIcon(filename) {
    if (!filename) return '<i class="fas fa-file"></i>'

    var parts = filename.split('.')
    var extension = parts.length > 1 ? parts.pop().toLowerCase() : ''

    switch (extension) {
      case 'pdf':
        return '<i class="fas fa-file-pdf text-danger"></i>'
      case 'xls':
      case 'xlsx':
        return '<i class="fas fa-file-excel text-success"></i>'
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return '<i class="fas fa-file-image text-primary"></i>'
      default:
        return '<i class="fas fa-file"></i>'
    }
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
      { title: tr.location, field: "location", width: 180, headerSort: false, editor: editable ? "input" : false },
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

  function getJaapId() {
    return $('[data-jaap-id]').data('jaapId');
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
})();

CW.JaapsCreate = CW.JaapsNew
CW.JaapsEdit = CW.JaapsNew
CW.JaapsUpdate = CW.JaapsNew
