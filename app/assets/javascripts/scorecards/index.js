CW.ScorecardsIndex = (() => {
  function init() {
    CW.DatepickerPopup.init();
    CW.ScorecardsShow.onClickBtnCopy();
    CW.FilterOptions.init();

    handleDisplayCollapseContent();
    onShowCollapse();
    onHideCollapse();
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
