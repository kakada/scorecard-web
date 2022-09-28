// https://codepen.io/chriscoyier/pen/JYyXjX
CW.CategoriesNew = (() => {
  return {
    init: init
  }

  function init() {
    onClickCheckbox();
    onChangeCategoryName();
  }

  function onClickCheckbox() {
    $('input[type="checkbox"]').change(function(e) {
      var checked = $(this).prop("checked"),
          container = $(this).parent();

      uncheckChildren(container);

      if (checked) {
        checkSiblings(container, checked);
      }

      updateLiveLabel();
    });
  }

  function onChangeCategoryName() {
    $(`#category_name_${languageCode()}`).on('change', function(e) {
      updateLiveLabel();
    })
  }

  function languageCode() {
    return $('[data-language-code]').data('languageCode');
  }

  function updateLiveLabel() {
    let str = $.map($(".hierarchy input:checked~label"), function( label ) {
      return $(label).html();
    });

    if (str.length) {
      let categoryName = $(`#category_name_${languageCode()}`).val();
      categoryName ||= $('.hierarchy').data('label');

      str.push(categoryName);
    }

    $('.live-label').html(`(${str.join(' → ')})`);
  }

  function uncheckChildren(container) {
    container.find('li input[type="checkbox"]').prop({
      indeterminate: false,
      checked: false
    });
  }

  function checkSiblings(el, checked) {
    var parent = el.parent().parent(),
        all = true;

    el.siblings().each(function() {
      let returnValue = all = ($(this).children('input[type="checkbox"]').prop("checked") === checked);
      return returnValue;
    });

    if (all && checked) {
      parent.children('input[type="checkbox"]').prop({
        indeterminate: false,
        checked: checked
      });

      checkSiblings(parent, checked);
    } else if (all && !checked) {
      parent.children('input[type="checkbox"]').prop("checked", checked);
      parent.children('input[type="checkbox"]').prop("indeterminate", (parent.find('input[type="checkbox"]:checked').length > 0));
      checkSiblings(parent, checked);
    } else {
      el.parents("li").children('input[type="checkbox"]').prop({
        indeterminate: true,
        checked: checked
      });
    }
  }
})();

CW.CategoriesEdit = CW.CategoriesNew
CW.CategoriesCreate = CW.CategoriesNew
CW.CategoriesUpdate = CW.CategoriesNew
