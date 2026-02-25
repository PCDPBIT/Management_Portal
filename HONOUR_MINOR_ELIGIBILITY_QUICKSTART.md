# Quick Start Guide: Honour/Minor Eligibility Management

## Step 1: Run the Database Migration

Execute the migration file to create the required table:

```sql
-- Run this SQL file
server/db/migrations/20260225_create_student_eligible_honour_minor.sql
```

Or manually run:
```sql
CREATE TABLE IF NOT EXISTS student_eligible_honour_minor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_email VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_student_email (student_email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

## Step 2: Add Eligible Students

### Option A: Add Students Individually
```sql
INSERT INTO student_eligible_honour_minor (student_email) 
VALUES ('student@example.com');
```

### Option B: Add Multiple Students at Once
```sql
INSERT INTO student_eligible_honour_minor (student_email) VALUES 
('student1@college.edu'),
('student2@college.edu'),
('student3@college.edu');
```

### Option C: Add Students Based on Criteria

**Example: Add all students with GPA > 8.5**
```sql
INSERT INTO student_eligible_honour_minor (student_email)
SELECT cd.student_email
FROM contact_details cd
INNER JOIN academic_details ad ON cd.student_id = ad.student_id
WHERE ad.cgpa > 8.5
AND cd.student_email NOT IN (SELECT student_email FROM student_eligible_honour_minor)
AND cd.student_email IS NOT NULL;
```

**Example: Add students from specific departments**
```sql
INSERT INTO student_eligible_honour_minor (student_email)
SELECT cd.student_email
FROM contact_details cd
INNER JOIN students s ON cd.student_id = s.id
WHERE s.department_id IN (1, 2, 3)  -- Replace with actual department IDs
AND cd.student_email NOT IN (SELECT student_email FROM student_eligible_honour_minor)
AND cd.student_email IS NOT NULL;
```

**Example: Add students from a specific batch**
```sql
INSERT INTO student_eligible_honour_minor (student_email)
SELECT cd.student_email
FROM contact_details cd
INNER JOIN academic_details ad ON cd.student_id = ad.student_id
WHERE ad.batch = '2023-2027'
AND cd.student_email NOT IN (SELECT student_email FROM student_eligible_honour_minor)
AND cd.student_email IS NOT NULL;
```

## Step 3: Verify Setup

### Check All Eligible Students
```sql
SELECT * FROM student_eligible_honour_minor;
```

### Count Eligible Students
```sql
SELECT COUNT(*) as total_eligible FROM student_eligible_honour_minor;
```

### Check if a Specific Student is Eligible
```sql
SELECT 
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM student_eligible_honour_minor 
            WHERE student_email = 'student@example.com'
        ) THEN 'Yes - Eligible'
        ELSE 'No - Not Eligible'
    END AS eligibility_status;
```

## Step 4: Remove Students (if needed)

### Remove a Single Student
```sql
DELETE FROM student_eligible_honour_minor 
WHERE student_email = 'student@example.com';
```

### Remove All Students
```sql
TRUNCATE TABLE student_eligible_honour_minor;
```

### Remove Students Based on Criteria
```sql
-- Example: Remove students who are no longer in the system
DELETE FROM student_eligible_honour_minor
WHERE student_email NOT IN (SELECT student_email FROM contact_details);
```

## How It Works

### For Eligible Students:
1. Login to the student portal
2. Navigate to Elective Selection
3. See HONOR, MINOR, and ADDON slots (if configured)
4. For each HONOR/MINOR slot, choose either:
   - A specific course
   - "Not Opted" (if you don't want to take Honour/Minor)
5. All ADDON courses are visible

### For Non-Eligible Students:
1. Login to the student portal
2. Navigate to Elective Selection
3. See only PROFESSIONAL, OPEN, MIXED, and ADDON slots
4. HONOR and MINOR slots are hidden
5. All ADDON courses are visible

## Troubleshooting

### Student Can't See Honour/Minor After Being Added
1. Check if email in table matches exactly:
   ```sql
   SELECT student_email FROM contact_details WHERE student_id = <ID>;
   SELECT student_email FROM student_eligible_honour_minor WHERE student_email LIKE '%<search>%';
   ```
2. Ask student to logout and login again
3. Clear browser cache/localStorage

### Wrong Students See Honour/Minor
1. Check who is in the eligibility table:
   ```sql
   SELECT * FROM student_eligible_honour_minor;
   ```
2. Remove incorrect entries:
   ```sql
   DELETE FROM student_eligible_honour_minor WHERE student_email = '<email>';
   ```

### "Not Opted" Button Not Showing
- This is normal for PROFESSIONAL, OPEN, MIXED, and ADDON slots
- "Not Opted" only appears for HONOR and MINOR slots
- These are only visible to eligible students

## Admin Commands

### Export Eligible Students List
```sql
SELECT 
    sehm.student_email,
    s.roll_number,
    CONCAT(pd.first_name, ' ', pd.last_name) as student_name,
    ad.semester,
    ad.batch,
    sehm.created_at as added_on
FROM student_eligible_honour_minor sehm
INNER JOIN contact_details cd ON sehm.student_email = cd.student_email
INNER JOIN students s ON cd.student_id = s.id
INNER JOIN personal_details pd ON s.id = pd.student_id
INNER JOIN academic_details ad ON s.id = ad.student_id
ORDER BY ad.batch, s.roll_number;
```

### Get Statistics
```sql
SELECT 
    'Total Eligible Students' as metric,
    COUNT(*) as count
FROM student_eligible_honour_minor
UNION ALL
SELECT 
    'Total Active Students',
    COUNT(DISTINCT student_email)
FROM contact_details
WHERE student_email IS NOT NULL;
```
