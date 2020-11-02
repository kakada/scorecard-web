CW.Local_ngosNew = (() => {
  var addAllSuggestionsElm;
  var tagify;
  var provinces;

  return { init }

  function init() {
    assignTargetProvinceToTags();
    initTagify();
  }

  function assignTargetProvinceToTags() {
    var provinces = $('input[name=tags]').data('collection').map(x => ({"value": x.id, "name": x.name_km}));
    var selectedProvinces = $("#local_ngo_target_province_ids").val().split(',');
    var data = provinces.filter(pro => selectedProvinces.includes(pro.value));

    $('input[name=tags]').val(JSON.stringify(data))
  }

  function initTagify() {
    var provinces = $('input[name=tags]').data('collection').map(x => ({"value": x.id, "name": x.name_km}));

    tagify = new Tagify($('input[name=tags]')[0], {
      enforceWhitelist: true,
      skipInvalid: true, // do not remporarily add invalid tags
      dropdown: {
        closeOnSelect: false,
        enabled: 0,
        maxItems: 25,
        classname: 'provinces-list',
        searchKeys: ['name']  // very important to set by which keys to search for suggesttions when typing
      },
      templates: {
        tag: tagTemplate,
        dropdownItem: suggestionItemTemplate
      },
      whitelist: provinces
    })

    tagify.on('dropdown:show dropdown:updated', onDropdownShow)
    tagify.on('dropdown:select', onSelectSuggestion)
    tagify.on('remove', function(e) {
      assignDataToInputTargetProvince();
    });

    tagify.on('add', function(e) {
      assignDataToInputTargetProvince();
    });
  }

  function assignDataToInputTargetProvince() {
    var data = $("tag").map((i, dom) => $(dom).attr('value')).toArray();

    $("#local_ngo_target_province_ids").val(data.join(','));
  }

  function tagTemplate(tagData){
    return `
        <tag title="${(tagData.title || tagData.email)}"
                contenteditable='false'
                spellcheck='false'
                tabIndex="-1"
                class="${this.settings.classNames.tag} ${tagData.class ? tagData.class : ""}"
                ${this.getAttributes(tagData)}>
            <x title='' class='tagify__tag__removeBtn' role='button' aria-label='remove tag'></x>
            <div>
                <span class='tagify__tag-text'>${tagData.name}</span>
            </div>
        </tag>
    `
  }

  function suggestionItemTemplate(tagData){
    return `
        <div ${this.getAttributes(tagData)}
            class='tagify__dropdown__item ${tagData.class ? tagData.class : ""}'
            tabindex="0"
            role="option">
            <strong>${tagData.name}</strong>
        </div>
    `
  }

  function onDropdownShow(e){
    var dropdownContentElm = e.detail.tagify.DOM.dropdown.content;

    if( tagify.suggestedListItems.length > 1 ) {
      addAllSuggestionsElm = getAddAllSuggestionsElm();

      // insert "addAllSuggestionsElm" as the first element in the suggestions list
      dropdownContentElm.insertBefore(addAllSuggestionsElm, dropdownContentElm.firstChild)
    }
  }

  function onSelectSuggestion(e){
    if( e.detail.elm == addAllSuggestionsElm ) {
      tagify.dropdown.selectAll.call(tagify);
      assignDataToInputTargetProvince();
    }
  }

  // create a "add all" custom suggestion element every time the dropdown changes
  function getAddAllSuggestionsElm(){
    // suggestions items should be based on "dropdownItem" template
    return tagify.parseTemplate('dropdownItem', [{
        class: "addAll",
        name: "Add all"
      }]
    )
  }

})();

CW.Local_ngosCreate = CW.Local_ngosNew
CW.Local_ngosEdit = CW.Local_ngosNew
CW.Local_ngosUpdate = CW.Local_ngosNew
