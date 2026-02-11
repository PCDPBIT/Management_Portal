-- =========================================================
-- ELECTIVE COURSE SELECTION SYSTEM - DATABASE SCHEMA
-- =========================================================

-- Drop tables in correct order (child tables first to avoid FK constraint errors)
DROP TABLE IF EXISTS `student_elective_choices`;
DROP TABLE IF EXISTS `hod_elective_selections`;
DROP TABLE IF EXISTS `department_curriculum_active`;
DROP TABLE IF EXISTS `academic_calendar`;

-- Table 1: Academic Calendar
-- Tracks current semester and academic year for automatic elective display
CREATE TABLE `academic_calendar` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `academic_year` VARCHAR(20) NOT NULL COMMENT 'e.g., "2025-2026"',
  `current_semester` INT NOT NULL COMMENT '1-8',
  `semester_start_date` DATE NOT NULL,
  `semester_end_date` DATE NOT NULL,
  `elective_selection_start` DATE DEFAULT NULL COMMENT 'When students can start selecting electives',
  `elective_selection_end` DATE DEFAULT NULL COMMENT 'Deadline for student elective selection',
  `is_current` TINYINT(1) DEFAULT 0 COMMENT 'Only one row should be current=1',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_academic_year_semester` (`academic_year`, `current_semester`),
  KEY `idx_is_current` (`is_current`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table 2: Elective Semester Slots (Fixed category slots by semester)
CREATE TABLE `elective_semester_slots` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `semester` INT NOT NULL,
  `slot_name` VARCHAR(100) NOT NULL,
  `slot_order` INT NOT NULL,
  `is_active` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_semester_slot` (`semester`, `slot_name`),
  KEY `idx_semester` (`semester`),
  KEY `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table 3: HOD Elective Selections
-- Stores which elective courses HOD has approved for their department
CREATE TABLE `hod_elective_selections` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `department_id` INT NOT NULL,
  `curriculum_id` INT NOT NULL COMMENT 'Which curriculum this applies to',
  `semester` INT NOT NULL COMMENT '4-8 (electives start from sem 4)',
  `course_id` INT NOT NULL,
  `slot_id` INT NOT NULL COMMENT 'Foreign key to elective_semester_slots',
  `academic_year` VARCHAR(20) NOT NULL COMMENT 'e.g., "2025-2026" - allows different electives per year',
  `batch` VARCHAR(20) DEFAULT NULL COMMENT 'Student batch e.g., "2024-2028" - for batch-specific electives',
  `max_students` INT DEFAULT NULL COMMENT 'Maximum students for this elective (optional capacity limit)',
  `approved_by_user_id` INT NOT NULL COMMENT 'User ID from users table (HOD who approved)',
  `status` ENUM('ACTIVE', 'INACTIVE', 'DRAFT') DEFAULT 'ACTIVE',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_dept_sem_course_year_batch` (`department_id`, `semester`, `course_id`, `academic_year`, `batch`),
  KEY `idx_department` (`department_id`),
  KEY `idx_curriculum` (`curriculum_id`),
  KEY `idx_semester` (`semester`),
  KEY `idx_academic_year` (`academic_year`),
  KEY `idx_batch` (`batch`),
  CONSTRAINT `fk_hod_selection_dept` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_hod_selection_curriculum` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_hod_selection_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_hod_selection_user` FOREIGN KEY (`approved_by_user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_hod_selection_slot` FOREIGN KEY (`slot_id`) REFERENCES `elective_semester_slots` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table 4: Student Elective Choices
-- Stores student selections from HOD-approved electives
CREATE TABLE `student_elective_choices` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `student_id` INT NOT NULL,
  `hod_selection_id` INT NOT NULL COMMENT 'References hod_elective_selections',
  `semester` INT NOT NULL,
  `academic_year` VARCHAR(20) NOT NULL,
  `choice_order` INT DEFAULT 1 COMMENT 'Priority if multiple electives in same category (1=first choice)',
  `status` ENUM('PENDING', 'CONFIRMED', 'REJECTED', 'WAITLISTED') DEFAULT 'PENDING',
  `selected_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `confirmed_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_student_hod_selection` (`student_id`, `hod_selection_id`),
  KEY `idx_student` (`student_id`),
  KEY `idx_semester` (`semester`),
  KEY `idx_academic_year` (`academic_year`),
  KEY `idx_status` (`status`),
  CONSTRAINT `fk_student_choice_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_student_choice_hod_selection` FOREIGN KEY (`hod_selection_id`) REFERENCES `hod_elective_selections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table 5: Department Curriculum Mapping
-- Maps departments to their active curricula (if not already tracked)
CREATE TABLE `department_curriculum_active` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `department_id` INT NOT NULL,
  `curriculum_id` INT NOT NULL,
  `academic_year` VARCHAR(20) NOT NULL COMMENT 'Which year this curriculum is active for',
  `is_active` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_dept_curriculum_year` (`department_id`, `curriculum_id`, `academic_year`),
  KEY `idx_department` (`department_id`),
  KEY `idx_curriculum` (`curriculum_id`),
  CONSTRAINT `fk_dept_curr_active_dept` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_dept_curr_active_curr` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- =========================================================
-- SAMPLE DATA INSERTION
-- =========================================================

-- Insert elective semester slots
INSERT INTO elective_semester_slots (semester, slot_name, slot_order) VALUES
(4, 'Professional Elective 1', 1),
(5, 'Professional Elective 2', 1),
(5, 'Open Elective', 2),
(6, 'Professional Elective 3', 1),
(6, 'Professional Elective 4', 2),
(6, 'Professional Elective 5', 3),
(7, 'Professional Elective 6', 1),
(7, 'Professional Elective 7', 2),
(7, 'Professional Elective 8', 3),
(7, 'Professional Elective 9', 4),
(7, 'Mini Project I', 5);

-- Insert current academic calendar
INSERT INTO `academic_calendar` 
(`academic_year`, `current_semester`, `semester_start_date`, `semester_end_date`, 
 `elective_selection_start`, `elective_selection_end`, `is_current`) 
VALUES 
('2025-2026', 4, '2026-01-01', '2026-05-30', '2026-02-01', '2026-02-15', 1);

-- Example: Link AIDS department (id=14) to its curriculum (id=296) for 2025-2026
INSERT INTO `department_curriculum_active` 
(`department_id`, `curriculum_id`, `academic_year`, `is_active`) 
VALUES 
(14, 296, '2025-2026', 1);

-- =========================================================
-- INDEXES FOR PERFORMANCE
-- =========================================================

-- Additional indexes for common queries
ALTER TABLE `hod_elective_selections` 
  ADD INDEX `idx_dept_sem_year` (`department_id`, `semester`, `academic_year`);

ALTER TABLE `student_elective_choices` 
  ADD INDEX `idx_student_sem_year` (`student_id`, `semester`, `academic_year`);

-- =========================================================
-- VIEWS FOR EASIER QUERYING (OPTIONAL - Commented out due to permissions)
-- =========================================================
-- Note: Uncomment these if your database user has CREATE VIEW privileges
-- The system works without these views - they're just convenience queries

-- View: HOD-approved electives with course details
/*
CREATE OR REPLACE VIEW `v_hod_approved_electives` AS
SELECT 
    hes.id AS selection_id,
    hes.department_id,
    d.department_name,
    hes.curriculum_id,
    c.name AS curriculum_name,
    hes.semester,
    hes.course_id,
    co.course_code,
    co.course_name,
    co.course_type,
    co.category,
    co.credit,
    hes.academic_year,
    hes.batch,
    hes.max_students,
    hes.status,
    u.full_name AS approved_by_name,
    hes.created_at
FROM 
    hod_elective_selections hes
    INNER JOIN departments d ON hes.department_id = d.id
    INNER JOIN curriculum c ON hes.curriculum_id = c.id
    INNER JOIN courses co ON hes.course_id = co.id
    INNER JOIN users u ON hes.approved_by_user_id = u.id
WHERE 
    hes.status = 'ACTIVE';
*/

-- View: Student elective choices with details
/*
CREATE OR REPLACE VIEW `v_student_elective_choices` AS
SELECT 
    sec.id AS choice_id,
    sec.student_id,
    s.name AS student_name,
    s.roll_no,
    sec.semester,
    sec.academic_year,
    co.course_code,
    co.course_name,
    co.course_type,
    co.category,
    co.credit,
    sec.choice_order,
    sec.status,
    sec.selected_at,
    sec.confirmed_at,
    d.department_name
FROM 
    student_elective_choices sec
    INNER JOIN students s ON sec.student_id = s.id
    INNER JOIN hod_elective_selections hes ON sec.hod_selection_id = hes.id
    INNER JOIN courses co ON hes.course_id = co.id
    INNER JOIN departments d ON hes.department_id = d.id;
*/

-- =========================================================
-- COMMENTS
-- =========================================================

-- Future-proofing strategy:
-- 1. `batch` column in hod_elective_selections allows different electives 
--    for 2024-2028 batch vs 2025-2029 batch in same academic year
-- 2. `academic_year` column allows historical tracking and future planning
-- 3. `status` ENUM allows draft mode before publishing to students
-- 4. `max_students` enables capacity management if needed
-- 5. Views simplify complex queries for API endpoints
