# Facility Creation Guide

## Overview

When creating a new facility in a program, administrators now have two options to choose from:

## Option 1: Create New Custom Facility

Use this option when you need to create a facility that is not in the predefined list.

**Steps:**
1. Click on "Create Facility"
2. Select the "Create New Custom Facility" tab (default)
3. Fill in the facility details:
   - Name (English)
   - Name (Khmer)
   - Code
   - Parent (optional)
   - Dataset (if applicable)
4. Click "Save"

**Note:** If you enter a name that matches a predefined facility, you'll see an alert prompting you to use the predefined list instead. This ensures consistency across programs.

## Option 2: Select from Predefined Facilities

Use this option to add standard facilities that are commonly used across multiple programs.

**Steps:**
1. Click on "Create Facility"
2. Select the "Select from Predefined Facilities" tab
3. Review the list of predefined facilities organized by parent-child relationships
4. Select the parent facilities you want to add (children will be automatically included)
5. Click "Save"

**Predefined Facilities:**
- **PA** (Public Administration)
  - CA (Commune Administrative)
- **ED** (Education)
  - PS (Primary School)
- **HE** (Health)
  - HC (Health Center)
- **GS** (Garment Sector)
  - FA (Factory)

**Benefits:**
- Consistent facility codes across all programs
- Accurate data consolidation for dashboards
- No developer involvement required
- Facilities that have already been added to your program will be filtered out

## Database Migration

To use this feature, run the following command:

```bash
rails db:migrate
rails db:seed
```

This will create the predefined_facilities table and populate it with the standard facility list.
