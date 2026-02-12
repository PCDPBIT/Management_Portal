# Teacher Course Selection - Troubleshooting Guide

## Problem Summary
Teacher ID 140 doesn't exist in the database, causing 500 errors when trying to fetch courses.

## Root Cause
You have stale `teacher_id: 140` stored in localStorage from a previous session, but this teacher doesn't exist in the `teachers` table.

---

## SOLUTION 1: Clear LocalStorage and Re-Login (RECOMMENDED)

### Step 1: Open Browser Console
Press `F12` or right-click → Inspect → Console tab

### Step 2: Clear Stale Data
Paste this code in the console:

```javascript
// Clear all localStorage
localStorage.clear();

// Reload the page
location.reload();
```

### Step 3: Login Again
- Go to login page
- Enter your credentials
- System will now store correct teacher_id (or none if you're not in teachers table)

---

## SOLUTION 2: Check Database and Create Teacher Record

### Step 1: Run Diagnostic Queries
Execute `diagnose_teacher_mismatch.sql` in your MySQL client to see:
- Which users have teacher role
- Which teachers exist
- Mismatches between users and teachers tables

### Step 2: Create Missing Teacher
If the user SHOULD be a teacher but isn't in the teachers table, run:

```sql
INSERT INTO teachers (name, email, faculty_id, dept, designation, status, theory_subject_count, theory_with_lab_subject_count)
VALUES (
  'Your Name',
  'your.email@example.com',  -- MUST match the email in users table
  'AD001',  -- Faculty ID
  'AI&DS',  -- Department
  'Assistant Professor',
  1,  -- status: active
  2,  -- How many theory courses can teach
  1   -- How many theory+lab courses can teach
);
```

### Step 3: Clear LocalStorage and Re-Login
Follow Solution 1 steps above.

---

## SOLUTION 3: Use a Different Teacher Account

If you have other teacher accounts in the database:

### Step 1: Check Existing Teachers
```sql
SELECT id, name, email, faculty_id, dept
FROM teachers
WHERE status = 1
ORDER BY id;
```

### Step 2: Find Matching User Account
```sql
SELECT u.id, u.username, u.email, u.role
FROM users u
INNER JOIN teachers t ON u.email = t.email
WHERE u.role IN ('teacher', 'hod')
AND t.status = 1;
```

### Step 3: Login with Valid Teacher Account
Use credentials from a user that has a matching teacher record.

---

## Files Created for You

1. **check_teachers.sql** - Check what teachers exist
2. **create_teacher_140.sql** - Template to create teacher 140
3. **diagnose_teacher_mismatch.sql** - Find mismatches between users and teachers
4. **clear_localstorage.js** - Script to clear stale data

---

## Code Changes Made

### 1. Login Page Enhancement
**File:** `client/src/pages/curriculum/loginPage.js`
- Now clears stale teacher_id if backend doesn't return teacher_data
- Prevents this issue from happening again

### 2. Teacher Course Selection Error Handling
**File:** `client/src/pages/teacher/TeacherCourseSelectionPage.js`
- Shows helpful error messages
- Displays debug info when teacher not found
- Gracefully handles 404 and 500 errors

### 3. Sidebar Menu Items
**File:** `client/src/components/Sidebar.js`
- Added menu items for all roles
- Teachers now see "My Course Selection"
- Students see "My Electives"
- HODs get access to management features

---

## Next Steps

1. **IMMEDIATELY**: Clear localStorage and re-login (Solution 1)
2. **If still issues**: Run diagnostic queries to check database
3. **If teacher missing**: Create teacher record or use different account

---

## Preventing This Issue

The fix in loginPage.js now automatically clears stale teacher data, so this won't happen again after you:
1. Clear localStorage once
2. Re-login to get fresh data
