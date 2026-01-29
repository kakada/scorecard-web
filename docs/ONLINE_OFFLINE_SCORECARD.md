# Scorecard Running Modes & Progress

This document explains the updated behavior for submitting scorecards in offline and online modes, and how scorecard progress updates work, including `open_voting` and `close_voting`.

## Overview
- Offline: submit a complete scorecard including `indicator_activities_attributes` in one request. The scorecard locks immediately after a successful update.
- Online: submit in two steps:
  - Step 1 (draft): submit all core data without `indicator_activities_attributes`. The scorecard saves but remains unlocked.
  - Step 2 (final): submit `indicator_activities_attributes` for existing voting indicators. The scorecard locks.
- Progress: creating `ScorecardProgress` records with statuses `open_voting` and `close_voting` advances the scorecard’s `progress` accordingly.

## API Endpoints
- Update scorecard (two-step online or single-step offline): `PUT /api/v1/scorecards/:uuid`
- Create scorecard progress (open/close voting): `POST /api/v1/scorecard_progresses`
- Get QR code for voting: `GET /api/v1/scorecards/:uuid/qr_code`

## Controller Logic
- File: app/controllers/api/v1/scorecards_controller.rb
- `update`:
  - Normalizes voting indicators using `Scorecards::NormalizeParamsToUpdateService` to prevent duplicates and calculate participants count.
  - Saves permitted params.
- `final_submit?`:
  - Returns true if `voting_indicators_attributes` contains at least one `indicator_activities_attributes` entry.
- Services:
  - `Scorecards::NormalizeParamsToUpdateService`: Matches existing voting indicators by `indicator_uuid` to prevent duplicate creation on retries and demographic calculation for online scorecards.

## Strong Parameters (subset)
- `voting_indicators_attributes`: `:id, :uuid, :indicator_uuid, :indicatorable_id, :indicatorable_type, :median, :display_order, indicator_activities_attributes: [ :id, :voting_indicator_uuid, :content, :selected, :type ]`
- `participants_attributes`: `:uuid, :age, :gender, :disability, :minority, :youth, :poor_card, :countable`
- `facilitators_attributes`: `:id, :caf_id, :position`
- `ratings_attributes`: `:uuid, :voting_indicator_uuid, :participant_uuid, :score`
- Legacy arrays (`strength`, `weakness`, `suggested_action`) and `suggested_actions_attributes` remain permitted for compatibility with older clients.
- Note: `scorecard_uuid` is no longer required in nested attributes as it's automatically inferred from the parent scorecard.

## Online Mode: Two-Step Flow
### Step 1: Draft submit (no activities → no lock)
Request:
```
PUT /api/v1/scorecards/:uuid
Content-Type: application/json
Authorization: Token <user-token>

{
  "scorecard": {
    "app_version": 15013,
    "voting_indicators_attributes": [
      { "uuid": "vi-001", "indicator_uuid": "ind-001", "indicatorable_id": <id>, "indicatorable_type": "Indicator", "display_order": 1 }
    ],
    "participants_attributes": [
      { "uuid": "p1", "gender": "female", "disability": true, "minority": false, "youth": true, "poor_card": false, "countable": true },
      { "uuid": "p2", "gender": "male", "disability": false, "minority": true, "youth": false, "poor_card": true, "countable": true }
    ]
  }
}
```
Effect:
- Returns 200.
- Voting indicators are normalized to prevent duplicates (matched by `indicator_uuid`).
- Scorecard updates fields.
- Participant records are created/updated.
- Scorecard remains unlocked (`submit_locked?` = false).
- Note: In online mode, demographic fields (number_of_participant, number_of_female, etc.) should not be submitted by the client, as they will be automatically calculated on final submit.

### Step 2: Final submit (includes activities → lock)
Request:
```
PUT /api/v1/scorecards/:uuid
Content-Type: application/json
Authorization: Token <user-token>

{
  "scorecard": {
    "voting_indicators_attributes": [
      {
        "uuid": "vi-001",
        "indicator_uuid": "ind-001",
        "indicator_activities_attributes": [
          { "voting_indicator_uuid": "vi-001", "content": "activity 1", "selected": true, "type": "SuggestedIndicatorActivity" }
        ]
      }
    ]
  }
}
```
Effect:
- Returns 200.
- Activities are persisted under the voting indicator.
- **For online scorecards**: Demographic fields (number_of_participant, number_of_female, number_of_disability, number_of_ethnic_minority, number_of_youth, number_of_id_poor) are automatically calculated from participant records.
- Scorecard locks (`submit_locked?` = true).

