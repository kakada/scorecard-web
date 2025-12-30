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
  - Saves permitted params.
  - Locks with `@scorecard.lock_submit!` only when `final_submit?` returns true.
- `final_submit?`:
  - Returns true if `voting_indicators_attributes` contains at least one `indicator_activities_attributes` entry.

## Strong Parameters (subset)
- `voting_indicators_attributes`: `:uuid, :indicator_uuid, :indicatorable_id, :indicatorable_type, :participant_uuid, :median, :scorecard_uuid, :display_order, indicator_activities_attributes: [ :id, :voting_indicator_uuid, :scorecard_uuid, :content, :selected, :type ]`
- Legacy arrays (`strength`, `weakness`, `suggested_action`) and `suggested_actions_attributes` remain permitted for compatibility with older clients.

## Online Mode: Two-Step Flow
### Step 1: Draft submit (no activities → no lock)
Request:
```
PUT /api/v1/scorecards/:uuid
Content-Type: application/json
Authorization: Token <user-token>

{
  "scorecard": {
    "number_of_participant": 10,
    "app_version": 15013,
    "voting_indicators_attributes": [
      { "uuid": "vi-001", "indicatorable_id": <id>, "indicatorable_type": "Indicator", "scorecard_uuid": ":uuid", "display_order": 1 }
    ]
  }
}
```
Effect:
- Returns 200.
- Scorecard updates fields.
- Scorecard remains unlocked (`submit_locked?` = false).

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
        "indicator_activities_attributes": [
          { "voting_indicator_uuid": "vi-001", "scorecard_uuid": ":uuid", "content": "activity 1", "selected": true, "type": "SuggestedIndicatorActivity" }
        ]
      }
    ]
  }
}
```
Effect:
- Returns 200.
- Activities are persisted under the voting indicator.
- Scorecard locks (`submit_locked?` = true).

## Offline Mode: Single-Step Submit
- Submit all data including `indicator_activities_attributes` in one request to lock immediately.

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
- Model specs: spec/models/scorecard_progress_spec.rb
  - Verifies `open_voting` and `close_voting` progress transitions.
  - Verifies QR code generation when status is `open_voting`.
- Service specs: spec/services/scorecards/open_voting_service_spec.rb
  - Verifies QR code generation logic and prevents regeneration.

## Compatibility Notes
- Legacy fields (`strength`, `weakness`, `suggested_action`) and `suggested_actions_attributes` are still permitted to support older mobile app versions; they map to `indicator_activities` internally.
- New clients should prefer `indicator_activities_attributes` with proper `type` (e.g., `SuggestedIndicatorActivity`).

## Summary
- Online: two-step submit with lock on second step.
- Offline: single-step submit with immediate lock.
- Progress: `open_voting` and `close_voting` statuses move the scorecard through the online workflow.
- QR Code: automatically generated when status is `open_voting`, contains voting URL for easy scanning.
