-- Migration to support 2022 and 2026 curriculum templates

-- Step 1: Add curriculum_template column to curriculum table
ALTER TABLE curriculum 
ADD COLUMN curriculum_template VARCHAR(10) DEFAULT '2026' AFTER academic_year;

-- Step 2: Create experiments table for 2022 template (similar to units/modules but for experiments)
CREATE TABLE IF NOT EXISTS course_experiments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    experiment_number INT NOT NULL,
    experiment_name VARCHAR(500) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    INDEX idx_course_exp (course_id)
);

-- Step 3: Create experiment topics table
CREATE TABLE IF NOT EXISTS course_experiment_topics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    experiment_id INT NOT NULL,
    topic_text TEXT NOT NULL,
    topic_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (experiment_id) REFERENCES course_experiments(id) ON DELETE CASCADE,
    INDEX idx_exp_topics (experiment_id)
);

-- Step 4: Update curriculum table to track template-specific features
-- This allows us to store different configurations per template
ALTER TABLE curriculum
ADD COLUMN template_config JSON DEFAULT NULL AFTER curriculum_template;

-- Example usage of template_config:
-- For 2022: {"has_objectives": false, "has_teamwork": false, "has_selflearning": false, "has_prerequisites": false, "units_label": "Units", "experiments_enabled": true}
-- For 2026: {"has_objectives": true, "has_teamwork": true, "has_selflearning": true, "has_prerequisites": true, "units_label": "Modules", "experiments_enabled": false}