## Offline Mode: Single-Step Submit
- Submit all data including `indicator_activities_attributes` in one request to lock immediately.
- **For offline scorecards**: Demographic fields (number_of_participant, number_of_female, number_of_disability, number_of_ethnic_minority, number_of_youth, number_of_id_poor) must be submitted by the client and are saved as provided.

## Scorecard Progress: Open/Close Voting
- File: app/controllers/api/v1/scorecard_progresses_controller.rb
- Endpoint: `POST /api/v1/scorecard_progresses`
- Params: `scorecard_uuid, status (open_voting|close_voting), device_id, conducted_at` (merged with `user_id` from the current user).

Examples:
```
POST /api/v1/scorecard_progresses
Content-Type: application/json
Authorization: Token <user-token>

{ "scorecard_progress": { "scorecard_uuid": ":uuid", "status": "open_voting" } }
```
Effect:
- Creates a `ScorecardProgress`.
- Advances `scorecard.progress` to `open_voting`.
- Automatically generates a QR code for the scorecard voting URL.

```
POST /api/v1/scorecard_progresses
Content-Type: application/json
Authorization: Token <user-token>

{ "scorecard_progress": { "scorecard_uuid": ":uuid", "status": "close_voting" } }
```
Effect:
- Advances `scorecard.progress` to `close_voting`.

## QR Code for Voting
- File: app/services/scorecards/open_voting_service.rb
- Endpoint: `GET /api/v1/scorecards/:uuid/qr_code`

When a scorecard progress is created with status `open_voting`, the system automatically generates a QR code containing the voting URL: `/scorecards/:uuid/vote`

### Get QR Code
Request:
```
GET /api/v1/scorecards/:uuid/qr_code
Content-Type: application/json
Authorization: Token <user-token>
```

Response (when QR code exists):
```
{
  "qr_code_url": "/uploads/scorecard/qr_code/123/qr_code.png",
  "voting_url": "/scorecards/:uuid/vote"
}
```

Response (when QR code does not exist):
```
{
  "error": "QR code not available"
}
```

Effect:
- Returns the URL to download the QR code image
- Returns the voting URL encoded in the QR code
- Users can scan the QR code to access the voting form

## Sandbox Mode
- When `scorecard.program.sandbox?` is true, `PUT /api/v1/scorecards/:uuid` responds 200 but does not update attributes or lock the scorecard.

## Tests
- Request specs: spec/requests/api/v1/scorecards_request_spec.rb
  - Verifies draft vs final submits and locking behavior.
  - Verifies `indicator_activities_attributes` persistence and counts.
  - Verifies QR code endpoint returns correct data or 404 when not available.
  - Verifies automatic demographic calculation for online scorecards.
  - Verifies offline scorecards use submitted demographic values.
- Service specs:
  - spec/services/scorecards/open_voting_service_spec.rb: Verifies QR code generation logic and prevents regeneration.
- Model specs: spec/models/scorecard_progress_spec.rb
  - Verifies `open_voting` and `close_voting` progress transitions.
  - Verifies QR code generation when status is `open_voting`.

## Compatibility Notes
- Legacy fields (`strength`, `weakness`, `suggested_action`) and `suggested_actions_attributes` are still permitted to support older mobile app versions; they map to `indicator_activities` internally.
- New clients should prefer `indicator_activities_attributes` with proper `type` (e.g., `SuggestedIndicatorActivity`).

## Participant Demographics Calculation
- **Online scorecards**: Demographic fields are automatically calculated from participant records on final submit. The calculation counts only participants where `countable` is `true`.
  - `number_of_participant`: Total count of countable participants
  - `number_of_female`: Count of countable participants with gender = "female"
  - `number_of_disability`: Count of countable participants with disability = true
  - `number_of_ethnic_minority`: Count of countable participants with minority = true
  - `number_of_youth`: Count of countable participants with youth = true
  - `number_of_id_poor`: Count of countable participants with poor_card = true
- **Offline scorecards**: Demographic fields must be provided by the client and are saved as submitted.
- **Transaction safety**: The demographic calculation and scorecard locking happen within a single database transaction to ensure data consistency.

## Summary
- Online: two-step submit with lock on second step. Demographic fields automatically calculated on final submit.
- Offline: single-step submit with immediate lock. Demographic fields provided by client.
- Progress: `open_voting` and `close_voting` statuses move the scorecard through the online workflow.
- QR Code: automatically generated when status is `open_voting`, contains voting URL for easy scanning.
