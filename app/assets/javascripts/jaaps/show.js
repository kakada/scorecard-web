CW.JaapsShow = (() => {
  var table = null;
  return { init: init }

  function init() {
    initJaapTable();
    onClickDropdownMenuDownloadExcel();
  }

  function initJaapTable() {
    table = new Tabulator("#jaap-table", {
      height: 520,
      layout: "fitColumns",
      dataTree: true,
      dataTreeStartExpanded: true,
      columnHeaderVertAlign: "middle",
      columnHeaderHozAlign: "center",
      data: JSON.parse(document.getElementById('jaap-table').getAttribute('data-content') || '[]'),
      columns: CW.JaapsNew.buildTableColumns(false),
    });
  }

  function onClickDropdownMenuDownloadExcel() {
    $('#download-jaap-excel').off('click').on('click', function (e) {
      e.preventDefault();
      downloadJaapExcel();
    });
  }

  function downloadJaapExcel() {
    table.download("xlsx", "jaap.xlsx", {
      sheetName: "JAAPs " + $("[data-location]").data("location")
    });
  }
})();
