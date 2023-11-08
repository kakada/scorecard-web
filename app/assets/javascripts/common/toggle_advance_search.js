CW.Common.toggleAdvanceSearch = (function () {
  return {
    init: init
  }

  function init() {
    let localstorageKey = $("[data-toggler-variable]").data("togglerVariable");

    if(!localstorageKey) return;

    handleDisplayCollapseContent(localstorageKey);
    onShowCollapse(localstorageKey);
    onHideCollapse(localstorageKey);
  }

  function handleDisplayCollapseContent(localstorageKey) {
    if (window.localStorage.getItem(localstorageKey) == "true") {
      $('.collapse-filter').addClass('show');
      hideArrowDown();
    }
  }

  function onShowCollapse(localstorageKey) {
    $('.collapse-filter').on('show.bs.collapse', function () {
      window.localStorage.setItem(localstorageKey, true);
      hideArrowDown();
    })
  }

  function onHideCollapse(localstorageKey) {
    $('.collapse-filter').on('hide.bs.collapse', function () {
      window.localStorage.setItem(localstorageKey, false);
      showArrowDown();
    })
  }

  function showArrowDown() {
    $('.advance-search i').removeClass('fa-angle-up');
    $('.advance-search i').addClass('fa-angle-down');
  }

  function hideArrowDown() {
    $('.advance-search i').removeClass('fa-angle-down');
    $('.advance-search i').addClass('fa-angle-up');
  }
})();
