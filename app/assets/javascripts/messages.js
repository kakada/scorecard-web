CW.MessagesNew = (() => {
  return {
    init
  }

  function init() {
    initEmailEditor();
    onFormSubmit();
  }

  function initEmailEditor() {
    let input = document.querySelector('textarea[name="message[email_notification_attributes][emails]"]');

    new Tagify(input, {
      delimiters: ',| ',
      pattern: /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    });
  }

  function onFormSubmit() {
    $('#message-form').submit(() => {
      let emails = $('#notification-emails').val();

      if (emails.length) {
        let transformValue = JSON.parse(emails).map(x => x.value);
        $('#notification-emails').val(`{${transformValue.join(',')}}`);
      }
    });
  }

})();

CW.MessagesEdit = CW.MessagesNew
CW.MessagesCreate = CW.MessagesNew
CW.MessagesUpdate = CW.MessagesNew
