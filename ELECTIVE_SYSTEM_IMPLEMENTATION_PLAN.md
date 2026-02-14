# Elective Course Selection System - Complete Implementation Plan

## 📋 System Overview

**Purpose**: Enable HODs to select elective courses for their department, then allow students to choose from HOD-approved electives based on:

- Department authentication via email
- Academic calendar (current semester)
- Student batch (year of admission)
- Future-proof design for multiple batches and academic years

---

## 🗄️ Database Architecture

### **Schema Analysis - Existing Tables**

| Table                 | Key Fields                                                 | Purpose                                                            |
| --------------------- | ---------------------------------------------------------- | ------------------------------------------------------------------ |
| `users`               | `email`, `role`, `password_hash`                           | HOD login credentials                                              |
| `teachers`            | `email`, `faculty_id`, `dept`                              | Faculty information                                                |
| `department_teachers` | `teacher_id`, `department_id`                              | Links faculty to departments                                       |
| `departments`         | `id`, `department_name`                                    | Department master                                                  |
| `courses`             | `course_code`, `course_name`, `course_type`                | All courses (electives have types like "ELECTIVE 1", "ELECTIVE 3") |
| `curriculum`          | `id`, `name`, `academic_year`                              | Curriculum definitions                                             |
| `curriculum_courses`  | `curriculum_id`, `semester_id`, `course_id`                | Courses mapped to semesters                                        |
| `students`            | `id`, `name`, `roll_no`                                    | Student master                                                     |
| `academic_details`    | `student_id`, `batch`, `year`, `semester`, `curriculum_id` | Student academic info                                              |

### **New Tables Created**

See [`elective_system_schema.sql`](elective_system_schema.sql) for complete DDL.

#### 1. **`academic_calendar`**

- Tracks current semester and academic year
- Defines elective selection date ranges
- Only one row with `is_current = 1`

**Key Fields:**

```sql
academic_year VARCHAR(20)           -- "2025-2026"
current_semester INT                -- 1-8
elective_selection_start DATE       -- When students can select
elective_selection_end DATE         -- Selection deadline
is_current TINYINT(1)              -- Marks active semester
```

#### 2. **`hod_elective_selections`**

- Stores HOD-approved elective courses
- Supports batch-specific and year-specific selections
- Allows capacity limits via `max_students`

**Key Fields:**

```sql
department_id INT                   -- Which department
curriculum_id INT                   -- Which curriculum
semester INT                        -- 4-8 (electives start sem 4)
course_id INT                       -- The elective course
academic_year VARCHAR(20)           -- "2025-2026"
batch VARCHAR(20)                   -- "2024-2028" (student batch)
max_students INT                    -- Capacity limit (optional)
approved_by_user_id INT            -- HOD who approved
status ENUM('ACTIVE', 'INACTIVE', 'DRAFT')
```

**Unique Constraint:** `(department_id, semester, course_id, academic_year, batch)`

#### 3. **`student_elective_choices`**

- Student selections from HOD-approved pool
- Tracks selection status and priority

**Key Fields:**

```sql
student_id INT
hod_selection_id INT               -- References hod_elective_selections
semester INT
academic_year VARCHAR(20)
choice_order INT                   -- Priority (1=first choice)
status ENUM('PENDING', 'CONFIRMED', 'REJECTED', 'WAITLISTED')
```

#### 4. **`department_curriculum_active`**

- Maps departments to active curricula per year
- Handles departments changing curricula

---

## 🔐 Authentication & Authorization Flow

### **HOD Login → Department Detection**

```
1. User logs in with email/password
2. Verify credentials in `users` table
3. Check role = 'hod'
4. Query to get department:

   SELECT d.id, d.department_name, dt.teacher_id
   FROM users u
   INNER JOIN teachers t ON u.email = t.email
   INNER JOIN department_teachers dt ON t.faculty_id = dt.teacher_id
   INNER JOIN departments d ON dt.department_id = d.id
   WHERE u.email = ? AND u.role = 'hod'
   LIMIT 1

5. Store in session/JWT: user_id, email, role, department_id, department_name
```

