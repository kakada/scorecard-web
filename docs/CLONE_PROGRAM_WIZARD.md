# Clone Program Wizard

## Overview

The Clone Program Wizard is a feature that allows system administrators to set up a new program's scorecard settings by cloning from either sample data or an existing program. The wizard provides a step-by-step interface to selectively import only the components needed.

## User Flow

### Step 1: Select Setup Method

After creating a new program, a system admin can click the "Clone Setup" button (clone icon) next to the program in the Programs list.

The wizard presents two options:

1. **Clone from Sample** - Import pre-configured sample components
2. **Clone from Existing Program** - Copy settings from another program in the system

### Step 2A: Select Sample Components (if "Clone from Sample")

The user can choose which sample components to import:

- Languages (6 languages: Khmer, Bunoung, Tampuen, Kreung, Kavet, Jarai)
- Facilities (Public Administration, Education, Health, etc.)
- Indicators (Evaluation indicators for scorecards)
- Rating Scales (Rating definitions with audio files)
- PDF Templates (Templates for scorecard PDF exports)

### Step 2B: Select Source Program & Components (if "Clone from Existing Program")

1. First, select which existing program to clone from
2. Then, select which components to copy (same options as above)

### Step 3: Review & Confirm

A summary page displays:
- Target program name
- Clone method (sample or program)
- Source program (if cloning from program)
- Selected components

The user can review and confirm before starting the process.

### Step 4: Execute in Background

The cloning process runs as a background job using Sidekiq. The status page shows:
- **Pending** - Waiting to start
- **Processing** - Cloning in progress
- **Completed** - Successfully finished
- **Failed** - An error occurred

The page auto-refreshes every 5 seconds while processing.

## Technical Implementation

### Components

- **WizardProgramService** (`app/services/wizard_program_service.rb`)
  - Handles selective component cloning
  - Supports both sample and program source cloning
  - Only clones selected components

- **CloneWizardWorker** (`app/workers/clone_wizard_worker.rb`)
  - Background job using Sidekiq
  - Processes clone operations asynchronously
  - Handles errors and updates status

- **ProgramClone Model** (`app/models/program_clone.rb`)
  - Tracks clone operations
  - Stores selected components, status, and metadata
  - Validates clone method and components

- **ProgramClonesController** (`app/controllers/program_clones_controller.rb`)
  - Multi-step wizard flow
  - Actions: new, select_method, select_components, review, create, show

### Database Schema

The `program_clones` table includes:
- `source_program_id` - Source program (nullable for sample cloning)
- `target_program_id` - Target program to clone into
- `user_id` - Admin who initiated the clone
- `selected_components` - Array of component names
- `clone_method` - 'sample' or 'program'
- `status` - 'pending', 'processing', 'completed', or 'failed'
- `error_message` - Error details if failed
- `completed_at` - Timestamp when completed

### Authorization

Only system administrators can access the clone wizard functionality. This is enforced via the `ProgramClonePolicy`.

### Routes

```ruby
resources :programs do
  resources :program_clones, only: [:new, :create, :show], path: 'clone_wizard' do
    get :select_method, on: :collection
    get :select_components, on: :collection
    post :select_components, on: :collection
    post :review, on: :collection
  end
end
```

### Available Components

- `languages` - System languages for scorecard localization
- `facilities` - Facility types and categories
- `indicators` - Evaluation indicators for scorecards
- `rating_scales` - Rating scale definitions with audio files
- `pdf_templates` - Templates for scorecard PDF exports

## Testing

Comprehensive test coverage includes:

- **Service Tests** (`spec/services/wizard_program_service_spec.rb`)
  - Tests selective component cloning
  - Tests both sample and program source cloning

- **Worker Tests** (`spec/workers/clone_wizard_worker_spec.rb`)
  - Tests background job execution
  - Tests error handling

- **Model Tests** (`spec/models/program_clone_spec.rb`)
  - Tests validations
  - Tests scopes and instance methods

- **Policy Tests** (`spec/policies/program_clone_policy_spec.rb`)
  - Tests authorization rules

## Localization

The feature supports both English and Khmer translations:
- `config/locales/program_clone/en.yml`
- `config/locales/program_clone/km.yml`

## Security

- Only system administrators can access the feature
- Source program validation prevents invalid references
- Error messages are sanitized to prevent XSS
- Background job includes comprehensive error handling
- CodeQL security scan shows no vulnerabilities

## Future Enhancements

Potential improvements:
- Email notifications when cloning completes
- Batch cloning for multiple programs
- Clone operation history/audit log
- Component dependency resolution (e.g., auto-select languages when selecting indicators)
