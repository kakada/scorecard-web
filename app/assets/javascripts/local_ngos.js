CW.Local_ngosNew = (() => {
  var provinces = [];

  return {
    init
  }

  function init() {
    assignProvinces();
    assignTargetProvinceToTagsInput();
    initTagify();
  }

  function assignProvinces() {
    provinces = $('input[name=tags]').data('collection').map(x => ({"value": x.id, "name": x.name_km}));
  }

  function assignTargetProvinceToTagsInput() {
    var selectedProvinces = $("#local_ngo_target_province_ids").val().split(',');
    var data = provinces.filter(pro => selectedProvinces.includes(pro.value));

    $('input[name=tags]').val(JSON.stringify(data))
  }

  function initTagify() {
    var tagify = new Tagify($('input[name=tags]')[0], {
      enforceWhitelist: true,
      skipInvalid: true,
      dropdown: {
        closeOnSelect: false,
        enabled: 0,
        maxItems: 25,
        classname: 'provinces-list',
        searchKeys: ['name']
      },
      templates: {
        tag: tagTemplate,
        dropdownItem: suggestionItemTemplate
      },
      whitelist: provinces
    })

    tagify.on('remove', assignDataToInputTargetProvince);
    tagify.on('add', assignDataToInputTargetProvince);
  }

  function assignDataToInputTargetProvince(e) {
    var data = $("tag").map((i, dom) => $(dom).attr('value')).toArray().join(',');

    $("#local_ngo_target_province_ids").val(data);
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

})();

CW.Local_ngosCreate = CW.Local_ngosNew
CW.Local_ngosEdit = CW.Local_ngosNew
CW.Local_ngosUpdate = CW.Local_ngosNew
