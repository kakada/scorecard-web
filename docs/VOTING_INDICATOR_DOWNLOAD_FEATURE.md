# Voting Indicator Download Feature - Implementation Summary

## Overview
This feature allows users to download raw voting indicator data as an Excel file, filtered by scorecard (with a limit of 50 scorecards per batch), to support visualization and analysis in Excel.

## Changes Made

### 1. Controller (app/controllers/voting_indicators_controller.rb)
- Created `VotingIndicatorsController` with `index` action
- Implements authorization using existing Pundit policies
- Supports filtering by:
  - Individual scorecard UUID
  - Current user's program
- Enforces 50 scorecard limit per download for performance
- Returns Excel file with timestamped filename

### 2. Excel Builder (lib/builders/excel_builders/voting_indicator_raw_data_excel_builder.rb)
- Creates comprehensive Excel export with the following columns:
  - Scorecard ID
  - Indicator ID
  - Indicator Name
  - Median Score (translated)
  - Strength (joined with semicolons)
  - Weakness (joined with semicolons)
  - Suggested Action (joined with semicolons)
  - Total Ratings
  - Rating distribution (counts for Very Bad, Bad, Acceptable, Good, Very Good)

### 3. View Template (app/views/voting_indicators/index.xlsx.axlsx)
- Simple template that delegates to the Excel builder
- Uses caxlsx gem for Excel generation

### 4. Routing (config/routes.rb)
- Added `resources :voting_indicators, only: [:index]`
- Accessible at `/voting_indicators.xlsx` with optional parameters

### 5. Translations
Added translations in both English and Khmer:
- Excel column headers (config/locales/excel/en.yml, km.yml)
- Error messages (config/locales/voting_indicator/en.yml, km.yml)
- UI button labels (config/locales/scorecard/en.yml, km.yml)

### 6. UI Integration (app/views/scorecards/index/_more_buttons.haml)
- Added "Download voting indicators" option to the download dropdown menu
- Passes current filter parameters to maintain user context

### 7. Tests (spec/requests/voting_indicators_request_spec.rb)
Comprehensive test coverage including:
- Download with scorecard UUID filter
- Download with batch code filter
- Batch limit enforcement (50 scorecard maximum)
- Authorization checks
- Updated rating factory for proper test data generation

## Usage

### From UI
1. Navigate to the Scorecards index page
2. Apply any desired filters (province, year, batch, etc.)
3. Click the "Download Excel" dropdown button
4. Select "Download voting indicators"
5. Excel file will download with filtered data

### Direct URL
```
GET /voting_indicators.xlsx?scorecard_uuid=123456
GET /voting_indicators.xlsx?batch_code=BATCH001
GET /voting_indicators.xlsx?batch_code=BATCH001&province_id=12
```

## Security
- Uses existing Pundit authorization (ScorecardPolicy scope)
- Only returns scorecards accessible to current user
- CodeQL security scan: **0 alerts found**

## Data Included
For each voting indicator, the export includes:
- Scorecard identification
- Indicator details and name
- Calculated median score with translation
- Qualitative data (strengths, weaknesses, suggested actions)
- Quantitative voting distribution (count of each rating 1-5)
- Total number of ratings received

## Limitations
- Maximum 50 scorecards per download (configurable)
- Requires user authentication
- Respects existing authorization rules

## Technical Notes
- Uses Rails' existing xlsx rendering via caxlsx_rails gem
- Follows existing patterns from VotingDetailExcelBuilder and VotingSummaryExcelBuilder
- Compatible with current database schema
- No migrations required
- Handles array fields by joining with semicolons for Excel compatibility

## Testing
Run tests with:
```bash
bundle exec rspec spec/requests/voting_indicators_request_spec.rb
```

## Future Enhancements (Optional)
- Configurable batch limit via settings
- Additional export formats (CSV, JSON)
- More granular filtering options
- Scheduled exports via background jobs
- Email delivery of large exports