**Edge Cases:**

- HOD email not in teachers table → Error: "Please contact admin"
- HOD linked to multiple departments → Use first, or show selection screen
- Department has no active curriculum → Error: "No curriculum configured"

### **Student Login → Batch Detection**

```
1. Student logs in (authentication TBD - may use students table or separate auth)
2. Query academic details:

   SELECT ad.batch, ad.year, ad.semester, ad.curriculum_id, ad.department
   FROM students s
   INNER JOIN academic_details ad ON s.id = ad.student_id
   WHERE s.id = ?

3. Store in session: student_id, batch, current_year, current_semester, curriculum_id, department
```

---

## 📡 Backend API Endpoints (Go)

### **HOD APIs**

#### 1. `GET /api/hod/profile`

**Purpose:** Get HOD department and curriculum info  
**Response:**

```json
{
  "user_id": 3,
  "full_name": "hod",
  "email": "preetha@bitsathy.ac.in",
  "role": "hod",
  "department": {
    "id": 14,
    "name": "Artificial Intelligence and Data Science",
    "code": "AD"
  },
  "curriculum": {
    "id": 296,
    "name": "AIDS Curriculum",
    "academic_year": "2025-2026"
  }
}
```

#### 2. `GET /api/hod/electives/available?semester={sem}&batch={batch}`

**Purpose:** Get available elective courses for a semester  
**Query Logic:**

```sql
SELECT
    c.id, c.course_code, c.course_name, c.course_type,
    c.category, c.credit,
    CASE
        WHEN hes.id IS NOT NULL THEN true
        ELSE false
    END AS is_selected
FROM curriculum_courses cc
INNER JOIN courses c ON cc.course_id = c.id
LEFT JOIN hod_elective_selections hes ON (
    hes.course_id = c.id
    AND hes.department_id = ?
    AND hes.semester = ?
    AND hes.academic_year = ?
    AND (hes.batch = ? OR hes.batch IS NULL)
    AND hes.status = 'ACTIVE'
)
WHERE cc.curriculum_id = ?
  AND cc.semester_id = (SELECT id FROM normal_cards WHERE semester_number = ?)
  AND c.course_type LIKE '%ELECTIVE%'
ORDER BY c.course_type, c.course_code
```

**Response:**

```json
{
  "semester": 4,
  "batch": "2024-2028",
  "academic_year": "2025-2026",
  "available_electives": [
    {
      "id": 147,
      "course_code": "22AI002",
      "course_name": "UI AND UX DESIGN",
      "course_type": "ELECTIVE 1",
      "category": "THEORY",
      "credit": 3,
      "is_selected": true
    },
    {
      "id": 154,
      "course_code": "22AI043",
      "course_name": "PYTHON FOR DATA SCIENCE",
      "course_type": "ELECTIVE 1",
      "category": "THEORY",
      "credit": 3,
      "is_selected": false
    }
  ]
}
```

#### 3. `POST /api/hod/electives/save`

**Purpose:** Save HOD's elective selections  
**Request:**

```json
{
  "semester": 4,
  "batch": "2024-2028",
  "academic_year": "2025-2026",
  "selected_courses": [147, 154, 148],
  "status": "ACTIVE"
}
```

**Logic:**

1. Get department_id from authenticated user
2. Get curriculum_id from department_curriculum_active
3. Delete existing selections: `DELETE FROM hod_elective_selections WHERE department_id=? AND semester=? AND batch=? AND academic_year=?`
4. Insert new selections in batch
5. Return success

**Response:**

```json
{
  "success": true,
  "message": "3 elective courses saved for Semester 4",
  "selections": [...]
}
```

#### 4. `GET /api/hod/electives/selected?semester={sem}&batch={batch}`

