# System Admin User Manual

## Table of Contents
- [Role Overview](#role-overview)
- [Logging In](#logging-in)
- [Navigating the Dashboard](#navigating-the-dashboard)
- [Primary Tasks and Workflows](#primary-tasks-and-workflows)
  - [Create or Import Programs](#create-or-import-programs)
  - [Manage Users and Roles](#manage-users-and-roles)
  - [Configure Global References](#configure-global-references)
  - [Monitor Activity and Background Jobs](#monitor-activity-and-background-jobs)
- [Tips, Best Practices, and Troubleshooting](#tips-best-practices-and-troubleshooting)

## Role Overview
System Admins oversee the entire platform. They create programs, control system-wide settings, and manage all user accounts. They also ensure data quality by maintaining shared lists such as languages, facilities, indicators, rating scales, and PDF templates.

## Logging In
1. Open the application URL provided by your organization.
2. Select **Log in** and enter your email and password, or choose **Sign in with Google** if enabled.  
   _Placeholder: Insert screenshot of the login screen._
3. If you are new, confirm your email through the link sent to your inbox before signing in.
4. If you forget your password, click **Forgot your password?** to receive a reset email.

## Navigating the Dashboard
After signing in you land on the dashboard:
- The top navigation bar provides links to Programs, Users, Languages, Facilities, Indicators, Rating Scales, Templates, Activity Logs, and Settings.
- The bell or notification area shows background job statuses and system alerts.
- A profile menu (top right) lets you switch language, update your password, or sign out.  
  _Placeholder: Insert screenshot of the main dashboard._

## Primary Tasks and Workflows

### Create or Import Programs
1. Go to **Programs**.
2. Click **New Program** to create a fresh program, or select **Clone Setup** (clone icon) to reuse settings.
3. For cloning, follow the wizard to choose **Clone from Sample** or **Clone from Existing Program**, select components (languages, facilities, indicators, rating scales, PDF templates), review, and start the job.
4. Monitor the background job until it shows **Completed**.
5. Open the program to confirm languages, facilities, and templates are present.  
   _Placeholder: Insert screenshot of the program form or clone wizard._

### Manage Users and Roles
1. Go to **Users**.
2. Click **New User** to add an account; enter email, assign **System Admin**, **Admin**, **Staff/Officer**, or **Lngo**, and pick the program or local NGO when required.
3. To edit, select a user from the list and choose **Edit**; to deactivate, use **Archive** or **Lock** where available.
4. Use filters (email, program, local NGO, archived) to quickly find accounts.
5. If an account is locked after failed attempts, unlock it from the user detail page.

### Configure Global References
1. **Languages** – add or edit languages available for scorecards and exports.  
2. **Facilities** – manage facility categories relevant to programs.  
3. **Indicators** – curate indicators and their descriptions used in scorecards.  
4. **Rating Scales** – define rating labels and upload audio files if needed.  
5. **PDF Templates** – upload or update templates used for PDF exports.  
For each list:
- Navigate to the section from the top bar.
- Use **New** to add items, **Edit** to adjust, and **Archive/Delete** only when items are not in active use.  
  _Placeholder: Insert screenshot of a reference list page._

### Monitor Activity and Background Jobs
1. Open **Activity Logs** to see recent actions (user updates, program changes, data imports).
2. Check background job pages (e.g., clone wizard status) for **Pending**, **Processing**, **Completed**, or **Failed** states.
3. For failed jobs, review the error message and rerun after fixing the underlying issue.
4. Periodically review dashboard metrics to ensure programs and users are active.

## Tips, Best Practices, and Troubleshooting
- Prefer cloning a program to ensure consistent settings across new programs.
- Keep at least one additional System Admin active for backup.
- Before archiving languages, facilities, or indicators, confirm they are not referenced by active scorecards.
- If you cannot see a feature you expect, confirm your account is set to **System Admin** and try signing out/in.
- For login issues:
  - Use the password reset link.
  - If your account is locked, unlock it from the Users page or ask another System Admin.
- Document any configuration changes so Program Admins and Staff know what to expect.
