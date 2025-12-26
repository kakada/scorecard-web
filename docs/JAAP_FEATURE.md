# JAAP - Join Accountable Action Plan

## Overview

The JAAP (Join Accountable Action Plan) feature provides a dynamic, Excel-like spreadsheet interface for creating and managing action plans. The form supports dynamic field configurations, inline editing, keyboard navigation, and flexible data management.

## Features

### Core Functionality
- **Dynamic Fields**: Form fields are defined by configuration (not hard-coded)
- **Excel-like Interface**: Table-based UI with editable cells
- **Inline Editing**: Edit values directly in cells without separate forms
- **Row Management**: Add/remove rows dynamically
- **Field Types**: Support for text, textarea, number, date, and select fields
- **Keyboard Navigation**: Navigate with Tab, Arrow keys, and Enter like Excel
- **Data Serialization**: Collects data as an array of row objects

### User Interface
- Responsive table layout
- Column headers from field definitions
- Row numbering
- Delete button per row
- Add row button
- Visual feedback for required fields
- Form validation

## Architecture

### Backend

#### Models
- **Jaap** (`app/models/jaap.rb`)
  - Belongs to Program and User
  - Optionally belongs to Scorecard
  - Stores field definitions and row data as JSONB
  - Validates title, uuid, and field_definitions
  - Generates UUID automatically

#### Controllers
- **JaapsController** (`app/controllers/jaaps_controller.rb`)
  - Standard CRUD actions (index, show, new, create, edit, update, destroy)
  - Complete action to mark JAAP as completed
  - JSON API support

#### Policies
- **JaapPolicy** (`app/policies/jaap_policy.rb`)
  - Authorization rules for different user roles
  - Program-based access control

### Frontend

#### JavaScript
- **JaapSpreadsheet** (`app/assets/javascripts/jaaps/spreadsheet.js`)
  - Excel-like spreadsheet component
  - Dynamic row rendering
  - Keyboard navigation
  - Data serialization
  - Field validation

#### Styles
- **spreadsheet.scss** (`app/assets/stylesheets/jaaps/spreadsheet.scss`)
  - Table styling
  - Responsive design
  - Input field styling
  - Visual feedback

## Field Configuration

### Default Field Definitions

The default JAAP form includes the following fields:

```ruby
[
  { key: 'issue', label: 'Issue/Problem', type: 'text', required: true },
  { key: 'root_cause', label: 'Root Cause', type: 'textarea', required: true },
  { key: 'action', label: 'Action', type: 'text', required: true },
  { key: 'responsible_person', label: 'Responsible Person', type: 'text', required: true },
  { key: 'deadline', label: 'Deadline', type: 'date', required: true },
  { key: 'budget', label: 'Budget', type: 'number', required: false },
  { key: 'status', label: 'Status', type: 'select', options: ['Not Started', 'In Progress', 'Completed', 'Delayed'], required: true }
]
```

### Field Types

- **text**: Single-line text input
- **textarea**: Multi-line text input
- **number**: Numeric input
- **date**: Date picker
- **select**: Dropdown with predefined options

### Custom Field Configuration

To customize fields for a specific JAAP:

```ruby
jaap = Jaap.new(
  title: "Custom Action Plan",
  field_definitions: [
    { key: 'task', label: 'Task Name', type: 'text', required: true },
    { key: 'assignee', label: 'Assigned To', type: 'text', required: true },
    { key: 'priority', label: 'Priority', type: 'select', options: ['High', 'Medium', 'Low'], required: true },
    { key: 'due_date', label: 'Due Date', type: 'date', required: true }
  ]
)
```

## Data Format

### Input Format
Field definitions and rows data are stored as JSONB in PostgreSQL:

```json
{
  "field_definitions": [
    {
      "key": "issue",
      "label": "Issue/Problem",
      "type": "text",
      "required": true
    }
  ],
  "rows_data": [
    {
      "issue": "Water shortage",
      "root_cause": "Broken pipe",
      "action": "Repair pipe",
      "responsible_person": "John Doe",
      "deadline": "2024-12-31",
      "budget": "1000",
      "status": "Not Started"
    }
  ]
}
```

