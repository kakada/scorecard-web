CW.Common.DataLinkClick = (() => {
  return {
    init
  }

  function init() {
    onClickTableRow();
  }
  function onClickTableRow() {
    $(document).off('click', 'tr[data-link]');
    $(document).on('click', 'tr[data-link]', function() {
      const link = $(this).data('link');
      if (link) {
        window.location = link;
      }
    });
  }
})();
