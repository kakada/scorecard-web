CW.TemplatesNew = do ->
  init = ->
    initSortable()

    onRemoveAudio()
    onChangeAudio()

    onClickAddField()
    onClickRemoveField()

    onClickBtnAdd()
    onClickCollapseTrigger()
    onClickCollapseAllTrigger()

  onClickCollapseAllTrigger = ->
    $('.btn-collapse-all-trigger').on 'click', (e) =>
      $(e.currentTarget).find('i').toggleClass('fa-caret-right fa-caret-down');
      showAll = $(e.currentTarget).find('i').hasClass('fa-caret-down');

      if showAll
        $('.fieldset').find('.collapse-trigger i').removeClass('fa-caret-right').addClass('fa-caret-down')
        $('.fieldset').find('.collapse-content').show()
      else
        $('.fieldset').find('.collapse-trigger i').removeClass('fa-caret-down').addClass('fa-caret-right')
        $('.fieldset').find('.collapse-content').hide()

  initSortable = ->
    $(document).find('ol.fields.sortable').sortable
      handle: '.btn-move'
      onDrop: ($item, container, _super) ->
        animateListItems($item, container, _super)
        assignDisplayOrderToListItem()

  assignDisplayOrderToListItem = ->
    $('ol.fields li').each (index)->
      $(this).find('.display-order').val(index)

  animateListItems = ($item, container, _super) ->
    $clonedItem = $('<li/>').css(height: 0)
    $item.before $clonedItem
    $clonedItem.animate 'height': $item.height()
    $item.animate $clonedItem.position(), ->
      $clonedItem.detach()
      _super $item, container
    return

  onClickBtnAdd = ->
    $(document).off('click', '.btn-add-field')
    $(document).on 'click', '.btn-add-field', (event) ->
      $(this).parent().hide()
      parent = $(event.currentTarget).parents('.fieldset')

      parent.find('.field-name').addClass('no-style as-title')
      parent.find('.field-name').parent().removeClass('pl-3')
      parent.find('.field-tag').addClass('no-style as-tag')

      parent.find('.collapse-trigger').removeClass('d-none').click()
      parent.find('.btn-move').removeClass('d-none')

  onClickCollapseTrigger = ->
    $(document).off('click', '.collapse-trigger')
    $(document).on 'click', '.collapse-trigger', (e) =>
      dom = e.currentTarget
      content = $(dom).parents('.fieldset').find('.collapse-content')
      icon = $(dom).find('i')

      content.toggle()

      if $(content).is(":visible")
        icon.removeClass('fa-caret-right').addClass('fa-caret-down')
      else
        icon.removeClass('fa-caret-down').addClass('fa-caret-right')

  onRemoveAudio = ->
    $(document).on 'click', '.remove-audio', (e) =>
      wrapper = $(e.target).parents('.audio-wrapper')

      wrapper.find('.audio-input').parent().removeClass('d-none')
      wrapper.find('.audio-input-destroy').val(1)
      wrapper.find('.remove-audio-wrapper').hide()

  onChangeAudio = ->
    $(document).on 'change', '.audio-input', (e) =>
      wrapper = $(e.target).parents('.audio-wrapper')
      !!wrapper.find('.audio-input-destroy') && wrapper.find('.audio-input-destroy').val(0)

  onClickAddField = ->
    $('form .add_indicators').off('click')
    $('form .add_indicators').on 'click', (event) ->
      event.preventDefault()
      appendField(this)

  appendField = (dom) ->
    time = new Date().getTime()
    regexp = new RegExp($(dom).data('id'), 'g')
    $(dom).before($(dom).data('fields').replace(regexp, time))

  onClickRemoveField = ->
    $(document).on 'click', 'form .remove_fields', (event) ->
      event.preventDefault()
      removeField(this)

  removeField = (dom)->
    $(dom).parent().find('input[type=hidden]').val('1')
    $(dom).closest('fieldset').hide()

  { init: init }

CW.TemplatesCreate = CW.TemplatesNew
CW.TemplatesEdit = CW.TemplatesNew
CW.TemplatesUpdate = CW.TemplatesNew