### Output Format
Data is submitted as JSON arrays and stored in the database:

```json
[
  {
    "issue": "value",
    "root_cause": "value",
    "action": "value",
    "responsible_person": "value",
    "deadline": "2024-12-31",
    "budget": "1000",
    "status": "Not Started"
  }
]
```

## Keyboard Navigation

The JAAP spreadsheet supports Excel-like keyboard navigation:

- **Tab**: Move to next cell
- **Shift+Tab**: Move to previous cell
- **Arrow Keys**: Navigate between cells
- **Enter**: Move to cell below (adds new row if at the end)
- **ESC**: Cancel editing (for future enhancement)

## Usage Examples

### Creating a JAAP

1. Navigate to JAAPs page
2. Click "New JAAP" button
3. Fill in title and description
4. Optionally link to a scorecard
5. Fill in the action plan table
6. Click "Add Row" to add more rows
7. Click "Save" to create the JAAP

### Editing a JAAP

1. Navigate to JAAP details page
2. Click "Edit" button
3. Modify fields as needed
4. Click "Save" to update

### Completing a JAAP

1. Navigate to JAAP details page
2. Click "Mark as Complete" button
3. Confirm the action

## API Endpoints

### RESTful Routes

```
GET    /jaaps                  # List all JAAPs
GET    /jaaps/new              # New JAAP form
POST   /jaaps                  # Create JAAP
GET    /jaaps/:uuid            # Show JAAP
GET    /jaaps/:uuid/edit       # Edit JAAP form
PATCH  /jaaps/:uuid            # Update JAAP
DELETE /jaaps/:uuid            # Delete JAAP
PUT    /jaaps/:uuid/complete   # Mark as completed
```

### JSON API

```
GET /jaaps/:uuid.json          # Get JAAP as JSON
```

Example response:
```json
{
  "uuid": "abc-123",
  "title": "Community Action Plan",
  "description": "Action plan for community issues",
  "field_definitions": [...],
  "rows_data": [...],
  "completed_at": null,
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z",
  "user": {
    "id": 1,
    "name": "John Doe"
  }
}
```

## Testing

### Running Tests

```bash
# Run all JAAP tests
docker-compose run --rm web rspec spec/models/jaap_spec.rb
docker-compose run --rm web rspec spec/requests/jaaps_request_spec.rb
docker-compose run --rm web rspec spec/policies/jaap_policy_spec.rb

# Run all tests
docker-compose run --rm web rspec
```

### Test Coverage

- Model tests: Validations, associations, callbacks, and methods
- Request tests: CRUD operations and authorization
- Policy tests: Access control for different user roles

## Future Enhancements

### Planned Features
- Export to Excel/PDF
- Import from Excel
- Version history/audit trail
- Comments and attachments per row
- Real-time collaboration
- Email notifications
- Advanced filtering and search
- Custom field templates
- Bulk operations
- Mobile app support

### Potential Improvements
- Cell-level validation with custom rules
- Formula support (like Excel)
- Conditional formatting
- Copy/paste between rows
- Undo/redo functionality
- Auto-save drafts
- Print-friendly view

## Security Considerations

- Authorization enforced through Pundit policies
- Program-based access control
- XSS prevention in cell values
- CSRF protection on all forms
- Input validation and sanitization
- UUID-based public identifiers

## Performance

- JSONB indexing for fast queries
- Efficient data serialization
- Optimized table rendering
- Lazy loading for large datasets
- Pagination support

## Browser Compatibility

The JAAP feature supports:
- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## Contributing

When adding new field types:

1. Update `createInput` method in `spreadsheet.js`
2. Add validation logic if needed
3. Update documentation
4. Add tests for the new field type

## License

This feature is part of the scorecard-web application.
