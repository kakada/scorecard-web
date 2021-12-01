CW.DataPublication = (() => {
  return {
    init
  }

  function init() {
    onChangePublishedOption();
  }

  function onChangePublishedOption() {
    $(document).off('change', '#program-released');
    $(document).on('change', "input[type=radio][name='program[data_publication_attributes][published_option]']", function(e) {
      $('.data-publish-form [type=submit]').removeClass('disabled');
    })
  }
})();
