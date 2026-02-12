# Honour & Minor Course Management Implementation

## Overview
Added two new systems to the HOD Elective Management page:
1. **Honour Courses** - HOD can assign up to 2 courses for their department students to earn extra credit
2. **Minor Programs** - HOD can offer verticals as minor programs for other departments

---

## Database Changes

### 1. Honour Slots Setup
**File:** `server/db/honour_minor_setup.sql`

Run this SQL script to:
- Add 6 honour slots per semester (4-8) to `elective_semester_slots` table
- Slots are named "Honour Slot 1" through "Honour Slot 6"

```sql
-- Run the honour_minor_setup.sql file in your MySQL database
-- This adds honour slots and creates the minor selections table
```

### 2. Minor Selections Table
**Table:** `hod_minor_selections`

**Columns:**
- `id`, `department_id`, `curriculum_id`, `vertical_id`, `semester`, `course_id`
- `allowed_dept_ids` (JSON array of department IDs)
- `academic_year`, `batch`, `approved_by_user_id`, `status`
- `created_at`, `updated_at`

---

## Backend Changes

### Models (`server/models/electives.go`)
Added new models:
- `HODMinorSelection` - Minor program database record
- `MinorVerticalInfo` - Vertical information for UI
- `MinorCourse` - Course info for minor programs
- `SaveMinorRequest` - Request payload for saving minor selections
- `MinorSemesterAssignment` - Maps courses to semesters with departments
- `SaveMinorResponse`, `MinorSelectionResponse`, `MinorAssignmentInfo`
- `Department` - Department information

### Handlers (`server/handlers/curriculum/electives.go`)

**Honour Validation:**
- Updated `SaveHODSelections` with honour course validation:
  - Max 2 honour courses enforced
  - Honour courses cannot duplicate professional electives
  - Uses slot names to identify honour vs professional slots

**New Minor APIs:**
1. `GetMinorVerticals` - Get honour verticals for minor selection
2. `GetVerticalCourses` - Get courses in a specific vertical
3. `SaveHODMinorSelections` - Save minor program configuration
4. `GetHODMinorSelections` - Retrieve saved minor selections
5. `GetDepartments` - Get all active departments for multi-select

### Routes (`server/routes/routes.go`)
Added new endpoints:
- `GET /api/hod/minor-verticals` - List verticals
- `GET /api/hod/vertical-courses` - Get vertical's courses
- `GET /api/hod/minor-selections` - Get saved minor config
- `POST /api/hod/minor-selections` - Save minor program
- `GET /api/departments` - List all departments

---

## Frontend Changes

### HODElectivePage.js

**New State:**
- `honourSlots` - Honour slot options (filtered from semester slots)
- `honourAssignments` - Array of 2 honour course selections
- `minorVerticals` - Available verticals for minor
- `selectedMinorVertical` - Currently selected vertical
- `minorCourses` - Courses in selected vertical
- `minorAssignments` - Course distribution across sems 5-7
- `allowedDepartments` - Department IDs allowed to take minor
- `departments` - All departments for selection

**New Functions:**
- `fetchMinorVerticals()` - Load verticals
- `fetchDepartments()` - Load departments
- `fetchVerticalCourses(verticalId)` - Load courses for vertical
- `handleSaveMinor()` - Save minor program configuration

**Updated Functions:**
- `handleSave()` - Now includes honour course assignments in payload
- `fetchElectiveSlots()` - Extracts honour slots from all slots

**New UI Sections:**

1. **Honour Courses Section:**
   - 2 rows for selecting honour courses
   - Course dropdown (filters out professional electives)
   - Honour slot dropdown
   - Clear button for each row
   - Shows count: X/2 honour courses selected

2. **Minor Program Section:**
   - Vertical selection dropdown
   - 3x2 table for course distribution (sems 5, 6, 7 with 2 courses each)
   - Department multi-select checkboxes (excludes own department)
   - Save button with success/error messages

---

## How to Test

### Setup:
1. Run the SQL script:
   ```bash
   # From Management_Portal directory
   mysql -u your_user -p your_database < server/db/honour_minor_setup.sql
   ```

2. Start the backend:
   ```bash
   cd server
   go run main.go
   ```

3. Start the frontend:
   ```bash
   cd client
   npm run dev
   ```

### Testing Honour Courses:

1. Login as HOD
2. Navigate to Elective Management page
3. Scroll to "Honour Courses (Extra Credit)" section
4. **Test Case 1: Add 2 honour courses**
   - Select a course from dropdown for Honour Course 1
   - Select a honour slot
   - Repeat for Honour Course 2
   - Click main "Save Assignments" button
   - ✓ Should save successfully

5. **Test Case 2: Attempt to add 3rd honour course**
   - Try adding another honour course to professional electives
   - Backend should reject with error message

