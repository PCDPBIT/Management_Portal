-- Add count_towards_limit column to curriculum_courses table
-- This allows courses to be optionally excluded from max credit calculations

ALTER TABLE curriculum_courses 
ADD COLUMN count_towards_limit TINYINT(1) DEFAULT 1 
COMMENT 'Whether this course counts towards the curriculum max credit limit';
