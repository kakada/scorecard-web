// JAAP Spreadsheet - Excel-like dynamic form
class JaapSpreadsheet {
  constructor(tableId, fieldDefinitions, rowsData) {
    this.table = document.getElementById(tableId);
    this.fieldDefinitions = fieldDefinitions || [];
    this.rowsData = rowsData || [];
    this.currentCell = null;
    this.rows = [];
  }

  init() {
    this.renderHeaders();
    this.renderRows();
    this.attachEventListeners();
    this.setupKeyboardNavigation();
  }

  renderHeaders() {
    const headerRow = document.getElementById('jaap-header-row');
    if (!headerRow) return;

    // Add headers for each field
    this.fieldDefinitions.forEach(field => {
      const th = document.createElement('th');
      th.textContent = field.label;
      th.dataset.fieldKey = field.key;
      if (field.required) {
        th.innerHTML += ' <span class="text-danger">*</span>';
      }
      headerRow.appendChild(th);
    });

    // Add action column
    const actionTh = document.createElement('th');
    actionTh.textContent = 'Actions';
    actionTh.style.width = '100px';
    headerRow.appendChild(actionTh);
  }

  renderRows() {
    const tbody = document.getElementById('jaap-body');
    if (!tbody) return;

    tbody.innerHTML = '';

    if (this.rowsData.length === 0) {
      this.addRow();
    } else {
      this.rowsData.forEach((rowData, index) => {
        this.addRow(rowData, index);
      });
    }
  }

  addRow(data = {}, index = null) {
    const tbody = document.getElementById('jaap-body');
    if (!tbody) return;

    const rowIndex = index !== null ? index : tbody.children.length;
    const tr = document.createElement('tr');
    tr.dataset.rowIndex = rowIndex;

    // Row number cell
    const rowNumberTd = document.createElement('td');
    rowNumberTd.className = 'row-number text-center';
    rowNumberTd.textContent = rowIndex + 1;
    tr.appendChild(rowNumberTd);

    // Field cells
    this.fieldDefinitions.forEach(field => {
      const td = document.createElement('td');
      td.dataset.fieldKey = field.key;
      td.dataset.fieldType = field.type;
      
      const value = data[field.key] || '';
      const input = this.createInput(field, value, rowIndex);
      
      td.appendChild(input);
      tr.appendChild(td);
    });

    // Action cell
    const actionTd = document.createElement('td');
    actionTd.className = 'text-center';
    const deleteBtn = document.createElement('button');
    deleteBtn.type = 'button';
    deleteBtn.className = 'btn btn-sm btn-danger delete-row-btn';
    deleteBtn.innerHTML = '<i class="fas fa-trash"></i>';
    deleteBtn.onclick = () => this.deleteRow(rowIndex);
    actionTd.appendChild(deleteBtn);
    tr.appendChild(actionTd);

    tbody.appendChild(tr);
    this.rows.push(tr);
  }

  createInput(field, value, rowIndex) {
    let input;
    const baseAttrs = {
      'data-field-key': field.key,
      'data-row-index': rowIndex,
      class: 'form-control form-control-sm jaap-cell-input'
    };

    switch (field.type) {
      case 'textarea':
        input = document.createElement('textarea');
        input.rows = 2;
        Object.assign(input, baseAttrs);
        input.value = value;
        break;

      case 'select':
        input = document.createElement('select');
        Object.assign(input, baseAttrs);
        
        // Add empty option
        const emptyOption = document.createElement('option');
        emptyOption.value = '';
        emptyOption.textContent = '-- Select --';
        input.appendChild(emptyOption);

        // Add options
        if (field.options) {
          field.options.forEach(option => {
            const opt = document.createElement('option');
            opt.value = option;
            opt.textContent = option;
            if (value === option) {
              opt.selected = true;
            }
            input.appendChild(opt);
          });
        }
        break;

      case 'date':
        input = document.createElement('input');
        input.type = 'date';
        Object.assign(input, baseAttrs);
        input.value = value;
        break;

      case 'number':
        input = document.createElement('input');
        input.type = 'number';
        Object.assign(input, baseAttrs);
        input.value = value;
        break;

      case 'text':
      default:
        input = document.createElement('input');
        input.type = 'text';
        Object.assign(input, baseAttrs);
        input.value = value;
        break;
    }

    if (field.required) {
      input.required = true;
    }

    return input;
  }

  deleteRow(rowIndex) {
    const tbody = document.getElementById('jaap-body');
    if (!tbody) return;

    const rows = Array.from(tbody.children);
    if (rows.length <= 1) {
      this.showNotification('Cannot delete the last row. At least one row is required.', 'warning');
      return;
    }

    const row = rows.find(r => parseInt(r.dataset.rowIndex) === rowIndex);
    if (row) {
      row.remove();
      this.renumberRows();
    }
  }

  renumberRows() {
    const tbody = document.getElementById('jaap-body');
    if (!tbody) return;

    Array.from(tbody.children).forEach((row, index) => {
      row.dataset.rowIndex = index;
      const rowNumberCell = row.querySelector('.row-number');
      if (rowNumberCell) {
        rowNumberCell.textContent = index + 1;
      }
      
      // Update data-row-index on inputs
      row.querySelectorAll('.jaap-cell-input').forEach(input => {
        input.dataset.rowIndex = index;
      });
    });
  }

  attachEventListeners() {
    const addRowBtn = document.getElementById('add-row-btn');
    if (addRowBtn) {
      addRowBtn.addEventListener('click', () => this.addRow());
    }

    const saveBtn = document.getElementById('save-jaap-btn');
    if (saveBtn) {
      saveBtn.addEventListener('click', (e) => this.serializeData());
    }

    const form = this.table.closest('form');
    if (form) {
      form.addEventListener('submit', (e) => {
        this.serializeData();
      });
    }
  }

