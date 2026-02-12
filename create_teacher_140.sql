-- Create teacher record for ID 140
-- Adjust the values based on your actual data needs

INSERT INTO teachers (id, name, email, faculty_id, dept, designation, theory_subject_count, theory_with_lab_subject_count)
VALUES (
  140, 
  'Test Teacher', 
  'teacher140@example.com', 
  'AD140', 
  'AI&DS',  -- or appropriate department code/ID
  'Assistant Professor',
  2,  -- theory subjects allowed
  1   -- theory with lab subjects allowed
);

-- Verify the insert
SELECT * FROM teachers WHERE id = 140;
