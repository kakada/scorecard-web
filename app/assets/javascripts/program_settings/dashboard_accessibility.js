CW.DashboardAccessibility = (() => {
  return {
    initTagEmails,
    onSubmitForm
  }

  function initTagEmails() {
    var inputEmail = document.getElementById('userEmails');

    new Tagify(inputEmail, {
      enforceWhitelist: true,
      whitelist: $('[data-emails]').data('emails'),
      dropdown: { maxItems: 20, classname: "tags-look", enabled: 0, closeOnSelect: false }
    });
  }

  function onSubmitForm() {
    $('.dashboard-form').submit(()=> {
      assignUserEmails();
      assignUserRoles();
    });
  }

  function assignUserEmails() {
    let inputEmail = $('#userEmails');

    if (inputEmail.val().length) {
      let transformValue = JSON.parse(inputEmail.val()).map(x => x.value);
      inputEmail.val(`{${transformValue.join(',')}}`);
    }
  }

  function assignUserRoles() {
    let roles = $( ".role :checkbox:checked" ).map( function() {
      return this.id }
    ).get().join();

    $('#userRoles').val(`{${roles}}`);
  }
})();
