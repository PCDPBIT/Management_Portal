-- Test queries to verify email-based teacher lookup

-- 1. Find your teacher record by email
-- Replace with your actual login email
SELECT 
    id, 
    faculty_id, 
    name, 
    email, 
    dept,
    status,
    theory_subject_count,
    theory_with_lab_subject_count
FROM teachers 
WHERE email = 'YOUR_EMAIL_HERE@example.com' 
AND status = 1;

-- 2. List all active teachers with their emails
SELECT 
    id,
    faculty_id,
    name,
    email,
    dept
FROM teachers
WHERE status = 1
ORDER BY id;

-- 3. Find users with teacher/hod role and their matching teacher records
SELECT 
    u.id as user_id,
    u.email as user_email,
    u.role,
    t.id as teacher_id,
    t.faculty_id,
    t.name as teacher_name,
    t.dept,
    CASE 
        WHEN t.id IS NULL THEN '❌ NO MATCH'
        ELSE '✅ MATCHED'
    END as status
FROM users u
LEFT JOIN teachers t ON u.email = t.email AND t.status = 1
WHERE u.role IN ('teacher', 'hod')
ORDER BY status DESC, u.email;

-- 4. Create missing teacher record (example)
-- Uncomment and modify if you need to create a teacher record
/*
INSERT INTO teachers (
    name, 
    email, 
    faculty_id, 
    dept, 
    designation,
    status,
    theory_subject_count,
    theory_with_lab_subject_count
)
VALUES (
    'Your Name',
    'your.email@example.com',  -- MUST match users.email
    'AD001',  -- Unique faculty ID
    'AI&DS',  -- Department code or name
    'Assistant Professor',
    1,  -- Active status
    2,  -- Number of theory subjects allowed
    1   -- Number of theory+lab subjects allowed
);
*/

-- 5. Verify the new teacher record was created
-- SELECT * FROM teachers WHERE email = 'your.email@example.com';
