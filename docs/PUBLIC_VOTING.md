# Public Voting Feature

## Overview

The public voting feature allows community members to vote on scorecard indicators without requiring a login. This feature is useful for gathering feedback from a wider audience during community scorecard events.

## How It Works

Public voting is controlled through the **scorecard progress status**. When a scorecard has an `open_voting` progress status, the public voting page becomes accessible.

### Scorecard Progress Status

The system uses `ScorecardProgress` with the following relevant statuses:
- `open_voting` (4): Voting is open for public participation
- `close_voting` (5): Voting has been closed

When a scorecard progress is set to `open_voting`, a QR code is automatically generated that links to the public voting page.

## Usage

### Enabling Public Voting

To enable public voting for a scorecard, create a scorecard progress with `open_voting` status:

```ruby
scorecard = Scorecard.find_by(uuid: "123456")
scorecard.scorecard_progresses.create(status: :open_voting, user_id: current_user.id)
```

This will:
1. Set the scorecard's progress to `open_voting`
2. Automatically generate a QR code for the voting URL
3. Make the public voting page accessible

### Closing Public Voting

To close voting:

```ruby
scorecard.scorecard_progresses.create(status: :close_voting, user_id: current_user.id)
```

### Public Voting URL

Once voting is enabled, participants can access the voting form at:

```
/scorecards/:scorecard_uuid/vote
```

Example: `https://your-domain.com/scorecards/123456/vote`

### Voting Flow

1. **Step 1: Participant Profile**
   - Age
   - Gender (Female, Male, Other)
   - Demographics (Disability, Minority, ID Poor Card, Youth)

2. **Step 2: Rate Indicators**
   - Rate each indicator from 1 (Very Bad) to 5 (Very Good)
   - All indicators must be rated before submission

3. **Step 3: Submit**
   - Vote is recorded and associated with the participant profile
   - Participant profiles from public voting are marked as `countable: false` to distinguish them from regular participants

When voting is closed:
- The voting page displays a "Voting is Currently Closed" message
- Any attempt to submit votes returns an error

## API Endpoints

### GET `/scorecards/:scorecard_uuid/vote`

Shows the public voting form.

**Response:**
- If scorecard has `open_voting` progress: Displays the voting form
- Otherwise: Displays a "voting closed" message

### POST `/scorecards/:scorecard_uuid/vote`

Submits a vote.

**Request Body:**
```json
{
  "participant": {
    "age": 25,
    "gender": "female",
    "disability": false,
    "minority": false,
    "poor_card": false,
    "youth": true
  },
  "voting_data": [
    {
      "indicator_uuid": "indicator-uuid-1",
      "score": 4
    },
    {
      "indicator_uuid": "indicator-uuid-2",
      "score": 5
    }
  ]
}
```

**Response:**
- Success: `{ "success": true, "message": "Your vote has been successfully submitted" }`
- Error: `{ "error": "Error message" }`

## Security Considerations

- The public voting endpoint bypasses authentication (`skip_before_action :authenticate_user!`)
- CSRF protection is disabled for the POST endpoint to allow API submissions
- Voting can only occur when `voting_open` is `true`
- Public votes are marked as `countable: false` to prevent manipulation of official statistics

## Multilingual Support

The feature supports both English (en) and Khmer (km) languages. Translations are located in:
- `config/locales/public_votes/en.yml`
- `config/locales/public_votes/km.yml`

## Testing

Controller tests are located in:
- `spec/controllers/public_votes_controller_spec.rb`

To run the tests:

```bash
docker-compose run --rm web rspec spec/controllers/public_votes_controller_spec.rb
docker-compose run --rm web rspec spec/models/scorecard_spec.rb
```
