# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

CW.Pdf_templatesNew = do ->
  init = ->
    initRichTextEditor()
    onClickTemplateField()

  onClickTemplateField =->
    $(document).off 'click', '.template-field'
    $(document).on 'click', '.template-field', (e) ->
      text = '{{' + $(this).data('code') + '}}'
      CW.Util.insertToTextbox($('.richText-editor')[0], text)

      e.preventDefault()

  initRichTextEditor = ->
    $('#pdf_template_content').richText
      bold: true
      italic: true
      underline: true
      leftAlign: true
      centerAlign: true
      rightAlign: true
      justify: true
      ol: true
      ul: true
      heading: true
      fonts: false
      fontList: [
        "Battambang-Bold",
        "Battambang-Regular"
      ],
      fontSize: true
      imageUpload: false
      fileUpload: false
      videoEmbed: false
      urls: false
      table: true
      removeStyles: true
      code: true
      fontColor: false
      colors: []
      translations:
        'title': 'Title'
        'white': 'White'
        'black': 'Black'
        'brown': 'Brown'
        'beige': 'Beige'
        'darkBlue': 'Dark Blue'
        'blue': 'Blue'
        'lightBlue': 'Light Blue'
        'darkRed': 'Dark Red'
        'red': 'Red'
        'darkGreen': 'Dark Green'
        'green': 'Green'
        'purple': 'Purple'
        'darkTurquois': 'Dark Turquois'
        'turquois': 'Turquois'
        'darkOrange': 'Dark Orange'
        'orange': 'Orange'
        'yellow': 'Yellow'
        'imageURL': 'Image URL'
        'fileURL': 'File URL'
        'linkText': 'Link text'
        'url': 'URL'
        'size': 'Size'
        'responsive': '<a href="https://www.jqueryscript.net/tags.php?/Responsive/">Responsive</a>'
        'text': 'Text'
        'openIn': 'Open in'
        'sameTab': 'Same tab'
        'newTab': 'New tab'
        'align': 'Align'
        'left': 'Left'
        'justify': 'Justify'
        'center': 'Center'
        'right': 'Right'
        'rows': 'Rows'
        'columns': 'Columns'
        'add': 'Add'
        'pleaseEnterURL': 'Please enter an URL'
        'pleaseSelectImage': 'Please select an image'
        'pleaseSelectFile': 'Please select a file'
        'bold': 'Bold'
        'italic': 'Italic'
        'underline': 'Underline'
        'alignLeft': 'Align left'
        'alignCenter': 'Align centered'
        'alignRight': 'Align right'
        'addOrderedList': 'Add ordered list'
        'addUnorderedList': 'Add unordered list'
        'addHeading': 'Add Heading/title'
        'addFont': 'Add font'
        'addFontColor': 'Add font color'
        'addFontSize': 'Add font size'
        'addImage': 'Add image'
        'addFile': 'Add file'
        'addURL': 'Add URL'
        'addTable': 'Add table'
        'removeStyles': 'Remove styles'
        'code': 'Show HTML code'
        'undo': 'Undo'
        'redo': 'Redo'
        'close': 'Close'
      youtubeCookies: false
      useSingleQuotes: false
      height: 0
      heightPercentage: 0
      id: ''
      class: ''
      useParagraph: false
      maxlength: 0
      callback: undefined

  { init: init }

CW.Pdf_templatesCreate = CW.Pdf_templatesNew
CW.Pdf_templatesEdit = CW.Pdf_templatesNew
CW.Pdf_templatesUpdate = CW.Pdf_templatesNew
