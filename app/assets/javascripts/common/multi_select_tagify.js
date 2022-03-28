// MultipleSelect tool dom structure

// %div{'data-toggle' => 'multiSelect'}
//   / Trigger
//   %div.tooltips{'data-toggle' => 'tooltip'}
//     / Require hidden-input class
//     %input.hidden-input{ name: 'province_ids', type: :hidden, value: params[:province_ids] }

//     / Require div for display
//     .form-control.text-truncate{'data-toggle' => 'modal', 'data-target' => '#provinceModal', 'data-placeholder' => t('scorecard.any_province'), 'data-display-text' => t('scorecard.n_province_selected')}

//   / Modal
//   #provinceModal.modal.fade{"aria-hidden" => "true", "aria-labelledby" => "exampleModalLabel", :role => "dialog", :tabindex => "-1"}
//     .modal-dialog{:role => "document"}
//       .modal-content
//         .modal-body
//           - list = Pumi::Province.all.map{|p| {value: p.id, name: p["name_#{I18n.locale}"]}}

//           / Require tagify-input class
//           %input.tagify-input{ placeholder: t('scorecard.input_province_name'), 'data-list' => list.to_json }

//         .modal-footer
//           / Require btn-save class
//           %button.btn.btn-primary.btn-save{"data-dismiss" => "modal", :type => "button"}= t('shared.save')

class MultiSelectTagify {
  constructor(wrapper) {
    this.tagifyInput = $(wrapper).find('.tagify-input');
    this.hiddenInput = $(wrapper).find('.hidden-input');
    this.tooltip = $(wrapper).find('.tooltips');
    this.btnSave = $(wrapper).find('.btn-save');
  }

  init() {
    this.assignTagifyInputData();
    this.assignDisplayContent();
    this.initTagify();

    this.onClickBtnSave();
  }

  onClickBtnSave() {
    let self = this;

    $(this.btnSave).on('click', function() {
      self.assignDisplayContent();
      self.assignHiddenInputData();
    })
  }

  assignTagifyInputData() {
    var selectedValues = (this.hiddenInput.val() || '').split(',');
    var selectedObjects = this.whiteListData().filter(pro => selectedValues.includes(`${pro.value}`));

    return this.tagifyInput.val(JSON.stringify(selectedObjects));
  }

  whiteListData() {
    return this.tagifyInput.data('list');
  }

  assignDisplayContent() {
    var data = this.tagifyData();
    var tooltipTitle = '';
    var displayText = this.tooltip.find('div').data('placeholder');

    if (data.length == 1) {
      displayText = data[0].name;
    } else if (data.length > 1) {
      tooltipTitle = data.map(d => d.name).join(', ');
      displayText = this.tooltip.find('div').data('displayText').replace('n', data.length);
    }

    this.setDisplay(displayText);
    this.setTooltip(tooltipTitle);
  }

  tagifyData() {
    return JSON.parse(this.tagifyInput.val() || '[]');
  }

  assignHiddenInputData() {
    return this.hiddenInput.val(this.tagifyData().map(d => d.value));
  }

  setDisplay(content) {
    return this.tooltip.find('div').html(content);
  }

  setTooltip(title) {
    return this.tooltip.attr('data-original-title', title)
  }

  initTagify() {
    var tagify = new Tagify(this.tagifyInput[0], {
      enforceWhitelist: true,
      skipInvalid: true,
      dropdown: {
        closeOnSelect: false,
        enabled: 0,
        maxItems: 25,
        searchKeys: ['name']
      },
      templates: {
        tag: this.tagTemplate,
        dropdownItem: this.suggestionItemTemplate
      },
      whitelist: this.whiteListData()
    })

    return tagify;
  }

  tagTemplate(tagData){
    return `
        <tag title="${(tagData.title)}"
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

  suggestionItemTemplate(tagData){
    return `
        <div ${this.getAttributes(tagData)}
            class='tagify__dropdown__item ${tagData.class ? tagData.class : ""}'
            tabindex="0"
            role="option">
            <strong>${tagData.name}</strong>
        </div>
    `
  }
};
