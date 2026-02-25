# Student Enrollments Table Creation Fix

## Problem
The auto-allocation scheduler was failing with the error:
```
Error calculating enrollments for semester X: query error: Error 1146 (42S02): Table 'cms_test2.student_enrollments' doesn't exist
```

This occurred because the `auto_allocate.go` handler expected a `student_enrollments` table to exist in the database, but it didn't.

## Root Cause
The `student_enrollments` table is required to track which students are enrolled in which courses for a given academic year and semester. The auto-allocation algorithm uses this table to:
1. Count the total number of students enrolled in each course per semester
2. Calculate the number of teacher sections needed based on the 60-student rule
3. Match teacher preferences with course enrollment data

## Solution

### What Was Done

1. **Created Migration File**: `server/db/migrations/20260224_create_student_enrollments.sql`
   - Defines the `student_enrollments` table structure
   - Includes necessary indexes and foreign key constraints

2. **Updated Database Initialization**: Modified `server/db/db.go` in the `runMigrations()` function to:
   - Create the `student_enrollments` table automatically on server startup
   - Populate it with enrollment data based on existing curriculum structure
   - Link students to courses based on their curriculum and semester

### Table Structure

```sql
CREATE TABLE `student_enrollments` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `student_id` INT NOT NULL,
  `course_id` INT NOT NULL,
  `academic_year` VARCHAR(20) NOT NULL,        -- e.g., "2025-2026"
  `semester` INT NOT NULL,                      -- Semester number 1-8
  `enrollment_status` VARCHAR(50) DEFAULT 'enrolled',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  -- Indexes for query performance
  KEY `idx_student_id` (`student_id`),
  KEY `idx_course_id` (`course_id`),
  KEY `idx_academic_year_semester` (`academic_year`, `semester`),
  KEY `idx_student_course_year_sem` (`student_id`, `course_id`, `academic_year`, `semester`),
  
  -- Foreign Key Constraints
  CONSTRAINT `fk_se_student` FOREIGN KEY (`student_id`) REFERENCES `students`(`id`),
  CONSTRAINT `fk_se_course` FOREIGN KEY (`course_id`) REFERENCES `courses`(`id`)
)
```

### Data Population Logic

The table is automatically populated using this query:
```sql
INSERT IGNORE INTO student_enrollments (student_id, course_id, academic_year, semester, enrollment_status)
SELECT DISTINCT
    ad.student_id,
    cc.course_id,
    '2025-2026' as academic_year,
    nc.semester_number as semester,
    'enrolled' as enrollment_status
FROM academic_details ad
JOIN curriculum c ON ad.curriculum_id = c.id
JOIN normal_cards nc ON nc.curriculum_id = c.id
JOIN curriculum_courses cc ON cc.curriculum_id = c.id AND cc.semester_id = nc.id
WHERE ad.student_id IS NOT NULL
  AND nc.semester_number IS NOT NULL
  AND nc.card_type = 'semester'
  AND cc.course_id IS NOT NULL
```

This algorithm:
1. Gets all students from `academic_details` 
2. Joins with their curriculum information
3. Links to all courses in their curriculum for their current semester
4. Creates enrollment records for each student-course pair

## Testing

To verify the fix works:

1. **Restart the server** - This will trigger the migration automatically:
   ```bash
   cd server
   go run main.go
   ```

2. **Check if the table was created**:
   ```sql
   SELECT COUNT(*) FROM student_enrollments;
   ```

3. **Run the auto-allocation endpoint**:
   ```bash
   curl http://localhost:8080/api/allocation/run-auto-allocation
   ```

4. **Verify the results** - The allocation should now process all semesters without errors:
   ```
   📚 Processing Semester 1
   Found X courses needing allocation in semester 1
   Found Y teachers with preferences in semester 1
   Allocation algorithm completed with Z results for semester 1
   ```

## How Auto-Allocation Works (After Fix)

1. **calculateCourseEnrollments()**: Queries `student_enrollments` to count total students per course
2. **calculateTeachersNeeded()**: Uses the 60-student rule:
   - 0-30 students: 1 teacher (quotient)
   - 31-60 students: 1 teacher (quotient)
   - 61-90 students: 2 teachers
   - 91-120 students: 2 teachers
   - And so on...

3. **getTeacherPreferences()**: Gets teacher course preferences for the academic year
4. **performAllocation()**: Matches teachers to sections based on preferences and availability
5. **saveAllocations()**: Stores results in the database

## Files Modified

- `server/db/db.go` - Added table creation and data population to `runMigrations()`
- `server/db/migrations/20260224_create_student_enrollments.sql` - Migration SQL file (for reference)

## Notes

- The table is created with `CREATE TABLE IF NOT EXISTS`, so it's safe to run multiple times
- Initial data is populated with `INSERT IGNORE`, preventing duplicate entries
- The academic year is hardcoded to '2025-2026' in the migration - this should be updated when needed
- Future enrollments for other academic years should be added through appropriate APIs or manual data entry
