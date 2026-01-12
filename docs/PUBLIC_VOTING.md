# Public Voting Feature

## Overview

The public voting feature allows community members to vote on scorecard indicators without requiring authentication. This feature integrates with the existing scorecard workflow and uses the scorecard progress status to control voting availability.

## How It Works

Public voting is controlled through the **scorecard progress status**:
- When a scorecard progress is set to `open_voting`, the public voting page becomes accessible
- A QR code is automatically generated linking to the public voting URL
- When progress changes to `close_voting` or any other status, voting is closed

### Scorecard Progress Status

The system uses `ScorecardProgress` with these relevant statuses:
- `open_voting` (4): Voting is open for public participation
- `close_voting` (5): Voting has been closed

## Implementation Details

### Database

- **No new columns added** - Uses existing `scorecard_progresses` table
- Migration file: `db/migrate/20251230065714_remove_voting_open_from_scorecards.rb` (cleanup migration)

### Backend

**Controller**: `app/controllers/public_votes_controller.rb`
- Public access (no authentication required)
- Two main actions:
  - `show`: Display voting form or closed message
  - `create`: Process and save votes
- CSRF protection maintained
- Public votes marked as `countable: false`

**Model**: `app/models/scorecard.rb`
- Integrates with existing `OpenVotingService` for QR code generation

**Routes**: `config/routes.rb`
- `GET /scorecards/:scorecard_uuid/vote` - Display voting form
- `POST /scorecards/:scorecard_uuid/vote` - Submit vote

### Frontend

**View**: `app/views/public_votes/show.html.haml`
- Single continuous vertical flow (no multi-step navigation)
- Displays participant profile form followed immediately by voting indicators
- Orange accent color (#c65e28) matching mobile app design
- Responsive design for desktop and mobile

**Styling**: `app/assets/stylesheets/public_votes.scss`
- Clean, minimal design with light gray background
- Interactive clickable boxes for selections
- Emoji-based rating system (😢 😞 😐 😊 😄)
- Mobile-responsive with touch-friendly elements

**JavaScript**: Inline in view
- Form validation
- Click handlers for interactive elements
- AJAX submission with CSRF token
- Visual feedback for selections

### UI Components

#### Participant Profile Section
1. **Age** (Required): Number input field
2. **Gender** (Required): Clickable boxes with icons (♀ ♂ ⚲)
3. **Participant Types** (Optional): Checkboxes with icons
   - Disability (wheelchair icon)
   - Ethnic minority (users icon)
   - ID Poor card (card icon)
4. **Youth** (Optional): Separate checkbox with badge showing age range

#### Voting Section
1. **Indicator List**: Numbered display of voting indicators
2. **Rating System**: 5 emoji-based options per indicator
   - 😢 Score 1 - Very Bad
   - 😞 Score 2 - Bad
   - 😐 Score 3 - Acceptable
   - 😊 Score 4 - Good
   - 😄 Score 5 - Very Good
3. **Submit Button**: Large, centered button at bottom

### Internationalization

**Locales**:
- `config/locales/public_votes/en.yml` (English)
- `config/locales/public_votes/km.yml` (Khmer)

Full coverage of all UI text, messages, and labels.

## Usage

### Enabling Public Voting

```ruby
scorecard = Scorecard.find_by(uuid: "123456")
scorecard.scorecard_progresses.create(
  status: :open_voting,
  user_id: current_user.id
)
```

This automatically:
1. Sets the scorecard's progress to `open_voting`
2. Generates a QR code for the voting URL
3. Makes the voting page accessible at `/scorecards/123456/vote`

### Closing Public Voting

```ruby
scorecard.scorecard_progresses.create(
  status: :close_voting,
  user_id: current_user.id
)
```

## API Endpoints

### GET `/scorecards/:scorecard_uuid/vote`

Shows the public voting form or a "voting closed" message.

**Response:**
- If scorecard has `open_voting` progress: Displays the voting form
- Otherwise: Displays "Voting is Currently Closed" message

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
      "indicator_uuid": "voting-indicator-uuid-1",
      "score": 4
    },
    {
      "indicator_uuid": "voting-indicator-uuid-2",
      "score": 5
    }
  ]
}
```

**Response:**
- Success: `{ "success": true, "message": "Your vote has been successfully submitted" }`
- Error: `{ "error": "Error message" }`

**Status Codes:**
- 200: Success
- 422: Unprocessable entity (voting closed, validation errors)
- 404: Scorecard not found

## Security

### Implemented Protections

1. **CSRF Protection**: CSRF tokens validated on all submissions
2. **XSS Prevention**: JavaScript strings escaped via `escape_javascript()`
3. **Data Separation**: Public votes marked as `countable: false` to separate from official statistics
4. **Access Control**: Voting only allowed when scorecard progress is `open_voting`
5. **No PII**: Participant profiles don't collect personally identifiable information
6. **CodeQL Scan**: Passed with 0 alerts

### Authentication Bypass

The public voting endpoint intentionally bypasses authentication to allow community participation:
- `skip_before_action :authenticate_user!` in controller
- This is safe because votes are isolated and don't affect official data

## Testing

### Test Files

- `spec/controllers/public_votes_controller_spec.rb` - Controller behavior tests

### Running Tests

```bash
# Run controller tests
docker-compose run --rm web rspec spec/controllers/public_votes_controller_spec.rb

