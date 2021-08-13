CW.ScorecardsIndex = (() => {
  function init() {
    CW.DatepickerPopup.init();
    CW.ScorecardsShow.onClickBtnCopy();

    handleDisplayCollapseContent();
    onShowCollapse();
    onHideCollapse();
    onAddFilter();
    onSaveFilter();
    onCancelFilter();
    onFilterChange();
  }

  function onFilterChange() {
    $("#add-filter__field").change(function () {
      let field = $(this).val();
      $(
        "#add-filter__modal .form-group:not(#add-filter__field)[data-field_attribute]"
      ).hide();
      $(`[data-field_attribute="${field}"`).show();
    });
  }

  function onCancelFilter() {
    $(".add-filter__cancel").click(function (e) {
      e.preventDefault();
      $("#add-filter__modal").hide();
    });
  }

  function onSaveFilter() {
    $(".add-filter__save").click(function (e) {
      e.preventDefault();
      let $container = $(".add-filter__saved_items_container");
      let $item = $("<div></div>");
      let field = $("#add-filter__field").val();
      let value = $(`[data-field_attribute="${field}"] .field-value`).val();
      $item.text(`${field}:${value}`);
      $item.addClass("d-inline-block p-1 mr-3");
      $item.css({ border: "1px solid #ccc" });
      $container.append($item);
      resetFilter();
    });
  }

  function resetFilter() {
    $("#add-filter__field").val("");
    $("#add-filter__field").trigger("change");
    $("#add-filter__modal").hide();
  }

  function onAddFilter() {
    $("#add-filter__link").click(function (e) {
      e.preventDefault();
      $("#add-filter__modal").toggle();
    });
  }

  function handleDisplayCollapseContent() {
    if (window.localStorage.getItem("show_collapse") == "true") {
      $(".collapse").addClass("show");
      hideArrowDown();
    }
  }

  function onShowCollapse() {
    $(".collapse").on("show.bs.collapse", function () {
      window.localStorage.setItem("show_collapse", true);
      hideArrowDown();
    });
  }

  function onHideCollapse() {
    $(".collapse").on("hide.bs.collapse", function () {
      window.localStorage.setItem("show_collapse", false);
      showArrowDown();
    });
  }

  function showArrowDown() {
    $(".advance-search i").removeClass("fa-angle-up");
    $(".advance-search i").addClass("fa-angle-down");
  }

  function hideArrowDown() {
    $(".advance-search i").removeClass("fa-angle-down");
    $(".advance-search i").addClass("fa-angle-up");
  }

  return {
    init,
  };
})();