  setupKeyboardNavigation() {
    const tbody = document.getElementById('jaap-body');
    if (!tbody) return;

    tbody.addEventListener('keydown', (e) => {
      const target = e.target;
      if (!target.classList.contains('jaap-cell-input')) return;

      const td = target.closest('td');
      const tr = td.closest('tr');

      switch (e.key) {
        case 'Tab':
          if (!e.shiftKey) {
            // Tab - move to next cell
            const nextTd = td.nextElementSibling;
            if (nextTd && nextTd.querySelector('.jaap-cell-input')) {
              e.preventDefault();
              nextTd.querySelector('.jaap-cell-input').focus();
            }
          } else {
            // Shift+Tab - move to previous cell
            const prevTd = td.previousElementSibling;
            if (prevTd && prevTd.querySelector('.jaap-cell-input')) {
              e.preventDefault();
              prevTd.querySelector('.jaap-cell-input').focus();
            }
          }
          break;

        case 'ArrowRight':
          if (target.selectionStart === target.value.length) {
            const nextTd = td.nextElementSibling;
            if (nextTd && nextTd.querySelector('.jaap-cell-input')) {
              nextTd.querySelector('.jaap-cell-input').focus();
            }
          }
          break;

        case 'ArrowLeft':
          if (target.selectionStart === 0) {
            const prevTd = td.previousElementSibling;
            if (prevTd && prevTd.querySelector('.jaap-cell-input')) {
              prevTd.querySelector('.jaap-cell-input').focus();
            }
          }
          break;

        case 'ArrowDown':
          const nextTr = tr.nextElementSibling;
          if (nextTr) {
            const cellIndex = Array.from(tr.children).indexOf(td);
            const nextCell = nextTr.children[cellIndex];
            if (nextCell && nextCell.querySelector('.jaap-cell-input')) {
              nextCell.querySelector('.jaap-cell-input').focus();
            }
          }
          break;

        case 'ArrowUp':
          const prevTr = tr.previousElementSibling;
          if (prevTr) {
            const cellIndex = Array.from(tr.children).indexOf(td);
            const prevCell = prevTr.children[cellIndex];
            if (prevCell && prevCell.querySelector('.jaap-cell-input')) {
              prevCell.querySelector('.jaap-cell-input').focus();
            }
          }
          break;

        case 'Enter':
          if (target.tagName !== 'TEXTAREA') {
            e.preventDefault();
            const nextTr = tr.nextElementSibling;
            if (nextTr) {
              const cellIndex = Array.from(tr.children).indexOf(td);
              const nextCell = nextTr.children[cellIndex];
              if (nextCell && nextCell.querySelector('.jaap-cell-input')) {
                nextCell.querySelector('.jaap-cell-input').focus();
              }
            } else {
              // Add new row if at the end
              this.addRow();
              setTimeout(() => {
                const newRow = tbody.lastElementChild;
                const firstInput = newRow.querySelector('.jaap-cell-input');
                if (firstInput) firstInput.focus();
              }, 50);
            }
          }
          break;
      }
    });
  }

  serializeData() {
    const tbody = document.getElementById('jaap-body');
    if (!tbody) return;

    const rows = [];
    Array.from(tbody.children).forEach(tr => {
      const rowData = {};
      tr.querySelectorAll('.jaap-cell-input').forEach(input => {
        const fieldKey = input.dataset.fieldKey;
        rowData[fieldKey] = input.value;
      });
      rows.push(rowData);
    });

    // Set the serialized data to hidden fields
    const fieldDefinitionsInput = document.getElementById('field-definitions-input');
    const rowsDataInput = document.getElementById('rows-data-input');

    if (fieldDefinitionsInput) {
      fieldDefinitionsInput.value = JSON.stringify(this.fieldDefinitions);
    }

    if (rowsDataInput) {
      rowsDataInput.value = JSON.stringify(rows);
    }

    return rows;
  }

  validate() {
    const tbody = document.getElementById('jaap-body');
    if (!tbody) return true;

    let isValid = true;
    const errors = [];

    Array.from(tbody.children).forEach((tr, rowIndex) => {
      tr.querySelectorAll('.jaap-cell-input').forEach(input => {
        input.classList.remove('is-invalid');
        
        if (input.required && !input.value.trim()) {
          input.classList.add('is-invalid');
          isValid = false;
          
          const fieldKey = input.dataset.fieldKey;
          const field = this.fieldDefinitions.find(f => f.key === fieldKey);
          errors.push(`Row ${rowIndex + 1}: ${field ? field.label : fieldKey} is required`);
        }
      });
    });

    if (!isValid) {
      this.showNotification('Please fill in all required fields. Check highlighted cells.', 'danger');
      // Scroll to first error
      const firstInvalidInput = tbody.querySelector('.is-invalid');
      if (firstInvalidInput) {
        firstInvalidInput.scrollIntoView({ behavior: 'smooth', block: 'center' });
        firstInvalidInput.focus();
      }
    }

    return isValid;
  }

  showNotification(message, type = 'info') {
    // Create notification element
    const notification = document.createElement('div');
    notification.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
    notification.style.cssText = 'top: 80px; right: 20px; z-index: 9999; max-width: 400px;';
    notification.setAttribute('role', 'alert');
    
    notification.innerHTML = `
      ${message}
      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
    `;

    document.body.appendChild(notification);

    // Auto-dismiss after 5 seconds
    setTimeout(() => {
      if (notification.parentNode) {
        notification.classList.remove('show');
        setTimeout(() => notification.remove(), 150);
      }
    }, 5000);
  }
}

// Make it globally available
window.JaapSpreadsheet = JaapSpreadsheet;