# Run model tests
docker-compose run --rm web rspec spec/models/scorecard_spec.rb
```

### Test Coverage

- Public voting form display
- Vote submission with valid data
- Voting closed scenarios
- Progress status changes
- Invalid data handling
- CSRF protection
- Error handling

## Integration with Existing System

### Leverages Existing Infrastructure

1. **ScorecardProgress Model**: Uses existing enum statuses
2. **OpenVotingService**: Automatically generates QR codes when progress becomes `open_voting`
3. **Voting Indicators**: Uses scorecard's configured `voting_indicators` list
4. **Participant Model**: Reuses existing participant structure with `countable: false` flag

### No Breaking Changes

- No new database columns
- No changes to existing workflows
- Follows established patterns for scorecard management
- Works seamlessly with existing QR code generation

## Files Modified/Created

1. `app/controllers/public_votes_controller.rb` (80 lines)
3. `app/views/public_votes/show.html.haml` (220 lines)
4. `app/assets/stylesheets/public_votes.scss` (170 lines)
5. `config/locales/public_votes/en.yml` (35 lines)
6. `config/locales/public_votes/km.yml` (35 lines)
7. `config/routes.rb` (2 routes added)
8. `db/migrate/20251230065714_remove_voting_open_from_scorecards.rb` (cleanup)
9. `spec/controllers/public_votes_controller_spec.rb` (test coverage)
10. `spec/models/scorecard_spec.rb` (added tests)

## Design Considerations

### Single Continuous Flow

The voting page uses a single continuous vertical layout:
- Participant profile form at top
- Voting indicators immediately below
- Single submit button at bottom
- No multi-step navigation required

### Mobile-First Design

- Touch-friendly interactive elements
- Responsive layout adapts to screen size
- Orange accent color matches mobile app
- Emoji-based ratings are intuitive

### Accessibility

- All inputs have proper labels
- Required fields marked with asterisk
- Clear visual feedback for selections
- Keyboard navigation supported
- WCAG AA color contrast standards met

## Performance

- Minimal JavaScript dependencies
- Single page load
- Efficient DOM manipulation
- CSS optimized with SCSS
- No additional API requests after initial load

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)
- Mobile browsers (iOS Safari, Chrome Mobile)

## Troubleshooting

### Voting Page Shows "Closed" When It Should Be Open

Check the scorecard progress:
```ruby
scorecard = Scorecard.find_by(uuid: "your-uuid")
scorecard.progress  # Should return "open_voting"
```

### QR Code Not Generated

Ensure the `generate_qr_code` is triggered:
```ruby
scorecard = Scorecard.find_by(uuid: "your-uuid")
scorecard.generate_qr_code
```

### Public Votes Affecting Statistics

Verify the `countable` flag:
```ruby
Participant.where(scorecard_uuid: scorecard.uuid, countable: false)
```

## Future Enhancements

Potential improvements for future iterations:
- Real-time vote count display for administrators
- Vote analytics dashboard
- Export public voting results
- Custom voting period schedules
- Email/SMS notifications when voting opens
- Multi-language QR code posters

## Best Practices

1. **Always close voting** after the voting period ends
2. **Monitor public votes** separately from official data
3. **Test QR codes** before distributing to community
4. **Provide clear instructions** at voting events
5. **Have backup access** (URL) if QR codes fail
6. **Communicate voting periods** clearly to community members
