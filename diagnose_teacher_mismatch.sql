-- Diagnostic queries to identify the mismatch

-- 1. Check users table for teacher role
SELECT id, username, email, role 
FROM users 
WHERE role IN ('teacher', 'hod')
ORDER BY id;

-- 2. Check teachers table
SELECT id, name, email, faculty_id, dept
FROM teachers
WHERE status = 1
ORDER BY id;

-- 3. Find users with teacher role but no matching teacher record
SELECT u.id, u.username, u.email, u.role
FROM users u
LEFT JOIN teachers t ON u.email = t.email AND t.status = 1
WHERE u.role IN ('teacher', 'hod')
AND t.id IS NULL;

-- 4. Find teachers without matching user account
SELECT t.id, t.name, t.email, t.faculty_id
FROM teachers t
LEFT JOIN users u ON t.email = u.email
WHERE t.status = 1
AND u.id IS NULL;
