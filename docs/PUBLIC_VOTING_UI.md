# Public Voting Page - UI/UX Description

## Visual Design Overview

The public voting page features a modern, professional design with a gradient purple background and a clean, card-based layout that guides users through a simple two-step voting process.

## Page Layout

### Header Section
- **Background**: Linear gradient from purple (#667eea) to dark purple (#764ba2)
- **Card Header**: Blue primary color with white text
- **Title**: "Community Scorecard Voting"
- **Subtitle**: Displays the scorecard name

### Step 1: Participant Profile Form

This step collects basic demographic information about the voter.

**Form Fields:**

1. **Age** (Required)
   - Number input field
   - Validation: 1-150 years
   - Rounded corners, responsive design

2. **Gender** (Required)
   - Dropdown select
   - Options: Female, Male, Other
   - Prompt text: "Select gender"

3. **Demographic Checkboxes** (Optional)
   - Person with disability
   - Ethnic minority
   - ID Poor card holder
   - Youth (15-24 years old)
   - Each checkbox has a light gray background (#f8f9fa)
   - Hover effect changes to darker gray (#e9ecef)

**Navigation:**
- Blue "Next" button with right arrow icon
- Positioned at bottom right

### Step 2: Rate Indicators

This step displays all indicators for the scorecard with interactive rating controls.

**Indicator Display:**

Each indicator is shown in a card with:
- Light background (#f8f9fa)
- Border and rounded corners
- Hover effect: subtle shadow and upward movement
- Responsive spacing

**Indicator Components:**

1. **Indicator Name**: Bold, dark text (#2c3e50)
2. **Hint Text** (if available): Smaller, muted gray text
3. **Rating Scale**: Five interactive buttons (1-5)

**Rating Buttons:**

The rating interface consists of 5 buttons arranged horizontally:

```
[1]     [2]       [3]         [4]    [5]
Very    Bad    Acceptable    Good   Very
Bad                                  Good
```

**Button States:**
- **Default**: White background, gray border
- **Hover**: Blue border (#007bff), light blue background (#e7f1ff), slight upward movement
- **Selected**: Blue background (#007bff), white text, blue border

**Button Layout:**
- Each button shows:
  - Large score number (1.5rem, bold)
  - Rating label below (smaller text)
- Flexible layout for responsiveness
- On mobile: Buttons stack vertically

**Navigation:**
- "Back" button (gray, left side) with left arrow icon
- "Submit Vote" button (green, right side) with check icon

### Step 3: Success/Error Messages

**Success State:**
- Green success alert
- Check circle icon
- "Vote Submitted Successfully!" heading
- Thank you message

**Error State:**
- Red danger alert
- Exclamation circle icon
- Error message display
- Submit button re-enabled for retry

**Voting Closed State:**
- Yellow warning alert
- "Voting is Currently Closed" heading
- Informative message about contacting organizer

## Color Scheme

- **Primary**: #007bff (Blue)
- **Success**: #28a745 (Green)
- **Warning**: #ffc107 (Yellow)
- **Danger**: #dc3545 (Red)
- **Background Gradient**: #667eea → #764ba2
- **Card Background**: White (#ffffff)
- **Light Background**: #f8f9fa
- **Text**: #2c3e50 (Dark gray)
- **Muted Text**: #6c757d (Gray)

## Responsive Design

### Desktop (≥768px)
- Cards centered with max-width
- Rating buttons display horizontally
- Generous padding and spacing

### Mobile (<768px)
- Full-width cards with minimal padding
- Rating buttons stack vertically for easier tapping
- Form fields expand to full width
- Touch-friendly button sizes

## Interactive Behaviors

1. **Form Validation**
   - Real-time validation on required fields
   - Browser native validation messages
   - Submit disabled until all fields valid

2. **Step Navigation**
   - Smooth transition between steps
   - Scroll to top on step change
   - Data preserved when moving back

3. **Rating Selection**
   - Visual feedback on hover
   - Clear active state when selected
   - Only one rating per indicator
   - All indicators must be rated

4. **Submission Process**
   - Loading spinner during submission
   - Disabled submit button during processing
   - Success message replaces form
   - Error messages shown inline

## Accessibility Features

1. **Form Labels**: All inputs have associated labels
2. **Required Fields**: Marked and validated
3. **Color Contrast**: Meets WCAG AA standards
4. **Keyboard Navigation**: Full keyboard support
5. **Focus Indicators**: Visible focus states
6. **Error Messages**: Clear, descriptive error text

## User Flow

```
1. User visits /scorecards/:uuid/vote
   ↓
2. Check if voting_open
   ↓ (if true)
3. Show Step 1: Participant Profile
   ↓ (fill form, click Next)
4. Validate Step 1 data
   ↓ (if valid)
5. Show Step 2: Rate Indicators
   ↓ (rate all indicators)
6. User clicks Submit
   ↓
7. Validate all ratings present
   ↓ (if valid)
8. Submit to server with CSRF token
   ↓
9. Server processes and saves vote
   ↓
10. Show success message
```

## Technical Implementation

- **Framework**: Ruby on Rails with Haml templates
- **Styling**: SCSS with Bootstrap 4
- **JavaScript**: Vanilla JavaScript (no jQuery dependency)
- **AJAX**: Fetch API for form submission
- **Security**: CSRF token included in all requests
- **i18n**: Full English and Khmer translation support

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)
- Mobile browsers (iOS Safari, Chrome Mobile)

## Performance Considerations

- Minimal JavaScript dependencies
- CSS optimized with SCSS nesting
- Single page load, no additional requests
- Efficient DOM manipulation
- Smooth transitions and animations
