-- Fix for Semester 5 Elective Slot Names
-- Problem: Semester 5 shows "Professional Elective 2" and "Open Elective" (displaying as 2 and 4)
-- Expected: Should show "Professional Elective 2" and "Professional Elective 3"

-- The issue is that slot_id 16 has the wrong name. It should be "Professional Elective 3" not "Open Elective"

-- View current state for Semester 5:
SELECT id, semester, slot_name, slot_order, is_active 
FROM elective_semester_slots 
WHERE semester = 5 
ORDER BY slot_order;

-- Expected output BEFORE fix:
-- | id | semester | slot_name              | slot_order | is_active |
-- | 15 | 5        | Professional Elective 2| 1          | 1         |
-- | 16 | 5        | Open Elective          | 2          | 1         |

-- FIX: Update the slot name to be Professional Elective 3
UPDATE elective_semester_slots 
SET slot_name = 'Professional Elective 3' 
WHERE id = 16 AND semester = 5;

-- Verify the fix worked:
SELECT id, semester, slot_name, slot_order, is_active 
FROM elective_semester_slots 
WHERE semester = 5 
ORDER BY slot_order;

-- Expected output AFTER fix:
-- | id | semester | slot_name              | slot_order | is_active |
-- | 15 | 5        | Professional Elective 2| 1          | 1         |
-- | 16 | 5        | Professional Elective 3| 2          | 1         |

-- Note: After running this SQL, restart your Go server for changes to take effect
-- Or just refresh the student elective selection page

