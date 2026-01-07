-- Add hours column to course_experiments table
ALTER TABLE course_experiments 
ADD COLUMN hours INT DEFAULT 0 AFTER experiment_name;
