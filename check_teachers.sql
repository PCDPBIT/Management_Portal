-- Check what teachers exist in the database
SELECT id, name, email, faculty_id, dept, designation
FROM teachers
ORDER BY id
LIMIT 20;

-- Check if teacher 140 exists
SELECT id, name, email, faculty_id, dept
FROM teachers
WHERE id = 140;

-- Count total teachers
SELECT COUNT(*) as total_teachers FROM teachers;
