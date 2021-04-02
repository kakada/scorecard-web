CW.MessagesNew = (() => {
  return {
    init
  }

  function init() {
    initEmailEditor();
    onFormSubmit();
    onClickTemplateField();
  }

  function onClickTemplateField() {
    $(".template-field").on('click', function(e) {
      let text = '{{' + $(this).data('code') + '}}';
      CW.Util.insertToTextArea('message_content', text);
      e.preventDefault();
    });
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
