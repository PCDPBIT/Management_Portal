-- Mark entry window rules (most specific match wins)
CREATE TABLE IF NOT EXISTS mark_entry_windows (
  id INT AUTO_INCREMENT PRIMARY KEY,
  teacher_id VARCHAR(45) NULL,
  department_id INT NULL,
  semester INT NULL,
  course_id INT NULL,
  start_at DATETIME NOT NULL,
  end_at DATETIME NOT NULL,
  enabled TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_window_lookup (teacher_id, department_id, semester, course_id)
);
