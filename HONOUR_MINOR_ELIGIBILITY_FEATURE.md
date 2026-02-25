# Student Honour/Minor Eligibility Feature - Implementation Summary

## Overview
This document describes the implementation of the honour/minor eligibility feature and "Not Opted" functionality for the student elective selection system.

## Changes Made

### 1. Database Changes

#### New Table: `student_eligible_honour_minor`
```sql
CREATE TABLE IF NOT EXISTS student_eligible_honour_minor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_email VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_student_email (student_email)
);
```

**Purpose**: Controls which students can see and select Honour/Minor courses.

**Migration File**: `server/db/migrations/20260225_create_student_eligible_honour_minor.sql`

### 2. Backend Changes

#### File: `server/handlers/student-teacher_entry/electives.go`

**Changes in `GetAvailableElectives` function:**
- Added eligibility check:
  ```go
  var isEligibleForHonourMinor bool
  err = db.DB.QueryRow(`
      SELECT EXISTS(
          SELECT 1 FROM student_eligible_honour_minor 
          WHERE student_email = ?
      )
  `, email).Scan(&isEligibleForHonourMinor)
  ```
- Filter out HONOR and MINOR slots for non-eligible students:
  ```go
  if !isEligibleForHonourMinor && (slot.SlotType == "HONOR" || slot.SlotType == "MINOR") {
      log.Printf("Filtering out %s slot '%s' - student not eligible", slot.SlotType, slot.SlotName)
      continue
  }
  ```

**Changes in `SaveElectiveSelections` function:**
- Handle "NOT_OPTED" selections by skipping them (courseID == 0):
  ```go
  if courseID == 0 {
      log.Printf("Skipping NOT_OPTED selection for slot %s", slotName)
      successCount++
      continue
  }
  ```

### 3. Frontend Changes

#### File: `client/src/pages/student/ElectiveSelectionPage.js`

**Added "Not Opted" Option:**
- HONOR and MINOR slots now show a "Not Opted" radio button option
- Selecting "Not Opted" allows students to explicitly decline Honour/Minor courses

**Updated Validation Logic:**
- Students can now either:
  1. Fill all HONOR/MINOR slots with courses
  2. Select "Not Opted" for all HONOR/MINOR slots
  3. Leave them blank (if optional)
- Cannot mix "Not Opted" with course selections for the same type (HONOR or MINOR)

**Updated `handleSelection` function:**
- Special handling for "NOT_OPTED" value
- "NOT_OPTED" selections don't count towards credit limits

**Updated `calculateTotalCredits` function:**
- Skips "NOT_OPTED" selections when calculating credits

**Updated Rules Display:**
- Added information about "Not Opted" option
- Added note that Honour/Minor visibility is based on eligibility

## Feature Behavior

### For Eligible Students (in `student_eligible_honour_minor` table):
- ✅ Can see HONOR slots (if available)
- ✅ Can see MINOR slots (if available)
- ✅ Can see ADDON slots (always visible)
- ✅ Can select courses OR "Not Opted" for HONOR/MINOR
- ✅ Must be consistent: all courses OR all "Not Opted" for each type

### For Non-Eligible Students:
- ❌ Cannot see HONOR slots
- ❌ Cannot see MINOR slots
- ✅ Can see ADDON slots (always visible)
- ✅ Can select any ADDON courses

### For All Students:
- ✅ ADDON courses are visible to everyone
- ✅ Total credits for HONOR/MINOR/ADDON combined: max 8 credits
- ✅ "Not Opted" selections = 0 credits

## How to Manage Eligible Students

### Add a Student to Eligible List:
```sql
INSERT INTO student_eligible_honour_minor (student_email) 
VALUES ('student@example.com');
```

### Remove a Student from Eligible List:
```sql
DELETE FROM student_eligible_honour_minor 
WHERE student_email = 'student@example.com';
```

### View All Eligible Students:
```sql
SELECT * FROM student_eligible_honour_minor;
```

### Check if a Student is Eligible:
```sql
SELECT EXISTS(
    SELECT 1 FROM student_eligible_honour_minor 
    WHERE student_email = 'student@example.com'
) AS is_eligible;
```

### Bulk Add Students:
```sql
INSERT INTO student_eligible_honour_minor (student_email) 
VALUES 
    ('student1@example.com'),
    ('student2@example.com'),
    ('student3@example.com');
```

## Testing Checklist

- [ ] Run migration to create `student_eligible_honour_minor` table
- [ ] Add test student emails to the table
- [ ] Test eligible student can see HONOR/MINOR slots
- [ ] Test non-eligible student cannot see HONOR/MINOR slots
- [ ] Test all students can see ADDON slots
- [ ] Test "Not Opted" option appears for HONOR/MINOR
- [ ] Test validation: cannot mix "Not Opted" with courses
- [ ] Test validation: can select all courses for HONOR/MINOR
- [ ] Test validation: can select "Not Opted" for all HONOR/MINOR
- [ ] Test credit calculation excludes "Not Opted" selections
- [ ] Test submission with "Not Opted" selections

## Notes

- The eligibility check is done at the backend level for security
- ADDON courses are intentionally available to all students regardless of eligibility
- "Not Opted" is stored as a special value that is skipped during database insertion
- The table uses student email (from contact_details.student_email) as the key
