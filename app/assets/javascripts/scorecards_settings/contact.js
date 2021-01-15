CW.ContactIndex = (() => {
  return {
    init
  }

  function init() {
    CW.TemplatesNew.onClickAddField();
    CW.TemplatesNew.onClickRemoveField();

    onChangeContactType();
  }

  function onChangeContactType() {
    $(document).on('change', '.contact-type', function(e) {
      let dom = $(e.target);
      let placeholders = dom.data('placeholders');
      let contactValueDom = dom.parents('.fieldset').find('.contact-value');

      contactValueDom.attr('placeholder', placeholders[e.target.value]);
    })
  }
})();
