-- Mark entry field permissions per course and teacher
CREATE TABLE IF NOT EXISTS mark_entry_field_permissions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  course_id INT NOT NULL,
  teacher_id VARCHAR(45) NOT NULL,
  assessment_component_id INT NOT NULL,
  enabled TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_mark_entry_permission (course_id, teacher_id, assessment_component_id)
);
