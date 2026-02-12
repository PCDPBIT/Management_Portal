-- Test Data for Honour Verticals (for Minor Program Testing)
-- This creates sample honour cards and verticals with courses

-- ========================================
-- Option 1: Quick Test Data Insertion
-- ========================================
-- Replace the curriculum_id (295) with your actual curriculum ID

-- Insert a test honour card
INSERT INTO honour_cards (curriculum_id, title, created_at, visibility, status) 
VALUES (295, 'Test Honour Card for Minor', NOW(), 'UNIQUE', 1);

-- Get the last inserted honour card ID (you'll need this for the next step)
SET @honour_card_id = LAST_INSERT_ID();

-- Insert test verticals
INSERT INTO honour_verticals (honour_card_id, name, created_at, status) 
VALUES 
(@honour_card_id, 'Data Science Minor', NOW(), 1),
(@honour_card_id, 'AI & Machine Learning Minor', NOW(), 1),
(@honour_card_id, 'Cyber Security Minor', NOW(), 1);

-- Get the vertical IDs
SET @vertical1_id = LAST_INSERT_ID();
SET @vertical2_id = @vertical1_id + 1;
SET @vertical3_id = @vertical1_id + 2;

-- Insert 6 test courses for first vertical (needed for minor - 2 per semester x 3 semesters)
INSERT INTO courses (course_code, course_name, course_type, credit, cia_marks, see_marks, total_marks, status)
VALUES
('DS101', 'Introduction to Data Science', 1, 3, 40, 60, 100, 1),
('DS102', 'Statistical Methods', 1, 3, 40, 60, 100, 1),
('DS201', 'Machine Learning Basics', 1, 4, 40, 60, 100, 1),
('DS202', 'Data Visualization', 1, 3, 40, 60, 100, 1),
('DS301', 'Advanced Analytics', 1, 4, 40, 60, 100, 1),
('DS302', 'Big Data Technologies', 1, 4, 40, 60, 100, 1);

-- Link courses to vertical
INSERT INTO honour_vertical_courses (honour_vertical_id, course_id, created_at, status)
SELECT @vertical1_id, id, NOW(), 1 FROM courses WHERE course_code IN ('DS101', 'DS102', 'DS201', 'DS202', 'DS301', 'DS302');

-- ========================================
-- Verification Queries
-- ========================================
-- Check honour cards exist
-- SELECT * FROM honour_cards WHERE status = 1;

-- Check honour verticals exist
-- SELECT hv.*, hc.title as card_title 
-- FROM honour_verticals hv 
-- INNER JOIN honour_cards hc ON hv.honour_card_id = hc.id 
-- WHERE hv.status = 1;

-- Check courses in vertical
-- SELECT c.course_code, c.course_name, hv.name as vertical_name
-- FROM courses c
-- INNER JOIN honour_vertical_courses hvc ON c.id = hvc.course_id
-- INNER JOIN honour_verticals hv ON hvc.honour_vertical_id = hv.id
-- WHERE hvc.status = 1 AND c.status = 1;

-- Count courses per vertical (should be 6 for minor program)
-- SELECT hv.id, hv.name, COUNT(hvc.id) as course_count
-- FROM honour_verticals hv
-- LEFT JOIN honour_vertical_courses hvc ON hv.id = hvc.honour_vertical_id AND hvc.status = 1
-- WHERE hv.status = 1
-- GROUP BY hv.id;
