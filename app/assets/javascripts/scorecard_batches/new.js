CW.Scorecard_batchesNew = (() => {
  return {
    init,
    onChangeImportFile,
    onClickBtnRemoveFile
  }

  function init() {
    onChangeImportFile();
    onClickBtnRemoveFile();
  }

  function onClickBtnRemoveFile() {
    $(".btn-remove-file").on('click', function(e) {
      e.preventDefault();
      clearInputSelectFile();
      displaySelectInput();
    });
  }

  function clearInputSelectFile() {
    $('input[type=file]').val("");
  }

  function onChangeImportFile() {
    $("#importModals input:file").on('change', function () {
      let file = this.files[0];

      if (file.size > (150*1024*1024)) {
        clearInputSelectFile();

        return alert("The file is over 150 KB!");
      }

      $('.filename').html(file.name);
      $('.filesize').html(interpretFileSize(file.size));
      displayFile();
    });
  }

  function displayFile() {
    console.log("displayFile")

    $('.file-wrapper').addClass('d-none');
    $('.display-file').removeClass('d-none');

    $("#importModals .btn-primary").attr('disabled', false)
  }

  function displaySelectInput() {
    console.log("displaySelectInput")
    $('.file-wrapper').removeClass('d-none');
    $('.display-file').addClass('d-none');

    $("#importModals .btn-primary").attr('disabled', true)
  }

  function interpretFileSize(size) {
    switch (true) {
      case (size < 1024):
        return `${size} Bytes`;
      case (size < 1024*1024):
        return `${(size/1024).toFixed(2)} KB`
      default:
        return`${(size/(1024*1024)).toFixed(2)} MB`
    }
  }

})();
