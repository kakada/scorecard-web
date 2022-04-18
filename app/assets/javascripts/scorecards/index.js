CW.ScorecardsIndex = (() => {
  function init() {
    CW.DaterangPicker.init()
    CW.ScorecardsShow.onClickBtnCopy();

    handleDisplayCollapseContent();
    onShowCollapse();
    onHideCollapse();
    initAddSuggestionTooltip();

    initSelectPicker();
  }

  function initSelectPicker() {
    $('.selectpicker').selectpicker();

    $('.selectpicker').on('changed.bs.select', function (e, clickedIndex, isSelected, previousValue) {
      setTooltip(e);
    });

    $('.selectpicker').on('loaded.bs.select', function (e, clickedIndex, isSelected, previousValue) {
      setTooltip(e);
    });
  }

  function setTooltip(e) {
    let selectedOptions = $(e.target).parents('.tooltips').find('select :selected');
    let title = selectedOptions.map((i, o) => $(o).html()).toArray().join(', ');

    $(e.target).parents('.tooltips').attr('data-original-title', title);
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
