CW.ScorecardsIndex = (() => {
  function init() {
    CW.DatepickerPopup.init()
    CW.ScorecardsShow.onClickBtnCopy();

    handleDisplayCollapseContent();
    onShowCollapse();
    onHideCollapse();
    onShownSharePopover();
    onClickShareButton();
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

  function onShownSharePopover() {
    $('.btn-share').on('shown.bs.popover', function (e) {
      let popupEl = $("#" + $(e.currentTarget).attr('aria-describedby'));
      let shareButtons = popupEl.find('.ssb-icon');

      popupEl.find('.social-share-button').attr('data-url', $(e.currentTarget).data('url'));

      for(let i=0; i < shareButtons.length; i++) {
        let channel = shareButtons[i].className.split(' ').pop().split('-').pop();
        $(shareButtons[i]).attr('data-site', channel);
      }
    })
  }

  function onClickShareButton() {
    $(document).on('click', '.social-share-button .ssb-icon', function (e) {
      e.preventDefault();
      SocialShareButton.share(this); //this method is from Gem social-share-button
    })
  }

  return {
    init
  }
})();
