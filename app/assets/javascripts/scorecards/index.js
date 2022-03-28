CW.ScorecardsIndex = (() => {
  function init() {
    CW.DaterangPicker.init()
    CW.ScorecardsShow.onClickBtnCopy();

    handleDisplayCollapseContent();
    onShowCollapse();
    onHideCollapse();
    initAddSuggestionTooltip();

    initScorecardFilter();
  }

  function initScorecardFilter() {
    let multiSelects = $('[data-toggle="multiSelect"]');

    for(let i=0; i<multiSelects.length; i++) {
      new MultiSelectTagify(multiSelects[i]).init();
    }
  }

  function handleDisplayCollapseContent() {
    if (window.localStorage.getItem('show_collapse') == "true") {
      $('.collapse').addClass('show');
      hideArrowDown();
    }
  }

  function onShowCollapse() {
    $('.collapse').on('show.bs.collapse', function () {
      window.localStorage.setItem('show_collapse', true);
      hideArrowDown();
    })
  }

  function onHideCollapse() {
    $('.collapse').on('hide.bs.collapse', function () {
      window.localStorage.setItem('show_collapse', false);
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

  function initAddSuggestionTooltip() {
    $('[data-toggle="popover"]').on('shown.bs.popover', function () {
      $('.tip').tooltip({
        trigger: "hover",
        title: $('.tip-title').html()
      });
    })
  }

  return {
    init,
    initAddSuggestionTooltip
  }
})();