**Purpose:** Get HOD's current selections  
**Use:** Pre-populate right panel on page load

#### 5. `GET /api/hod/batches`

**Purpose:** Get all batches for the HOD's department  
**Query:**

```sql
SELECT DISTINCT batch
FROM academic_details
WHERE department = (SELECT department_name FROM departments WHERE id = ?)
ORDER BY batch DESC
```

### **Student APIs**

#### 6. `GET /api/student/electives/available?semester={sem}`

**Purpose:** Get HOD-approved electives for student's batch/department  
**Logic:**

```sql
SELECT DISTINCT
    hes.id AS selection_id,
    c.course_code, c.course_name, c.course_type,
    c.category, c.credit,
    hes.max_students,
    COUNT(sec.id) AS current_enrollments,
    CASE
        WHEN my_choice.id IS NOT NULL THEN true
        ELSE false
    END AS is_chosen
FROM hod_elective_selections hes
INNER JOIN courses c ON hes.course_id = c.id
LEFT JOIN student_elective_choices sec ON hes.id = sec.hod_selection_id
LEFT JOIN student_elective_choices my_choice ON (
    hes.id = my_choice.hod_selection_id
    AND my_choice.student_id = ?
)
WHERE hes.department_id = ?
  AND hes.semester = ?
  AND hes.batch = ?
  AND hes.academic_year = ?
  AND hes.status = 'ACTIVE'
GROUP BY hes.id, c.id
HAVING current_enrollments < hes.max_students OR hes.max_students IS NULL
```

#### 7. `POST /api/student/electives/choose`

**Purpose:** Student chooses electives  
**Request:**

```json
{
  "semester": 4,
  "selections": [
    { "hod_selection_id": 123, "choice_order": 1 },
    { "hod_selection_id": 124, "choice_order": 2 }
  ]
}
```

### **Admin/System APIs**

#### 8. `GET /api/academic-calendar/current`

**Purpose:** Get current semester and academic year

#### 9. `POST /api/academic-calendar/update`

**Purpose:** Admin updates current semester

---

## 🎨 Frontend Implementation

### **HODElectivePage.js Updates**

**Current State:**

- Split-view UI with dummy data
- Semester tabs (4-8)
- Color-coded categories
- Selection/deselection functionality

**Required Changes:**

1. **Add Batch Selector**

```jsx
const [batches, setBatches] = useState([]);
const [selectedBatch, setSelectedBatch] = useState("");

useEffect(() => {
  // Fetch batches from API
  fetch("/api/hod/batches")
    .then((res) => res.json())
    .then((data) => {
      setBatches(data.batches);
      if (data.batches.length > 0) {
        setSelectedBatch(data.batches[0]); // Default to latest batch
      }
    });
}, []);
```

2. **Fetch Available Electives**

```jsx
useEffect(() => {
  if (!selectedBatch) return;

  Promise.all([
    fetch(
      `/api/hod/electives/available?semester=${activeSemester}&batch=${selectedBatch}`,
    ),
    fetch(
      `/api/hod/electives/selected?semester=${activeSemester}&batch=${selectedBatch}`,
    ),
  ]).then(async ([availableRes, selectedRes]) => {
    const available = await availableRes.json();
    const selected = await selectedRes.json();

    setAvailableElectives(available.available_electives);
    setSelectedElectives(selected.selected_courses);
  });
}, [activeSemester, selectedBatch]);
```

3. **Save Functionality**

```jsx
const handleSave = async () => {
  const courseIds = selectedElectives.map((e) => e.id);

  const response = await fetch("/api/hod/electives/save", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      semester: activeSemester,
      batch: selectedBatch,
      academic_year: currentAcademicYear, // From context/state
      selected_courses: courseIds,
      status: "ACTIVE",
    }),
  });

  const result = await response.json();
  if (result.success) {
    // Show success message
  }
};
```

4. **UI Enhancements**

