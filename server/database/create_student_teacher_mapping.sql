-- Create student_teacher_mapping table to store student-to-teacher assignments
CREATE TABLE IF NOT EXISTS `student_teacher_mapping` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `teacher_id` bigint unsigned NOT NULL,
  `department_id` int NOT NULL,
  `year` int NOT NULL,
  `academic_year` varchar(50) NOT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_student_year` (`student_id`, `year`, `academic_year`),
  KEY `idx_teacher` (`teacher_id`),
  KEY `idx_department_year` (`department_id`, `year`),
  CONSTRAINT `fk_stm_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_stm_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_stm_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
