# Public Voting Page - Design Update Summary

## Overview
Updated the public voting page to match the mobile app design reference images, providing a single continuous flow experience.

## Key Changes from Original Design

### 1. Layout Structure
**Before**: Two-step wizard with "Next" and "Back" navigation
**After**: Single continuous vertical flow (profile → voting → submit)

### 2. Data Source
**Before**: `@scorecard.facility.indicators`
**After**: `@scorecard.voting_indicators`

This ensures the voting form displays the exact indicators that have been configured for the scorecard's voting process, not all facility indicators.

### 3. Visual Design Updates

#### Participant Profile Section
- **Age input**: Simple number field with asterisk (required)
- **Gender selection**: 
  - Changed from dropdown to clickable boxes
  - Three options displayed horizontally with icons
  - Orange highlight (#ff8533) when selected
  - Icons: Venus (♀) for female, Mars (♂) for male, Genderless for other

- **Participant Type**:
  - Changed from checkboxes to clickable boxes
  - Icons for each type:
    - Wheelchair icon for disability
    - Users icon for ethnic minority
    - ID card icon for poor card holder
  - Gray background when selected

- **Youth Option**:
  - Separate section with badge showing age range
  - User-graduate icon
  - Same clickable box style

#### Voting Section
- **Header**: "Rate Indicators" with horizontal line separator
- **Indicator Display**:
  - Numbered list (1., 2., 3., etc.)
  - Indicator name in bold
  - Optional hint text in gray
  - Audio icon if audio is available

- **Rating System**:
  - 5 emoji-based rating options:
    - 😢 (Score 1 - Very Bad)
    - 😞 (Score 2 - Bad)
    - 😐 (Score 3 - Acceptable)
    - 😊 (Score 4 - Good)
    - 😄 (Score 5 - Very Good)
  - Orange border/background when selected
  - Small audio icon next to score if indicator has audio
  - Rating scale description shown above options

#### Submit Button
- Gray background (#e0e0e0) by default
- Large, rounded button centered at bottom
- "Submit" text with paper plane icon

### 4. Color Scheme Updates
**Before**: Purple gradient background (#667eea → #764ba2)
**After**: 
- White/light gray background (#f5f5f5)
- Orange header (#c65e28) matching mobile app
- Orange accents (#ff8533) for selections
- Gray neutral tones for unselected states

### 5. Interaction Improvements
- All options are now clickable boxes (not just the checkbox/radio)
- Visual feedback on hover (border color change, slight elevation)
- Clear selected state with color changes
- No step navigation required - users see everything at once
- Form validation ensures all required fields and all indicators are rated

## Technical Implementation

### Controller Changes
```ruby
# Show action now loads voting_indicators
@indicators = @scorecard.voting_indicators.includes(:indicator).order(:display_order)

# Create action simplified to directly reference voting_indicators
voting_indicator = @scorecard.voting_indicators.find_by(uuid: vote[:indicator_uuid])
```

### View Structure
```haml
.participant-profile-section
  # Age, Gender, Participant Types, Youth
  
%hr

.voting-section
  # All indicators with emoji ratings
  
.submit-button
  # Single submit button
```

### JavaScript Updates
- Removed step navigation code
- Single form submission handler
- Click handlers for gender, type, and rating options
- Visual feedback with 'selected' class toggling
- Form validation before AJAX submission

## Benefits

1. **Simpler UX**: Users can see the entire form at once
2. **Faster completion**: No need to navigate between steps
3. **Better mobile experience**: Vertical scroll instead of multi-step navigation
4. **Consistent design**: Matches the mobile app's look and feel
5. **Clearer data source**: Uses scorecard's configured voting indicators

## Files Modified

1. `app/controllers/public_votes_controller.rb`
2. `app/views/public_votes/show.html.haml`
3. `app/assets/stylesheets/public_votes.scss`
4. `config/locales/public_votes/en.yml`
5. `config/locales/public_votes/km.yml`

## Responsive Design
- Desktop: 3 columns for gender, 3 columns for participant types
- Mobile: 2 columns for most options, stacked ratings if needed
- All interactive elements are touch-friendly (minimum 44x44px)

## Accessibility
- All inputs have proper labels
- Required fields marked with asterisk
- Clear visual feedback for selections
- Keyboard navigation supported
- Color contrast meets WCAG AA standards
