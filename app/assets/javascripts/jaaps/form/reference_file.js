CW.JaapReferenceFile = (() => {
  const MAX_FILE_SIZE_MB = 5; // Must match JaapReferenceUploader::MAX_FILE_SIZE_MB
  var tr;

  return {
    init: init
  };

  function init(translations) {
    tr = translations;
    onClickRemoveReference();
    onFileInputChange();
  }

  function onClickRemoveReference() {
    // remove existing file
    $(document).on("click", ".js-remove-reference", function () {
      var wrapper = $(this).closest(".reference-wrapper")

      wrapper.find(".reference-existing").addClass("d-none")
      wrapper.find(".reference-input").val("").removeClass("d-none")

      wrapper.find("input[name*='[remove_reference]']").val("1")

      // IMPORTANT: clear file input value
      var fileInput = wrapper.find(".js-reference-input")
      fileInput.val("")

      wrapper.find(".reference-filename").text("")
    })
  }

  function onFileInputChange() {
    // file selected (NEW form fix)
    $(document).on("change", ".js-reference-input", function () {
      var wrapper = $(this).closest(".reference-wrapper")
      var file = this.files && this.files.length > 0 ? this.files[0] : null

      if (!file) return

      // Check file size limit (must match JaapReferenceUploader::MAX_FILE_SIZE_MB)
      var maxSizeBytes = MAX_FILE_SIZE_MB * 1024 * 1024
      if (file.size > maxSizeBytes) {
        var defaultErrorMsg = `File size exceeds ${MAX_FILE_SIZE_MB}MB limit. Please choose a smaller file.`
        var errorMsg = (tr && tr.file_size_error) || defaultErrorMsg
        alert(errorMsg)
        $(this).val("") // Clear the file input
        return
      }

      var fileName = file.name

      // Add icon based on file extension
      var icon = getFileTypeIcon(fileName)
      wrapper.find(".reference-filename").html(icon + ' ' + fileName)
      wrapper.find(".reference-existing").removeClass("d-none")
      wrapper.find(".reference-input").addClass("d-none")

      // user selected a new file → ensure we are NOT removing it
      wrapper.find("input[name*='[remove_reference]']").val("0")
    })
  }

  function getFileTypeIcon(filename) {
    if (!filename) return '<i class="fas fa-file"></i>'

    var parts = filename.split('.')
    var extension = parts.length > 1 ? parts.pop().toLowerCase() : ''

    switch (extension) {
      case 'pdf':
        return '<i class="fas fa-file-pdf text-danger"></i>'
      case 'xls':
      case 'xlsx':
        return '<i class="fas fa-file-excel text-success"></i>'
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return '<i class="fas fa-file-image text-primary"></i>'
      default:
        return '<i class="fas fa-file"></i>'
    }
  }
})();
