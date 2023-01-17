CW.Removing_scorecardsCreate = (() => {
  return {
    init
  }

  function init() {
    onChangeInputConfirmDelete();
  }

  function onChangeInputConfirmDelete() {
    $(document).on('change', '.confirm-input', function(e) {
      if (e.target.value == $(this).data('codes')) {
        $("#confirmModal .btn-yes").removeAttr('disabled');
      } else {
        $("#confirmModal .btn-yes").attr('disabled', true);
      }
    });
  }
})();