- Add batch dropdown in header
- Add "Save" and "Publish" buttons
- Add loading states
- Add confirmation dialogs
- Display current academic year
- Show selection count (e.g., "Selected: 5 courses")

### **New Student Page: StudentElectivePage.js**

Create new page for student elective selection:

```jsx
import React, { useState, useEffect } from "react";
import MainLayout from "../components/MainLayout";

const StudentElectivePage = () => {
  const [availableElectives, setAvailableElectives] = useState([]);
  const [myChoices, setMyChoices] = useState([]);
  const [semester, setSemester] = useState(4);

  useEffect(() => {
    fetchElectives();
  }, [semester]);

  const fetchElectives = async () => {
    const res = await fetch(
      `/api/student/electives/available?semester=${semester}`,
    );
    const data = await res.json();
    setAvailableElectives(data.electives);
  };

  const handleSelect = async (selectionId) => {
    // Add to choices
    const response = await fetch("/api/student/electives/choose", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        semester,
        selections: [{ hod_selection_id: selectionId, choice_order: 1 }],
      }),
    });

    if (response.ok) {
      fetchElectives(); // Refresh
    }
  };

  return (
    <MainLayout>
      <div className="p-6">
        <h1 className="text-2xl font-bold mb-4">Choose Elective Courses</h1>

        {/* Semester tabs */}
        {/* Available electives list */}
        {/* My selections panel */}
      </div>
    </MainLayout>
  );
};

export default StudentElectivePage;
```

---

## 🔄 Data Flow Diagram

### **HOD Flow**

```
1. Login → Email verified → Department detected → Curriculum fetched
2. Select batch → Fetch available electives from curriculum
3. Select courses → Right panel updates
4. Click "Save" → POST to API → Database updated
5. Status: DRAFT → Can edit anytime
6. Click "Publish" → Status: ACTIVE → Students can see
```

### **Student Flow**

```
1. Login → Batch/semester detected from academic_details
2. Check academic_calendar → Is elective selection window open?
3. Fetch HOD-approved electives for student's dept/batch/semester
4. Select electives → POST to API
5. Status: PENDING → Admin can confirm later
```

### **Academic Calendar Update Flow**

```
1. Admin updates current_semester in academic_calendar
2. System automatically shows electives for new semester
3. HODs can see which semesters need elective selection
4. Students see notification if their semester has elective selection open
```

---

## 🛡️ Edge Cases & Solutions

| Edge Case                                        | Solution                                                                   |
| ------------------------------------------------ | -------------------------------------------------------------------------- |
| **HOD not in teachers table**                    | Show error: "Your account is not linked to faculty record. Contact admin." |
| **HOD linked to multiple departments**           | Show department selection screen, or use first department                  |
| **Department has no curriculum**                 | Show error: "No curriculum configured for your department."                |
| **Student batch not in academic_details**        | Cannot proceed until admin adds student academic info                      |
| **Same course selected for multiple batches**    | Allowed - different batches can have same electives                        |
| **HOD selects conflicting electives**            | No restriction - HOD can select any electives from curriculum              |
| **Student tries to select after deadline**       | Check `elective_selection_end` date, block if past                         |
| **Course reaches max_students capacity**         | Query excludes full courses from student view                              |
| **Curriculum changes mid-year**                  | Use `curriculum_id` + `academic_year` to track historical data             |
| **Multiple semesters running (e.g., sem 3 & 5)** | `current_semester` refers to odd/even, filter by student's actual semester |

---

## 🚀 Implementation Steps

### **Phase 1: Database Setup** ✅ READY

1. Run `elective_system_schema.sql` to create tables
2. Insert sample academic calendar data
3. Link departments to curricula in `department_curriculum_active`

### **Phase 2: Backend API** 🔨 TODO

1. Create Go handlers in `server/handlers/curriculum/electives.go`:
   - `GetHODProfile()`
   - `GetAvailableElectives()`
   - `SaveHODSelections()`
   - `GetStudentElectives()`
   - `SaveStudentChoices()`

