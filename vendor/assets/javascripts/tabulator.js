/**
 * Simple Tabulator-like library for JAAP spreadsheet functionality
 * MIT-compatible implementation
 */
(function(window) {
  'use strict';

  // HTML escape function to prevent XSS
  function escapeHtml(text) {
    var div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }

  function Tabulator(selector, options) {
    this.element = typeof selector === 'string' ? document.querySelector(selector) : selector;
    this.options = options || {};
    this.data = options.data || [];
    this.columns = options.columns || [];
    this.init();
  }

  Tabulator.prototype.init = function() {
    this.element.classList.add('tabulator');
    this.render();
  };

  Tabulator.prototype.render = function() {
    var html = '<table class="table table-bordered table-sm">';
    
    // Header
    html += '<thead><tr>';
    this.columns.forEach(function(col) {
      html += '<th>' + escapeHtml(col.title || '') + '</th>';
    });
    html += '<th style="width: 80px;">Actions</th>';
    html += '</tr></thead>';
    
    // Body
    html += '<tbody>';
    var self = this;
    this.data.forEach(function(row, index) {
      html += '<tr data-row-index="' + index + '">';
      self.columns.forEach(function(col) {
        var value = row[col.field] || '';
        if (col.editor === 'select') {
          html += '<td>';
          html += '<select class="form-control form-control-sm" data-field="' + escapeHtml(col.field) + '">';
          html += '<option value="">Select...</option>';
          (col.editorParams.values || []).forEach(function(opt) {
            var selected = value === opt ? 'selected' : '';
            html += '<option value="' + escapeHtml(opt) + '" ' + selected + '>' + escapeHtml(opt) + '</option>';
          });
          html += '</select>';
          html += '</td>';
        } else {
          html += '<td><input type="text" class="form-control form-control-sm" data-field="' + escapeHtml(col.field) + '" value="' + escapeHtml(value) + '"></td>';
        }
      });
      html += '<td><button type="button" class="btn btn-sm btn-danger delete-row" data-row-index="' + index + '">Delete</button></td>';
      html += '</tr>';
    });
    html += '</tbody>';
    html += '</table>';
    
    this.element.innerHTML = html;
    this.attachEvents();
  };
  };

  Tabulator.prototype.attachEvents = function() {
    var self = this;
    
    // Delete row buttons
    var deleteButtons = this.element.querySelectorAll('.delete-row');
    deleteButtons.forEach(function(btn) {
      btn.addEventListener('click', function() {
        var index = parseInt(this.getAttribute('data-row-index'));
        self.data.splice(index, 1);
        self.render();
      });
    });
    
    // Update data on input change
    var inputs = this.element.querySelectorAll('input, select');
    inputs.forEach(function(input) {
      input.addEventListener('change', function() {
        var row = this.closest('tr');
        var rowIndex = parseInt(row.getAttribute('data-row-index'));
        var field = this.getAttribute('data-field');
        if (self.data[rowIndex]) {
          self.data[rowIndex][field] = this.value;
        }
      });
    });
  };

  Tabulator.prototype.addRow = function(rowData) {
    this.data.push(rowData || {});
    this.render();
  };

  Tabulator.prototype.getData = function() {
    // Collect current values from inputs
    var self = this;
    var rows = this.element.querySelectorAll('tbody tr');
    rows.forEach(function(row, index) {
      var inputs = row.querySelectorAll('input, select');
      inputs.forEach(function(input) {
        var field = input.getAttribute('data-field');
        self.data[index][field] = input.value;
      });
    });
    return this.data;
  };

  // Export to global scope
  window.Tabulator = Tabulator;

})(window);