6. **Test Case 3: Duplicate check**
   - Add a course to professional electives
   - Try adding the same course as honour course
   - Backend should reject with error message

### Testing Minor Program:

1. **Test Case 1: Create minor program**
   - Scroll to "Minor Program Management" section
   - Select a vertical from dropdown
   - Verify 6 courses are auto-assigned to semesters (2-2-2)
   - Adjust course assignments if needed
   - Select at least one department from checkboxes
   - Click "Save Minor Program"
   - ✓ Should save successfully

2. **Test Case 2: Validation**
   - Try saving without selecting vertical → Should show error
   - Try saving without selecting departments → Should show error
   - Remove a course from semester 5 → Should show error about 2 courses per semester

3. **Test Case 3: Load existing minor**
   - Refresh the page
   - Previous minor selection should persist (requires adding load logic)

### Backend Validation Tests:

1. **Honour validation:**
   - Send POST to `/api/hod/electives/save` with 3 honour courses
   - Should return 400 error: "Maximum 2 honour courses allowed"

2. **Minor validation:**
   - Send POST to `/api/hod/minor-selections` with only 1 course in sem 5
   - Should return 400 error: "Each semester must have exactly 2 courses"

---

## API Examples

### Save Honour Courses (included in main elective save):
```json
POST /api/hod/electives/save?email=hod@university.edu
{
  "batch": "2024",
  "academic_year": "2025-2026",
  "course_assignments": [
    {
      "course_id": 101,
      "semester": 5,
      "slot_id": 25  // honour_slot_1 ID
    },
    {
      "course_id": 102,
      "semester": 6,
      "slot_id": 31  // honour_slot_1 ID  
    }
  ],
  "status": "ACTIVE"
}
```

### Save Minor Program:
```json
POST /api/hod/minor-selections?email=hod@university.edu
{
  "vertical_id": 5,
  "academic_year": "2025-2026",
  "batch": "2024",
  "semester_assignments": [
    {
      "semester": 5,
      "course_id": 201,
      "allowed_dept_ids": [2, 3, 4]
    },
    {
      "semester": 5,
      "course_id": 202,
      "allowed_dept_ids": [2, 3, 4]
    },
    {
      "semester": 6,
      "course_id": 203,
      "allowed_dept_ids": [2, 3, 4]
    },
    {
      "semester": 6,
      "course_id": 204,
      "allowed_dept_ids": [2, 3, 4]
    },
    {
      "semester": 7,
      "course_id": 205,
      "allowed_dept_ids": [2, 3, 4]
    },
    {
      "semester": 7,
      "course_id": 206,
      "allowed_dept_ids": [2, 3, 4]
    }
  ],
  "status": "ACTIVE"
}
```

---

## Future Enhancements

1. **Load existing honour assignments** on page load (currently only saves)
2. **Load existing minor selections** to populate form on page load
3. **Minor program viewing for other departments** - let other dept HODs see available minors
4. **Student minor selection interface** - students from other depts can choose minors
5. **Honour course enrollment tracking** - track which students take honour courses
6. **Validation improvements:**
   - Check vertical has exactly 6 courses before allowing minor creation
   - Prevent same course in multiple semesters
   - Department-level approvals workflow

---

## Troubleshooting

### Backend errors:
- **"Honour courses cannot be the same as professional elective courses"**
  → Clear honour course selection or choose different courses

- **"Maximum 2 honour courses allowed"**
  → Remove extra honour courses from payload

- **"Each semester must have exactly 2 courses"**
  → Ensure minor program has 2 courses in each of sems 5, 6, 7

### Frontend issues:
- **Honour slots dropdown empty**
  → Check SQL script ran successfully
  → Verify `elective_semester_slots` has rows with slot_name containing "Honour Slot"

- **Verticals dropdown empty**
  → Check `honour_verticals` table has active rows for your curriculum
  → Verify HOD profile API returns curriculum_id

- **Departments not loading**
  → Check `departments` table has active rows (status=1)

---

## Files Modified

**Database:**
- `server/db/honour_minor_setup.sql` (new)

**Backend:**
- `server/models/electives.go` (added minor models)
- `server/handlers/curriculum/electives.go` (added honour validation + minor APIs)
- `server/routes/routes.go` (added minor routes)

**Frontend:**
- `client/src/pages/curriculum/HODElectivePage.js` (added honour + minor UI sections)

---

## Summary

✅ **Completed:**
- Database schema for honour slots and minor selections
- Backend validation for honour courses (max 2, no duplicates with professional)
- Backend APIs for minor program management (CRUD operations)
- Frontend UI for honour course selection (2 dropdowns)
- Frontend UI for minor program management (vertical selection, course distribution, dept selection)
- Integration with existing save flow (honour courses included in main payload)

🚧 **Next Steps:**
- Run SQL migration script
- Test honour course selection and validation
- Test minor program creation
- Consider adding load logic to populate existing selections on page load
