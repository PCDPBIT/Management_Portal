-- Migration to add elective_sem_no column to courses table
-- Run this SQL script on your database before deploying the code changes

ALTER TABLE courses 
ADD COLUMN elective_sem_no INT DEFAULT NULL 
COMMENT 'Semester number for elective and open elective courses';

-- Optional: Add an index if you plan to query by this field frequently
-- CREATE INDEX idx_elective_sem_no ON courses(elective_sem_no);
