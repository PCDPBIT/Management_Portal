# Course Type Reference Analysis
## Management Portal Codebase

**Date:** February 4, 2026  
**Analysis Scope:** All references to `course_type` in frontend, backend, and database

---

## 1. DATABASE STRUCTURE

### Courses Table Definition
**File:** [References/cms_test.sql](References/cms_test.sql#L579)

**Column Definition:**
```sql
`course_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL
```

**Table Structure:** Complete courses table (lines 579-607)
- `id` - AUTO_INCREMENT primary key
- `course_code` - VARCHAR(50)
- `course_name` - VARCHAR(255)
- **`course_type`** - VARCHAR(50) - **stores course type as string**
- `credit`, `lecture_hrs`, `tutorial_hrs`, `practical_hrs`, `activity_hrs`
- `category` - VARCHAR(50)
- `cia_marks`, `see_marks` - marks
- `theory_total_hrs`, `tutorial_total_hrs`, `practical_total_hrs`, `activity_total_hrs`
- `visibility` - ENUM('UNIQUE', 'CLUSTER')
- `status` - TINYINT(1)

**Key Finding:** Course type is stored as VARCHAR in courses table with values like 'Theory', 'Lab', 'Theory&Lab', 'NA'

---

## 2. BACKEND (Server Side)

### 2.1 Data Models

| File | Component | Type | Usage | Changes Needed |
|------|-----------|------|-------|-----------------|
| [server/models/curriculum.go](server/models/curriculum.go#L14) | `Course` struct | Field: `CourseType string` | JSON serialization: `"course_type"` | NO |
| [server/models/curriculum.go](server/models/curriculum.go#L45) | `CourseWithDetails` struct | Field: `CourseType string` | JSON serialization: `"course_type"` | NO |
| [server/models/allocation.go](server/models/allocation.go#L25) | `CourseWithAllocations` struct | Field: `CourseType string` | JSON serialization: `"course_type"` | NO |
| [server/models/pdf.go](server/models/pdf.go#L37) | PDF model | Field: `CourseType string` | JSON serialization: `"course_type"` | NO |

### 2.2 Handler Functions - Curriculum Edit

| File | Handler | Line | Operation | SQL/Logic | Changes Needed |
|------|---------|------|-----------|-----------|-----------------|
| [server/handlers/curriculum/curriculum_edit.go](server/handlers/curriculum/curriculum_edit.go#L239) | UpdateCourse | 239 | SELECT | `SELECT course_code, course_name, course_type, category...` | NO - Reading only |
| [server/handlers/curriculum/curriculum_edit.go](server/handlers/curriculum/curriculum_edit.go#L311) | UpdateCourse | 311 | UPDATE | `UPDATE courses SET ... course_type = ?, category = ?...` | NO - Working as expected |
| [server/handlers/curriculum/curriculum_edit.go](server/handlers/curriculum/curriculum_edit.go#L336) | UpdateCourse | 336 | Diff Tracking | Creates diff: `"course_type": {old, new}` | NO - Logging only |

**Code Logic (Line 269-295):** Validates and calculates hours based on `course_type` value:
- `"Theory"` → calculates theory hours
- `"Lab"` → calculates practical hours
- `"Theory&Lab"` → calculates both
- Default → calculates all

### 2.3 Handler Functions - Curriculum Operations

| File | Handler | Line | Operation | Details | Changes Needed |
|------|---------|------|-----------|---------|-----------------|
| [server/handlers/curriculum/curriculum.go](server/handlers/curriculum/curriculum.go#L350) | GetSemesterCourses | 350 | SELECT | `SELECT c.id, c.course_code, c.course_name, c.course_type...` | NO - Reading only |

### 2.4 Handler Functions - PDF Generation

| File | Handler | Lines | Operation | Details | Changes Needed |
|------|---------|-------|-----------|---------|-----------------|
| [server/handlers/curriculum/pdf.go](server/handlers/curriculum/pdf.go#L114) | GeneratePDF | 114 | SELECT | `SELECT c.id, c.course_code, c.course_name, c.course_type...` | NO - Reading only |
| [server/handlers/curriculum/pdf_html.go](server/handlers/curriculum/pdf_html.go#L207) | GeneratePDFHTML | 207 | SELECT | `SELECT c.id, c.course_code, c.course_name, c.course_type...` | NO - Reading only |
| [server/handlers/curriculum/pdf_html.go](server/handlers/curriculum/pdf_html.go#L349) | GeneratePDFHTML | 349 | SELECT | `SELECT c.id, c.course_code, c.course_name, c.course_type...` | NO - Reading only |

### 2.5 Handler Functions - Honour Cards

| File | Handler | Lines | Operation | Details | Changes Needed |
|------|---------|-------|-----------|---------|-----------------|
| [server/handlers/curriculum/honour_cards.go](server/handlers/curriculum/honour_cards.go#L86) | fetchCoursesForVertical | 86 | SELECT | `SELECT c.id, c.course_code, c.course_name, c.course_type...` | NO - Reading only |
| [server/handlers/curriculum/honour_cards.go](server/handlers/curriculum/honour_cards.go#L244) | Honor Card struct | 244 | Struct field | `CourseType string json:"course_type,omitempty"` | NO - For JSON response |
| [server/handlers/curriculum/honour_cards.go](server/handlers/curriculum/honour_cards.go#L367) | CreateHonourCard | 367 | INSERT | `INSERT INTO courses (course_code, course_name, course_type, category...` | NO - Writing course_type |
| [server/handlers/curriculum/honour_cards.go](server/handlers/curriculum/honour_cards.go#L441) | FetchHonourCard | 441 | SELECT | `SELECT id, course_code, course_name, course_type, category...` | NO - Reading only |
| [server/handlers/curriculum/honour_cards.go](server/handlers/curriculum/honour_cards.go#L486) | BuildHonourCardResponse | 486 | JSON Output | `"course_type": fullCourse.CourseType` | NO - JSON serialization |

### 2.6 Handler Functions - Sharing

| File | Handler | Lines | Operation | Details | Changes Needed |
|------|---------|-------|-----------|---------|-----------------|
| [server/handlers/curriculum/sharing.go](server/handlers/curriculum/sharing.go#L1179) | ShareCurriculum | 1179 | SELECT | `SELECT course_code, course_name, credit, course_type` | NO - Reading only |
| [server/handlers/curriculum/sharing.go](server/handlers/curriculum/sharing.go#L1287) | ShareCurriculum | 1287 | INSERT | `INSERT INTO courses (course_code, course_name, credit, course_type, visibility)` | NO - Writing course_type |
| [server/handlers/curriculum/sharing.go](server/handlers/curriculum/sharing.go#L1393) | ShareCurriculum | 1393 | SELECT | `SELECT c.id, c.course_code, c.course_name, c.course_type...` | NO - Reading only |
| [server/handlers/curriculum/sharing.go](server/handlers/curriculum/sharing.go#L1434) | ShareCurriculum | 1434 | INSERT | `INSERT INTO courses (course_code, course_name, course_type, visibility...` | NO - Writing course_type |

---

## 3. FRONTEND (Client Side)

### 3.1 Pages Using Course Type

| File | Component | Usage Type | Details | Changes Needed |
|------|-----------|-----------|---------|-----------------|
| [client/src/pages/curriculum/semesterDetailPage.js](client/src/pages/curriculum/semesterDetailPage.js#L22) | State | Initialization | `course_type: ''` in newCourse state | NO - Default value |
| [client/src/pages/curriculum/semesterDetailPage.js](client/src/pages/curriculum/semesterDetailPage.js#L39) | State | Initialization | `course_type: ''` in editCourseData state | NO - Default value |
| [client/src/pages/curriculum/semesterDetailPage.js](client/src/pages/curriculum/semesterDetailPage.js#L173-183) | Logic | Conditional Rendering | Hour calculations based on course_type: 'Lab', 'Theory', 'Theory&Lab', 'NA' | NO - Working correctly |
| [client/src/pages/curriculum/semesterDetailPage.js](client/src/pages/curriculum/semesterDetailPage.js#L251) | Data Mapping | Form Population | `course_type: course.course_type` - maps from API response | NO - Reading from API |
| [client/src/pages/curriculum/semesterDetailPage.js](client/src/pages/curriculum/semesterDetailPage.js#L300-310) | Logic | Edit Logic | Same hour calculations on edit | NO - Working correctly |
| [client/src/pages/curriculum/semesterDetailPage.js](client/src/pages/curriculum/semesterDetailPage.js#L512-513) | Form Input | Select Dropdown | Course type selection dropdown | **SEE DETAIL BELOW** |
| [client/src/pages/curriculum/semesterDetailPage.js](client/src/pages/curriculum/semesterDetailPage.js#L545) | Logic | Conditional Rendering | `!(curriculumTemplate === '2022' && newCourse.course_type === 'Lab')` | NO - Conditional logic |
| [client/src/pages/curriculum/semesterDetailPage.js](client/src/pages/curriculum/semesterDetailPage.js#L574) | Logic | Conditional Rendering | `{newCourse.course_type !== 'Theory' && (...)` - shows practical hrs field | NO - Conditional logic |
| [client/src/pages/curriculum/semesterDetailPage.js](client/src/pages/curriculum/semesterDetailPage.js#L658) | Logic | Conditional Rendering | `{newCourse.course_type === 'Theory' && (...)` | NO - Conditional logic |

### 3.2 Select Dropdown Options
**File:** [client/src/pages/curriculum/semesterDetailPage.js](client/src/pages/curriculum/semesterDetailPage.js#L520-527)

```javascript
<select value={newCourse.course_type} onChange={(e) => setNewCourse({...})}>
  <option value="">Select Type</option>
  <option value="Theory">Theory</option>
  <option value="Lab">Lab</option>
  <option value="Theory&Lab">Theory&Lab</option>
  <option value="NA">NA</option>
</select>
```

**Hardcoded Values:** Theory, Lab, Theory&Lab, NA
**Status:** NO CHANGES NEEDED - matches database values

### 3.3 Display Pages

| File | Usage | Line | Details | Changes Needed |
|------|-------|------|---------|-----------------|
| [client/src/pages/curriculum/TeacherDashboardPage.js](client/src/pages/curriculum/TeacherDashboardPage.js#L244) | Display | 244 | `{course.course_type}` - displays course type in dashboard | NO - Display only |
| [client/src/pages/curriculum/TeacherCoursesPage.js](client/src/pages/curriculum/TeacherCoursesPage.js#L247) | Display | 247 | `<span className="type-badge">{course.course_type}</span>` - badge display | NO - Display only |

### 3.4 Color Mapping (TeacherDashboardPage)
**File:** [client/src/pages/curriculum/TeacherDashboardPage.js](client/src/pages/curriculum/TeacherDashboardPage.js#L79)

```javascript
'Lab': '#f59e0b',
```

**Note:** Partial color mapping found - suggests more color logic exists

---

## 4. SUMMARY TABLE - ALL REFERENCES

| File Path | Line(s) | Operation | Current Behavior | Needs Changes? | Priority |
|-----------|---------|-----------|------------------|----------------|----------|
| **Database** |
| References/cms_test.sql | 579 | Table definition | VARCHAR(50), default NULL | NO | - |
| **Backend Models** |
| server/models/curriculum.go | 14, 45 | Struct fields | CourseType string | NO | - |
| server/models/allocation.go | 25 | Struct field | CourseType string | NO | - |
| server/models/pdf.go | 37 | Struct field | CourseType string | NO | - |
| **Backend Handlers - Edit** |
| server/handlers/curriculum/curriculum_edit.go | 239 | SELECT query | Fetches course_type | NO | - |
| server/handlers/curriculum/curriculum_edit.go | 311 | UPDATE query | Updates course_type | NO | - |
| server/handlers/curriculum/curriculum_edit.go | 336 | Diff tracking | Logs course_type changes | NO | - |
| **Backend Handlers - Read** |
| server/handlers/curriculum/curriculum.go | 350 | SELECT query | Fetches course_type | NO | - |
| server/handlers/curriculum/pdf.go | 114 | SELECT query | Fetches for PDF | NO | - |
| server/handlers/curriculum/pdf_html.go | 207, 349 | SELECT query | Fetches for PDF HTML | NO | - |
| **Backend Handlers - Honour Cards** |
| server/handlers/curriculum/honour_cards.go | 86, 244, 367, 441, 486 | Mixed operations | SELECT, INSERT, JSON output | NO | - |
| **Backend Handlers - Sharing** |
| server/handlers/curriculum/sharing.go | 1179, 1287, 1393, 1434 | Mixed operations | SELECT, INSERT with course_type | NO | - |
| **Frontend - Form & State** |
| client/src/pages/curriculum/semesterDetailPage.js | 22, 39 | State initialization | `course_type: ''` | NO | - |
| client/src/pages/curriculum/semesterDetailPage.js | 512-513 | Select dropdown | Hardcoded options: Theory, Lab, Theory&Lab, NA | NO | - |
| **Frontend - Logic & Validation** |
| client/src/pages/curriculum/semesterDetailPage.js | 173-183 | Hour calculation logic | Uses course_type to calculate hours | NO | - |
| client/src/pages/curriculum/semesterDetailPage.js | 300-310 | Edit logic | Same hour calculations | NO | - |
| client/src/pages/curriculum/semesterDetailPage.js | 545, 560, 574, 658 | Conditional rendering | Field visibility based on course_type | NO | - |
| client/src/pages/curriculum/semesterDetailPage.js | 251 | Data mapping | Maps from API response | NO | - |
| **Frontend - Display** |
| client/src/pages/curriculum/TeacherDashboardPage.js | 79, 244 | Display & styling | Shows course_type with badge/color | NO | - |
| client/src/pages/curriculum/TeacherCoursesPage.js | 247 | Display | Badge display of course_type | NO | - |

---

## 5. COURSE TYPE VALUES USED

### Valid Values in System:
1. **Theory** - Lecture-based courses
2. **Lab** - Laboratory/Practical courses
3. **Theory&Lab** - Combined theoretical and practical courses
4. **NA** - Not Applicable or unspecified

### Where Values Are Hardcoded:
- **Frontend:** semesterDetailPage.js lines 522-527 (select dropdown)
- **Backend:** Multiple validation checks in curriculum_edit.go (lines 269-295)
- **Database:** sample data in cms_test.sql

### Validation Points:
1. [curriculum_edit.go](server/handlers/curriculum/curriculum_edit.go#L269) - Switch statement validates course_type against known values
2. No validation on course creation appears to enforce these values strictly
3. Database column allows NULL and any string value (VARCHAR)

---

## 6. FINDINGS & RECOMMENDATIONS

### Key Observations:

1. **Database Structure:**
   - `course_type` is VARCHAR(50), allows NULL values
   - No foreign key constraint to a lookup table
   - No CHECK constraint to enforce specific values

2. **Backend Implementation:**
   - All handlers correctly read/write `course_type` field
   - Hour calculations depend on course_type values (Theory, Lab, Theory&Lab)
   - No validation enforces allowed values at database level
   - Sharing logic preserves course_type when copying courses

3. **Frontend Implementation:**
   - Dropdown has 4 hardcoded options (Theory, Lab, Theory&Lab, NA)
   - Conditional logic properly checks course_type for field visibility
   - Form submission sends course_type to backend
   - Display pages show course_type in dashboards and course lists

4. **Data Integrity Risks:**
   - ⚠️ **No database constraint** - allows invalid course_type values
   - ⚠️ **No API validation** - backend doesn't validate against allowed values
   - ⚠️ **Hardcoded frontend options** - if values change, needs code update

### Recommendations:

**HIGH PRIORITY:**
1. Create `course_types` lookup table with id, name, description
2. Add foreign key constraint in courses table: `FOREIGN KEY (course_type_id) REFERENCES course_types(id)`
3. Add validation in backend handlers to check against allowed values
4. Migrate existing data to use foreign keys

**MEDIUM PRIORITY:**
1. Update all SQL queries to JOIN with course_types table
2. Update backend models to accept course_type_id instead of string
3. Create API endpoint to fetch available course types
4. Update frontend dropdown to fetch from API dynamically

**LOW PRIORITY:**
1. Add more descriptive course_type naming if needed
2. Create migration scripts for smooth transition
3. Add logging for course_type changes

---

## 7. FILES REQUIRING CHANGES (If Implementing Normalization)

### Database:
- New migration/script to create course_types table
- Migration to add foreign key to courses table

### Backend:
- [server/models/curriculum.go](server/models/curriculum.go) - Update Course, CourseWithDetails structs
- [server/models/allocation.go](server/models/allocation.go) - Update CourseWithAllocations struct
- [server/models/pdf.go](server/models/pdf.go) - Update PDF model
- All files in [server/handlers/curriculum/](server/handlers/curriculum/) - Update SQL queries and struct bindings

### Frontend:
- [client/src/pages/curriculum/semesterDetailPage.js](client/src/pages/curriculum/semesterDetailPage.js) - Update dropdown to fetch from API
- May affect display pages if changing structure

---

**End of Analysis**
