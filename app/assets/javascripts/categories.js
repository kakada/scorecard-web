CW.CategoriesNew = (() => {
  return {
    init
  }

  function init() {
    onKeyupCategoryName()
    onKeyupCategoryCode()
  }

  function onKeyupCategoryName() {
    $(document).off('keyup', '#category_name')
    $(document).on('keyup', '#category_name', function(event) {
      let value = event.target.value.toUpperCase().split(" ").map(x => x.charAt(0)).join('')

      $('#category_code').val(value)
    });
  }

  function onKeyupCategoryCode() {
    $(document).off('keyup', '#category_code')
    $(document).on('keyup', '#category_code', function(event) {
      $(document).off('keyup', '#category_name');
    });
  }

})();


CW.CategoriesCreate = CW.CategoriesNew
CW.CategoriesEdit = CW.CategoriesNew
CW.CategoriesUpdate = CW.CategoriesNew
