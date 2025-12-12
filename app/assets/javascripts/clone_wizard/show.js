
CW.Clone_wizardShow = (() => {
  return {
    init: init
  }

  function init() {
    initSelectMethodStep();
    initChooseComponentStep();
  }

  function initChooseComponentStep() {
    if($('[data-step="choose_component"]').length == 0) { return; }

    function updateNextButton() {
      var anyChecked = $('.component-checkbox:checked').length > 0;
      $('#btn-next-components').prop('disabled', !anyChecked);
    }

    function updateSelectAllCheckbox() {
      var total = $('.component-checkbox').length;
      var checked = $('.component-checkbox:checked').length;
      $('#select_all').prop('checked', total > 0 && total === checked);
    }

    // Select all toggle
    $('#select_all').on('change', function() {
      var checked = $(this).is(':checked');
      $('.component-checkbox').prop('checked', checked).trigger('change');
    });

    // Individual checkbox changes
    $(document).on('change', '.component-checkbox', function() {
      updateSelectAllCheckbox();
      updateNextButton();
      var $card = $(this).closest('.option-component');
      if ($(this).is(':checked')) {
        $card.addClass('border-primary shadow-sm');
      } else {
        $card.removeClass('border-primary shadow-sm');
      }
    });

    // Click on card toggles checkbox (except when clicking inputs/links)
    $(document).on('click', '.option-component', function(e) {
      if ($(e.target).is('input, a')) return;
      var $checkbox = $(this).find('.component-checkbox');
      $checkbox.prop('checked', !$checkbox.is(':checked')).trigger('change');
    }).on('keypress', '.option-component', function(e) {
      if (e.which === 13 || e.which === 32) { e.preventDefault(); $(this).click(); }
    });

    // Initialize state
    updateSelectAllCheckbox();
    updateNextButton();
  }

  function initSelectMethodStep() {
    if($('[data-step="select_method"]').length == 0) {
      return;
    }

    // Handle card click
    $('.option-card').on('click', function() {
      var method = $(this).data('method');
      $('#clone_method_' + method).prop('checked', true).trigger('change');
    });

    // Handle radio button change
    $('input[name="clone_method"]').on('change', function() {
      var method = $(this).val();
      if (method === 'program') {
        $('#program_selection_wrapper').slideDown();
        updateNextButton();
      } else {
        $('#program_selection_wrapper').slideUp();
        $('#btn-next-method').prop('disabled', false);
      }
    });

    // Handle source program selection
    $('#source_program_id').on('change', function() {
      updateNextButton();
    });

    function updateNextButton() {
      var method = $('input[name="clone_method"]:checked').val();
      if (method === 'program') {
        var programSelected = $('#source_program_id').val() !== '';
        $('#btn-next-method').prop('disabled', !programSelected);
      } else {
        $('#btn-next-method').prop('disabled', false);
      }
    }

    // Initialize state
    updateNextButton();
  }

})();