2. Create Go models in `server/models/electives.go`:
   - `AcademicCalendar struct`
   - `HODElectiveSelection struct`
   - `StudentElectiveChoice struct`

3. Add routes in `server/routes/routes.go`:

   ```go
   // HOD routes
   r.GET("/api/hod/profile", handlers.GetHODProfile)
   r.GET("/api/hod/electives/available", handlers.GetAvailableElectives)
   r.POST("/api/hod/electives/save", handlers.SaveHODSelections)
   r.GET("/api/hod/batches", handlers.GetHODBatches)

   // Student routes
   r.GET("/api/student/electives/available", handlers.GetStudentElectives)
   r.POST("/api/student/electives/choose", handlers.SaveStudentChoices)

   // System routes
   r.GET("/api/academic-calendar/current", handlers.GetCurrentAcademicCalendar)
   ```

4. Add authentication middleware to verify HOD role

### **Phase 3: Frontend Integration** 🔨 TODO

1. Update `HODElectivePage.js`:
   - Add batch selector dropdown
   - Replace dummy data with API calls
   - Add save/publish buttons
   - Add loading states
   - Add error handling

2. Create `StudentElectivePage.js`:
   - Build UI similar to HOD page
   - Show only HOD-approved electives
   - Add selection confirmation

3. Update routes in client

### **Phase 4: Testing** 🧪 TODO

1. Test HOD login → department detection
2. Test elective selection across multiple batches
3. Test student selection with capacity limits
4. Test academic year transitions
5. Test concurrent HOD selections

### **Phase 5: Deployment** 🚢 TODO

1. Backup database
2. Run migrations
3. Update Go server
4. Deploy frontend
5. User training for HODs

---

## 📊 Sample Queries for Testing

### **Check HOD's department**

```sql
SELECT d.id, d.department_name
FROM users u
INNER JOIN teachers t ON u.email = t.email
INNER JOIN department_teachers dt ON t.faculty_id = dt.teacher_id
INNER JOIN departments d ON dt.department_id = d.id
WHERE u.email = 'preetha@bitsathy.ac.in';
```

### **Get electives for AIDS dept, semester 4**

```sql
SELECT c.course_code, c.course_name, c.course_type
FROM curriculum_courses cc
INNER JOIN courses c ON cc.course_id = c.id
WHERE cc.curriculum_id = 296
  AND c.course_type LIKE '%ELECTIVE%'
  AND cc.semester_id IN (SELECT id FROM normal_cards WHERE semester_number = 4);
```

### **Check HOD selections**

```sql
SELECT * FROM v_hod_approved_electives
WHERE department_id = 14 AND semester = 4;
```

---

## 🎯 Success Criteria

- ✅ HOD can login and see their department automatically
- ✅ HOD can select electives for current semester of all years (1st year, 2nd year, etc.)
- ✅ Different batches can have different elective options
- ✅ Students see only HOD-approved electives for their batch
- ✅ System supports multiple academic years without code changes
- ✅ Selection deadlines are enforced via academic calendar
- ✅ Capacity limits work if HOD sets max_students
- ✅ Historical data preserved for past semesters

---

## 📝 Next Actions

**IMMEDIATE:**

1. Review this plan with stakeholders
2. Run `elective_system_schema.sql` on database
3. Start backend API development

**QUESTIONS TO CLARIFY:**

1. Should HOD be able to select different electives for different sections?
2. Do we need approval workflow (HOD → Principal)?
3. Should students rank their choices (1st choice, 2nd choice)?
4. What happens if a student doesn't select in time - auto-assign?
5. Can students change their selection after confirmation?

**FILES CREATED:**

- `elective_system_schema.sql` - Complete database schema
- `ELECTIVE_SYSTEM_IMPLEMENTATION_PLAN.md` - This document
