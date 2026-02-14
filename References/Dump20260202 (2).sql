-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 10.10.12.99    Database: cms_test
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `academic_calendar`
--

DROP TABLE IF EXISTS `academic_calendar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_calendar` (
  `id` int NOT NULL AUTO_INCREMENT,
  `academic_year` varchar(20) NOT NULL COMMENT 'e.g., "2025-2026"',
  `current_semester` int NOT NULL COMMENT '1-8',
  `semester_start_date` date NOT NULL,
  `semester_end_date` date NOT NULL,
  `elective_selection_start` date DEFAULT NULL COMMENT 'When students can start selecting electives',
  `elective_selection_end` date DEFAULT NULL COMMENT 'Deadline for student elective selection',
  `is_current` tinyint(1) DEFAULT '0' COMMENT 'Only one row should be current=1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_academic_year_semester` (`academic_year`,`current_semester`),
  KEY `idx_is_current` (`is_current`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_calendar`
--

LOCK TABLES `academic_calendar` WRITE;
/*!40000 ALTER TABLE `academic_calendar` DISABLE KEYS */;
INSERT INTO `academic_calendar` VALUES (1,'2025-2026',4,'2026-01-01','2026-05-30','2026-02-01','2026-02-15',1,'2026-02-02 10:29:37','2026-02-02 10:29:37');
/*!40000 ALTER TABLE `academic_calendar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `academic_details`
--

DROP TABLE IF EXISTS `academic_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `batch` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `year` int DEFAULT NULL,
  `semester` int DEFAULT NULL,
  `degree_level` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `section` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `department` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `student_category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `branch_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `seat_category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `regulation` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `quota` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `university` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `year_of_admission` int DEFAULT NULL,
  `year_of_completion` int DEFAULT NULL,
  `student_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `curriculum_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_academic_student` (`student_id`) USING BTREE,
  KEY `fk_academic_curriculum` (`curriculum_id`) USING BTREE,
  CONSTRAINT `fk_academic_curriculum` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_academic_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_details`
--

LOCK TABLES `academic_details` WRITE;
/*!40000 ALTER TABLE `academic_details` DISABLE KEYS */;
INSERT INTO `academic_details` VALUES (18,3005,'2024 - 2028',2232,3,'wf','e','Information Technology','','','','','','',0,0,'',NULL),(34,3073,'2024-2028',2,3,'Bachelors','1','Computer Science and Engineering','','','','','','',0,0,'',295);
/*!40000 ALTER TABLE `academic_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `address`
--

DROP TABLE IF EXISTS `address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `address` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `permanent_address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `present_address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `residence_location` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`) USING BTREE,
  CONSTRAINT `address_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address`
--

LOCK TABLES `address` WRITE;
/*!40000 ALTER TABLE `address` DISABLE KEYS */;
INSERT INTO `address` VALUES (1,3005,'32e23','',''),(16,3073,'erwefwfwef','','');
/*!40000 ALTER TABLE `address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admission_payment`
--

DROP TABLE IF EXISTS `admission_payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admission_payment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `dte_register_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `dte_admission_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `receipt_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `receipt_date` date DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `bank_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`) USING BTREE,
  CONSTRAINT `admission_payment_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admission_payment`
--

LOCK TABLES `admission_payment` WRITE;
/*!40000 ALTER TABLE `admission_payment` DISABLE KEYS */;
/*!40000 ALTER TABLE `admission_payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cluster_departments`
--

DROP TABLE IF EXISTS `cluster_departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cluster_departments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cluster_id` int NOT NULL,
  `curriculum_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `unique_department` (`curriculum_id`) USING BTREE,
  KEY `cluster_id` (`cluster_id`) USING BTREE,
  CONSTRAINT `cluster_departments_ibfk_1` FOREIGN KEY (`cluster_id`) REFERENCES `clusters` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cluster_departments`
--

LOCK TABLES `cluster_departments` WRITE;
/*!40000 ALTER TABLE `cluster_departments` DISABLE KEYS */;
/*!40000 ALTER TABLE `cluster_departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clusters`
--

DROP TABLE IF EXISTS `clusters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clusters` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clusters`
--

LOCK TABLES `clusters` WRITE;
/*!40000 ALTER TABLE `clusters` DISABLE KEYS */;
/*!40000 ALTER TABLE `clusters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `co_po_mapping`
--

DROP TABLE IF EXISTS `co_po_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `co_po_mapping` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `co_index` int NOT NULL,
  `po_index` int NOT NULL,
  `mapping_value` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_copo_course` (`course_id`) USING BTREE,
  CONSTRAINT `fk_copo_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `co_po_mapping`
--

LOCK TABLES `co_po_mapping` WRITE;
/*!40000 ALTER TABLE `co_po_mapping` DISABLE KEYS */;
/*!40000 ALTER TABLE `co_po_mapping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `co_pso_mapping`
--

DROP TABLE IF EXISTS `co_pso_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `co_pso_mapping` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `co_index` int NOT NULL,
  `pso_index` int NOT NULL,
  `mapping_value` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_copso_course` (`course_id`) USING BTREE,
  CONSTRAINT `fk_copso_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `co_pso_mapping`
--

LOCK TABLES `co_pso_mapping` WRITE;
/*!40000 ALTER TABLE `co_pso_mapping` DISABLE KEYS */;
/*!40000 ALTER TABLE `co_pso_mapping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_details`
--

DROP TABLE IF EXISTS `contact_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `parent_mobile` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `student_mobile` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `student_email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `parent_email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `official_email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`) USING BTREE,
  CONSTRAINT `contact_details_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_details`
--

LOCK TABLES `contact_details` WRITE;
/*!40000 ALTER TABLE `contact_details` DISABLE KEYS */;
INSERT INTO `contact_details` VALUES (1,3005,'3222323322','','23e@gmail.com','',''),(14,3073,'3423423234','','sdf@gmail.com','','');
/*!40000 ALTER TABLE `contact_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_experiment_topics`
--

DROP TABLE IF EXISTS `course_experiment_topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_experiment_topics` (
  `id` int NOT NULL AUTO_INCREMENT,
  `experiment_id` int NOT NULL,
  `topic_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `topic_order` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_exp_topics` (`experiment_id`) USING BTREE,
  CONSTRAINT `course_experiment_topics_ibfk_1` FOREIGN KEY (`experiment_id`) REFERENCES `course_experiments` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_experiment_topics`
--

LOCK TABLES `course_experiment_topics` WRITE;
/*!40000 ALTER TABLE `course_experiment_topics` DISABLE KEYS */;
INSERT INTO `course_experiment_topics` VALUES (71,25,'check',0,'2026-01-29 10:14:33',0),(72,26,'check main',0,'2026-01-29 10:17:53',0),(73,27,'hello',0,'2026-01-30 05:51:46',0),(74,28,'hello',0,'2026-01-30 06:49:32',0);
/*!40000 ALTER TABLE `course_experiment_topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_experiments`
--

DROP TABLE IF EXISTS `course_experiments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_experiments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `experiment_number` int NOT NULL,
  `experiment_name` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `hours` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_course_exp` (`course_id`) USING BTREE,
  CONSTRAINT `course_experiments_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_experiments`
--

LOCK TABLES `course_experiments` WRITE;
/*!40000 ALTER TABLE `course_experiments` DISABLE KEYS */;
INSERT INTO `course_experiments` VALUES (25,19,1,'Experiment 1',2,'2026-01-29 09:32:27','2026-01-30 03:06:38',0),(26,22,1,'Experiment 1',3,'2026-01-29 10:17:37','2026-01-30 03:06:38',0),(27,88,1,'Experiment 1',1,'2026-01-30 05:51:41','2026-01-30 05:52:20',0),(28,90,1,'Experiment 1',1,'2026-01-30 06:49:28','2026-01-30 07:57:42',0);
/*!40000 ALTER TABLE `course_experiments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_objectives`
--

DROP TABLE IF EXISTS `course_objectives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_objectives` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `objective` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `position` int NOT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_course_id` (`course_id`),
  CONSTRAINT `course_objectives_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_objectives`
--

LOCK TABLES `course_objectives` WRITE;
/*!40000 ALTER TABLE `course_objectives` DISABLE KEYS */;
INSERT INTO `course_objectives` VALUES (59,13,'check',0,0),(60,14,'delete',0,0),(61,15,'check 1',0,0),(62,16,'checkc',0,0),(63,22,'check main',0,0),(64,19,'check main',0,0),(65,88,'bug',0,0),(66,88,'bug1',1,0),(67,88,'bug 3',2,0),(68,88,'bug 2',3,0),(69,88,'bug123',4,0),(70,90,'hello',0,0);
/*!40000 ALTER TABLE `course_objectives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_outcomes`
--

DROP TABLE IF EXISTS `course_outcomes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_outcomes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `outcome` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `position` int NOT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_course_id` (`course_id`),
  CONSTRAINT `fk_course_outcomes_courses` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=235 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_outcomes`
--

LOCK TABLES `course_outcomes` WRITE;
/*!40000 ALTER TABLE `course_outcomes` DISABLE KEYS */;
INSERT INTO `course_outcomes` VALUES (225,13,'check',0,0),(226,14,'delete',0,0),(227,15,'check 1',0,0),(228,16,'checkc',0,0),(229,22,'check main',0,0),(230,19,'check main',0,0),(231,88,'bug',1,0),(232,88,'bug',0,0),(233,88,'nigh 2',2,0),(234,90,'hello',0,0);
/*!40000 ALTER TABLE `course_outcomes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_prerequisites`
--

DROP TABLE IF EXISTS `course_prerequisites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_prerequisites` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `prerequisite` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `position` int NOT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_course_id` (`course_id`),
  CONSTRAINT `fk_course_prerequisites_courses` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_prerequisites`
--

LOCK TABLES `course_prerequisites` WRITE;
/*!40000 ALTER TABLE `course_prerequisites` DISABLE KEYS */;
/*!40000 ALTER TABLE `course_prerequisites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_references`
--

DROP TABLE IF EXISTS `course_references`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_references` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `reference_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `position` int NOT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_course_id` (`course_id`),
  CONSTRAINT `fk_course_references_courses` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_references`
--

LOCK TABLES `course_references` WRITE;
/*!40000 ALTER TABLE `course_references` DISABLE KEYS */;
INSERT INTO `course_references` VALUES (32,13,'check',0,0),(33,14,'delete',0,0),(34,15,'check 1',0,0),(35,16,'checkc',0,0),(36,22,'check main',0,0),(37,19,'check main',0,0),(38,88,'hello',0,0),(39,90,'hello',0,0);
/*!40000 ALTER TABLE `course_references` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_selflearning`
--

DROP TABLE IF EXISTS `course_selflearning`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_selflearning` (
  `id` int NOT NULL,
  `course_id` int NOT NULL,
  `total_hours` int NOT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_course_id` (`course_id`),
  CONSTRAINT `fk_target_table_courses` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_selflearning`
--

LOCK TABLES `course_selflearning` WRITE;
/*!40000 ALTER TABLE `course_selflearning` DISABLE KEYS */;
INSERT INTO `course_selflearning` VALUES (88,88,0,1),(89,89,0,1),(90,90,0,1);
/*!40000 ALTER TABLE `course_selflearning` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_selflearning_resources`
--

DROP TABLE IF EXISTS `course_selflearning_resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_selflearning_resources` (
  `id` int NOT NULL AUTO_INCREMENT,
  `main_id` int NOT NULL,
  `internal_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `position` int NOT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_main_id` (`main_id`),
  CONSTRAINT `course_selflearning_resources_ibfk_1` FOREIGN KEY (`main_id`) REFERENCES `course_selflearning_topics` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_selflearning_resources`
--

LOCK TABLES `course_selflearning_resources` WRITE;
/*!40000 ALTER TABLE `course_selflearning_resources` DISABLE KEYS */;
/*!40000 ALTER TABLE `course_selflearning_resources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_selflearning_topics`
--

DROP TABLE IF EXISTS `course_selflearning_topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_selflearning_topics` (
  `id` int NOT NULL AUTO_INCREMENT,
  `main_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `position` int NOT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_selflearning_topics`
--

LOCK TABLES `course_selflearning_topics` WRITE;
/*!40000 ALTER TABLE `course_selflearning_topics` DISABLE KEYS */;
/*!40000 ALTER TABLE `course_selflearning_topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_student_teacher_allocation`
--

DROP TABLE IF EXISTS `course_student_teacher_allocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_student_teacher_allocation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `course_id` int NOT NULL,
  `teacher_id` varchar(45) NOT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_student_course_assign` (`student_id`,`course_id`),
  KEY `fk_assign_course` (`course_id`),
  CONSTRAINT `fk_assign_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`),
  CONSTRAINT `fk_assign_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4096 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_student_teacher_allocation`
--

LOCK TABLES `course_student_teacher_allocation` WRITE;
/*!40000 ALTER TABLE `course_student_teacher_allocation` DISABLE KEYS */;
INSERT INTO `course_student_teacher_allocation` VALUES (1,3048,130,'AG10172',1),(2,3049,130,'AG10895',1),(3,3050,130,'AG11083',1),(4,3051,130,'AG10172',1),(5,3052,130,'AG10895',1),(6,3053,130,'AG11083',1),(7,3054,130,'AG10172',1),(8,3055,130,'AG10895',1),(9,3056,130,'AG11083',1),(10,3057,130,'AG10172',1),(11,3058,130,'AG10895',1),(12,3059,130,'AG11083',1),(13,3060,130,'AG10172',1),(14,3061,130,'AG10895',1),(15,3062,130,'AG11083',1),(16,3063,130,'AG10172',1),(17,3064,130,'AG10895',1),(18,3065,130,'AG11083',1),(19,3066,130,'AG10172',1),(20,3067,130,'AG10895',1),(21,3068,130,'AG11083',1),(22,3069,130,'AG10172',1),(23,3070,130,'AG10895',1),(24,3071,130,'AG11083',1),(25,3072,130,'AG10172',1),(26,3073,130,'AG10895',1),(27,3048,131,'AG11083',1),(28,3049,131,'AG11083',1),(29,3050,131,'AG11083',1),(30,3051,131,'AG11083',1),(31,3052,131,'AG11083',1),(32,3053,131,'AG11083',1),(33,3054,131,'AG11083',1),(34,3055,131,'AG11083',1),(35,3056,131,'AG11083',1),(36,3057,131,'AG11083',1),(37,3058,131,'AG11083',1),(38,3059,131,'AG11083',1),(39,3060,131,'AG11083',1),(40,3061,131,'AG11083',1),(41,3062,131,'AG11083',1),(42,3063,131,'AG11083',1),(43,3064,131,'AG11083',1),(44,3065,131,'AG11083',1),(45,3066,131,'AG11083',1),(46,3067,131,'AG11083',1),(47,3068,131,'AG11083',1),(48,3069,131,'AG11083',1),(49,3070,131,'AG11083',1),(50,3071,131,'AG11083',1),(51,3072,131,'AG11083',1),(52,3073,131,'AG11083',1),(53,3048,132,'AG10172',1),(54,3049,132,'AG10172',1),(55,3050,132,'AG10172',1),(56,3051,132,'AG10172',1),(57,3052,132,'AG10172',1),(58,3053,132,'AG10172',1),(59,3054,132,'AG10172',1),(60,3055,132,'AG10172',1),(61,3056,132,'AG10172',1),(62,3057,132,'AG10172',1),(63,3058,132,'AG10172',1),(64,3059,132,'AG10172',1),(65,3060,132,'AG10172',1),(66,3061,132,'AG10172',1),(67,3062,132,'AG10172',1),(68,3063,132,'AG10172',1),(69,3064,132,'AG10172',1),(70,3065,132,'AG10172',1),(71,3066,132,'AG10172',1),(72,3067,132,'AG10172',1),(73,3068,132,'AG10172',1),(74,3069,132,'AG10172',1),(75,3070,132,'AG10172',1),(76,3071,132,'AG10172',1),(77,3072,132,'AG10172',1),(78,3073,132,'AG10172',1),(79,3048,133,'MC10299',1),(80,3049,133,'MC10299',1),(81,3050,133,'MC10299',1),(82,3051,133,'MC10299',1),(83,3052,133,'MC10299',1),(84,3053,133,'MC10299',1),(85,3054,133,'MC10299',1),(86,3055,133,'MC10299',1),(87,3056,133,'MC10299',1),(88,3057,133,'MC10299',1),(89,3058,133,'MC10299',1),(90,3059,133,'MC10299',1),(91,3060,133,'MC10299',1),(92,3061,133,'MC10299',1),(93,3062,133,'MC10299',1),(94,3063,133,'MC10299',1),(95,3064,133,'MC10299',1),(96,3065,133,'MC10299',1),(97,3066,133,'MC10299',1),(98,3067,133,'MC10299',1),(99,3068,133,'MC10299',1),(100,3069,133,'MC10299',1),(101,3070,133,'MC10299',1),(102,3071,133,'MC10299',1),(103,3072,133,'MC10299',1),(104,3073,133,'MC10299',1),(105,3048,134,'AG1312',1),(106,3049,134,'AG1312',1),(107,3050,134,'AG1312',1),(108,3051,134,'AG1312',1),(109,3052,134,'AG1312',1),(110,3053,134,'AG1312',1),(111,3054,134,'AG1312',1),(112,3055,134,'AG1312',1),(113,3056,134,'AG1312',1),(114,3057,134,'AG1312',1),(115,3058,134,'AG1312',1),(116,3059,134,'AG1312',1),(117,3060,134,'AG1312',1),(118,3061,134,'AG1312',1),(119,3062,134,'AG1312',1),(120,3063,134,'AG1312',1),(121,3064,134,'AG1312',1),(122,3065,134,'AG1312',1),(123,3066,134,'AG1312',1),(124,3067,134,'AG1312',1),(125,3068,134,'AG1312',1),(126,3069,134,'AG1312',1),(127,3070,134,'AG1312',1),(128,3071,134,'AG1312',1),(129,3072,134,'AG1312',1),(130,3073,134,'AG1312',1),(131,3048,135,'AG10092',1),(132,3049,135,'AG10092',1),(133,3050,135,'AG10092',1),(134,3051,135,'AG10092',1),(135,3052,135,'AG10092',1),(136,3053,135,'AG10092',1),(137,3054,135,'AG10092',1),(138,3055,135,'AG10092',1),(139,3056,135,'AG10092',1),(140,3057,135,'AG10092',1),(141,3058,135,'AG10092',1),(142,3059,135,'AG10092',1),(143,3060,135,'AG10092',1),(144,3061,135,'AG10092',1),(145,3062,135,'AG10092',1),(146,3063,135,'AG10092',1),(147,3064,135,'AG10092',1),(148,3065,135,'AG10092',1),(149,3066,135,'AG10092',1),(150,3067,135,'AG10092',1),(151,3068,135,'AG10092',1),(152,3069,135,'AG10092',1),(153,3070,135,'AG10092',1),(154,3071,135,'AG10092',1),(155,3072,135,'AG10092',1),(156,3073,135,'AG10092',1),(157,3048,141,'CH10957',1),(158,3049,141,'CH11127',1),(159,3050,141,'CH1557',1),(160,3051,141,'CH1558',1),(161,3052,141,'CH1894',1),(162,3053,141,'CH10957',1),(163,3054,141,'CH11127',1),(164,3055,141,'CH1557',1),(165,3056,141,'CH1558',1),(166,3057,141,'CH1894',1),(167,3058,141,'CH10957',1),(168,3059,141,'CH11127',1),(169,3060,141,'CH1557',1),(170,3061,141,'CH1558',1),(171,3062,141,'CH1894',1),(172,3063,141,'CH10957',1),(173,3064,141,'CH11127',1),(174,3065,141,'CH1557',1),(175,3066,141,'CH1558',1),(176,3067,141,'CH1894',1),(177,3068,141,'CH10957',1),(178,3069,141,'CH11127',1),(179,3070,141,'CH1557',1),(180,3071,141,'CH1558',1),(181,3072,141,'CH1894',1),(182,3073,141,'CH10957',1),(183,3507,141,'CH11127',1),(184,3508,141,'CH1557',1),(185,3509,141,'CH1558',1),(186,3510,141,'CH1894',1),(187,3511,141,'CH10957',1),(188,3512,141,'CH11127',1),(189,3513,141,'CH1557',1),(190,3514,141,'CH1558',1),(191,3515,141,'CH1894',1),(192,3516,141,'CH10957',1),(193,3517,141,'CH11127',1),(194,3518,141,'CH1557',1),(195,3519,141,'CH1558',1),(196,3520,141,'CH1894',1),(197,3521,141,'CH10957',1),(198,3522,141,'CH11127',1),(199,3523,141,'CH1557',1),(200,3524,141,'CH1558',1),(201,3525,141,'CH1894',1),(202,3526,141,'CH10957',1),(203,3527,141,'CH11127',1),(204,3528,141,'CH1557',1),(205,3529,141,'CH1558',1),(206,3530,141,'CH1894',1),(207,3531,141,'CH10957',1),(208,3532,141,'CH11127',1),(209,3533,141,'CH1557',1),(210,3534,141,'CH1558',1),(211,3535,141,'CH1894',1),(212,3536,141,'CH10957',1),(213,3537,141,'CH11127',1),(214,3538,141,'CH1557',1),(215,3539,141,'CH1558',1),(216,3540,141,'CH1894',1),(217,3541,141,'CH10957',1),(218,3542,141,'CH11127',1),(219,3543,141,'CH1557',1),(220,3544,141,'CH1558',1),(221,3545,141,'CH1894',1),(222,3546,141,'CH10957',1),(223,3547,141,'CH11127',1),(224,3548,141,'CH1557',1),(225,3549,141,'CH1558',1),(226,3550,141,'CH1894',1),(227,3551,141,'CH10957',1),(228,3552,141,'CH11127',1),(229,3553,141,'CH1557',1),(230,3554,141,'CH1558',1),(231,3555,141,'CH1894',1),(232,3556,141,'CH10957',1),(233,3557,141,'CH11127',1),(234,3558,141,'CH1557',1),(235,3559,141,'CH1558',1),(236,3560,141,'CH1894',1),(237,3561,141,'CH10957',1),(238,3562,141,'CH11127',1),(239,3563,141,'CH1557',1),(240,3564,141,'CH1558',1),(241,3565,141,'CH1894',1),(242,3566,141,'CH10957',1),(243,3567,141,'CH11127',1),(244,3568,141,'CH1557',1),(245,3569,141,'CH1558',1),(246,3570,141,'CH1894',1),(247,3571,141,'CH10957',1),(248,3572,141,'CH11127',1),(249,3573,141,'CH1557',1),(250,3574,141,'CH1558',1),(251,3575,141,'CH1894',1),(252,3576,141,'CH10957',1),(253,3577,141,'CH11127',1),(254,3578,141,'CH1557',1),(255,3579,141,'CH1558',1),(256,3580,141,'CH1894',1),(257,3581,141,'CH10957',1),(258,3582,141,'CH11127',1),(259,3583,141,'CH1557',1),(260,3584,141,'CH1558',1),(261,3585,141,'CH1894',1),(262,3586,141,'CH10957',1),(263,3587,141,'CH11127',1),(264,3588,141,'CH1557',1),(265,3589,141,'CH1558',1),(266,3590,141,'CH1894',1),(267,3591,141,'CH10957',1),(268,3592,141,'CH11127',1),(269,3593,141,'CH1557',1),(270,3594,141,'CH1558',1),(271,3595,141,'CH1894',1),(272,3596,141,'CH10957',1),(273,3597,141,'CH11127',1),(274,3598,141,'CH1557',1),(275,3599,141,'CH1558',1),(276,3600,141,'CH1894',1),(277,3601,141,'CH10957',1),(278,3602,141,'CH11127',1),(279,3603,141,'CH1557',1),(280,3604,141,'CH1558',1),(281,3605,141,'CH1894',1),(282,3606,141,'CH10957',1),(283,3607,141,'CH11127',1),(284,3608,141,'CH1557',1),(285,3609,141,'CH1558',1),(286,3610,141,'CH1894',1),(287,3611,141,'CH10957',1),(288,3612,141,'CH11127',1),(289,3613,141,'CH1557',1),(290,3614,141,'CH1558',1),(291,3615,141,'CH1894',1),(292,3616,141,'CH10957',1),(293,3617,141,'CH11127',1),(294,3618,141,'CH1557',1),(295,3619,141,'CH1558',1),(296,3620,141,'CH1894',1),(297,3621,141,'CH10957',1),(298,3622,141,'CH11127',1),(299,3623,141,'CH1557',1),(300,3624,141,'CH1558',1),(301,3625,141,'CH1894',1),(302,3626,141,'CH10957',1),(303,3627,141,'CH11127',1),(304,3628,141,'CH1557',1),(305,3629,141,'CH1558',1),(306,3630,141,'CH1894',1),(307,3631,141,'CH10957',1),(308,3632,141,'CH11127',1),(309,3633,141,'CH1557',1),(310,3634,141,'CH1558',1),(311,3635,141,'CH1894',1),(312,3636,141,'CH10957',1),(313,3637,141,'CH11127',1),(314,3638,141,'CH1557',1),(315,3639,141,'CH1558',1),(316,3640,141,'CH1894',1),(317,3641,141,'CH10957',1),(318,3642,141,'CH11127',1),(319,3643,141,'CH1557',1),(320,3644,141,'CH1558',1),(321,3645,141,'CH1894',1),(322,3646,141,'CH10957',1),(323,3647,141,'CH11127',1),(324,3648,141,'CH1557',1),(325,3649,141,'CH1558',1),(326,3650,141,'CH1894',1),(327,3651,141,'CH10957',1),(328,3652,141,'CH11127',1),(329,3653,141,'CH1557',1),(330,3654,141,'CH1558',1),(331,3655,141,'CH1894',1),(332,3656,141,'CH10957',1),(333,3657,141,'CH11127',1),(334,3658,141,'CH1557',1),(335,3659,141,'CH1558',1),(336,3660,141,'CH1894',1),(337,3661,141,'CH10957',1),(338,3662,141,'CH11127',1),(339,3663,141,'CH1557',1),(340,3664,141,'CH1558',1),(341,3665,141,'CH1894',1),(342,3666,141,'CH10957',1),(343,3667,141,'CH11127',1),(344,3668,141,'CH1557',1),(345,3669,141,'CH1558',1),(346,3670,141,'CH1894',1),(347,3671,141,'CH10957',1),(348,3672,141,'CH11127',1),(349,3673,141,'CH1557',1),(350,3674,141,'CH1558',1),(351,3675,141,'CH1894',1),(352,3676,141,'CH10957',1),(353,3677,141,'CH11127',1),(354,3678,141,'CH1557',1),(355,3679,141,'CH1558',1),(356,3680,141,'CH1894',1),(357,3681,141,'CH10957',1),(358,3682,141,'CH11127',1),(359,3683,141,'CH1557',1),(360,3684,141,'CH1558',1),(361,3685,141,'CH1894',1),(362,3686,141,'CH10957',1),(363,3687,141,'CH11127',1),(364,3688,141,'CH1557',1),(365,3689,141,'CH1558',1),(366,3690,141,'CH1894',1),(367,3691,141,'CH10957',1),(368,3692,141,'CH11127',1),(369,3693,141,'CH1557',1),(370,3694,141,'CH1558',1),(371,3695,141,'CH1894',1),(372,3696,141,'CH10957',1),(373,3697,141,'CH11127',1),(374,3698,141,'CH1557',1),(375,3699,141,'CH1558',1),(376,3700,141,'CH1894',1),(377,3701,141,'CH10957',1),(378,3702,141,'CH11127',1),(379,3703,141,'CH1557',1),(380,3704,141,'CH1558',1),(381,3705,141,'CH1894',1),(382,3706,141,'CH10957',1),(383,3707,141,'CH11127',1),(384,3708,141,'CH1557',1),(385,3709,141,'CH1558',1),(386,3710,141,'CH1894',1),(387,3711,141,'CH10957',1),(388,3712,141,'CH11127',1),(389,3713,141,'CH1557',1),(390,3714,141,'CH1558',1),(391,3715,141,'CH1894',1),(392,3716,141,'CH10957',1),(393,3717,141,'CH11127',1),(394,3718,141,'CH1557',1),(395,3719,141,'CH1558',1),(396,3720,141,'CH1894',1),(397,3721,141,'CH10957',1),(398,3722,141,'CH11127',1),(399,3723,141,'CH1557',1),(400,3724,141,'CH1558',1),(401,3725,141,'CH1894',1),(402,3726,141,'CH10957',1),(403,3727,141,'CH11127',1),(404,3728,141,'CH1557',1),(405,3729,141,'CH1558',1),(406,3730,141,'CH1894',1),(407,3731,141,'CH10957',1),(408,3732,141,'CH11127',1),(409,3733,141,'CH1557',1),(410,3734,141,'CH1558',1),(411,3735,141,'CH1894',1),(412,3736,141,'CH10957',1),(413,3737,141,'CH11127',1),(414,3738,141,'CH1557',1),(415,3739,141,'CH1558',1),(416,3740,141,'CH1894',1),(417,3741,141,'CH10957',1),(418,3742,141,'CH11127',1),(419,3743,141,'CH1557',1),(420,3744,141,'CH1558',1),(421,3745,141,'CH1894',1),(422,3746,141,'CH10957',1),(423,3747,141,'CH11127',1),(424,3748,141,'CH1557',1),(425,3749,141,'CH1558',1),(426,3750,141,'CH1894',1),(427,3751,141,'CH10957',1),(428,3752,141,'CH11127',1),(429,3753,141,'CH1557',1),(430,3754,141,'CH1558',1),(431,3755,141,'CH1894',1),(432,3756,141,'CH10957',1),(433,3757,141,'CH11127',1),(434,3758,141,'CH1557',1),(435,3759,141,'CH1558',1),(436,3760,141,'CH1894',1),(437,3761,141,'CH10957',1),(438,3762,141,'CH11127',1),(439,3763,141,'CH1557',1),(440,3764,141,'CH1558',1),(441,3765,141,'CH1894',1),(442,3766,141,'CH10957',1),(443,3767,141,'CH11127',1),(444,3768,141,'CH1557',1),(445,3048,142,'HU11011',1),(446,3049,142,'HU11125',1),(447,3050,142,'HU11139',1),(448,3051,142,'HU11141',1),(449,3052,142,'HU11151',1),(450,3053,142,'HU11011',1),(451,3054,142,'HU11125',1),(452,3055,142,'HU11139',1),(453,3056,142,'HU11141',1),(454,3057,142,'HU11151',1),(455,3058,142,'HU11011',1),(456,3059,142,'HU11125',1),(457,3060,142,'HU11139',1),(458,3061,142,'HU11141',1),(459,3062,142,'HU11151',1),(460,3063,142,'HU11011',1),(461,3064,142,'HU11125',1),(462,3065,142,'HU11139',1),(463,3066,142,'HU11141',1),(464,3067,142,'HU11151',1),(465,3068,142,'HU11011',1),(466,3069,142,'HU11125',1),(467,3070,142,'HU11139',1),(468,3071,142,'HU11141',1),(469,3072,142,'HU11151',1),(470,3073,142,'HU11011',1),(471,3507,142,'HU11125',1),(472,3508,142,'HU11139',1),(473,3509,142,'HU11141',1),(474,3510,142,'HU11151',1),(475,3511,142,'HU11011',1),(476,3512,142,'HU11125',1),(477,3513,142,'HU11139',1),(478,3514,142,'HU11141',1),(479,3515,142,'HU11151',1),(480,3516,142,'HU11011',1),(481,3517,142,'HU11125',1),(482,3518,142,'HU11139',1),(483,3519,142,'HU11141',1),(484,3520,142,'HU11151',1),(485,3521,142,'HU11011',1),(486,3522,142,'HU11125',1),(487,3523,142,'HU11139',1),(488,3524,142,'HU11141',1),(489,3525,142,'HU11151',1),(490,3526,142,'HU11011',1),(491,3527,142,'HU11125',1),(492,3528,142,'HU11139',1),(493,3529,142,'HU11141',1),(494,3530,142,'HU11151',1),(495,3531,142,'HU11011',1),(496,3532,142,'HU11125',1),(497,3533,142,'HU11139',1),(498,3534,142,'HU11141',1),(499,3535,142,'HU11151',1),(500,3536,142,'HU11011',1),(501,3537,142,'HU11125',1),(502,3538,142,'HU11139',1),(503,3539,142,'HU11141',1),(504,3540,142,'HU11151',1),(505,3541,142,'HU11011',1),(506,3542,142,'HU11125',1),(507,3543,142,'HU11139',1),(508,3544,142,'HU11141',1),(509,3545,142,'HU11151',1),(510,3546,142,'HU11011',1),(511,3547,142,'HU11125',1),(512,3548,142,'HU11139',1),(513,3549,142,'HU11141',1),(514,3550,142,'HU11151',1),(515,3551,142,'HU11011',1),(516,3552,142,'HU11125',1),(517,3553,142,'HU11139',1),(518,3554,142,'HU11141',1),(519,3555,142,'HU11151',1),(520,3556,142,'HU11011',1),(521,3557,142,'HU11125',1),(522,3558,142,'HU11139',1),(523,3559,142,'HU11141',1),(524,3560,142,'HU11151',1),(525,3561,142,'HU11011',1),(526,3562,142,'HU11125',1),(527,3563,142,'HU11139',1),(528,3564,142,'HU11141',1),(529,3565,142,'HU11151',1),(530,3566,142,'HU11011',1),(531,3567,142,'HU11125',1),(532,3568,142,'HU11139',1),(533,3569,142,'HU11141',1),(534,3570,142,'HU11151',1),(535,3571,142,'HU11011',1),(536,3572,142,'HU11125',1),(537,3573,142,'HU11139',1),(538,3574,142,'HU11141',1),(539,3575,142,'HU11151',1),(540,3576,142,'HU11011',1),(541,3577,142,'HU11125',1),(542,3578,142,'HU11139',1),(543,3579,142,'HU11141',1),(544,3580,142,'HU11151',1),(545,3581,142,'HU11011',1),(546,3582,142,'HU11125',1),(547,3583,142,'HU11139',1),(548,3584,142,'HU11141',1),(549,3585,142,'HU11151',1),(550,3586,142,'HU11011',1),(551,3587,142,'HU11125',1),(552,3588,142,'HU11139',1),(553,3589,142,'HU11141',1),(554,3590,142,'HU11151',1),(555,3591,142,'HU11011',1),(556,3592,142,'HU11125',1),(557,3593,142,'HU11139',1),(558,3594,142,'HU11141',1),(559,3595,142,'HU11151',1),(560,3596,142,'HU11011',1),(561,3597,142,'HU11125',1),(562,3598,142,'HU11139',1),(563,3599,142,'HU11141',1),(564,3600,142,'HU11151',1),(565,3601,142,'HU11011',1),(566,3602,142,'HU11125',1),(567,3603,142,'HU11139',1),(568,3604,142,'HU11141',1),(569,3605,142,'HU11151',1),(570,3606,142,'HU11011',1),(571,3607,142,'HU11125',1),(572,3608,142,'HU11139',1),(573,3609,142,'HU11141',1),(574,3610,142,'HU11151',1),(575,3611,142,'HU11011',1),(576,3612,142,'HU11125',1),(577,3613,142,'HU11139',1),(578,3614,142,'HU11141',1),(579,3615,142,'HU11151',1),(580,3616,142,'HU11011',1),(581,3617,142,'HU11125',1),(582,3618,142,'HU11139',1),(583,3619,142,'HU11141',1),(584,3620,142,'HU11151',1),(585,3621,142,'HU11011',1),(586,3622,142,'HU11125',1),(587,3623,142,'HU11139',1),(588,3624,142,'HU11141',1),(589,3625,142,'HU11151',1),(590,3626,142,'HU11011',1),(591,3627,142,'HU11125',1),(592,3628,142,'HU11139',1),(593,3629,142,'HU11141',1),(594,3630,142,'HU11151',1),(595,3631,142,'HU11011',1),(596,3632,142,'HU11125',1),(597,3633,142,'HU11139',1),(598,3634,142,'HU11141',1),(599,3635,142,'HU11151',1),(600,3636,142,'HU11011',1),(601,3637,142,'HU11125',1),(602,3638,142,'HU11139',1),(603,3639,142,'HU11141',1),(604,3640,142,'HU11151',1),(605,3641,142,'HU11011',1),(606,3642,142,'HU11125',1),(607,3643,142,'HU11139',1),(608,3644,142,'HU11141',1),(609,3645,142,'HU11151',1),(610,3646,142,'HU11011',1),(611,3647,142,'HU11125',1),(612,3648,142,'HU11139',1),(613,3649,142,'HU11141',1),(614,3650,142,'HU11151',1),(615,3651,142,'HU11011',1),(616,3652,142,'HU11125',1),(617,3653,142,'HU11139',1),(618,3654,142,'HU11141',1),(619,3655,142,'HU11151',1),(620,3656,142,'HU11011',1),(621,3657,142,'HU11125',1),(622,3658,142,'HU11139',1),(623,3659,142,'HU11141',1),(624,3660,142,'HU11151',1),(625,3661,142,'HU11011',1),(626,3662,142,'HU11125',1),(627,3663,142,'HU11139',1),(628,3664,142,'HU11141',1),(629,3665,142,'HU11151',1),(630,3666,142,'HU11011',1),(631,3667,142,'HU11125',1),(632,3668,142,'HU11139',1),(633,3669,142,'HU11141',1),(634,3670,142,'HU11151',1),(635,3671,142,'HU11011',1),(636,3672,142,'HU11125',1),(637,3673,142,'HU11139',1),(638,3674,142,'HU11141',1),(639,3675,142,'HU11151',1),(640,3676,142,'HU11011',1),(641,3677,142,'HU11125',1),(642,3678,142,'HU11139',1),(643,3679,142,'HU11141',1),(644,3680,142,'HU11151',1),(645,3681,142,'HU11011',1),(646,3682,142,'HU11125',1),(647,3683,142,'HU11139',1),(648,3684,142,'HU11141',1),(649,3685,142,'HU11151',1),(650,3686,142,'HU11011',1),(651,3687,142,'HU11125',1),(652,3688,142,'HU11139',1),(653,3689,142,'HU11141',1),(654,3690,142,'HU11151',1),(655,3691,142,'HU11011',1),(656,3692,142,'HU11125',1),(657,3693,142,'HU11139',1),(658,3694,142,'HU11141',1),(659,3695,142,'HU11151',1),(660,3696,142,'HU11011',1),(661,3697,142,'HU11125',1),(662,3698,142,'HU11139',1),(663,3699,142,'HU11141',1),(664,3700,142,'HU11151',1),(665,3701,142,'HU11011',1),(666,3702,142,'HU11125',1),(667,3703,142,'HU11139',1),(668,3704,142,'HU11141',1),(669,3705,142,'HU11151',1),(670,3706,142,'HU11011',1),(671,3707,142,'HU11125',1),(672,3708,142,'HU11139',1),(673,3709,142,'HU11141',1),(674,3710,142,'HU11151',1),(675,3711,142,'HU11011',1),(676,3712,142,'HU11125',1),(677,3713,142,'HU11139',1),(678,3714,142,'HU11141',1),(679,3715,142,'HU11151',1),(680,3716,142,'HU11011',1),(681,3717,142,'HU11125',1),(682,3718,142,'HU11139',1),(683,3719,142,'HU11141',1),(684,3720,142,'HU11151',1),(685,3721,142,'HU11011',1),(686,3722,142,'HU11125',1),(687,3723,142,'HU11139',1),(688,3724,142,'HU11141',1),(689,3725,142,'HU11151',1),(690,3726,142,'HU11011',1),(691,3727,142,'HU11125',1),(692,3728,142,'HU11139',1),(693,3729,142,'HU11141',1),(694,3730,142,'HU11151',1),(695,3731,142,'HU11011',1),(696,3732,142,'HU11125',1),(697,3733,142,'HU11139',1),(698,3734,142,'HU11141',1),(699,3735,142,'HU11151',1),(700,3736,142,'HU11011',1),(701,3737,142,'HU11125',1),(702,3738,142,'HU11139',1),(703,3739,142,'HU11141',1),(704,3740,142,'HU11151',1),(705,3741,142,'HU11011',1),(706,3742,142,'HU11125',1),(707,3743,142,'HU11139',1),(708,3744,142,'HU11141',1),(709,3745,142,'HU11151',1),(710,3746,142,'HU11011',1),(711,3747,142,'HU11125',1),(712,3748,142,'HU11139',1),(713,3749,142,'HU11141',1),(714,3750,142,'HU11151',1),(715,3751,142,'HU11011',1),(716,3752,142,'HU11125',1),(717,3753,142,'HU11139',1),(718,3754,142,'HU11141',1),(719,3755,142,'HU11151',1),(720,3756,142,'HU11011',1),(721,3757,142,'HU11125',1),(722,3758,142,'HU11139',1),(723,3759,142,'HU11141',1),(724,3760,142,'HU11151',1),(725,3761,142,'HU11011',1),(726,3762,142,'HU11125',1),(727,3763,142,'HU11139',1),(728,3764,142,'HU11141',1),(729,3765,142,'HU11151',1),(730,3766,142,'HU11011',1),(731,3767,142,'HU11125',1),(732,3768,142,'HU11139',1),(733,3509,147,'AD11009',1),(734,3510,147,'AD1108',1),(735,3511,147,'AD11009',1),(736,3513,147,'AD1108',1),(737,3515,147,'AD11009',1),(738,3516,147,'AD1108',1),(739,3520,147,'AD11009',1),(740,3521,147,'AD1108',1),(741,3522,147,'AD11009',1),(742,3525,147,'AD1108',1),(743,3526,147,'AD11009',1),(744,3530,147,'AD1108',1),(745,3533,147,'AD11009',1),(746,3534,147,'AD1108',1),(747,3535,147,'AD11009',1),(748,3537,147,'AD1108',1),(749,3538,147,'AD11009',1),(750,3540,147,'AD1108',1),(751,3541,147,'AD11009',1),(752,3544,147,'AD1108',1),(753,3545,147,'AD11009',1),(754,3552,147,'AD1108',1),(755,3556,147,'AD11009',1),(756,3557,147,'AD1108',1),(757,3558,147,'AD11009',1),(758,3559,147,'AD1108',1),(759,3561,147,'AD11009',1),(760,3562,147,'AD1108',1),(761,3563,147,'AD11009',1),(762,3565,147,'AD1108',1),(763,3574,147,'AD11009',1),(764,3575,147,'AD1108',1),(765,3579,147,'AD11009',1),(766,3580,147,'AD1108',1),(767,3584,147,'AD11009',1),(768,3585,147,'AD1108',1),(769,3586,147,'AD11009',1),(770,3587,147,'AD1108',1),(771,3589,147,'AD11009',1),(772,3591,147,'AD1108',1),(773,3596,147,'AD11009',1),(774,3600,147,'AD1108',1),(775,3601,147,'AD11009',1),(776,3604,147,'AD1108',1),(777,3606,147,'AD11009',1),(778,3607,147,'AD1108',1),(779,3608,147,'AD11009',1),(780,3609,147,'AD1108',1),(781,3613,147,'AD11009',1),(782,3615,147,'AD1108',1),(783,3616,147,'AD11009',1),(784,3618,147,'AD1108',1),(785,3620,147,'AD11009',1),(786,3623,147,'AD1108',1),(787,3624,147,'AD11009',1),(788,3625,147,'AD1108',1),(789,3626,147,'AD11009',1),(790,3627,147,'AD1108',1),(791,3628,147,'AD11009',1),(792,3629,147,'AD1108',1),(793,3633,147,'AD11009',1),(794,3634,147,'AD1108',1),(795,3635,147,'AD11009',1),(796,3636,147,'AD1108',1),(797,3638,147,'AD11009',1),(798,3639,147,'AD1108',1),(799,3640,147,'AD11009',1),(800,3641,147,'AD1108',1),(801,3646,147,'AD11009',1),(802,3647,147,'AD1108',1),(803,3648,147,'AD11009',1),(804,3650,147,'AD1108',1),(805,3652,147,'AD11009',1),(806,3654,147,'AD1108',1),(807,3658,147,'AD11009',1),(808,3660,147,'AD1108',1),(809,3664,147,'AD11009',1),(810,3670,147,'AD1108',1),(811,3672,147,'AD11009',1),(812,3675,147,'AD1108',1),(813,3676,147,'AD11009',1),(814,3679,147,'AD1108',1),(815,3684,147,'AD11009',1),(816,3686,147,'AD1108',1),(817,3688,147,'AD11009',1),(818,3691,147,'AD1108',1),(819,3692,147,'AD11009',1),(820,3693,147,'AD1108',1),(821,3695,147,'AD11009',1),(822,3701,147,'AD1108',1),(823,3702,147,'AD11009',1),(824,3709,147,'AD1108',1),(825,3710,147,'AD11009',1),(826,3713,147,'AD1108',1),(827,3714,147,'AD11009',1),(828,3716,147,'AD1108',1),(829,3717,147,'AD11009',1),(830,3718,147,'AD1108',1),(831,3719,147,'AD11009',1),(832,3720,147,'AD1108',1),(833,3722,147,'AD11009',1),(834,3724,147,'AD1108',1),(835,3726,147,'AD11009',1),(836,3728,147,'AD1108',1),(837,3730,147,'AD11009',1),(838,3731,147,'AD1108',1),(839,3735,147,'AD11009',1),(840,3736,147,'AD1108',1),(841,3737,147,'AD11009',1),(842,3738,147,'AD1108',1),(843,3739,147,'AD11009',1),(844,3740,147,'AD1108',1),(845,3741,147,'AD11009',1),(846,3744,147,'AD1108',1),(847,3745,147,'AD11009',1),(848,3746,147,'AD1108',1),(849,3748,147,'AD11009',1),(850,3750,147,'AD1108',1),(851,3751,147,'AD11009',1),(852,3756,147,'AD1108',1),(853,3757,147,'AD11009',1),(854,3758,147,'AD1108',1),(855,3760,147,'AD11009',1),(856,3761,147,'AD1108',1),(857,3763,147,'AD11009',1),(858,3765,147,'AD1108',1),(859,3767,147,'AD11009',1),(860,3768,147,'AD1108',1),(861,3507,154,'AD11111',1),(862,3508,154,'AD1444',1),(863,3512,154,'AD11111',1),(864,3514,154,'AD1444',1),(865,3517,154,'AD11111',1),(866,3518,154,'AD1444',1),(867,3519,154,'AD11111',1),(868,3523,154,'AD1444',1),(869,3524,154,'AD11111',1),(870,3527,154,'AD1444',1),(871,3528,154,'AD11111',1),(872,3529,154,'AD1444',1),(873,3531,154,'AD11111',1),(874,3532,154,'AD1444',1),(875,3536,154,'AD11111',1),(876,3539,154,'AD1444',1),(877,3542,154,'AD11111',1),(878,3543,154,'AD1444',1),(879,3546,154,'AD11111',1),(880,3547,154,'AD1444',1),(881,3548,154,'AD11111',1),(882,3549,154,'AD1444',1),(883,3550,154,'AD11111',1),(884,3551,154,'AD1444',1),(885,3553,154,'AD11111',1),(886,3554,154,'AD1444',1),(887,3555,154,'AD11111',1),(888,3560,154,'AD1444',1),(889,3564,154,'AD11111',1),(890,3566,154,'AD1444',1),(891,3567,154,'AD11111',1),(892,3568,154,'AD1444',1),(893,3569,154,'AD11111',1),(894,3570,154,'AD1444',1),(895,3571,154,'AD11111',1),(896,3572,154,'AD1444',1),(897,3573,154,'AD11111',1),(898,3576,154,'AD1444',1),(899,3577,154,'AD11111',1),(900,3578,154,'AD1444',1),(901,3581,154,'AD11111',1),(902,3582,154,'AD1444',1),(903,3583,154,'AD11111',1),(904,3588,154,'AD1444',1),(905,3590,154,'AD11111',1),(906,3592,154,'AD1444',1),(907,3593,154,'AD11111',1),(908,3594,154,'AD1444',1),(909,3595,154,'AD11111',1),(910,3597,154,'AD1444',1),(911,3598,154,'AD11111',1),(912,3599,154,'AD1444',1),(913,3602,154,'AD11111',1),(914,3603,154,'AD1444',1),(915,3605,154,'AD11111',1),(916,3610,154,'AD1444',1),(917,3611,154,'AD11111',1),(918,3612,154,'AD1444',1),(919,3614,154,'AD11111',1),(920,3617,154,'AD1444',1),(921,3619,154,'AD11111',1),(922,3621,154,'AD1444',1),(923,3622,154,'AD11111',1),(924,3630,154,'AD1444',1),(925,3631,154,'AD11111',1),(926,3632,154,'AD1444',1),(927,3637,154,'AD11111',1),(928,3642,154,'AD1444',1),(929,3643,154,'AD11111',1),(930,3644,154,'AD1444',1),(931,3645,154,'AD11111',1),(932,3649,154,'AD1444',1),(933,3651,154,'AD11111',1),(934,3653,154,'AD1444',1),(935,3655,154,'AD11111',1),(936,3656,154,'AD1444',1),(937,3657,154,'AD11111',1),(938,3659,154,'AD1444',1),(939,3661,154,'AD11111',1),(940,3662,154,'AD1444',1),(941,3663,154,'AD11111',1),(942,3665,154,'AD1444',1),(943,3666,154,'AD11111',1),(944,3667,154,'AD1444',1),(945,3668,154,'AD11111',1),(946,3669,154,'AD1444',1),(947,3671,154,'AD11111',1),(948,3673,154,'AD1444',1),(949,3674,154,'AD11111',1),(950,3677,154,'AD1444',1),(951,3678,154,'AD11111',1),(952,3680,154,'AD1444',1),(953,3681,154,'AD11111',1),(954,3682,154,'AD1444',1),(955,3683,154,'AD11111',1),(956,3685,154,'AD1444',1),(957,3687,154,'AD11111',1),(958,3689,154,'AD1444',1),(959,3690,154,'AD11111',1),(960,3694,154,'AD1444',1),(961,3696,154,'AD11111',1),(962,3697,154,'AD1444',1),(963,3698,154,'AD11111',1),(964,3699,154,'AD1444',1),(965,3700,154,'AD11111',1),(966,3703,154,'AD1444',1),(967,3704,154,'AD11111',1),(968,3705,154,'AD1444',1),(969,3706,154,'AD11111',1),(970,3707,154,'AD1444',1),(971,3708,154,'AD11111',1),(972,3711,154,'AD1444',1),(973,3712,154,'AD11111',1),(974,3715,154,'AD1444',1),(975,3721,154,'AD11111',1),(976,3723,154,'AD1444',1),(977,3725,154,'AD11111',1),(978,3727,154,'AD1444',1),(979,3729,154,'AD11111',1),(980,3732,154,'AD1444',1),(981,3733,154,'AD11111',1),(982,3734,154,'AD1444',1),(983,3742,154,'AD11111',1),(984,3743,154,'AD1444',1),(985,3747,154,'AD11111',1),(986,3749,154,'AD1444',1),(987,3752,154,'AD11111',1),(988,3753,154,'AD1444',1),(989,3754,154,'AD11111',1),(990,3755,154,'AD1444',1),(991,3759,154,'AD11111',1),(992,3762,154,'AD1444',1),(993,3764,154,'AD11111',1),(994,3766,154,'AD1444',1),(995,3507,157,'MA10763',1),(996,3508,157,'MA11028',1),(997,3509,157,'MA11122',1),(998,3510,157,'MA1327',1),(999,3511,157,'MA10763',1),(1000,3512,157,'MA11028',1),(1001,3513,157,'MA11122',1),(1002,3514,157,'MA1327',1),(1003,3515,157,'MA10763',1),(1004,3516,157,'MA11028',1),(1005,3517,157,'MA11122',1),(1006,3518,157,'MA1327',1),(1007,3519,157,'MA10763',1),(1008,3520,157,'MA11028',1),(1009,3521,157,'MA11122',1),(1010,3522,157,'MA1327',1),(1011,3523,157,'MA10763',1),(1012,3524,157,'MA11028',1),(1013,3525,157,'MA11122',1),(1014,3526,157,'MA1327',1),(1015,3527,157,'MA10763',1),(1016,3528,157,'MA11028',1),(1017,3529,157,'MA11122',1),(1018,3530,157,'MA1327',1),(1019,3531,157,'MA10763',1),(1020,3532,157,'MA11028',1),(1021,3533,157,'MA11122',1),(1022,3534,157,'MA1327',1),(1023,3535,157,'MA10763',1),(1024,3536,157,'MA11028',1),(1025,3537,157,'MA11122',1),(1026,3538,157,'MA1327',1),(1027,3539,157,'MA10763',1),(1028,3540,157,'MA11028',1),(1029,3541,157,'MA11122',1),(1030,3542,157,'MA1327',1),(1031,3543,157,'MA10763',1),(1032,3544,157,'MA11028',1),(1033,3545,157,'MA11122',1),(1034,3546,157,'MA1327',1),(1035,3547,157,'MA10763',1),(1036,3548,157,'MA11028',1),(1037,3549,157,'MA11122',1),(1038,3550,157,'MA1327',1),(1039,3551,157,'MA10763',1),(1040,3552,157,'MA11028',1),(1041,3553,157,'MA11122',1),(1042,3554,157,'MA1327',1),(1043,3555,157,'MA10763',1),(1044,3556,157,'MA11028',1),(1045,3557,157,'MA11122',1),(1046,3558,157,'MA1327',1),(1047,3559,157,'MA10763',1),(1048,3560,157,'MA11028',1),(1049,3561,157,'MA11122',1),(1050,3562,157,'MA1327',1),(1051,3563,157,'MA10763',1),(1052,3564,157,'MA11028',1),(1053,3565,157,'MA11122',1),(1054,3566,157,'MA1327',1),(1055,3567,157,'MA10763',1),(1056,3568,157,'MA11028',1),(1057,3569,157,'MA11122',1),(1058,3570,157,'MA1327',1),(1059,3571,157,'MA10763',1),(1060,3572,157,'MA11028',1),(1061,3573,157,'MA11122',1),(1062,3574,157,'MA1327',1),(1063,3575,157,'MA10763',1),(1064,3576,157,'MA11028',1),(1065,3577,157,'MA11122',1),(1066,3578,157,'MA1327',1),(1067,3579,157,'MA10763',1),(1068,3580,157,'MA11028',1),(1069,3581,157,'MA11122',1),(1070,3582,157,'MA1327',1),(1071,3583,157,'MA10763',1),(1072,3584,157,'MA11028',1),(1073,3585,157,'MA11122',1),(1074,3586,157,'MA1327',1),(1075,3587,157,'MA10763',1),(1076,3588,157,'MA11028',1),(1077,3589,157,'MA11122',1),(1078,3590,157,'MA1327',1),(1079,3591,157,'MA10763',1),(1080,3592,157,'MA11028',1),(1081,3593,157,'MA11122',1),(1082,3594,157,'MA1327',1),(1083,3595,157,'MA10763',1),(1084,3596,157,'MA11028',1),(1085,3597,157,'MA11122',1),(1086,3598,157,'MA1327',1),(1087,3599,157,'MA10763',1),(1088,3600,157,'MA11028',1),(1089,3601,157,'MA11122',1),(1090,3602,157,'MA1327',1),(1091,3603,157,'MA10763',1),(1092,3604,157,'MA11028',1),(1093,3605,157,'MA11122',1),(1094,3606,157,'MA1327',1),(1095,3607,157,'MA10763',1),(1096,3608,157,'MA11028',1),(1097,3609,157,'MA11122',1),(1098,3610,157,'MA1327',1),(1099,3611,157,'MA10763',1),(1100,3612,157,'MA11028',1),(1101,3613,157,'MA11122',1),(1102,3614,157,'MA1327',1),(1103,3615,157,'MA10763',1),(1104,3616,157,'MA11028',1),(1105,3617,157,'MA11122',1),(1106,3618,157,'MA1327',1),(1107,3619,157,'MA10763',1),(1108,3620,157,'MA11028',1),(1109,3621,157,'MA11122',1),(1110,3622,157,'MA1327',1),(1111,3623,157,'MA10763',1),(1112,3624,157,'MA11028',1),(1113,3625,157,'MA11122',1),(1114,3626,157,'MA1327',1),(1115,3627,157,'MA10763',1),(1116,3628,157,'MA11028',1),(1117,3629,157,'MA11122',1),(1118,3630,157,'MA1327',1),(1119,3631,157,'MA10763',1),(1120,3632,157,'MA11028',1),(1121,3633,157,'MA11122',1),(1122,3634,157,'MA1327',1),(1123,3635,157,'MA10763',1),(1124,3636,157,'MA11028',1),(1125,3637,157,'MA11122',1),(1126,3638,157,'MA1327',1),(1127,3639,157,'MA10763',1),(1128,3640,157,'MA11028',1),(1129,3641,157,'MA11122',1),(1130,3642,157,'MA1327',1),(1131,3643,157,'MA10763',1),(1132,3644,157,'MA11028',1),(1133,3645,157,'MA11122',1),(1134,3646,157,'MA1327',1),(1135,3647,157,'MA10763',1),(1136,3648,157,'MA11028',1),(1137,3649,157,'MA11122',1),(1138,3650,157,'MA1327',1),(1139,3651,157,'MA10763',1),(1140,3652,157,'MA11028',1),(1141,3653,157,'MA11122',1),(1142,3654,157,'MA1327',1),(1143,3655,157,'MA10763',1),(1144,3656,157,'MA11028',1),(1145,3657,157,'MA11122',1),(1146,3658,157,'MA1327',1),(1147,3659,157,'MA10763',1),(1148,3660,157,'MA11028',1),(1149,3661,157,'MA11122',1),(1150,3662,157,'MA1327',1),(1151,3663,157,'MA10763',1),(1152,3664,157,'MA11028',1),(1153,3665,157,'MA11122',1),(1154,3666,157,'MA1327',1),(1155,3667,157,'MA10763',1),(1156,3668,157,'MA11028',1),(1157,3669,157,'MA11122',1),(1158,3670,157,'MA1327',1),(1159,3671,157,'MA10763',1),(1160,3672,157,'MA11028',1),(1161,3673,157,'MA11122',1),(1162,3674,157,'MA1327',1),(1163,3675,157,'MA10763',1),(1164,3676,157,'MA11028',1),(1165,3677,157,'MA11122',1),(1166,3678,157,'MA1327',1),(1167,3679,157,'MA10763',1),(1168,3680,157,'MA11028',1),(1169,3681,157,'MA11122',1),(1170,3682,157,'MA1327',1),(1171,3683,157,'MA10763',1),(1172,3684,157,'MA11028',1),(1173,3685,157,'MA11122',1),(1174,3686,157,'MA1327',1),(1175,3687,157,'MA10763',1),(1176,3688,157,'MA11028',1),(1177,3689,157,'MA11122',1),(1178,3690,157,'MA1327',1),(1179,3691,157,'MA10763',1),(1180,3692,157,'MA11028',1),(1181,3693,157,'MA11122',1),(1182,3694,157,'MA1327',1),(1183,3695,157,'MA10763',1),(1184,3696,157,'MA11028',1),(1185,3697,157,'MA11122',1),(1186,3698,157,'MA1327',1),(1187,3699,157,'MA10763',1),(1188,3700,157,'MA11028',1),(1189,3701,157,'MA11122',1),(1190,3702,157,'MA1327',1),(1191,3703,157,'MA10763',1),(1192,3704,157,'MA11028',1),(1193,3705,157,'MA11122',1),(1194,3706,157,'MA1327',1),(1195,3707,157,'MA10763',1),(1196,3708,157,'MA11028',1),(1197,3709,157,'MA11122',1),(1198,3710,157,'MA1327',1),(1199,3711,157,'MA10763',1),(1200,3712,157,'MA11028',1),(1201,3713,157,'MA11122',1),(1202,3714,157,'MA1327',1),(1203,3715,157,'MA10763',1),(1204,3716,157,'MA11028',1),(1205,3717,157,'MA11122',1),(1206,3718,157,'MA1327',1),(1207,3719,157,'MA10763',1),(1208,3720,157,'MA11028',1),(1209,3721,157,'MA11122',1),(1210,3722,157,'MA1327',1),(1211,3723,157,'MA10763',1),(1212,3724,157,'MA11028',1),(1213,3725,157,'MA11122',1),(1214,3726,157,'MA1327',1),(1215,3727,157,'MA10763',1),(1216,3728,157,'MA11028',1),(1217,3729,157,'MA11122',1),(1218,3730,157,'MA1327',1),(1219,3731,157,'MA10763',1),(1220,3732,157,'MA11028',1),(1221,3733,157,'MA11122',1),(1222,3734,157,'MA1327',1),(1223,3735,157,'MA10763',1),(1224,3736,157,'MA11028',1),(1225,3737,157,'MA11122',1),(1226,3738,157,'MA1327',1),(1227,3739,157,'MA10763',1),(1228,3740,157,'MA11028',1),(1229,3741,157,'MA11122',1),(1230,3742,157,'MA1327',1),(1231,3743,157,'MA10763',1),(1232,3744,157,'MA11028',1),(1233,3745,157,'MA11122',1),(1234,3746,157,'MA1327',1),(1235,3747,157,'MA10763',1),(1236,3748,157,'MA11028',1),(1237,3749,157,'MA11122',1),(1238,3750,157,'MA1327',1),(1239,3751,157,'MA10763',1),(1240,3752,157,'MA11028',1),(1241,3753,157,'MA11122',1),(1242,3754,157,'MA1327',1),(1243,3755,157,'MA10763',1),(1244,3756,157,'MA11028',1),(1245,3757,157,'MA11122',1),(1246,3758,157,'MA1327',1),(1247,3759,157,'MA10763',1),(1248,3760,157,'MA11028',1),(1249,3761,157,'MA11122',1),(1250,3762,157,'MA1327',1),(1251,3763,157,'MA10763',1),(1252,3764,157,'MA11028',1),(1253,3765,157,'MA11122',1),(1254,3766,157,'MA1327',1),(1255,3767,157,'MA10763',1),(1256,3768,157,'MA11028',1),(1257,3507,158,'AD10928',1),(1258,3508,158,'AD10953',1),(1259,3509,158,'AD10955',1),(1260,3510,158,'AD11041',1),(1261,3511,158,'AD11089',1),(1262,3512,158,'AD11114',1),(1263,3513,158,'AD10928',1),(1264,3514,158,'AD10953',1),(1265,3515,158,'AD10955',1),(1266,3516,158,'AD11041',1),(1267,3517,158,'AD11089',1),(1268,3518,158,'AD11114',1),(1269,3519,158,'AD10928',1),(1270,3520,158,'AD10953',1),(1271,3521,158,'AD10955',1),(1272,3522,158,'AD11041',1),(1273,3523,158,'AD11089',1),(1274,3524,158,'AD11114',1),(1275,3525,158,'AD10928',1),(1276,3526,158,'AD10953',1),(1277,3527,158,'AD10955',1),(1278,3528,158,'AD11041',1),(1279,3529,158,'AD11089',1),(1280,3530,158,'AD11114',1),(1281,3531,158,'AD10928',1),(1282,3532,158,'AD10953',1),(1283,3533,158,'AD10955',1),(1284,3534,158,'AD11041',1),(1285,3535,158,'AD11089',1),(1286,3536,158,'AD11114',1),(1287,3537,158,'AD10928',1),(1288,3538,158,'AD10953',1),(1289,3539,158,'AD10955',1),(1290,3540,158,'AD11041',1),(1291,3541,158,'AD11089',1),(1292,3542,158,'AD11114',1),(1293,3543,158,'AD10928',1),(1294,3544,158,'AD10953',1),(1295,3545,158,'AD10955',1),(1296,3546,158,'AD11041',1),(1297,3547,158,'AD11089',1),(1298,3548,158,'AD11114',1),(1299,3549,158,'AD10928',1),(1300,3550,158,'AD10953',1),(1301,3551,158,'AD10955',1),(1302,3552,158,'AD11041',1),(1303,3553,158,'AD11089',1),(1304,3554,158,'AD11114',1),(1305,3555,158,'AD10928',1),(1306,3556,158,'AD10953',1),(1307,3557,158,'AD10955',1),(1308,3558,158,'AD11041',1),(1309,3559,158,'AD11089',1),(1310,3560,158,'AD11114',1),(1311,3561,158,'AD10928',1),(1312,3562,158,'AD10953',1),(1313,3563,158,'AD10955',1),(1314,3564,158,'AD11041',1),(1315,3565,158,'AD11089',1),(1316,3566,158,'AD11114',1),(1317,3567,158,'AD10928',1),(1318,3568,158,'AD10953',1),(1319,3569,158,'AD10955',1),(1320,3570,158,'AD11041',1),(1321,3571,158,'AD11089',1),(1322,3572,158,'AD11114',1),(1323,3573,158,'AD10928',1),(1324,3574,158,'AD10953',1),(1325,3575,158,'AD10955',1),(1326,3576,158,'AD11041',1),(1327,3577,158,'AD11089',1),(1328,3578,158,'AD11114',1),(1329,3579,158,'AD10928',1),(1330,3580,158,'AD10953',1),(1331,3581,158,'AD10955',1),(1332,3582,158,'AD11041',1),(1333,3583,158,'AD11089',1),(1334,3584,158,'AD11114',1),(1335,3585,158,'AD10928',1),(1336,3586,158,'AD10953',1),(1337,3587,158,'AD10955',1),(1338,3588,158,'AD11041',1),(1339,3589,158,'AD11089',1),(1340,3590,158,'AD11114',1),(1341,3591,158,'AD10928',1),(1342,3592,158,'AD10953',1),(1343,3593,158,'AD10955',1),(1344,3594,158,'AD11041',1),(1345,3595,158,'AD11089',1),(1346,3596,158,'AD11114',1),(1347,3597,158,'AD10928',1),(1348,3598,158,'AD10953',1),(1349,3599,158,'AD10955',1),(1350,3600,158,'AD11041',1),(1351,3601,158,'AD11089',1),(1352,3602,158,'AD11114',1),(1353,3603,158,'AD10928',1),(1354,3604,158,'AD10953',1),(1355,3605,158,'AD10955',1),(1356,3606,158,'AD11041',1),(1357,3607,158,'AD11089',1),(1358,3608,158,'AD11114',1),(1359,3609,158,'AD10928',1),(1360,3610,158,'AD10953',1),(1361,3611,158,'AD10955',1),(1362,3612,158,'AD11041',1),(1363,3613,158,'AD11089',1),(1364,3614,158,'AD11114',1),(1365,3615,158,'AD10928',1),(1366,3616,158,'AD10953',1),(1367,3617,158,'AD10955',1),(1368,3618,158,'AD11041',1),(1369,3619,158,'AD11089',1),(1370,3620,158,'AD11114',1),(1371,3621,158,'AD10928',1),(1372,3622,158,'AD10953',1),(1373,3623,158,'AD10955',1),(1374,3624,158,'AD11041',1),(1375,3625,158,'AD11089',1),(1376,3626,158,'AD11114',1),(1377,3627,158,'AD10928',1),(1378,3628,158,'AD10953',1),(1379,3629,158,'AD10955',1),(1380,3630,158,'AD11041',1),(1381,3631,158,'AD11089',1),(1382,3632,158,'AD11114',1),(1383,3633,158,'AD10928',1),(1384,3634,158,'AD10953',1),(1385,3635,158,'AD10955',1),(1386,3636,158,'AD11041',1),(1387,3637,158,'AD11089',1),(1388,3638,158,'AD11114',1),(1389,3639,158,'AD10928',1),(1390,3640,158,'AD10953',1),(1391,3641,158,'AD10955',1),(1392,3642,158,'AD11041',1),(1393,3643,158,'AD11089',1),(1394,3644,158,'AD11114',1),(1395,3645,158,'AD10928',1),(1396,3646,158,'AD10953',1),(1397,3647,158,'AD10955',1),(1398,3648,158,'AD11041',1),(1399,3649,158,'AD11089',1),(1400,3650,158,'AD11114',1),(1401,3651,158,'AD10928',1),(1402,3652,158,'AD10953',1),(1403,3653,158,'AD10955',1),(1404,3654,158,'AD11041',1),(1405,3655,158,'AD11089',1),(1406,3656,158,'AD11114',1),(1407,3657,158,'AD10928',1),(1408,3658,158,'AD10953',1),(1409,3659,158,'AD10955',1),(1410,3660,158,'AD11041',1),(1411,3661,158,'AD11089',1),(1412,3662,158,'AD11114',1),(1413,3663,158,'AD10928',1),(1414,3664,158,'AD10953',1),(1415,3665,158,'AD10955',1),(1416,3666,158,'AD11041',1),(1417,3667,158,'AD11089',1),(1418,3668,158,'AD11114',1),(1419,3669,158,'AD10928',1),(1420,3670,158,'AD10953',1),(1421,3671,158,'AD10955',1),(1422,3672,158,'AD11041',1),(1423,3673,158,'AD11089',1),(1424,3674,158,'AD11114',1),(1425,3675,158,'AD10928',1),(1426,3676,158,'AD10953',1),(1427,3677,158,'AD10955',1),(1428,3678,158,'AD11041',1),(1429,3679,158,'AD11089',1),(1430,3680,158,'AD11114',1),(1431,3681,158,'AD10928',1),(1432,3682,158,'AD10953',1),(1433,3683,158,'AD10955',1),(1434,3684,158,'AD11041',1),(1435,3685,158,'AD11089',1),(1436,3686,158,'AD11114',1),(1437,3687,158,'AD10928',1),(1438,3688,158,'AD10953',1),(1439,3689,158,'AD10955',1),(1440,3690,158,'AD11041',1),(1441,3691,158,'AD11089',1),(1442,3692,158,'AD11114',1),(1443,3693,158,'AD10928',1),(1444,3694,158,'AD10953',1),(1445,3695,158,'AD10955',1),(1446,3696,158,'AD11041',1),(1447,3697,158,'AD11089',1),(1448,3698,158,'AD11114',1),(1449,3699,158,'AD10928',1),(1450,3700,158,'AD10953',1),(1451,3701,158,'AD10955',1),(1452,3702,158,'AD11041',1),(1453,3703,158,'AD11089',1),(1454,3704,158,'AD11114',1),(1455,3705,158,'AD10928',1),(1456,3706,158,'AD10953',1),(1457,3707,158,'AD10955',1),(1458,3708,158,'AD11041',1),(1459,3709,158,'AD11089',1),(1460,3710,158,'AD11114',1),(1461,3711,158,'AD10928',1),(1462,3712,158,'AD10953',1),(1463,3713,158,'AD10955',1),(1464,3714,158,'AD11041',1),(1465,3715,158,'AD11089',1),(1466,3716,158,'AD11114',1),(1467,3717,158,'AD10928',1),(1468,3718,158,'AD10953',1),(1469,3719,158,'AD10955',1),(1470,3720,158,'AD11041',1),(1471,3721,158,'AD11089',1),(1472,3722,158,'AD11114',1),(1473,3723,158,'AD10928',1),(1474,3724,158,'AD10953',1),(1475,3725,158,'AD10955',1),(1476,3726,158,'AD11041',1),(1477,3727,158,'AD11089',1),(1478,3728,158,'AD11114',1),(1479,3729,158,'AD10928',1),(1480,3730,158,'AD10953',1),(1481,3731,158,'AD10955',1),(1482,3732,158,'AD11041',1),(1483,3733,158,'AD11089',1),(1484,3734,158,'AD11114',1),(1485,3735,158,'AD10928',1),(1486,3736,158,'AD10953',1),(1487,3737,158,'AD10955',1),(1488,3738,158,'AD11041',1),(1489,3739,158,'AD11089',1),(1490,3740,158,'AD11114',1),(1491,3741,158,'AD10928',1),(1492,3742,158,'AD10953',1),(1493,3743,158,'AD10955',1),(1494,3744,158,'AD11041',1),(1495,3745,158,'AD11089',1),(1496,3746,158,'AD11114',1),(1497,3747,158,'AD10928',1),(1498,3748,158,'AD10953',1),(1499,3749,158,'AD10955',1),(1500,3750,158,'AD11041',1),(1501,3751,158,'AD11089',1),(1502,3752,158,'AD11114',1),(1503,3753,158,'AD10928',1),(1504,3754,158,'AD10953',1),(1505,3755,158,'AD10955',1),(1506,3756,158,'AD11041',1),(1507,3757,158,'AD11089',1),(1508,3758,158,'AD11114',1),(1509,3759,158,'AD10928',1),(1510,3760,158,'AD10953',1),(1511,3761,158,'AD10955',1),(1512,3762,158,'AD11041',1),(1513,3763,158,'AD11089',1),(1514,3764,158,'AD11114',1),(1515,3765,158,'AD10928',1),(1516,3766,158,'AD10953',1),(1517,3767,158,'AD10955',1),(1518,3768,158,'AD11041',1),(1519,3507,159,'AD10628',1),(1520,3508,159,'AD10818',1),(1521,3509,159,'AD11068',1),(1522,3510,159,'AD11164',1),(1523,3511,159,'AD10628',1),(1524,3512,159,'AD10818',1),(1525,3513,159,'AD11068',1),(1526,3514,159,'AD11164',1),(1527,3515,159,'AD10628',1),(1528,3516,159,'AD10818',1),(1529,3517,159,'AD11068',1),(1530,3518,159,'AD11164',1),(1531,3519,159,'AD10628',1),(1532,3520,159,'AD10818',1),(1533,3521,159,'AD11068',1),(1534,3522,159,'AD11164',1),(1535,3523,159,'AD10628',1),(1536,3524,159,'AD10818',1),(1537,3525,159,'AD11068',1),(1538,3526,159,'AD11164',1),(1539,3527,159,'AD10628',1),(1540,3528,159,'AD10818',1),(1541,3529,159,'AD11068',1),(1542,3530,159,'AD11164',1),(1543,3531,159,'AD10628',1),(1544,3532,159,'AD10818',1),(1545,3533,159,'AD11068',1),(1546,3534,159,'AD11164',1),(1547,3535,159,'AD10628',1),(1548,3536,159,'AD10818',1),(1549,3537,159,'AD11068',1),(1550,3538,159,'AD11164',1),(1551,3539,159,'AD10628',1),(1552,3540,159,'AD10818',1),(1553,3541,159,'AD11068',1),(1554,3542,159,'AD11164',1),(1555,3543,159,'AD10628',1),(1556,3544,159,'AD10818',1),(1557,3545,159,'AD11068',1),(1558,3546,159,'AD11164',1),(1559,3547,159,'AD10628',1),(1560,3548,159,'AD10818',1),(1561,3549,159,'AD11068',1),(1562,3550,159,'AD11164',1),(1563,3551,159,'AD10628',1),(1564,3552,159,'AD10818',1),(1565,3553,159,'AD11068',1),(1566,3554,159,'AD11164',1),(1567,3555,159,'AD10628',1),(1568,3556,159,'AD10818',1),(1569,3557,159,'AD11068',1),(1570,3558,159,'AD11164',1),(1571,3559,159,'AD10628',1),(1572,3560,159,'AD10818',1),(1573,3561,159,'AD11068',1),(1574,3562,159,'AD11164',1),(1575,3563,159,'AD10628',1),(1576,3564,159,'AD10818',1),(1577,3565,159,'AD11068',1),(1578,3566,159,'AD11164',1),(1579,3567,159,'AD10628',1),(1580,3568,159,'AD10818',1),(1581,3569,159,'AD11068',1),(1582,3570,159,'AD11164',1),(1583,3571,159,'AD10628',1),(1584,3572,159,'AD10818',1),(1585,3573,159,'AD11068',1),(1586,3574,159,'AD11164',1),(1587,3575,159,'AD10628',1),(1588,3576,159,'AD10818',1),(1589,3577,159,'AD11068',1),(1590,3578,159,'AD11164',1),(1591,3579,159,'AD10628',1),(1592,3580,159,'AD10818',1),(1593,3581,159,'AD11068',1),(1594,3582,159,'AD11164',1),(1595,3583,159,'AD10628',1),(1596,3584,159,'AD10818',1),(1597,3585,159,'AD11068',1),(1598,3586,159,'AD11164',1),(1599,3587,159,'AD10628',1),(1600,3588,159,'AD10818',1),(1601,3589,159,'AD11068',1),(1602,3590,159,'AD11164',1),(1603,3591,159,'AD10628',1),(1604,3592,159,'AD10818',1),(1605,3593,159,'AD11068',1),(1606,3594,159,'AD11164',1),(1607,3595,159,'AD10628',1),(1608,3596,159,'AD10818',1),(1609,3597,159,'AD11068',1),(1610,3598,159,'AD11164',1),(1611,3599,159,'AD10628',1),(1612,3600,159,'AD10818',1),(1613,3601,159,'AD11068',1),(1614,3602,159,'AD11164',1),(1615,3603,159,'AD10628',1),(1616,3604,159,'AD10818',1),(1617,3605,159,'AD11068',1),(1618,3606,159,'AD11164',1),(1619,3607,159,'AD10628',1),(1620,3608,159,'AD10818',1),(1621,3609,159,'AD11068',1),(1622,3610,159,'AD11164',1),(1623,3611,159,'AD10628',1),(1624,3612,159,'AD10818',1),(1625,3613,159,'AD11068',1),(1626,3614,159,'AD11164',1),(1627,3615,159,'AD10628',1),(1628,3616,159,'AD10818',1),(1629,3617,159,'AD11068',1),(1630,3618,159,'AD11164',1),(1631,3619,159,'AD10628',1),(1632,3620,159,'AD10818',1),(1633,3621,159,'AD11068',1),(1634,3622,159,'AD11164',1),(1635,3623,159,'AD10628',1),(1636,3624,159,'AD10818',1),(1637,3625,159,'AD11068',1),(1638,3626,159,'AD11164',1),(1639,3627,159,'AD10628',1),(1640,3628,159,'AD10818',1),(1641,3629,159,'AD11068',1),(1642,3630,159,'AD11164',1),(1643,3631,159,'AD10628',1),(1644,3632,159,'AD10818',1),(1645,3633,159,'AD11068',1),(1646,3634,159,'AD11164',1),(1647,3635,159,'AD10628',1),(1648,3636,159,'AD10818',1),(1649,3637,159,'AD11068',1),(1650,3638,159,'AD11164',1),(1651,3639,159,'AD10628',1),(1652,3640,159,'AD10818',1),(1653,3641,159,'AD11068',1),(1654,3642,159,'AD11164',1),(1655,3643,159,'AD10628',1),(1656,3644,159,'AD10818',1),(1657,3645,159,'AD11068',1),(1658,3646,159,'AD11164',1),(1659,3647,159,'AD10628',1),(1660,3648,159,'AD10818',1),(1661,3649,159,'AD11068',1),(1662,3650,159,'AD11164',1),(1663,3651,159,'AD10628',1),(1664,3652,159,'AD10818',1),(1665,3653,159,'AD11068',1),(1666,3654,159,'AD11164',1),(1667,3655,159,'AD10628',1),(1668,3656,159,'AD10818',1),(1669,3657,159,'AD11068',1),(1670,3658,159,'AD11164',1),(1671,3659,159,'AD10628',1),(1672,3660,159,'AD10818',1),(1673,3661,159,'AD11068',1),(1674,3662,159,'AD11164',1),(1675,3663,159,'AD10628',1),(1676,3664,159,'AD10818',1),(1677,3665,159,'AD11068',1),(1678,3666,159,'AD11164',1),(1679,3667,159,'AD10628',1),(1680,3668,159,'AD10818',1),(1681,3669,159,'AD11068',1),(1682,3670,159,'AD11164',1),(1683,3671,159,'AD10628',1),(1684,3672,159,'AD10818',1),(1685,3673,159,'AD11068',1),(1686,3674,159,'AD11164',1),(1687,3675,159,'AD10628',1),(1688,3676,159,'AD10818',1),(1689,3677,159,'AD11068',1),(1690,3678,159,'AD11164',1),(1691,3679,159,'AD10628',1),(1692,3680,159,'AD10818',1),(1693,3681,159,'AD11068',1),(1694,3682,159,'AD11164',1),(1695,3683,159,'AD10628',1),(1696,3684,159,'AD10818',1),(1697,3685,159,'AD11068',1),(1698,3686,159,'AD11164',1),(1699,3687,159,'AD10628',1),(1700,3688,159,'AD10818',1),(1701,3689,159,'AD11068',1),(1702,3690,159,'AD11164',1),(1703,3691,159,'AD10628',1),(1704,3692,159,'AD10818',1),(1705,3693,159,'AD11068',1),(1706,3694,159,'AD11164',1),(1707,3695,159,'AD10628',1),(1708,3696,159,'AD10818',1),(1709,3697,159,'AD11068',1),(1710,3698,159,'AD11164',1),(1711,3699,159,'AD10628',1),(1712,3700,159,'AD10818',1),(1713,3701,159,'AD11068',1),(1714,3702,159,'AD11164',1),(1715,3703,159,'AD10628',1),(1716,3704,159,'AD10818',1),(1717,3705,159,'AD11068',1),(1718,3706,159,'AD11164',1),(1719,3707,159,'AD10628',1),(1720,3708,159,'AD10818',1),(1721,3709,159,'AD11068',1),(1722,3710,159,'AD11164',1),(1723,3711,159,'AD10628',1),(1724,3712,159,'AD10818',1),(1725,3713,159,'AD11068',1),(1726,3714,159,'AD11164',1),(1727,3715,159,'AD10628',1),(1728,3716,159,'AD10818',1),(1729,3717,159,'AD11068',1),(1730,3718,159,'AD11164',1),(1731,3719,159,'AD10628',1),(1732,3720,159,'AD10818',1),(1733,3721,159,'AD11068',1),(1734,3722,159,'AD11164',1),(1735,3723,159,'AD10628',1),(1736,3724,159,'AD10818',1),(1737,3725,159,'AD11068',1),(1738,3726,159,'AD11164',1),(1739,3727,159,'AD10628',1),(1740,3728,159,'AD10818',1),(1741,3729,159,'AD11068',1),(1742,3730,159,'AD11164',1),(1743,3731,159,'AD10628',1),(1744,3732,159,'AD10818',1),(1745,3733,159,'AD11068',1),(1746,3734,159,'AD11164',1),(1747,3735,159,'AD10628',1),(1748,3736,159,'AD10818',1),(1749,3737,159,'AD11068',1),(1750,3738,159,'AD11164',1),(1751,3739,159,'AD10628',1),(1752,3740,159,'AD10818',1),(1753,3741,159,'AD11068',1),(1754,3742,159,'AD11164',1),(1755,3743,159,'AD10628',1),(1756,3744,159,'AD10818',1),(1757,3745,159,'AD11068',1),(1758,3746,159,'AD11164',1),(1759,3747,159,'AD10628',1),(1760,3748,159,'AD10818',1),(1761,3749,159,'AD11068',1),(1762,3750,159,'AD11164',1),(1763,3751,159,'AD10628',1),(1764,3752,159,'AD10818',1),(1765,3753,159,'AD11068',1),(1766,3754,159,'AD11164',1),(1767,3755,159,'AD10628',1),(1768,3756,159,'AD10818',1),(1769,3757,159,'AD11068',1),(1770,3758,159,'AD11164',1),(1771,3759,159,'AD10628',1),(1772,3760,159,'AD10818',1),(1773,3761,159,'AD11068',1),(1774,3762,159,'AD11164',1),(1775,3763,159,'AD10628',1),(1776,3764,159,'AD10818',1),(1777,3765,159,'AD11068',1),(1778,3766,159,'AD11164',1),(1779,3767,159,'AD10628',1),(1780,3768,159,'AD10818',1),(1781,3507,160,'AD11019',1),(1782,3508,160,'AD11023',1),(1783,3509,160,'AD11026',1),(1784,3510,160,'AD11104',1),(1785,3511,160,'AD11019',1),(1786,3512,160,'AD11023',1),(1787,3513,160,'AD11026',1),(1788,3514,160,'AD11104',1),(1789,3515,160,'AD11019',1),(1790,3516,160,'AD11023',1),(1791,3517,160,'AD11026',1),(1792,3518,160,'AD11104',1),(1793,3519,160,'AD11019',1),(1794,3520,160,'AD11023',1),(1795,3521,160,'AD11026',1),(1796,3522,160,'AD11104',1),(1797,3523,160,'AD11019',1),(1798,3524,160,'AD11023',1),(1799,3525,160,'AD11026',1),(1800,3526,160,'AD11104',1),(1801,3527,160,'AD11019',1),(1802,3528,160,'AD11023',1),(1803,3529,160,'AD11026',1),(1804,3530,160,'AD11104',1),(1805,3531,160,'AD11019',1),(1806,3532,160,'AD11023',1),(1807,3533,160,'AD11026',1),(1808,3534,160,'AD11104',1),(1809,3535,160,'AD11019',1),(1810,3536,160,'AD11023',1),(1811,3537,160,'AD11026',1),(1812,3538,160,'AD11104',1),(1813,3539,160,'AD11019',1),(1814,3540,160,'AD11023',1),(1815,3541,160,'AD11026',1),(1816,3542,160,'AD11104',1),(1817,3543,160,'AD11019',1),(1818,3544,160,'AD11023',1),(1819,3545,160,'AD11026',1),(1820,3546,160,'AD11104',1),(1821,3547,160,'AD11019',1),(1822,3548,160,'AD11023',1),(1823,3549,160,'AD11026',1),(1824,3550,160,'AD11104',1),(1825,3551,160,'AD11019',1),(1826,3552,160,'AD11023',1),(1827,3553,160,'AD11026',1),(1828,3554,160,'AD11104',1),(1829,3555,160,'AD11019',1),(1830,3556,160,'AD11023',1),(1831,3557,160,'AD11026',1),(1832,3558,160,'AD11104',1),(1833,3559,160,'AD11019',1),(1834,3560,160,'AD11023',1),(1835,3561,160,'AD11026',1),(1836,3562,160,'AD11104',1),(1837,3563,160,'AD11019',1),(1838,3564,160,'AD11023',1),(1839,3565,160,'AD11026',1),(1840,3566,160,'AD11104',1),(1841,3567,160,'AD11019',1),(1842,3568,160,'AD11023',1),(1843,3569,160,'AD11026',1),(1844,3570,160,'AD11104',1),(1845,3571,160,'AD11019',1),(1846,3572,160,'AD11023',1),(1847,3573,160,'AD11026',1),(1848,3574,160,'AD11104',1),(1849,3575,160,'AD11019',1),(1850,3576,160,'AD11023',1),(1851,3577,160,'AD11026',1),(1852,3578,160,'AD11104',1),(1853,3579,160,'AD11019',1),(1854,3580,160,'AD11023',1),(1855,3581,160,'AD11026',1),(1856,3582,160,'AD11104',1),(1857,3583,160,'AD11019',1),(1858,3584,160,'AD11023',1),(1859,3585,160,'AD11026',1),(1860,3586,160,'AD11104',1),(1861,3587,160,'AD11019',1),(1862,3588,160,'AD11023',1),(1863,3589,160,'AD11026',1),(1864,3590,160,'AD11104',1),(1865,3591,160,'AD11019',1),(1866,3592,160,'AD11023',1),(1867,3593,160,'AD11026',1),(1868,3594,160,'AD11104',1),(1869,3595,160,'AD11019',1),(1870,3596,160,'AD11023',1),(1871,3597,160,'AD11026',1),(1872,3598,160,'AD11104',1),(1873,3599,160,'AD11019',1),(1874,3600,160,'AD11023',1),(1875,3601,160,'AD11026',1),(1876,3602,160,'AD11104',1),(1877,3603,160,'AD11019',1),(1878,3604,160,'AD11023',1),(1879,3605,160,'AD11026',1),(1880,3606,160,'AD11104',1),(1881,3607,160,'AD11019',1),(1882,3608,160,'AD11023',1),(1883,3609,160,'AD11026',1),(1884,3610,160,'AD11104',1),(1885,3611,160,'AD11019',1),(1886,3612,160,'AD11023',1),(1887,3613,160,'AD11026',1),(1888,3614,160,'AD11104',1),(1889,3615,160,'AD11019',1),(1890,3616,160,'AD11023',1),(1891,3617,160,'AD11026',1),(1892,3618,160,'AD11104',1),(1893,3619,160,'AD11019',1),(1894,3620,160,'AD11023',1),(1895,3621,160,'AD11026',1),(1896,3622,160,'AD11104',1),(1897,3623,160,'AD11019',1),(1898,3624,160,'AD11023',1),(1899,3625,160,'AD11026',1),(1900,3626,160,'AD11104',1),(1901,3627,160,'AD11019',1),(1902,3628,160,'AD11023',1),(1903,3629,160,'AD11026',1),(1904,3630,160,'AD11104',1),(1905,3631,160,'AD11019',1),(1906,3632,160,'AD11023',1),(1907,3633,160,'AD11026',1),(1908,3634,160,'AD11104',1),(1909,3635,160,'AD11019',1),(1910,3636,160,'AD11023',1),(1911,3637,160,'AD11026',1),(1912,3638,160,'AD11104',1),(1913,3639,160,'AD11019',1),(1914,3640,160,'AD11023',1),(1915,3641,160,'AD11026',1),(1916,3642,160,'AD11104',1),(1917,3643,160,'AD11019',1),(1918,3644,160,'AD11023',1),(1919,3645,160,'AD11026',1),(1920,3646,160,'AD11104',1),(1921,3647,160,'AD11019',1),(1922,3648,160,'AD11023',1),(1923,3649,160,'AD11026',1),(1924,3650,160,'AD11104',1),(1925,3651,160,'AD11019',1),(1926,3652,160,'AD11023',1),(1927,3653,160,'AD11026',1),(1928,3654,160,'AD11104',1),(1929,3655,160,'AD11019',1),(1930,3656,160,'AD11023',1),(1931,3657,160,'AD11026',1),(1932,3658,160,'AD11104',1),(1933,3659,160,'AD11019',1),(1934,3660,160,'AD11023',1),(1935,3661,160,'AD11026',1),(1936,3662,160,'AD11104',1),(1937,3663,160,'AD11019',1),(1938,3664,160,'AD11023',1),(1939,3665,160,'AD11026',1),(1940,3666,160,'AD11104',1),(1941,3667,160,'AD11019',1),(1942,3668,160,'AD11023',1),(1943,3669,160,'AD11026',1),(1944,3670,160,'AD11104',1),(1945,3671,160,'AD11019',1),(1946,3672,160,'AD11023',1),(1947,3673,160,'AD11026',1),(1948,3674,160,'AD11104',1),(1949,3675,160,'AD11019',1),(1950,3676,160,'AD11023',1),(1951,3677,160,'AD11026',1),(1952,3678,160,'AD11104',1),(1953,3679,160,'AD11019',1),(1954,3680,160,'AD11023',1),(1955,3681,160,'AD11026',1),(1956,3682,160,'AD11104',1),(1957,3683,160,'AD11019',1),(1958,3684,160,'AD11023',1),(1959,3685,160,'AD11026',1),(1960,3686,160,'AD11104',1),(1961,3687,160,'AD11019',1),(1962,3688,160,'AD11023',1),(1963,3689,160,'AD11026',1),(1964,3690,160,'AD11104',1),(1965,3691,160,'AD11019',1),(1966,3692,160,'AD11023',1),(1967,3693,160,'AD11026',1),(1968,3694,160,'AD11104',1),(1969,3695,160,'AD11019',1),(1970,3696,160,'AD11023',1),(1971,3697,160,'AD11026',1),(1972,3698,160,'AD11104',1),(1973,3699,160,'AD11019',1),(1974,3700,160,'AD11023',1),(1975,3701,160,'AD11026',1),(1976,3702,160,'AD11104',1),(1977,3703,160,'AD11019',1),(1978,3704,160,'AD11023',1),(1979,3705,160,'AD11026',1),(1980,3706,160,'AD11104',1),(1981,3707,160,'AD11019',1),(1982,3708,160,'AD11023',1),(1983,3709,160,'AD11026',1),(1984,3710,160,'AD11104',1),(1985,3711,160,'AD11019',1),(1986,3712,160,'AD11023',1),(1987,3713,160,'AD11026',1),(1988,3714,160,'AD11104',1),(1989,3715,160,'AD11019',1),(1990,3716,160,'AD11023',1),(1991,3717,160,'AD11026',1),(1992,3718,160,'AD11104',1),(1993,3719,160,'AD11019',1),(1994,3720,160,'AD11023',1),(1995,3721,160,'AD11026',1),(1996,3722,160,'AD11104',1),(1997,3723,160,'AD11019',1),(1998,3724,160,'AD11023',1),(1999,3725,160,'AD11026',1),(2000,3726,160,'AD11104',1),(2001,3727,160,'AD11019',1),(2002,3728,160,'AD11023',1),(2003,3729,160,'AD11026',1),(2004,3730,160,'AD11104',1),(2005,3731,160,'AD11019',1),(2006,3732,160,'AD11023',1),(2007,3733,160,'AD11026',1),(2008,3734,160,'AD11104',1),(2009,3735,160,'AD11019',1),(2010,3736,160,'AD11023',1),(2011,3737,160,'AD11026',1),(2012,3738,160,'AD11104',1),(2013,3739,160,'AD11019',1),(2014,3740,160,'AD11023',1),(2015,3741,160,'AD11026',1),(2016,3742,160,'AD11104',1),(2017,3743,160,'AD11019',1),(2018,3744,160,'AD11023',1),(2019,3745,160,'AD11026',1),(2020,3746,160,'AD11104',1),(2021,3747,160,'AD11019',1),(2022,3748,160,'AD11023',1),(2023,3749,160,'AD11026',1),(2024,3750,160,'AD11104',1),(2025,3751,160,'AD11019',1),(2026,3752,160,'AD11023',1),(2027,3753,160,'AD11026',1),(2028,3754,160,'AD11104',1),(2029,3755,160,'AD11019',1),(2030,3756,160,'AD11023',1),(2031,3757,160,'AD11026',1),(2032,3758,160,'AD11104',1),(2033,3759,160,'AD11019',1),(2034,3760,160,'AD11023',1),(2035,3761,160,'AD11026',1),(2036,3762,160,'AD11104',1),(2037,3763,160,'AD11019',1),(2038,3764,160,'AD11023',1),(2039,3765,160,'AD11026',1),(2040,3766,160,'AD11104',1),(2041,3767,160,'AD11019',1),(2042,3768,160,'AD11023',1),(2043,3507,161,'AD10838',1),(2044,3508,161,'AD10931',1),(2045,3509,161,'AD11016',1),(2046,3510,161,'AD11096',1),(2047,3511,161,'AD10838',1),(2048,3512,161,'AD10931',1),(2049,3513,161,'AD11016',1),(2050,3514,161,'AD11096',1),(2051,3515,161,'AD10838',1),(2052,3516,161,'AD10931',1),(2053,3517,161,'AD11016',1),(2054,3518,161,'AD11096',1),(2055,3519,161,'AD10838',1),(2056,3520,161,'AD10931',1),(2057,3521,161,'AD11016',1),(2058,3522,161,'AD11096',1),(2059,3523,161,'AD10838',1),(2060,3524,161,'AD10931',1),(2061,3525,161,'AD11016',1),(2062,3526,161,'AD11096',1),(2063,3527,161,'AD10838',1),(2064,3528,161,'AD10931',1),(2065,3529,161,'AD11016',1),(2066,3530,161,'AD11096',1),(2067,3531,161,'AD10838',1),(2068,3532,161,'AD10931',1),(2069,3533,161,'AD11016',1),(2070,3534,161,'AD11096',1),(2071,3535,161,'AD10838',1),(2072,3536,161,'AD10931',1),(2073,3537,161,'AD11016',1),(2074,3538,161,'AD11096',1),(2075,3539,161,'AD10838',1),(2076,3540,161,'AD10931',1),(2077,3541,161,'AD11016',1),(2078,3542,161,'AD11096',1),(2079,3543,161,'AD10838',1),(2080,3544,161,'AD10931',1),(2081,3545,161,'AD11016',1),(2082,3546,161,'AD11096',1),(2083,3547,161,'AD10838',1),(2084,3548,161,'AD10931',1),(2085,3549,161,'AD11016',1),(2086,3550,161,'AD11096',1),(2087,3551,161,'AD10838',1),(2088,3552,161,'AD10931',1),(2089,3553,161,'AD11016',1),(2090,3554,161,'AD11096',1),(2091,3555,161,'AD10838',1),(2092,3556,161,'AD10931',1),(2093,3557,161,'AD11016',1),(2094,3558,161,'AD11096',1),(2095,3559,161,'AD10838',1),(2096,3560,161,'AD10931',1),(2097,3561,161,'AD11016',1),(2098,3562,161,'AD11096',1),(2099,3563,161,'AD10838',1),(2100,3564,161,'AD10931',1),(2101,3565,161,'AD11016',1),(2102,3566,161,'AD11096',1),(2103,3567,161,'AD10838',1),(2104,3568,161,'AD10931',1),(2105,3569,161,'AD11016',1),(2106,3570,161,'AD11096',1),(2107,3571,161,'AD10838',1),(2108,3572,161,'AD10931',1),(2109,3573,161,'AD11016',1),(2110,3574,161,'AD11096',1),(2111,3575,161,'AD10838',1),(2112,3576,161,'AD10931',1),(2113,3577,161,'AD11016',1),(2114,3578,161,'AD11096',1),(2115,3579,161,'AD10838',1),(2116,3580,161,'AD10931',1),(2117,3581,161,'AD11016',1),(2118,3582,161,'AD11096',1),(2119,3583,161,'AD10838',1),(2120,3584,161,'AD10931',1),(2121,3585,161,'AD11016',1),(2122,3586,161,'AD11096',1),(2123,3587,161,'AD10838',1),(2124,3588,161,'AD10931',1),(2125,3589,161,'AD11016',1),(2126,3590,161,'AD11096',1),(2127,3591,161,'AD10838',1),(2128,3592,161,'AD10931',1),(2129,3593,161,'AD11016',1),(2130,3594,161,'AD11096',1),(2131,3595,161,'AD10838',1),(2132,3596,161,'AD10931',1),(2133,3597,161,'AD11016',1),(2134,3598,161,'AD11096',1),(2135,3599,161,'AD10838',1),(2136,3600,161,'AD10931',1),(2137,3601,161,'AD11016',1),(2138,3602,161,'AD11096',1),(2139,3603,161,'AD10838',1),(2140,3604,161,'AD10931',1),(2141,3605,161,'AD11016',1),(2142,3606,161,'AD11096',1),(2143,3607,161,'AD10838',1),(2144,3608,161,'AD10931',1),(2145,3609,161,'AD11016',1),(2146,3610,161,'AD11096',1),(2147,3611,161,'AD10838',1),(2148,3612,161,'AD10931',1),(2149,3613,161,'AD11016',1),(2150,3614,161,'AD11096',1),(2151,3615,161,'AD10838',1),(2152,3616,161,'AD10931',1),(2153,3617,161,'AD11016',1),(2154,3618,161,'AD11096',1),(2155,3619,161,'AD10838',1),(2156,3620,161,'AD10931',1),(2157,3621,161,'AD11016',1),(2158,3622,161,'AD11096',1),(2159,3623,161,'AD10838',1),(2160,3624,161,'AD10931',1),(2161,3625,161,'AD11016',1),(2162,3626,161,'AD11096',1),(2163,3627,161,'AD10838',1),(2164,3628,161,'AD10931',1),(2165,3629,161,'AD11016',1),(2166,3630,161,'AD11096',1),(2167,3631,161,'AD10838',1),(2168,3632,161,'AD10931',1),(2169,3633,161,'AD11016',1),(2170,3634,161,'AD11096',1),(2171,3635,161,'AD10838',1),(2172,3636,161,'AD10931',1),(2173,3637,161,'AD11016',1),(2174,3638,161,'AD11096',1),(2175,3639,161,'AD10838',1),(2176,3640,161,'AD10931',1),(2177,3641,161,'AD11016',1),(2178,3642,161,'AD11096',1),(2179,3643,161,'AD10838',1),(2180,3644,161,'AD10931',1),(2181,3645,161,'AD11016',1),(2182,3646,161,'AD11096',1),(2183,3647,161,'AD10838',1),(2184,3648,161,'AD10931',1),(2185,3649,161,'AD11016',1),(2186,3650,161,'AD11096',1),(2187,3651,161,'AD10838',1),(2188,3652,161,'AD10931',1),(2189,3653,161,'AD11016',1),(2190,3654,161,'AD11096',1),(2191,3655,161,'AD10838',1),(2192,3656,161,'AD10931',1),(2193,3657,161,'AD11016',1),(2194,3658,161,'AD11096',1),(2195,3659,161,'AD10838',1),(2196,3660,161,'AD10931',1),(2197,3661,161,'AD11016',1),(2198,3662,161,'AD11096',1),(2199,3663,161,'AD10838',1),(2200,3664,161,'AD10931',1),(2201,3665,161,'AD11016',1),(2202,3666,161,'AD11096',1),(2203,3667,161,'AD10838',1),(2204,3668,161,'AD10931',1),(2205,3669,161,'AD11016',1),(2206,3670,161,'AD11096',1),(2207,3671,161,'AD10838',1),(2208,3672,161,'AD10931',1),(2209,3673,161,'AD11016',1),(2210,3674,161,'AD11096',1),(2211,3675,161,'AD10838',1),(2212,3676,161,'AD10931',1),(2213,3677,161,'AD11016',1),(2214,3678,161,'AD11096',1),(2215,3679,161,'AD10838',1),(2216,3680,161,'AD10931',1),(2217,3681,161,'AD11016',1),(2218,3682,161,'AD11096',1),(2219,3683,161,'AD10838',1),(2220,3684,161,'AD10931',1),(2221,3685,161,'AD11016',1),(2222,3686,161,'AD11096',1),(2223,3687,161,'AD10838',1),(2224,3688,161,'AD10931',1),(2225,3689,161,'AD11016',1),(2226,3690,161,'AD11096',1),(2227,3691,161,'AD10838',1),(2228,3692,161,'AD10931',1),(2229,3693,161,'AD11016',1),(2230,3694,161,'AD11096',1),(2231,3695,161,'AD10838',1),(2232,3696,161,'AD10931',1),(2233,3697,161,'AD11016',1),(2234,3698,161,'AD11096',1),(2235,3699,161,'AD10838',1),(2236,3700,161,'AD10931',1),(2237,3701,161,'AD11016',1),(2238,3702,161,'AD11096',1),(2239,3703,161,'AD10838',1),(2240,3704,161,'AD10931',1),(2241,3705,161,'AD11016',1),(2242,3706,161,'AD11096',1),(2243,3707,161,'AD10838',1),(2244,3708,161,'AD10931',1),(2245,3709,161,'AD11016',1),(2246,3710,161,'AD11096',1),(2247,3711,161,'AD10838',1),(2248,3712,161,'AD10931',1),(2249,3713,161,'AD11016',1),(2250,3714,161,'AD11096',1),(2251,3715,161,'AD10838',1),(2252,3716,161,'AD10931',1),(2253,3717,161,'AD11016',1),(2254,3718,161,'AD11096',1),(2255,3719,161,'AD10838',1),(2256,3720,161,'AD10931',1),(2257,3721,161,'AD11016',1),(2258,3722,161,'AD11096',1),(2259,3723,161,'AD10838',1),(2260,3724,161,'AD10931',1),(2261,3725,161,'AD11016',1),(2262,3726,161,'AD11096',1),(2263,3727,161,'AD10838',1),(2264,3728,161,'AD10931',1),(2265,3729,161,'AD11016',1),(2266,3730,161,'AD11096',1),(2267,3731,161,'AD10838',1),(2268,3732,161,'AD10931',1),(2269,3733,161,'AD11016',1),(2270,3734,161,'AD11096',1),(2271,3735,161,'AD10838',1),(2272,3736,161,'AD10931',1),(2273,3737,161,'AD11016',1),(2274,3738,161,'AD11096',1),(2275,3739,161,'AD10838',1),(2276,3740,161,'AD10931',1),(2277,3741,161,'AD11016',1),(2278,3742,161,'AD11096',1),(2279,3743,161,'AD10838',1),(2280,3744,161,'AD10931',1),(2281,3745,161,'AD11016',1),(2282,3746,161,'AD11096',1),(2283,3747,161,'AD10838',1),(2284,3748,161,'AD10931',1),(2285,3749,161,'AD11016',1),(2286,3750,161,'AD11096',1),(2287,3751,161,'AD10838',1),(2288,3752,161,'AD10931',1),(2289,3753,161,'AD11016',1),(2290,3754,161,'AD11096',1),(2291,3755,161,'AD10838',1),(2292,3756,161,'AD10931',1),(2293,3757,161,'AD11016',1),(2294,3758,161,'AD11096',1),(2295,3759,161,'AD10838',1),(2296,3760,161,'AD10931',1),(2297,3761,161,'AD11016',1),(2298,3762,161,'AD11096',1),(2299,3763,161,'AD10838',1),(2300,3764,161,'AD10931',1),(2301,3765,161,'AD11016',1),(2302,3766,161,'AD11096',1),(2303,3767,161,'AD10838',1),(2304,3768,161,'AD10931',1);
/*!40000 ALTER TABLE `course_student_teacher_allocation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_teamwork`
--

DROP TABLE IF EXISTS `course_teamwork`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_teamwork` (
  `id` int NOT NULL,
  `course_id` int NOT NULL,
  `total_hours` int NOT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_course_id` (`course_id`),
  CONSTRAINT `fk_course_teamwork_courses` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_teamwork`
--

LOCK TABLES `course_teamwork` WRITE;
/*!40000 ALTER TABLE `course_teamwork` DISABLE KEYS */;
INSERT INTO `course_teamwork` VALUES (88,88,0,1),(89,89,4,1),(90,90,0,1);
/*!40000 ALTER TABLE `course_teamwork` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_teamwork_activities`
--

DROP TABLE IF EXISTS `course_teamwork_activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_teamwork_activities` (
  `id` int NOT NULL AUTO_INCREMENT,
  `teamwork_id` int NOT NULL,
  `activity` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `position` int NOT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_teamwork_id` (`teamwork_id`),
  CONSTRAINT `fk_course_teamwork_activities_teamwork` FOREIGN KEY (`teamwork_id`) REFERENCES `course_teamwork` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_teamwork_activities`
--

LOCK TABLES `course_teamwork_activities` WRITE;
/*!40000 ALTER TABLE `course_teamwork_activities` DISABLE KEYS */;
INSERT INTO `course_teamwork_activities` VALUES (28,89,'hello',0,1);
/*!40000 ALTER TABLE `course_teamwork_activities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_type`
--

DROP TABLE IF EXISTS `course_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_type` varchar(50) NOT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_type`
--

LOCK TABLES `course_type` WRITE;
/*!40000 ALTER TABLE `course_type` DISABLE KEYS */;
INSERT INTO `course_type` VALUES (1,'Theory',1),(2,'Lab',1),(3,'Theroy with Lab',1);
/*!40000 ALTER TABLE `course_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `courses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `course_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `course_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `credit` int DEFAULT NULL,
  `lecture_hrs` int DEFAULT '0',
  `tutorial_hrs` int DEFAULT '0',
  `practical_hrs` int DEFAULT '0',
  `activity_hrs` int DEFAULT '0',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `cia_marks` int DEFAULT '40',
  `see_marks` int DEFAULT '60',
  `total_marks` int GENERATED ALWAYS AS ((`cia_marks` + `see_marks`)) STORED,
  `theory_total_hrs` int DEFAULT '0',
  `tutorial_total_hrs` int DEFAULT '0',
  `practical_total_hrs` int DEFAULT NULL,
  `activity_total_hrs` int DEFAULT '0',
  `tw/sl` int DEFAULT NULL,
  `visibility` enum('UNIQUE','CLUSTER') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'UNIQUE',
  `source_curriculum_id` int DEFAULT NULL,
  `curriculum_ref_id` int DEFAULT NULL,
  `total_hrs` int GENERATED ALWAYS AS ((((`theory_total_hrs` + `activity_total_hrs`) + `tutorial_total_hrs`) + coalesce(`practical_total_hrs`,0))) STORED,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=168 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` (`id`, `course_code`, `course_name`, `course_type`, `credit`, `lecture_hrs`, `tutorial_hrs`, `practical_hrs`, `activity_hrs`, `category`, `cia_marks`, `see_marks`, `theory_total_hrs`, `tutorial_total_hrs`, `practical_total_hrs`, `activity_total_hrs`, `tw/sl`, `visibility`, `source_curriculum_id`, `curriculum_ref_id`, `status`) VALUES (13,'CS345','check','Lab',4,0,0,3,0,'HSS - Humanities and Social Sciences',40,60,0,0,45,0,0,'UNIQUE',NULL,NULL,0),(14,'CS123','delete','Lab',2,0,0,3,0,'ES - Engineering Sciences',40,60,0,0,45,0,0,'UNIQUE',NULL,NULL,0),(15,'Cs232','check 1','Lab',34,0,0,2,0,'ES - Engineering Sciences',40,60,0,0,30,0,0,'UNIQUE',NULL,NULL,0),(16,'CS111','checkc','Lab',3,0,0,2,0,'HSS - Humanities and Social Sciences',40,60,0,0,30,0,0,'UNIQUE',NULL,NULL,1),(17,'CS112','checkc','Lab',3,2,3,1,0,'BS - Basic Sciences',40,60,0,0,15,0,0,'UNIQUE',NULL,NULL,0),(18,'CS120','introduction to programming','Lab',3,1,3,4,3,'ES - Engineering Sciences',40,60,0,0,60,0,4,'UNIQUE',NULL,NULL,0),(19,'CS121','check','Lab',4,0,0,1,0,'ES - Engineering Sciences',40,60,0,0,15,0,0,'UNIQUE',NULL,NULL,1),(20,'CS101','linear equation','Lab',1,0,0,2,0,'HSS - Humanities and Social Sciences',40,60,0,0,30,0,0,'UNIQUE',NULL,NULL,0),(21,'CS156','check one','Lab',3,0,0,5,0,'ES - Engineering Sciences',40,60,0,0,75,0,0,'UNIQUE',NULL,NULL,1),(22,'CS167','check main','Lab',4,0,0,5,0,'ES - Engineering Sciences',40,60,0,0,75,0,0,'UNIQUE',NULL,NULL,0),(29,'101','101','Theory&Lab',5,0,0,0,0,'BS - Basic Sciences',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,0),(30,'1013','101','Theory',2,100,0,0,0,'BS - Basic Sciences',40,60,1500,0,0,0,0,'UNIQUE',NULL,NULL,0),(88,'CS720','bug','Theory',4,2,2,0,0,'ES - Engineering Sciences',40,60,30,30,0,0,0,'UNIQUE',NULL,NULL,0),(89,'CS2','dccv','Lab',5,2,3,4,0,'ES - Engineering Sciences',40,60,0,0,60,0,0,'UNIQUE',NULL,NULL,0),(90,'CS120','check','Lab',3,0,0,5,0,'ES - Engineering Sciences',40,60,0,0,75,0,0,'UNIQUE',NULL,NULL,0),(91,'CS720','check bug','Lab',3,0,0,1,0,'HSS - Humanities and Social Sciences',40,60,0,0,15,0,0,'UNIQUE',NULL,NULL,1),(92,'CS120','course name check','Lab',2,0,0,3,0,'ES - Engineering Sciences',40,60,0,0,45,0,0,'UNIQUE',NULL,NULL,0),(94,'sem 1','sem 1 subj','Theory',3,0,0,0,0,'BS - Basic Sciences',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(95,'sem 2','sem 2','Theory',4,0,0,0,0,'BS - Basic Sciences',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(112,'CS199','check see','Lab',3,0,0,1,0,'HSS - Humanities and Social Sciences',40,60,0,0,15,0,0,'UNIQUE',NULL,NULL,1),(113,'1','1','Theory',1,0,0,0,0,'BS - Basic Sciences',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(130,'22AG040','TECHNOLOGY OF SEED PROCESSING','ELECTIVE 1',3,3,0,0,0,'THEORY',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(131,'22AG401','CROP PRODUCTION TECHNOLOGY','CORE',4,3,0,2,0,'THEORY WITH LAB',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(132,'22AG402','HEAT AND MASS TRANSFER','CORE',4,3,0,2,0,'THEORY WITH LAB',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(133,'22AG403','STRENGTH OF MATERIALS','CORE',4,2,1,2,0,'THEORY',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(134,'22AG404','THEORY OF MACHINES','CORE',4,3,0,2,0,'THEORY WITH LAB',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(135,'22AG405','HYDROLOGY','CORE',4,3,1,0,0,'THEORY',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(136,'22CH203','ENGINEERING CHEMISTRY II','CORE',3,2,0,2,0,'THEORY WITH LAB',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(137,'22GE002','COMPUTATIONAL PROBLEM SOLVING','CORE',3,3,0,0,0,'THEORY',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(138,'22GE004','BASICS OF ELECTRONICS ENGINEERING','CORE',3,2,0,2,0,'THEORY WITH LAB',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(139,'22HS002','STARTUP MANAGEMENT','CORE',2,1,0,2,0,'LAB',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(140,'22HS006','TAMILS AND TECHNOLOGY','CORE',1,1,0,0,0,'LAB',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(141,'22HS007','ENVIRONMENTAL SCIENCE','CORE',2,2,0,0,0,'LAB',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(142,'22HS008','ADVANCED ENGLISH AND TECHNICAL EXPRESSION','CORE',1,0,0,2,0,'LAB',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(143,'22HS201','COMMUNICATIVE ENGLISH II','LANGUAGE ELECTIVE',2,1,0,2,0,'LAB',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(144,'22MA201','ENGINEERING MATHEMATICS II','CORE',4,3,1,0,0,'THEORY',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(145,'22PH202','ELECTROMAGNETISM AND MODERN PHYSICS','CORE',3,2,0,2,0,'THEORY WITH LAB',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(146,'CS445','check phonon','Lab',4,0,0,3,0,'ES - Engineering Sciences',40,60,0,0,45,0,0,'UNIQUE',NULL,NULL,1),(147,'22AI002','UI AND UX DESIGN','ELECTIVE 1',3,3,0,0,0,'THEORY',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(148,'22AI020','REINFORCEMENT LEARNING','ELECTIVE 3',3,3,0,0,0,'THEORY',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(149,'22AI025','KNOWLEDGE ENGINEERING','ELECTIVE 4',3,3,0,0,0,'THEORY',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(150,'22AI029','QUANTUM COMPUTING','ADD COURSE',3,3,0,0,0,'THEORY',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(151,'22AI032','RECOMMENDER SYSTEMS','ELECTIVE 4',3,3,0,0,0,'THEORY',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(152,'22AI035','BUSINESS ANALYTICS','ELECTIVE 5',3,3,0,0,0,'THEORY',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(153,'22AI036','DIGITAL MARKETING AND MANAGEMENT','ELECTIVE 5',3,3,0,0,0,'THEORY',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(154,'22AI043','PYTHON FOR DATA SCIENCE','ELECTIVE 1',3,3,0,0,0,'THEORY',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(155,'22AI049','ETHICS IN DATA SCIENCE','ELECTIVE 3',3,3,0,0,0,'THEORY',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(156,'22AI206','DIGITAL COMPUTER ELECTRONICS','CORE',4,3,0,2,0,'THEORY',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(157,'22AI401','APPLIED LINEAR ALGEBRA','CORE',4,3,1,0,0,'THEORY',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(158,'22AI402','DATA STRUCTURES II','CORE',4,3,0,2,0,'THEORY',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(159,'22AI403','OPERATING SYSTEMS','CORE',4,3,1,0,0,'THEORY',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(160,'22AI404','WEB TECHNOLOGY AND FRAMEWORKS','CORE',4,3,0,2,0,'THEORY WITH LAB',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(161,'22AI405','DATABASE MANAGEMENT SYSTEM','CORE',4,3,0,2,0,'THEORY WITH LAB',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(162,'22AI601','NATURAL LANGUAGE PROCESSING','CORE',4,3,0,2,0,'THEORY WITH LAB',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(163,'22AI602','COMPUTER VISION AND DIGITAL IMAGING','CORE',4,3,0,2,0,'THEORY WITH LAB',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(164,'22AI603','DEEP LEARNING','CORE',4,3,0,2,0,'THEORY WITH LAB',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(165,'22AIH09','CLOUD STORAGE TECHNOLOGIES','HONOURS',3,3,0,0,0,'THEORY',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1),(166,'22AIH10','CLOUD AUTOMATION TOOLS AND APPLICATIONS','Theory',3,3,0,0,0,'BS - Basic Sciences',40,60,45,0,0,0,0,'UNIQUE',NULL,NULL,1),(167,'22GE003','BASICS OF ELECTRICAL ENGINEERING','CORE',3,2,0,2,0,'THEORY WITH LAB',40,60,0,0,0,0,0,'UNIQUE',NULL,NULL,1);
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `curriculum`
--

DROP TABLE IF EXISTS `curriculum`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `curriculum` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `academic_year` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `curriculum_template` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '2026',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `max_credits` int DEFAULT '0',
  `status` tinyint(1) DEFAULT '1',
  `curriculum_ref_id` int DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=297 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curriculum`
--

LOCK TABLES `curriculum` WRITE;
/*!40000 ALTER TABLE `curriculum` DISABLE KEYS */;
INSERT INTO `curriculum` VALUES (3,'R2024 CSE','2024-2025','2022','2026-01-27 08:58:41',125,0,NULL),(290,'Default Curriculum','2024-2025','2026','2026-01-28 09:20:53',0,0,NULL),(291,'checkc','2024-2025','2022','2026-01-28 10:17:30',162,0,NULL),(293,'bug','2024-2025','2022','2026-01-30 04:19:13',164,1,NULL),(294,'buzz','2025 - 2026','2022','2026-01-30 08:42:37',160,1,NULL),(295,'AGRI CURRICULUM 2025-2026','2025 - 2026','2022','2026-01-30 10:35:48',160,1,NULL),(296,'AIDS Curriculum','2025 - 2026','2022','2026-02-02 04:28:29',160,1,NULL);
/*!40000 ALTER TABLE `curriculum` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `curriculum_courses`
--

DROP TABLE IF EXISTS `curriculum_courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `curriculum_courses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `curriculum_id` int NOT NULL,
  `semester_id` int NOT NULL,
  `course_id` int NOT NULL,
  `count_towards_limit` tinyint(1) DEFAULT '1' COMMENT 'Whether this course counts towards the curriculum max credit limit',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_rc_regulation` (`curriculum_id`) USING BTREE,
  KEY `fk_rc_semester` (`semester_id`) USING BTREE,
  KEY `fk_rc_course` (`course_id`) USING BTREE,
  CONSTRAINT `fk_rc_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_rc_regulation` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_rc_semester` FOREIGN KEY (`semester_id`) REFERENCES `normal_cards` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=334 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curriculum_courses`
--

LOCK TABLES `curriculum_courses` WRITE;
/*!40000 ALTER TABLE `curriculum_courses` DISABLE KEYS */;
INSERT INTO `curriculum_courses` VALUES (249,3,77,13,1),(250,3,77,14,1),(251,3,77,15,0),(252,291,78,16,1),(253,290,80,18,0),(254,3,79,19,1),(255,3,79,20,1),(264,293,82,18,1),(265,293,82,88,1),(266,290,80,89,0),(267,293,83,19,1),(268,294,84,94,1),(269,294,85,95,1),(270,294,86,112,1),(288,295,88,130,1),(289,295,88,131,1),(290,295,88,132,1),(291,295,88,133,1),(292,295,88,134,1),(293,295,88,135,1),(294,295,88,136,1),(295,295,88,137,1),(296,295,88,138,1),(297,295,88,139,1),(298,295,88,140,1),(299,295,88,141,1),(300,295,88,142,1),(301,295,88,143,1),(302,295,88,144,1),(303,295,88,145,1),(304,294,86,146,1),(305,296,91,147,1),(306,296,92,148,1),(307,296,92,149,1),(308,296,92,150,1),(309,296,92,151,1),(310,296,92,152,1),(311,296,92,153,1),(312,296,91,154,1),(313,296,92,155,1),(314,296,93,156,1),(315,296,91,157,1),(316,296,91,158,1),(317,296,91,159,1),(318,296,91,160,1),(319,296,91,161,1),(320,296,92,162,1),(321,296,92,163,1),(322,296,92,164,1),(323,296,92,165,1),(324,296,92,166,1),(325,296,93,136,1),(326,296,93,137,1),(327,296,93,167,1),(328,296,93,140,1),(329,296,91,141,1),(330,296,91,142,1),(331,296,93,143,1),(332,296,93,144,1),(333,296,93,145,1);
/*!40000 ALTER TABLE `curriculum_courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `curriculum_logs`
--

DROP TABLE IF EXISTS `curriculum_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `curriculum_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `curriculum_id` int NOT NULL,
  `action` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `changed_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'System',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `diff` json DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `curriculum_id` (`curriculum_id`) USING BTREE,
  CONSTRAINT `curriculum_logs_ibfk_1` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=508 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curriculum_logs`
--

LOCK TABLES `curriculum_logs` WRITE;
/*!40000 ALTER TABLE `curriculum_logs` DISABLE KEYS */;
INSERT INTO `curriculum_logs` VALUES (358,3,'Curriculum Created','Created new curriculum: R2024 CSE (2024-2025)','System','2026-01-27 08:58:41',NULL),(359,3,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-27 09:00:10',NULL),(360,3,'Curriculum Updated','Updated curriculum details','System','2026-01-27 09:16:48','{\"name\": {\"new\": \"R2024 CS\", \"old\": \"R2024 CSE\"}}'),(361,3,'Curriculum Updated','Updated curriculum details','System','2026-01-27 09:17:09','{\"name\": {\"new\": \"R2024 CSE\", \"old\": \"R2024 CS\"}, \"academic_year\": {\"new\": \"2024-2024\", \"old\": \"2024-2025\"}}'),(362,3,'Curriculum Updated','Updated curriculum details','System','2026-01-27 09:17:25','{\"max_credits\": {\"new\": 125, \"old\": 124}, \"academic_year\": {\"new\": \"2024-2025\", \"old\": \"2024-2024\"}}'),(363,3,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-27 09:18:49',NULL),(364,3,'Card Added','Added Semester 1','System','2026-01-27 09:29:49',NULL),(365,3,'Course Added','Added course CS101 - hello to Semester 75','System','2026-01-27 09:30:12',NULL),(366,3,'Card Added','Added Semester 1','System','2026-01-27 09:37:35',NULL),(367,3,'Course Added','Added course CS100 - hello to Semester 76','System','2026-01-27 09:38:08',NULL),(368,3,'Card Added','Added Semester 1','System','2026-01-27 10:12:44',NULL),(369,3,'Course Added','Added course CS120 - check to Semester 77','System','2026-01-27 10:13:55',NULL),(370,3,'Course Removed','Removed course check from Semester 77','System','2026-01-28 06:44:18',NULL),(371,3,'Course Removed','Removed course check from Semester 77','System','2026-01-28 08:23:30',NULL),(372,3,'Course Removed','Removed course check from Semester 77','System','2026-01-28 08:35:20',NULL),(373,3,'Course Added','Added course CS121 - check  to Semester 77','System','2026-01-28 08:37:23',NULL),(374,3,'Course Removed','Removed course check  from Semester 77','System','2026-01-28 08:37:45',NULL),(375,3,'Course Added','Added course CS130 - hello to Semester 77','System','2026-01-28 08:48:11',NULL),(376,3,'Course Removed','Removed course hello from Semester 77','System','2026-01-28 08:48:52',NULL),(377,3,'Course Added','Added course CS130 - check to Semester 77','System','2026-01-28 09:00:16',NULL),(378,3,'Course Removed','Removed course check from Semester 77','System','2026-01-28 09:00:30',NULL),(379,3,'Course Added','Added course CS345 - check to Semester 77','System','2026-01-28 09:01:31',NULL),(380,3,'Course Removed','Removed course check from Semester 77','System','2026-01-28 09:06:01',NULL),(381,3,'Course Removed','Removed course check from Semester 77','System','2026-01-28 09:51:42',NULL),(382,3,'Course Added','Added course CS123 - delete to Semester 77','System','2026-01-28 09:53:03',NULL),(383,3,'Course Removed','Removed course delete from Semester 77','System','2026-01-28 09:55:26',NULL),(384,3,'Course Added','Added course Cs232 - check 1 to Semester 77','System','2026-01-28 09:57:33',NULL),(385,291,'Curriculum Created','Created new curriculum: check (2024-2025)','System','2026-01-28 10:17:30',NULL),(386,291,'Curriculum Updated','Updated curriculum details','System','2026-01-28 10:17:42','{\"name\": {\"new\": \"checkc\", \"old\": \"check\"}}'),(387,291,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-28 10:19:25',NULL),(388,291,'Card Added','Added Semester 1','System','2026-01-28 10:19:36',NULL),(389,291,'Honour Card Added','Added Honour Card: honour','System','2026-01-28 10:19:50',NULL),(390,291,'Course Added','Added course CS111 - checkc to Semester 78','System','2026-01-28 10:20:09',NULL),(391,3,'Honour Card Added','Added Honour Card: honour','System','2026-01-28 10:25:40',NULL),(392,3,'Honour Card Added','Added Honour Card: honours','System','2026-01-28 10:43:22',NULL),(393,3,'Card Added','Added Semester 1','System','2026-01-28 10:45:12',NULL),(394,290,'Card Added','Added Semester 1','System','2026-01-29 03:48:43',NULL),(395,290,'Course Added','Added course CS120 - introduction to programming to Semester 80','System','2026-01-29 03:54:07',NULL),(396,3,'Course Added','Added course CS121 - check to Semester 79','System','2026-01-29 03:56:02',NULL),(397,3,'Course Added','Added course CS101 - linear equation to Semester 79','System','2026-01-29 04:05:54',NULL),(412,293,'Curriculum Created','Created new curriculum: bug (2024-2025)','System','2026-01-30 04:19:13',NULL),(413,293,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-30 04:20:17',NULL),(414,293,'PSO[0] Added','Added PSO item at index 0','System','2026-01-30 04:20:22','{\"PSO[0]\": {\"new\": \"bug\", \"old\": \"\"}}'),(415,293,'Card Added','Added Semester 1','System','2026-01-30 04:21:07',NULL),(416,293,'Course Added','Added course CS120 - bug to Semester 82','System','2026-01-30 05:01:34',NULL),(417,293,'Course Removed','Removed course introduction to programming from Semester 82','System','2026-01-30 05:03:39',NULL),(418,293,'Course Added','Added course CS720 - bug to Semester 82','System','2026-01-30 05:04:49',NULL),(419,290,'Course Added','Added course CS2 - dccv to Semester 80','System','2026-01-30 05:45:23',NULL),(420,293,'Course Removed','Removed course bug from Semester 82','System','2026-01-30 05:52:20',NULL),(421,293,'Card Added','Added New Card','System','2026-01-30 06:19:10',NULL),(422,293,'Course Added','Added course CS121 - bug to Semester 83','System','2026-01-30 06:19:30',NULL),(423,293,'Honour Card Added','Added Honour Card: honour verticals ','System','2026-01-30 06:20:42',NULL),(424,293,'Honour Card Added','Added Honour Card: honour verticals','System','2026-01-30 06:32:57',NULL),(425,293,'Honour Card Added','Added Honour Card: honour cards','System','2026-01-30 08:14:27',NULL),(426,294,'Curriculum Created','Created new curriculum: buzz (2025 - 2026)','System','2026-01-30 08:42:37',NULL),(427,294,'Card Added','Added Semester 1','System','2026-01-30 08:42:44',NULL),(428,294,'Card Added','Added Semester 2','System','2026-01-30 08:42:48',NULL),(429,294,'Course Added','Added course sem 1 - sem 1 subj to Semester 84','System','2026-01-30 08:43:04',NULL),(430,294,'Course Added','Added course sem 2 - sem 2 to Semester 85','System','2026-01-30 08:43:19',NULL),(431,294,'Card Added','Added New Card','System','2026-01-30 10:05:35',NULL),(432,294,'Course Added','Added course CS199 - check see to Semester 86','System','2026-01-30 10:32:34',NULL),(433,294,'Card Added','Added New Card','System','2026-01-30 10:33:30',NULL),(434,295,'Curriculum Created','Created new curriculum: AGRI CURRICULUM 2025-2026 (2025 - 2026)','System','2026-01-30 10:35:49',NULL),(435,295,'Card Added','Added Semester 1','System','2026-01-30 10:41:31',NULL),(436,295,'Course Added','Added course 1 - 1 to Semester 88','System','2026-01-30 10:41:53',NULL),(437,295,'Course Added','Added course 22AG040 - TECHNOLOGY OF SEED PROCESSING to Semester 88','System','2026-01-30 10:42:37',NULL),(438,295,'Course Added','Added course 22AG401 - CROP PRODUCTION TECHNOLOGY to Semester 88','System','2026-01-30 10:42:37',NULL),(439,295,'Course Added','Added course 22AG402 - HEAT AND MASS TRANSFER to Semester 88','System','2026-01-30 10:42:37',NULL),(440,295,'Course Added','Added course 22AG403 - STRENGTH OF MATERIALS to Semester 88','System','2026-01-30 10:42:38',NULL),(441,295,'Course Added','Added course 22AG404 - THEORY OF MACHINES to Semester 88','System','2026-01-30 10:42:39',NULL),(442,295,'Course Added','Added course 22AG405 - HYDROLOGY to Semester 88','System','2026-01-30 10:42:39',NULL),(443,295,'Course Added','Added course 22CH203 - ENGINEERING CHEMISTRY II to Semester 88','System','2026-01-30 10:42:39',NULL),(444,295,'Course Added','Added course 22GE002 - COMPUTATIONAL PROBLEM SOLVING to Semester 88','System','2026-01-30 10:42:39',NULL),(445,295,'Course Added','Added course 22GE004 - BASICS OF ELECTRONICS ENGINEERING to Semester 88','System','2026-01-30 10:42:40',NULL),(446,295,'Course Added','Added course 22HS002 - STARTUP MANAGEMENT to Semester 88','System','2026-01-30 10:42:40',NULL),(447,295,'Course Added','Added course 22HS006 - TAMILS AND TECHNOLOGY to Semester 88','System','2026-01-30 10:42:40',NULL),(448,295,'Course Added','Added course 22HS007 - ENVIRONMENTAL SCIENCE to Semester 88','System','2026-01-30 10:42:41',NULL),(449,295,'Course Added','Added course 22HS008 - ADVANCED ENGLISH AND TECHNICAL EXPRESSION to Semester 88','System','2026-01-30 10:42:41',NULL),(450,295,'Course Added','Added course 22HS201 - COMMUNICATIVE ENGLISH II to Semester 88','System','2026-01-30 10:42:42',NULL),(451,295,'Course Added','Added course 22MA201 - ENGINEERING MATHEMATICS II to Semester 88','System','2026-01-30 10:42:42',NULL),(452,295,'Course Added','Added course 22PH202 - ELECTROMAGNETISM AND MODERN PHYSICS to Semester 88','System','2026-01-30 10:42:42',NULL),(453,295,'Course Added','Added course 22AG040 - TECHNOLOGY OF SEED PROCESSING to Semester 88','System','2026-01-30 10:51:24',NULL),(454,295,'Course Added','Added course 22AG401 - CROP PRODUCTION TECHNOLOGY to Semester 88','System','2026-01-30 10:51:24',NULL),(455,295,'Course Added','Added course 22AG402 - HEAT AND MASS TRANSFER to Semester 88','System','2026-01-30 10:51:24',NULL),(456,295,'Course Added','Added course 22AG403 - STRENGTH OF MATERIALS to Semester 88','System','2026-01-30 10:51:25',NULL),(457,295,'Course Added','Added course 22AG404 - THEORY OF MACHINES to Semester 88','System','2026-01-30 10:51:25',NULL),(458,295,'Course Added','Added course 22AG405 - HYDROLOGY to Semester 88','System','2026-01-30 10:51:25',NULL),(459,295,'Course Added','Added course 22CH203 - ENGINEERING CHEMISTRY II to Semester 88','System','2026-01-30 10:51:26',NULL),(460,295,'Course Added','Added course 22GE002 - COMPUTATIONAL PROBLEM SOLVING to Semester 88','System','2026-01-30 10:51:26',NULL),(461,295,'Course Added','Added course 22GE004 - BASICS OF ELECTRONICS ENGINEERING to Semester 88','System','2026-01-30 10:51:26',NULL),(462,295,'Course Added','Added course 22HS002 - STARTUP MANAGEMENT to Semester 88','System','2026-01-30 10:51:26',NULL),(463,295,'Course Added','Added course 22HS006 - TAMILS AND TECHNOLOGY to Semester 88','System','2026-01-30 10:51:27',NULL),(464,295,'Course Added','Added course 22HS007 - ENVIRONMENTAL SCIENCE to Semester 88','System','2026-01-30 10:51:27',NULL),(465,295,'Course Added','Added course 22HS008 - ADVANCED ENGLISH AND TECHNICAL EXPRESSION to Semester 88','System','2026-01-30 10:51:27',NULL),(466,295,'Course Added','Added course 22HS201 - COMMUNICATIVE ENGLISH II to Semester 88','System','2026-01-30 10:51:28',NULL),(467,295,'Course Added','Added course 22MA201 - ENGINEERING MATHEMATICS II to Semester 88','System','2026-01-30 10:51:28',NULL),(468,295,'Course Added','Added course 22PH202 - ELECTROMAGNETISM AND MODERN PHYSICS to Semester 88','System','2026-01-30 10:51:28',NULL),(469,294,'Course Added','Added course CS445 - check phonon to Semester 86','System','2026-01-31 04:54:56',NULL),(470,295,'Card Added','Added New Card','System','2026-02-02 04:16:32',NULL),(471,295,'Honour Card Added','Added Honour Card: honour','System','2026-02-02 04:18:13',NULL),(472,295,'Card Added','Added New Card','System','2026-02-02 04:20:57',NULL),(473,296,'Curriculum Created','Created new curriculum: AIDS Curriculum (2025 - 2026)','System','2026-02-02 04:28:30',NULL),(474,296,'Curriculum Updated','Updated curriculum details','System','2026-02-02 04:28:35','{\"max_credits\": {\"new\": 160, \"old\": 158}}'),(475,296,'Card Added','Added Semester 4','System','2026-02-02 04:29:02',NULL),(476,296,'Course Added','Added course 22AI002 - UI AND UX DESIGN to Semester 91','System','2026-02-02 04:29:03',NULL),(477,296,'Card Added','Added Semester 6','System','2026-02-02 04:29:04',NULL),(478,296,'Course Added','Added course 22AI020 - REINFORCEMENT LEARNING to Semester 92','System','2026-02-02 04:29:06',NULL),(479,296,'Course Added','Added course 22AI025 - KNOWLEDGE ENGINEERING to Semester 92','System','2026-02-02 04:29:08',NULL),(480,296,'Course Added','Added course 22AI029 - QUANTUM COMPUTING to Semester 92','System','2026-02-02 04:29:11',NULL),(481,296,'Course Added','Added course 22AI032 - RECOMMENDER SYSTEMS to Semester 92','System','2026-02-02 04:29:13',NULL),(482,296,'Course Added','Added course 22AI035 - BUSINESS ANALYTICS to Semester 92','System','2026-02-02 04:29:15',NULL),(483,296,'Course Added','Added course 22AI036 - DIGITAL MARKETING AND MANAGEMENT to Semester 92','System','2026-02-02 04:29:20',NULL),(484,296,'Course Added','Added course 22AI043 - PYTHON FOR DATA SCIENCE to Semester 91','System','2026-02-02 04:29:22',NULL),(485,296,'Course Added','Added course 22AI049 - ETHICS IN DATA SCIENCE to Semester 92','System','2026-02-02 04:29:24',NULL),(486,296,'Card Added','Added Semester 2','System','2026-02-02 04:29:24',NULL),(487,296,'Course Added','Added course 22AI206 - DIGITAL COMPUTER ELECTRONICS to Semester 93','System','2026-02-02 04:29:28',NULL),(488,296,'Course Added','Added course 22AI401 - APPLIED LINEAR ALGEBRA to Semester 91','System','2026-02-02 04:29:31',NULL),(489,296,'Course Added','Added course 22AI402 - DATA STRUCTURES II to Semester 91','System','2026-02-02 04:29:34',NULL),(490,296,'Course Added','Added course 22AI403 - OPERATING SYSTEMS to Semester 91','System','2026-02-02 04:29:37',NULL),(491,296,'Course Added','Added course 22AI404 - WEB TECHNOLOGY AND FRAMEWORKS to Semester 91','System','2026-02-02 04:29:39',NULL),(492,296,'Course Added','Added course 22AI405 - DATABASE MANAGEMENT SYSTEM to Semester 91','System','2026-02-02 04:29:42',NULL),(493,296,'Course Added','Added course 22AI601 - NATURAL LANGUAGE PROCESSING to Semester 92','System','2026-02-02 04:29:44',NULL),(494,296,'Course Added','Added course 22AI602 - COMPUTER VISION AND DIGITAL IMAGING to Semester 92','System','2026-02-02 04:29:46',NULL),(495,296,'Course Added','Added course 22AI603 - DEEP LEARNING to Semester 92','System','2026-02-02 04:29:48',NULL),(496,296,'Course Added','Added course 22AIH09 - CLOUD STORAGE TECHNOLOGIES to Semester 92','System','2026-02-02 04:29:51',NULL),(497,296,'Course Added','Added course 22AIH10 - CLOUD AUTOMATION TOOLS AND APPLICATIONS to Semester 92','System','2026-02-02 04:29:53',NULL),(498,296,'Course Added','Added course 22CH203 - ENGINEERING CHEMISTRY II to Semester 93','System','2026-02-02 04:29:56',NULL),(499,296,'Course Added','Added course 22GE002 - COMPUTATIONAL PROBLEM SOLVING to Semester 93','System','2026-02-02 04:29:57',NULL),(500,296,'Course Added','Added course 22GE003 - BASICS OF ELECTRICAL ENGINEERING to Semester 93','System','2026-02-02 04:30:00',NULL),(501,296,'Course Added','Added course 22HS006 - தமிழரும் ததொழில்நுட்பமும்/TAMILS AND TECHNOLOGY to Semester 93','System','2026-02-02 04:30:02',NULL),(502,296,'Course Added','Added course 22HS007 - ENVIRONMENTAL SCIENCE to Semester 91','System','2026-02-02 04:30:05',NULL),(503,296,'Course Added','Added course 22HS008 - ADVANCED ENGLISH AND TECHNICAL EXPRESSION to Semester 91','System','2026-02-02 04:30:07',NULL),(504,296,'Course Added','Added course 22HS201 - COMMUNICATIVE ENGLISH II to Semester 93','System','2026-02-02 04:30:09',NULL),(505,296,'Course Added','Added course 22MA201 - ENGINEERING MATHEMATICS II to Semester 93','System','2026-02-02 04:30:11',NULL),(506,296,'Course Added','Added course 22PH202 - ELECTROMAGNETISM AND MODERN PHYSICS to Semester 93','System','2026-02-02 04:30:12',NULL),(507,296,'Course Updated','Updated course: 22AIH10 - CLOUD AUTOMATION TOOLS AND APPLICATIONS','System','2026-02-02 04:33:55','{\"category\": {\"new\": \"BS - Basic Sciences\", \"old\": \"THEORY\"}, \"course_type\": {\"new\": \"Theory\", \"old\": \"HONOURS\"}}');
/*!40000 ALTER TABLE `curriculum_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `curriculum_mission`
--

DROP TABLE IF EXISTS `curriculum_mission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `curriculum_mission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `curriculum_id` int NOT NULL,
  `mission_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `position` int NOT NULL,
  `visibility` enum('UNIQUE','CLUSTER') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'UNIQUE',
  `source_curriculum_id` int DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_curriculum_id` (`curriculum_id`),
  CONSTRAINT `curriculum_mission_ibfk_1` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curriculum_mission`
--

LOCK TABLES `curriculum_mission` WRITE;
/*!40000 ALTER TABLE `curriculum_mission` DISABLE KEYS */;
INSERT INTO `curriculum_mission` VALUES (62,3,'hello',0,'UNIQUE',NULL,0),(63,291,'checkc',0,'UNIQUE',NULL,0),(65,293,'bug',0,'UNIQUE',NULL,1);
/*!40000 ALTER TABLE `curriculum_mission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `curriculum_peos`
--

DROP TABLE IF EXISTS `curriculum_peos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `curriculum_peos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `curriculum_id` int NOT NULL,
  `peo_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `position` int NOT NULL,
  `visibility` enum('UNIQUE','CLUSTER') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'UNIQUE',
  `source_curriculum_id` int DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_curriculum_id` (`curriculum_id`),
  CONSTRAINT `curriculum_peos_ibfk_1` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curriculum_peos`
--

LOCK TABLES `curriculum_peos` WRITE;
/*!40000 ALTER TABLE `curriculum_peos` DISABLE KEYS */;
INSERT INTO `curriculum_peos` VALUES (44,3,'hello',0,'UNIQUE',NULL,0),(45,291,'checkc',0,'UNIQUE',NULL,0),(47,293,'bug',0,'UNIQUE',NULL,1);
/*!40000 ALTER TABLE `curriculum_peos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `curriculum_pos`
--

DROP TABLE IF EXISTS `curriculum_pos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `curriculum_pos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `curriculum_id` int NOT NULL,
  `po_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `position` int NOT NULL,
  `visibility` enum('UNIQUE','CLUSTER') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'UNIQUE',
  `source_curriculum_id` int DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_curriculum_id` (`curriculum_id`),
  CONSTRAINT `curriculum_pos_ibfk_1` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curriculum_pos`
--

LOCK TABLES `curriculum_pos` WRITE;
/*!40000 ALTER TABLE `curriculum_pos` DISABLE KEYS */;
INSERT INTO `curriculum_pos` VALUES (55,3,'hello',0,'UNIQUE',NULL,0),(56,291,'checkc',0,'UNIQUE',NULL,0),(58,293,'bug',0,'UNIQUE',NULL,1);
/*!40000 ALTER TABLE `curriculum_pos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `curriculum_psos`
--

DROP TABLE IF EXISTS `curriculum_psos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `curriculum_psos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `curriculum_id` int NOT NULL,
  `pso_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `position` int NOT NULL,
  `visibility` enum('UNIQUE','CLUSTER') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'UNIQUE',
  `source_curriculum_id` int DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_curriculum_id` (`curriculum_id`),
  CONSTRAINT `curriculum_psos_ibfk_1` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curriculum_psos`
--

LOCK TABLES `curriculum_psos` WRITE;
/*!40000 ALTER TABLE `curriculum_psos` DISABLE KEYS */;
INSERT INTO `curriculum_psos` VALUES (28,3,'hello',0,'UNIQUE',NULL,0),(29,291,'checkc',0,'UNIQUE',NULL,0),(31,293,'bug',0,'UNIQUE',NULL,1);
/*!40000 ALTER TABLE `curriculum_psos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `curriculum_vision`
--

DROP TABLE IF EXISTS `curriculum_vision`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `curriculum_vision` (
  `id` int NOT NULL AUTO_INCREMENT,
  `curriculum_id` int NOT NULL,
  `vision` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` int DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `curriculum_vision_ibfk_1` (`curriculum_id`),
  CONSTRAINT `curriculum_vision_ibfk_1` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curriculum_vision`
--

LOCK TABLES `curriculum_vision` WRITE;
/*!40000 ALTER TABLE `curriculum_vision` DISABLE KEYS */;
INSERT INTO `curriculum_vision` VALUES (19,3,'hello',0),(20,291,'checkc',0),(22,293,'bug',1);
/*!40000 ALTER TABLE `curriculum_vision` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department_curriculum`
--

DROP TABLE IF EXISTS `department_curriculum`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department_curriculum` (
  `id` int NOT NULL AUTO_INCREMENT,
  `department_id` int NOT NULL,
  `curriculum_id` int NOT NULL,
  `visibility` enum('UNIQUE','CLUSTER') DEFAULT 'UNIQUE',
  `source_curriculum_id` int DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_department_curriculum` (`department_id`,`curriculum_id`),
  KEY `idx_department` (`department_id`),
  KEY `idx_curriculum` (`curriculum_id`),
  CONSTRAINT `fk_dc_curriculum` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_dc_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_curriculum`
--

LOCK TABLES `department_curriculum` WRITE;
/*!40000 ALTER TABLE `department_curriculum` DISABLE KEYS */;
/*!40000 ALTER TABLE `department_curriculum` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department_curriculum_active`
--

DROP TABLE IF EXISTS `department_curriculum_active`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department_curriculum_active` (
  `id` int NOT NULL AUTO_INCREMENT,
  `department_id` int NOT NULL,
  `curriculum_id` int NOT NULL,
  `academic_year` varchar(20) NOT NULL COMMENT 'Which year this curriculum is active for',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_dept_curriculum_year` (`department_id`,`curriculum_id`,`academic_year`),
  KEY `idx_department` (`department_id`),
  KEY `idx_curriculum` (`curriculum_id`),
  CONSTRAINT `fk_dept_curr_active_curr` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_dept_curr_active_dept` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_curriculum_active`
--

LOCK TABLES `department_curriculum_active` WRITE;
/*!40000 ALTER TABLE `department_curriculum_active` DISABLE KEYS */;
INSERT INTO `department_curriculum_active` VALUES (1,14,296,'2025-2026',1,'2026-02-02 10:29:37');
/*!40000 ALTER TABLE `department_curriculum_active` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department_teachers`
--

DROP TABLE IF EXISTS `department_teachers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department_teachers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `teacher_id` varchar(45) NOT NULL,
  `department_id` int NOT NULL,
  `role` varchar(100) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_department_teacher` (`teacher_id`,`department_id`),
  KEY `idx_teacher` (`teacher_id`),
  KEY `idx_department` (`department_id`),
  CONSTRAINT `fk_dt_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_dt_teacher_new` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`faculty_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=198 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_teachers`
--

LOCK TABLES `department_teachers` WRITE;
/*!40000 ALTER TABLE `department_teachers` DISABLE KEYS */;
INSERT INTO `department_teachers` VALUES (16,'17',1,NULL,1,'2026-01-27 09:27:55','2026-01-27 09:27:55'),(17,'101',1,NULL,1,'2026-01-28 09:17:16','2026-01-28 09:17:16'),(18,'102',1,NULL,1,'2026-01-28 09:17:16','2026-01-28 09:17:16'),(19,'103',2,NULL,1,'2026-01-28 09:17:16','2026-01-28 09:17:16'),(20,'104',3,NULL,1,'2026-01-28 09:17:16','2026-01-28 09:17:16'),(21,'105',1,NULL,1,'2026-01-28 09:17:16','2026-01-28 09:17:16'),(32,'1312',8,'Faculty',1,'2026-01-29 08:35:25','2026-01-29 08:35:25'),(33,'1558',8,'Faculty',1,'2026-01-29 08:35:25','2026-01-29 08:35:25'),(34,'10092',8,'Faculty',1,'2026-01-29 08:35:25','2026-01-29 08:35:25'),(35,'10172',8,'Faculty',1,'2026-01-29 08:35:25','2026-01-29 08:35:25'),(36,'10299',8,'Faculty',1,'2026-01-29 08:35:25','2026-01-29 08:35:25'),(37,'10895',8,'Faculty',1,'2026-01-29 08:35:25','2026-01-29 08:35:25'),(38,'11011',8,'Faculty',1,'2026-01-29 08:35:25','2026-01-29 08:35:25'),(39,'11083',8,'Faculty',1,'2026-01-29 08:35:25','2026-01-29 08:35:25'),(47,'10503',8,'Faculty',1,'2026-01-29 08:51:05','2026-01-29 08:51:05'),(48,'10994',8,'Faculty',1,'2026-01-29 08:51:05','2026-01-29 08:51:05'),(49,'11049',8,'Faculty',1,'2026-01-29 08:51:05','2026-01-29 08:51:05'),(50,'11178',8,'Faculty',1,'2026-01-29 08:51:05','2026-01-29 08:51:05'),(54,'10071',8,NULL,1,'2026-01-29 09:17:42','2026-01-29 09:17:42'),(55,'11015',8,NULL,1,'2026-01-29 09:17:43','2026-01-29 09:17:43'),(56,'11057',8,NULL,1,'2026-01-29 09:17:43','2026-01-29 09:17:43'),(57,'11119',8,NULL,1,'2026-01-29 09:17:44','2026-01-29 09:17:44'),(58,'11131',8,NULL,1,'2026-01-29 09:17:44','2026-01-29 09:17:44'),(60,'11085',8,NULL,1,'2026-01-29 09:17:45','2026-01-29 09:17:45'),(100,'MA10071',8,NULL,1,'2026-01-30 10:45:39','2026-01-30 10:45:39'),(101,'PH11015',8,NULL,1,'2026-01-30 10:45:39','2026-01-30 10:45:39'),(111,'AG10092',8,NULL,1,'2026-01-30 10:45:42','2026-01-30 10:45:42'),(138,'PH11015',14,NULL,1,'2026-02-02 06:17:47','2026-02-02 06:17:47');
/*!40000 ALTER TABLE `department_teachers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `department_code` varchar(30) DEFAULT NULL,
  `department_name` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_departments_code` (`department_code`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,NULL,'Computer Science and Engineering',1,'2026-01-27 08:22:33','2026-01-27 08:22:33'),(2,NULL,'Information Technology',1,'2026-01-27 08:22:33','2026-01-27 08:22:33'),(3,NULL,'Electronics and Communication Engineering',1,'2026-01-27 08:22:33','2026-01-27 08:22:33'),(4,NULL,'Mechanical Engineering',1,'2026-01-27 08:40:37','2026-01-28 09:17:15'),(8,'AG','Agricultural Engineering',1,'2026-01-29 08:35:15','2026-02-02 12:07:29'),(14,'AD','Artificial Intelligence and Data Science',1,'2026-02-02 06:17:41','2026-02-02 06:24:59');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hod_elective_selections`
--

DROP TABLE IF EXISTS `hod_elective_selections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hod_elective_selections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `department_id` int NOT NULL,
  `curriculum_id` int NOT NULL COMMENT 'Which curriculum this applies to',
  `semester` int NOT NULL COMMENT '4-8 (electives start from sem 4)',
  `course_id` int NOT NULL,
  `academic_year` varchar(20) NOT NULL COMMENT 'e.g., "2025-2026" - allows different electives per year',
  `batch` varchar(20) DEFAULT NULL COMMENT 'Student batch e.g., "2024-2028" - for batch-specific electives',
  `max_students` int DEFAULT NULL COMMENT 'Maximum students for this elective (optional capacity limit)',
  `approved_by_user_id` int NOT NULL COMMENT 'User ID from users table (HOD who approved)',
  `status` enum('ACTIVE','INACTIVE','DRAFT') DEFAULT 'ACTIVE',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_dept_sem_course_year_batch` (`department_id`,`semester`,`course_id`,`academic_year`,`batch`),
  KEY `idx_department` (`department_id`),
  KEY `idx_curriculum` (`curriculum_id`),
  KEY `idx_semester` (`semester`),
  KEY `idx_academic_year` (`academic_year`),
  KEY `idx_batch` (`batch`),
  KEY `fk_hod_selection_course` (`course_id`),
  KEY `fk_hod_selection_user` (`approved_by_user_id`),
  KEY `idx_dept_sem_year` (`department_id`,`semester`,`academic_year`),
  CONSTRAINT `fk_hod_selection_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_hod_selection_curriculum` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_hod_selection_dept` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_hod_selection_user` FOREIGN KEY (`approved_by_user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hod_elective_selections`
--

LOCK TABLES `hod_elective_selections` WRITE;
/*!40000 ALTER TABLE `hod_elective_selections` DISABLE KEYS */;
/*!40000 ALTER TABLE `hod_elective_selections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `honour_cards`
--

DROP TABLE IF EXISTS `honour_cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `honour_cards` (
  `id` int NOT NULL AUTO_INCREMENT,
  `curriculum_id` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `visibility` enum('UNIQUE','CLUSTER') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'UNIQUE',
  `source_curriculum_id` int DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_curriculum_id` (`curriculum_id`) USING BTREE,
  CONSTRAINT `curriculum_cards_ibfk_1` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `honour_cards`
--

LOCK TABLES `honour_cards` WRITE;
/*!40000 ALTER TABLE `honour_cards` DISABLE KEYS */;
INSERT INTO `honour_cards` VALUES (6,293,'honour cards','2026-01-30 08:14:27','UNIQUE',NULL,0),(7,295,'honour','2026-02-02 04:18:13','UNIQUE',NULL,1);
/*!40000 ALTER TABLE `honour_cards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `honour_vertical_courses`
--

DROP TABLE IF EXISTS `honour_vertical_courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `honour_vertical_courses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `honour_vertical_id` int NOT NULL,
  `course_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `unique_course_vertical` (`honour_vertical_id`,`course_id`) USING BTREE,
  KEY `course_id` (`course_id`) USING BTREE,
  KEY `idx_vertical` (`honour_vertical_id`) USING BTREE,
  CONSTRAINT `honour_vertical_courses_ibfk_1` FOREIGN KEY (`honour_vertical_id`) REFERENCES `honour_verticals` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `honour_vertical_courses_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `honour_vertical_courses`
--

LOCK TABLES `honour_vertical_courses` WRITE;
/*!40000 ALTER TABLE `honour_vertical_courses` DISABLE KEYS */;
INSERT INTO `honour_vertical_courses` VALUES (23,9,92,'2026-01-30 08:16:08',0);
/*!40000 ALTER TABLE `honour_vertical_courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `honour_verticals`
--

DROP TABLE IF EXISTS `honour_verticals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `honour_verticals` (
  `id` int NOT NULL AUTO_INCREMENT,
  `honour_card_id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_honour_card` (`honour_card_id`) USING BTREE,
  CONSTRAINT `honour_verticals_ibfk_1` FOREIGN KEY (`honour_card_id`) REFERENCES `honour_cards` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `honour_verticals`
--

LOCK TABLES `honour_verticals` WRITE;
/*!40000 ALTER TABLE `honour_verticals` DISABLE KEYS */;
INSERT INTO `honour_verticals` VALUES (9,6,'vertical coard','2026-01-30 08:14:56',0);
/*!40000 ALTER TABLE `honour_verticals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hostel_details`
--

DROP TABLE IF EXISTS `hostel_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hostel_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `hosteller_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `hostel_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `room_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `room_capacity` int DEFAULT NULL,
  `room_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `floor_no` int DEFAULT NULL,
  `warden_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `alternate_warden` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `class_advisor` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `status` int DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`) USING BTREE,
  CONSTRAINT `hostel_details_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hostel_details`
--

LOCK TABLES `hostel_details` WRITE;
/*!40000 ALTER TABLE `hostel_details` DISABLE KEYS */;
INSERT INTO `hostel_details` VALUES (1,3005,'sdff','sdf','23',0,'sdf',0,'sdf','sdfsdf','ssfv',1);
/*!40000 ALTER TABLE `hostel_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `insurance_details`
--

DROP TABLE IF EXISTS `insurance_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `insurance_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `nominee_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `relationship` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `nominee_age` int DEFAULT NULL,
  `status` int DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`) USING BTREE,
  CONSTRAINT `insurance_details_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `insurance_details`
--

LOCK TABLES `insurance_details` WRITE;
/*!40000 ALTER TABLE `insurance_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `insurance_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `learning_modes`
--

DROP TABLE IF EXISTS `learning_modes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `learning_modes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `learning_modes`
--

LOCK TABLES `learning_modes` WRITE;
/*!40000 ALTER TABLE `learning_modes` DISABLE KEYS */;
INSERT INTO `learning_modes` VALUES (1,'UAL','University Academic Learning',1),(2,'PBL','Project Based Learning',1);
/*!40000 ALTER TABLE `learning_modes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mark_category_name`
--

DROP TABLE IF EXISTS `mark_category_name`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mark_category_name` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) NOT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mark_category_name`
--

LOCK TABLES `mark_category_name` WRITE;
/*!40000 ALTER TABLE `mark_category_name` DISABLE KEYS */;
INSERT INTO `mark_category_name` VALUES (1,'Periodical Test 1',1),(2,'Periodical Test 2',1),(3,'Innovative Practice',1),(4,'Preparation',1),(5,'Experiment and analysis of results',1),(6,'Record',1),(7,'Test - Cycle I',1),(8,'Test - Cycle II',1);
/*!40000 ALTER TABLE `mark_category_name` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mark_category_types`
--

DROP TABLE IF EXISTS `mark_category_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mark_category_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `max_marks` int NOT NULL,
  `conversion_marks` decimal(6,2) DEFAULT NULL,
  `position` int NOT NULL,
  `course_type_id` int NOT NULL,
  `category_name_id` int NOT NULL,
  `learning_mode_id` int NOT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `idx_course_type_id` (`course_type_id`),
  KEY `idx_category_name_id` (`category_name_id`),
  KEY `idx_learning_mode_id` (`learning_mode_id`),
  CONSTRAINT `fk_assessment_category` FOREIGN KEY (`category_name_id`) REFERENCES `mark_category_name` (`id`),
  CONSTRAINT `fk_assessment_course_type` FOREIGN KEY (`course_type_id`) REFERENCES `course_type` (`id`),
  CONSTRAINT `fk_assessment_learning_mode` FOREIGN KEY (`learning_mode_id`) REFERENCES `learning_modes` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mark_category_types`
--

LOCK TABLES `mark_category_types` WRITE;
/*!40000 ALTER TABLE `mark_category_types` DISABLE KEYS */;
INSERT INTO `mark_category_types` VALUES (1,'PT1','Periodical Test 1',50,12.00,1,1,1,1,1),(2,'PT2','Periodical Test 2',50,12.00,2,1,1,1,1),(3,'UT1','Unit Test 1',20,2.00,3,1,2,1,1),(4,'UT2','Unit Test 2',20,2.00,4,1,2,1,1),(5,'UT3','Unit Test 3',20,2.00,5,1,2,1,1),(6,'UT4','Unit Test 4',20,2.00,6,1,2,1,1),(7,'UT5','Unit Test 5',20,2.00,7,1,2,1,1),(8,'SDG_A1','SDG Assignment 1',10,1.00,8,1,3,1,1),(9,'SDG_A2','SDG Assignment 2',10,1.00,9,1,3,1,1),(10,'SDG_CS1','SDG Case Study 1',10,1.00,10,1,3,1,1),(11,'SDG_CS2','SDG Case Study 2',10,1.00,11,1,3,1,1),(20,'PT1','Periodical Test 1',50,15.00,1,2,1,1,1),(21,'PT2','Periodical Test 2',50,15.00,2,2,1,1,1),(22,'UT1','Unit Test 1',20,1.00,3,2,2,1,1),(23,'UT2','Unit Test 2',20,1.00,4,2,2,1,1),(24,'UT3','Unit Test 3',20,1.00,5,2,2,1,1),(25,'UT4','Unit Test 4',20,1.00,6,2,2,1,1),(26,'UT5','Unit Test 5',20,1.00,7,2,2,1,1),(27,'TEST_CYCLE_1','Test Cycle I',50,4.00,8,2,6,1,1);
/*!40000 ALTER TABLE `mark_category_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `normal_cards`
--

DROP TABLE IF EXISTS `normal_cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `normal_cards` (
  `id` int NOT NULL AUTO_INCREMENT,
  `curriculum_id` int NOT NULL,
  `semester_number` int DEFAULT NULL,
  `visibility` enum('UNIQUE','CLUSTER') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'UNIQUE',
  `source_curriculum_id` int DEFAULT NULL,
  `card_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'semester',
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_semester_regulation` (`curriculum_id`) USING BTREE,
  CONSTRAINT `fk_semester_regulation` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `normal_cards`
--

LOCK TABLES `normal_cards` WRITE;
/*!40000 ALTER TABLE `normal_cards` DISABLE KEYS */;
INSERT INTO `normal_cards` VALUES (77,3,1,'UNIQUE',NULL,'semester',0),(78,291,1,'UNIQUE',NULL,'semester',0),(79,3,1,'UNIQUE',NULL,'semester',0),(80,290,1,'UNIQUE',NULL,'semester',0),(82,293,1,'UNIQUE',NULL,'semester',1),(83,293,NULL,'UNIQUE',NULL,'elective',1),(84,294,1,'UNIQUE',NULL,'semester',1),(85,294,2,'UNIQUE',NULL,'semester',1),(86,294,NULL,'UNIQUE',NULL,'elective',1),(87,294,NULL,'UNIQUE',NULL,'open_elective',1),(88,295,1,'UNIQUE',NULL,'semester',1),(89,295,NULL,'UNIQUE',NULL,'elective',1),(90,295,NULL,'UNIQUE',NULL,'open_elective',1),(91,296,4,'UNIQUE',NULL,'semester',1),(92,296,6,'UNIQUE',NULL,'semester',1),(93,296,2,'UNIQUE',NULL,'semester',1);
/*!40000 ALTER TABLE `normal_cards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `peo_po_mapping`
--

DROP TABLE IF EXISTS `peo_po_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `peo_po_mapping` (
  `id` int NOT NULL AUTO_INCREMENT,
  `curriculum_id` int NOT NULL,
  `peo_index` int NOT NULL,
  `po_index` int NOT NULL,
  `mapping_value` int NOT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_peopo_reg` (`curriculum_id`) USING BTREE,
  CONSTRAINT `fk_peopo_reg` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=738 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `peo_po_mapping`
--

LOCK TABLES `peo_po_mapping` WRITE;
/*!40000 ALTER TABLE `peo_po_mapping` DISABLE KEYS */;
/*!40000 ALTER TABLE `peo_po_mapping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regulation_clause_history`
--

DROP TABLE IF EXISTS `regulation_clause_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regulation_clause_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `clause_id` int NOT NULL,
  `old_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `new_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `changed_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `changed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `change_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `status` int DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `clause_id` (`clause_id`) USING BTREE,
  CONSTRAINT `regulation_clause_history_ibfk_1` FOREIGN KEY (`clause_id`) REFERENCES `regulation_clauses` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regulation_clause_history`
--

LOCK TABLES `regulation_clause_history` WRITE;
/*!40000 ALTER TABLE `regulation_clause_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `regulation_clause_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regulation_clauses`
--

DROP TABLE IF EXISTS `regulation_clauses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regulation_clauses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `regulation_id` int NOT NULL,
  `section_no` int NOT NULL,
  `clause_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `regulation_id` (`regulation_id`) USING BTREE,
  CONSTRAINT `regulation_clauses_ibfk_1` FOREIGN KEY (`regulation_id`) REFERENCES `regulations` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regulation_clauses`
--

LOCK TABLES `regulation_clauses` WRITE;
/*!40000 ALTER TABLE `regulation_clauses` DISABLE KEYS */;
/*!40000 ALTER TABLE `regulation_clauses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regulation_sections`
--

DROP TABLE IF EXISTS `regulation_sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regulation_sections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `regulation_id` int NOT NULL,
  `section_no` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `display_order` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `unique_section` (`regulation_id`,`section_no`) USING BTREE,
  KEY `idx_regulation` (`regulation_id`) USING BTREE,
  KEY `idx_order` (`regulation_id`,`display_order`) USING BTREE,
  CONSTRAINT `regulation_sections_ibfk_1` FOREIGN KEY (`regulation_id`) REFERENCES `regulations` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regulation_sections`
--

LOCK TABLES `regulation_sections` WRITE;
/*!40000 ALTER TABLE `regulation_sections` DISABLE KEYS */;
INSERT INTO `regulation_sections` VALUES (1,1,1,'ADMISSION',1,'2025-12-29 04:27:34','2025-12-29 04:27:34');
/*!40000 ALTER TABLE `regulation_sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regulations`
--

DROP TABLE IF EXISTS `regulations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regulations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` enum('DRAFT','PUBLISHED','LOCKED') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'DRAFT',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `code` (`code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regulations`
--

LOCK TABLES `regulations` WRITE;
/*!40000 ALTER TABLE `regulations` DISABLE KEYS */;
INSERT INTO `regulations` VALUES (1,'R2022','Academic Regulation 2022','DRAFT','2025-12-27 10:20:35','2025-12-27 10:20:35');
/*!40000 ALTER TABLE `regulations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `research_profiles`
--

DROP TABLE IF EXISTS `research_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `research_profiles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `scopus_link` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `google_scholar_link` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `researchgate_link` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `orcid_link` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `h_index` int DEFAULT NULL,
  `status` int DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`) USING BTREE,
  CONSTRAINT `research_profiles_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `research_profiles`
--

LOCK TABLES `research_profiles` WRITE;
/*!40000 ALTER TABLE `research_profiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `research_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `school_details`
--

DROP TABLE IF EXISTS `school_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `school_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `school_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `board` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `year_of_pass` int DEFAULT NULL,
  `state` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `tc_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `tc_date` date DEFAULT NULL,
  `total_marks` decimal(6,2) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `student_id` (`student_id`) USING BTREE,
  CONSTRAINT `school_details_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `school_details`
--

LOCK TABLES `school_details` WRITE;
/*!40000 ALTER TABLE `school_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `school_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sharing_tracking`
--

DROP TABLE IF EXISTS `sharing_tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sharing_tracking` (
  `id` int NOT NULL AUTO_INCREMENT,
  `source_curriculum_id` int NOT NULL,
  `target_curriculum_id` int NOT NULL,
  `item_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `source_item_id` int NOT NULL,
  `copied_item_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_source` (`source_curriculum_id`,`item_type`,`source_item_id`) USING BTREE,
  KEY `idx_target` (`target_curriculum_id`,`item_type`) USING BTREE,
  KEY `idx_copied` (`copied_item_id`,`item_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sharing_tracking`
--

LOCK TABLES `sharing_tracking` WRITE;
/*!40000 ALTER TABLE `sharing_tracking` DISABLE KEYS */;
/*!40000 ALTER TABLE `sharing_tracking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_courses`
--

DROP TABLE IF EXISTS `student_courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_courses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `course_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_student_course` (`student_id`,`course_id`),
  KEY `idx_student_courses_course` (`course_id`),
  CONSTRAINT `fk_student_courses_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_student_courses_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6407 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_courses`
--

LOCK TABLES `student_courses` WRITE;
/*!40000 ALTER TABLE `student_courses` DISABLE KEYS */;
INSERT INTO `student_courses` VALUES (173,3048,130),(176,3048,131),(179,3048,132),(182,3048,133),(185,3048,134),(188,3048,135),(191,3048,141),(194,3048,142),(198,3049,130),(201,3049,131),(204,3049,132),(207,3049,133),(210,3049,134),(213,3049,135),(216,3049,141),(219,3049,142),(223,3050,130),(226,3050,131),(229,3050,132),(232,3050,133),(235,3050,134),(238,3050,135),(241,3050,141),(244,3050,142),(248,3051,130),(251,3051,131),(254,3051,132),(257,3051,133),(260,3051,134),(263,3051,135),(266,3051,141),(269,3051,142),(273,3052,130),(276,3052,131),(279,3052,132),(282,3052,133),(285,3052,134),(288,3052,135),(291,3052,141),(294,3052,142),(298,3053,130),(301,3053,131),(304,3053,132),(307,3053,133),(310,3053,134),(313,3053,135),(316,3053,141),(319,3053,142),(323,3054,130),(326,3054,131),(329,3054,132),(332,3054,133),(335,3054,134),(338,3054,135),(341,3054,141),(344,3054,142),(348,3055,130),(351,3055,131),(354,3055,132),(357,3055,133),(360,3055,134),(363,3055,135),(366,3055,141),(369,3055,142),(373,3056,130),(376,3056,131),(379,3056,132),(382,3056,133),(385,3056,134),(388,3056,135),(391,3056,141),(394,3056,142),(398,3057,130),(401,3057,131),(404,3057,132),(407,3057,133),(410,3057,134),(413,3057,135),(416,3057,141),(419,3057,142),(423,3058,130),(426,3058,131),(429,3058,132),(432,3058,133),(435,3058,134),(438,3058,135),(441,3058,141),(444,3058,142),(448,3059,130),(451,3059,131),(454,3059,132),(457,3059,133),(460,3059,134),(463,3059,135),(466,3059,141),(469,3059,142),(473,3060,130),(476,3060,131),(479,3060,132),(482,3060,133),(485,3060,134),(488,3060,135),(491,3060,141),(494,3060,142),(498,3061,130),(501,3061,131),(504,3061,132),(507,3061,133),(510,3061,134),(513,3061,135),(516,3061,141),(519,3061,142),(523,3062,130),(526,3062,131),(529,3062,132),(532,3062,133),(535,3062,134),(538,3062,135),(541,3062,141),(544,3062,142),(548,3063,130),(551,3063,131),(554,3063,132),(557,3063,133),(560,3063,134),(563,3063,135),(566,3063,141),(569,3063,142),(573,3064,130),(576,3064,131),(579,3064,132),(582,3064,133),(585,3064,134),(588,3064,135),(591,3064,141),(594,3064,142),(598,3065,130),(601,3065,131),(604,3065,132),(607,3065,133),(610,3065,134),(613,3065,135),(616,3065,141),(619,3065,142),(623,3066,130),(626,3066,131),(629,3066,132),(632,3066,133),(635,3066,134),(638,3066,135),(641,3066,141),(644,3066,142),(648,3067,130),(651,3067,131),(654,3067,132),(657,3067,133),(660,3067,134),(663,3067,135),(666,3067,141),(669,3067,142),(673,3068,130),(676,3068,131),(679,3068,132),(682,3068,133),(685,3068,134),(688,3068,135),(691,3068,141),(694,3068,142),(698,3069,130),(701,3069,131),(704,3069,132),(707,3069,133),(710,3069,134),(713,3069,135),(716,3069,141),(719,3069,142),(723,3070,130),(726,3070,131),(729,3070,132),(732,3070,133),(735,3070,134),(738,3070,135),(741,3070,141),(744,3070,142),(748,3071,130),(751,3071,131),(754,3071,132),(757,3071,133),(760,3071,134),(763,3071,135),(766,3071,141),(769,3071,142),(773,3072,130),(776,3072,131),(779,3072,132),(782,3072,133),(785,3072,134),(788,3072,135),(791,3072,141),(794,3072,142),(798,3073,130),(801,3073,131),(804,3073,132),(807,3073,133),(810,3073,134),(813,3073,135),(816,3073,141),(819,3073,142),(4301,3507,141),(4302,3507,142),(4295,3507,154),(4296,3507,157),(4297,3507,158),(4298,3507,159),(4299,3507,160),(4300,3507,161),(4321,3508,141),(4324,3508,142),(4303,3508,154),(4306,3508,157),(4309,3508,158),(4312,3508,159),(4315,3508,160),(4318,3508,161),(4333,3509,141),(4334,3509,142),(4327,3509,147),(4328,3509,157),(4329,3509,158),(4330,3509,159),(4331,3509,160),(4332,3509,161),(4341,3510,141),(4342,3510,142),(4335,3510,147),(4336,3510,157),(4337,3510,158),(4338,3510,159),(4339,3510,160),(4340,3510,161),(4349,3511,141),(4350,3511,142),(4343,3511,147),(4344,3511,157),(4345,3511,158),(4346,3511,159),(4347,3511,160),(4348,3511,161),(4357,3512,141),(4358,3512,142),(4351,3512,154),(4352,3512,157),(4353,3512,158),(4354,3512,159),(4355,3512,160),(4356,3512,161),(4365,3513,141),(4366,3513,142),(4359,3513,147),(4360,3513,157),(4361,3513,158),(4362,3513,159),(4363,3513,160),(4364,3513,161),(4373,3514,141),(4374,3514,142),(4367,3514,154),(4368,3514,157),(4369,3514,158),(4370,3514,159),(4371,3514,160),(4372,3514,161),(4381,3515,141),(4382,3515,142),(4375,3515,147),(4376,3515,157),(4377,3515,158),(4378,3515,159),(4379,3515,160),(4380,3515,161),(4389,3516,141),(4390,3516,142),(4383,3516,147),(4384,3516,157),(4385,3516,158),(4386,3516,159),(4387,3516,160),(4388,3516,161),(4397,3517,141),(4398,3517,142),(4391,3517,154),(4392,3517,157),(4393,3517,158),(4394,3517,159),(4395,3517,160),(4396,3517,161),(4405,3518,141),(4406,3518,142),(4399,3518,154),(4400,3518,157),(4401,3518,158),(4402,3518,159),(4403,3518,160),(4404,3518,161),(4413,3519,141),(4414,3519,142),(4407,3519,154),(4408,3519,157),(4409,3519,158),(4410,3519,159),(4411,3519,160),(4412,3519,161),(4421,3520,141),(4422,3520,142),(4415,3520,147),(4416,3520,157),(4417,3520,158),(4418,3520,159),(4419,3520,160),(4420,3520,161),(4429,3521,141),(4430,3521,142),(4423,3521,147),(4424,3521,157),(4425,3521,158),(4426,3521,159),(4427,3521,160),(4428,3521,161),(4437,3522,141),(4438,3522,142),(4431,3522,147),(4432,3522,157),(4433,3522,158),(4434,3522,159),(4435,3522,160),(4436,3522,161),(4445,3523,141),(4446,3523,142),(4439,3523,154),(4440,3523,157),(4441,3523,158),(4442,3523,159),(4443,3523,160),(4444,3523,161),(4453,3524,141),(4454,3524,142),(4447,3524,154),(4448,3524,157),(4449,3524,158),(4450,3524,159),(4451,3524,160),(4452,3524,161),(4461,3525,141),(4462,3525,142),(4455,3525,147),(4456,3525,157),(4457,3525,158),(4458,3525,159),(4459,3525,160),(4460,3525,161),(4469,3526,141),(4470,3526,142),(4463,3526,147),(4464,3526,157),(4465,3526,158),(4466,3526,159),(4467,3526,160),(4468,3526,161),(4477,3527,141),(4478,3527,142),(4471,3527,154),(4472,3527,157),(4473,3527,158),(4474,3527,159),(4475,3527,160),(4476,3527,161),(4485,3528,141),(4486,3528,142),(4479,3528,154),(4480,3528,157),(4481,3528,158),(4482,3528,159),(4483,3528,160),(4484,3528,161),(4493,3529,141),(4494,3529,142),(4487,3529,154),(4488,3529,157),(4489,3529,158),(4490,3529,159),(4491,3529,160),(4492,3529,161),(4501,3530,141),(4502,3530,142),(4495,3530,147),(4496,3530,157),(4497,3530,158),(4498,3530,159),(4499,3530,160),(4500,3530,161),(4509,3531,141),(4510,3531,142),(4503,3531,154),(4504,3531,157),(4505,3531,158),(4506,3531,159),(4507,3531,160),(4508,3531,161),(4517,3532,141),(4518,3532,142),(4511,3532,154),(4512,3532,157),(4513,3532,158),(4514,3532,159),(4515,3532,160),(4516,3532,161),(4525,3533,141),(4526,3533,142),(4519,3533,147),(4520,3533,157),(4521,3533,158),(4522,3533,159),(4523,3533,160),(4524,3533,161),(4533,3534,141),(4534,3534,142),(4527,3534,147),(4528,3534,157),(4529,3534,158),(4530,3534,159),(4531,3534,160),(4532,3534,161),(4541,3535,141),(4542,3535,142),(4535,3535,147),(4536,3535,157),(4537,3535,158),(4538,3535,159),(4539,3535,160),(4540,3535,161),(4549,3536,141),(4550,3536,142),(4543,3536,154),(4544,3536,157),(4545,3536,158),(4546,3536,159),(4547,3536,160),(4548,3536,161),(4557,3537,141),(4558,3537,142),(4551,3537,147),(4552,3537,157),(4553,3537,158),(4554,3537,159),(4555,3537,160),(4556,3537,161),(4565,3538,141),(4566,3538,142),(4559,3538,147),(4560,3538,157),(4561,3538,158),(4562,3538,159),(4563,3538,160),(4564,3538,161),(4573,3539,141),(4574,3539,142),(4567,3539,154),(4568,3539,157),(4569,3539,158),(4570,3539,159),(4571,3539,160),(4572,3539,161),(4581,3540,141),(4582,3540,142),(4575,3540,147),(4576,3540,157),(4577,3540,158),(4578,3540,159),(4579,3540,160),(4580,3540,161),(4589,3541,141),(4590,3541,142),(4583,3541,147),(4584,3541,157),(4585,3541,158),(4586,3541,159),(4587,3541,160),(4588,3541,161),(4597,3542,141),(4598,3542,142),(4591,3542,154),(4592,3542,157),(4593,3542,158),(4594,3542,159),(4595,3542,160),(4596,3542,161),(4605,3543,141),(4606,3543,142),(4599,3543,154),(4600,3543,157),(4601,3543,158),(4602,3543,159),(4603,3543,160),(4604,3543,161),(4613,3544,141),(4614,3544,142),(4607,3544,147),(4608,3544,157),(4609,3544,158),(4610,3544,159),(4611,3544,160),(4612,3544,161),(4621,3545,141),(4622,3545,142),(4615,3545,147),(4616,3545,157),(4617,3545,158),(4618,3545,159),(4619,3545,160),(4620,3545,161),(4629,3546,141),(4630,3546,142),(4623,3546,154),(4624,3546,157),(4625,3546,158),(4626,3546,159),(4627,3546,160),(4628,3546,161),(4637,3547,141),(4638,3547,142),(4631,3547,154),(4632,3547,157),(4633,3547,158),(4634,3547,159),(4635,3547,160),(4636,3547,161),(4645,3548,141),(4646,3548,142),(4639,3548,154),(4640,3548,157),(4641,3548,158),(4642,3548,159),(4643,3548,160),(4644,3548,161),(4653,3549,141),(4654,3549,142),(4647,3549,154),(4648,3549,157),(4649,3549,158),(4650,3549,159),(4651,3549,160),(4652,3549,161),(4661,3550,141),(4662,3550,142),(4655,3550,154),(4656,3550,157),(4657,3550,158),(4658,3550,159),(4659,3550,160),(4660,3550,161),(4669,3551,141),(4670,3551,142),(4663,3551,154),(4664,3551,157),(4665,3551,158),(4666,3551,159),(4667,3551,160),(4668,3551,161),(4677,3552,141),(4678,3552,142),(4671,3552,147),(4672,3552,157),(4673,3552,158),(4674,3552,159),(4675,3552,160),(4676,3552,161),(4685,3553,141),(4686,3553,142),(4679,3553,154),(4680,3553,157),(4681,3553,158),(4682,3553,159),(4683,3553,160),(4684,3553,161),(4693,3554,141),(4694,3554,142),(4687,3554,154),(4688,3554,157),(4689,3554,158),(4690,3554,159),(4691,3554,160),(4692,3554,161),(4701,3555,141),(4702,3555,142),(4695,3555,154),(4696,3555,157),(4697,3555,158),(4698,3555,159),(4699,3555,160),(4700,3555,161),(4709,3556,141),(4710,3556,142),(4703,3556,147),(4704,3556,157),(4705,3556,158),(4706,3556,159),(4707,3556,160),(4708,3556,161),(4717,3557,141),(4718,3557,142),(4711,3557,147),(4712,3557,157),(4713,3557,158),(4714,3557,159),(4715,3557,160),(4716,3557,161),(4725,3558,141),(4726,3558,142),(4719,3558,147),(4720,3558,157),(4721,3558,158),(4722,3558,159),(4723,3558,160),(4724,3558,161),(4733,3559,141),(4734,3559,142),(4727,3559,147),(4728,3559,157),(4729,3559,158),(4730,3559,159),(4731,3559,160),(4732,3559,161),(4741,3560,141),(4742,3560,142),(4735,3560,154),(4736,3560,157),(4737,3560,158),(4738,3560,159),(4739,3560,160),(4740,3560,161),(4749,3561,141),(4750,3561,142),(4743,3561,147),(4744,3561,157),(4745,3561,158),(4746,3561,159),(4747,3561,160),(4748,3561,161),(4757,3562,141),(4758,3562,142),(4751,3562,147),(4752,3562,157),(4753,3562,158),(4754,3562,159),(4755,3562,160),(4756,3562,161),(4765,3563,141),(4766,3563,142),(4759,3563,147),(4760,3563,157),(4761,3563,158),(4762,3563,159),(4763,3563,160),(4764,3563,161),(4773,3564,141),(4774,3564,142),(4767,3564,154),(4768,3564,157),(4769,3564,158),(4770,3564,159),(4771,3564,160),(4772,3564,161),(4781,3565,141),(4782,3565,142),(4775,3565,147),(4776,3565,157),(4777,3565,158),(4778,3565,159),(4779,3565,160),(4780,3565,161),(4789,3566,141),(4790,3566,142),(4783,3566,154),(4784,3566,157),(4785,3566,158),(4786,3566,159),(4787,3566,160),(4788,3566,161),(4797,3567,141),(4798,3567,142),(4791,3567,154),(4792,3567,157),(4793,3567,158),(4794,3567,159),(4795,3567,160),(4796,3567,161),(4805,3568,141),(4806,3568,142),(4799,3568,154),(4800,3568,157),(4801,3568,158),(4802,3568,159),(4803,3568,160),(4804,3568,161),(4813,3569,141),(4814,3569,142),(4807,3569,154),(4808,3569,157),(4809,3569,158),(4810,3569,159),(4811,3569,160),(4812,3569,161),(4821,3570,141),(4822,3570,142),(4815,3570,154),(4816,3570,157),(4817,3570,158),(4818,3570,159),(4819,3570,160),(4820,3570,161),(4829,3571,141),(4830,3571,142),(4823,3571,154),(4824,3571,157),(4825,3571,158),(4826,3571,159),(4827,3571,160),(4828,3571,161),(4837,3572,141),(4838,3572,142),(4831,3572,154),(4832,3572,157),(4833,3572,158),(4834,3572,159),(4835,3572,160),(4836,3572,161),(4845,3573,141),(4846,3573,142),(4839,3573,154),(4840,3573,157),(4841,3573,158),(4842,3573,159),(4843,3573,160),(4844,3573,161),(4853,3574,141),(4854,3574,142),(4847,3574,147),(4848,3574,157),(4849,3574,158),(4850,3574,159),(4851,3574,160),(4852,3574,161),(4861,3575,141),(4862,3575,142),(4855,3575,147),(4856,3575,157),(4857,3575,158),(4858,3575,159),(4859,3575,160),(4860,3575,161),(4869,3576,141),(4870,3576,142),(4863,3576,154),(4864,3576,157),(4865,3576,158),(4866,3576,159),(4867,3576,160),(4868,3576,161),(4877,3577,141),(4878,3577,142),(4871,3577,154),(4872,3577,157),(4873,3577,158),(4874,3577,159),(4875,3577,160),(4876,3577,161),(4885,3578,141),(4886,3578,142),(4879,3578,154),(4880,3578,157),(4881,3578,158),(4882,3578,159),(4883,3578,160),(4884,3578,161),(4893,3579,141),(4894,3579,142),(4887,3579,147),(4888,3579,157),(4889,3579,158),(4890,3579,159),(4891,3579,160),(4892,3579,161),(4901,3580,141),(4902,3580,142),(4895,3580,147),(4896,3580,157),(4897,3580,158),(4898,3580,159),(4899,3580,160),(4900,3580,161),(4909,3581,141),(4910,3581,142),(4903,3581,154),(4904,3581,157),(4905,3581,158),(4906,3581,159),(4907,3581,160),(4908,3581,161),(4917,3582,141),(4918,3582,142),(4911,3582,154),(4912,3582,157),(4913,3582,158),(4914,3582,159),(4915,3582,160),(4916,3582,161),(4925,3583,141),(4926,3583,142),(4919,3583,154),(4920,3583,157),(4921,3583,158),(4922,3583,159),(4923,3583,160),(4924,3583,161),(4933,3584,141),(4934,3584,142),(4927,3584,147),(4928,3584,157),(4929,3584,158),(4930,3584,159),(4931,3584,160),(4932,3584,161),(4941,3585,141),(4942,3585,142),(4935,3585,147),(4936,3585,157),(4937,3585,158),(4938,3585,159),(4939,3585,160),(4940,3585,161),(4949,3586,141),(4950,3586,142),(4943,3586,147),(4944,3586,157),(4945,3586,158),(4946,3586,159),(4947,3586,160),(4948,3586,161),(4957,3587,141),(4958,3587,142),(4951,3587,147),(4952,3587,157),(4953,3587,158),(4954,3587,159),(4955,3587,160),(4956,3587,161),(4965,3588,141),(4966,3588,142),(4959,3588,154),(4960,3588,157),(4961,3588,158),(4962,3588,159),(4963,3588,160),(4964,3588,161),(4973,3589,141),(4974,3589,142),(4967,3589,147),(4968,3589,157),(4969,3589,158),(4970,3589,159),(4971,3589,160),(4972,3589,161),(4981,3590,141),(4982,3590,142),(4975,3590,154),(4976,3590,157),(4977,3590,158),(4978,3590,159),(4979,3590,160),(4980,3590,161),(4989,3591,141),(4990,3591,142),(4983,3591,147),(4984,3591,157),(4985,3591,158),(4986,3591,159),(4987,3591,160),(4988,3591,161),(4997,3592,141),(4998,3592,142),(4991,3592,154),(4992,3592,157),(4993,3592,158),(4994,3592,159),(4995,3592,160),(4996,3592,161),(5005,3593,141),(5006,3593,142),(4999,3593,154),(5000,3593,157),(5001,3593,158),(5002,3593,159),(5003,3593,160),(5004,3593,161),(5013,3594,141),(5014,3594,142),(5007,3594,154),(5008,3594,157),(5009,3594,158),(5010,3594,159),(5011,3594,160),(5012,3594,161),(5021,3595,141),(5022,3595,142),(5015,3595,154),(5016,3595,157),(5017,3595,158),(5018,3595,159),(5019,3595,160),(5020,3595,161),(5029,3596,141),(5030,3596,142),(5023,3596,147),(5024,3596,157),(5025,3596,158),(5026,3596,159),(5027,3596,160),(5028,3596,161),(5037,3597,141),(5038,3597,142),(5031,3597,154),(5032,3597,157),(5033,3597,158),(5034,3597,159),(5035,3597,160),(5036,3597,161),(5045,3598,141),(5046,3598,142),(5039,3598,154),(5040,3598,157),(5041,3598,158),(5042,3598,159),(5043,3598,160),(5044,3598,161),(5053,3599,141),(5054,3599,142),(5047,3599,154),(5048,3599,157),(5049,3599,158),(5050,3599,159),(5051,3599,160),(5052,3599,161),(5061,3600,141),(5062,3600,142),(5055,3600,147),(5056,3600,157),(5057,3600,158),(5058,3600,159),(5059,3600,160),(5060,3600,161),(5069,3601,141),(5070,3601,142),(5063,3601,147),(5064,3601,157),(5065,3601,158),(5066,3601,159),(5067,3601,160),(5068,3601,161),(5077,3602,141),(5078,3602,142),(5071,3602,154),(5072,3602,157),(5073,3602,158),(5074,3602,159),(5075,3602,160),(5076,3602,161),(5085,3603,141),(5086,3603,142),(5079,3603,154),(5080,3603,157),(5081,3603,158),(5082,3603,159),(5083,3603,160),(5084,3603,161),(5093,3604,141),(5094,3604,142),(5087,3604,147),(5088,3604,157),(5089,3604,158),(5090,3604,159),(5091,3604,160),(5092,3604,161),(5101,3605,141),(5102,3605,142),(5095,3605,154),(5096,3605,157),(5097,3605,158),(5098,3605,159),(5099,3605,160),(5100,3605,161),(5109,3606,141),(5110,3606,142),(5103,3606,147),(5104,3606,157),(5105,3606,158),(5106,3606,159),(5107,3606,160),(5108,3606,161),(5117,3607,141),(5118,3607,142),(5111,3607,147),(5112,3607,157),(5113,3607,158),(5114,3607,159),(5115,3607,160),(5116,3607,161),(5125,3608,141),(5126,3608,142),(5119,3608,147),(5120,3608,157),(5121,3608,158),(5122,3608,159),(5123,3608,160),(5124,3608,161),(5133,3609,141),(5134,3609,142),(5127,3609,147),(5128,3609,157),(5129,3609,158),(5130,3609,159),(5131,3609,160),(5132,3609,161),(5141,3610,141),(5142,3610,142),(5135,3610,154),(5136,3610,157),(5137,3610,158),(5138,3610,159),(5139,3610,160),(5140,3610,161),(5149,3611,141),(5150,3611,142),(5143,3611,154),(5144,3611,157),(5145,3611,158),(5146,3611,159),(5147,3611,160),(5148,3611,161),(5157,3612,141),(5158,3612,142),(5151,3612,154),(5152,3612,157),(5153,3612,158),(5154,3612,159),(5155,3612,160),(5156,3612,161),(5165,3613,141),(5166,3613,142),(5159,3613,147),(5160,3613,157),(5161,3613,158),(5162,3613,159),(5163,3613,160),(5164,3613,161),(5173,3614,141),(5174,3614,142),(5167,3614,154),(5168,3614,157),(5169,3614,158),(5170,3614,159),(5171,3614,160),(5172,3614,161),(5181,3615,141),(5182,3615,142),(5175,3615,147),(5176,3615,157),(5177,3615,158),(5178,3615,159),(5179,3615,160),(5180,3615,161),(5189,3616,141),(5190,3616,142),(5183,3616,147),(5184,3616,157),(5185,3616,158),(5186,3616,159),(5187,3616,160),(5188,3616,161),(5197,3617,141),(5198,3617,142),(5191,3617,154),(5192,3617,157),(5193,3617,158),(5194,3617,159),(5195,3617,160),(5196,3617,161),(5205,3618,141),(5206,3618,142),(5199,3618,147),(5200,3618,157),(5201,3618,158),(5202,3618,159),(5203,3618,160),(5204,3618,161),(5213,3619,141),(5214,3619,142),(5207,3619,154),(5208,3619,157),(5209,3619,158),(5210,3619,159),(5211,3619,160),(5212,3619,161),(5221,3620,141),(5222,3620,142),(5215,3620,147),(5216,3620,157),(5217,3620,158),(5218,3620,159),(5219,3620,160),(5220,3620,161),(5229,3621,141),(5230,3621,142),(5223,3621,154),(5224,3621,157),(5225,3621,158),(5226,3621,159),(5227,3621,160),(5228,3621,161),(5237,3622,141),(5238,3622,142),(5231,3622,154),(5232,3622,157),(5233,3622,158),(5234,3622,159),(5235,3622,160),(5236,3622,161),(5245,3623,141),(5246,3623,142),(5239,3623,147),(5240,3623,157),(5241,3623,158),(5242,3623,159),(5243,3623,160),(5244,3623,161),(5253,3624,141),(5254,3624,142),(5247,3624,147),(5248,3624,157),(5249,3624,158),(5250,3624,159),(5251,3624,160),(5252,3624,161),(5261,3625,141),(5262,3625,142),(5255,3625,147),(5256,3625,157),(5257,3625,158),(5258,3625,159),(5259,3625,160),(5260,3625,161),(5269,3626,141),(5270,3626,142),(5263,3626,147),(5264,3626,157),(5265,3626,158),(5266,3626,159),(5267,3626,160),(5268,3626,161),(5277,3627,141),(5278,3627,142),(5271,3627,147),(5272,3627,157),(5273,3627,158),(5274,3627,159),(5275,3627,160),(5276,3627,161),(5285,3628,141),(5286,3628,142),(5279,3628,147),(5280,3628,157),(5281,3628,158),(5282,3628,159),(5283,3628,160),(5284,3628,161),(5293,3629,141),(5294,3629,142),(5287,3629,147),(5288,3629,157),(5289,3629,158),(5290,3629,159),(5291,3629,160),(5292,3629,161),(5301,3630,141),(5302,3630,142),(5295,3630,154),(5296,3630,157),(5297,3630,158),(5298,3630,159),(5299,3630,160),(5300,3630,161),(5309,3631,141),(5310,3631,142),(5303,3631,154),(5304,3631,157),(5305,3631,158),(5306,3631,159),(5307,3631,160),(5308,3631,161),(5317,3632,141),(5318,3632,142),(5311,3632,154),(5312,3632,157),(5313,3632,158),(5314,3632,159),(5315,3632,160),(5316,3632,161),(5325,3633,141),(5326,3633,142),(5319,3633,147),(5320,3633,157),(5321,3633,158),(5322,3633,159),(5323,3633,160),(5324,3633,161),(5333,3634,141),(5334,3634,142),(5327,3634,147),(5328,3634,157),(5329,3634,158),(5330,3634,159),(5331,3634,160),(5332,3634,161),(5341,3635,141),(5342,3635,142),(5335,3635,147),(5336,3635,157),(5337,3635,158),(5338,3635,159),(5339,3635,160),(5340,3635,161),(5349,3636,141),(5350,3636,142),(5343,3636,147),(5344,3636,157),(5345,3636,158),(5346,3636,159),(5347,3636,160),(5348,3636,161),(5357,3637,141),(5358,3637,142),(5351,3637,154),(5352,3637,157),(5353,3637,158),(5354,3637,159),(5355,3637,160),(5356,3637,161),(5365,3638,141),(5366,3638,142),(5359,3638,147),(5360,3638,157),(5361,3638,158),(5362,3638,159),(5363,3638,160),(5364,3638,161),(5373,3639,141),(5374,3639,142),(5367,3639,147),(5368,3639,157),(5369,3639,158),(5370,3639,159),(5371,3639,160),(5372,3639,161),(5381,3640,141),(5382,3640,142),(5375,3640,147),(5376,3640,157),(5377,3640,158),(5378,3640,159),(5379,3640,160),(5380,3640,161),(5389,3641,141),(5390,3641,142),(5383,3641,147),(5384,3641,157),(5385,3641,158),(5386,3641,159),(5387,3641,160),(5388,3641,161),(5397,3642,141),(5398,3642,142),(5391,3642,154),(5392,3642,157),(5393,3642,158),(5394,3642,159),(5395,3642,160),(5396,3642,161),(5405,3643,141),(5406,3643,142),(5399,3643,154),(5400,3643,157),(5401,3643,158),(5402,3643,159),(5403,3643,160),(5404,3643,161),(5413,3644,141),(5414,3644,142),(5407,3644,154),(5408,3644,157),(5409,3644,158),(5410,3644,159),(5411,3644,160),(5412,3644,161),(5421,3645,141),(5422,3645,142),(5415,3645,154),(5416,3645,157),(5417,3645,158),(5418,3645,159),(5419,3645,160),(5420,3645,161),(5429,3646,141),(5430,3646,142),(5423,3646,147),(5424,3646,157),(5425,3646,158),(5426,3646,159),(5427,3646,160),(5428,3646,161),(5437,3647,141),(5438,3647,142),(5431,3647,147),(5432,3647,157),(5433,3647,158),(5434,3647,159),(5435,3647,160),(5436,3647,161),(5445,3648,141),(5446,3648,142),(5439,3648,147),(5440,3648,157),(5441,3648,158),(5442,3648,159),(5443,3648,160),(5444,3648,161),(5453,3649,141),(5454,3649,142),(5447,3649,154),(5448,3649,157),(5449,3649,158),(5450,3649,159),(5451,3649,160),(5452,3649,161),(5461,3650,141),(5462,3650,142),(5455,3650,147),(5456,3650,157),(5457,3650,158),(5458,3650,159),(5459,3650,160),(5460,3650,161),(5469,3651,141),(5470,3651,142),(5463,3651,154),(5464,3651,157),(5465,3651,158),(5466,3651,159),(5467,3651,160),(5468,3651,161),(5477,3652,141),(5478,3652,142),(5471,3652,147),(5472,3652,157),(5473,3652,158),(5474,3652,159),(5475,3652,160),(5476,3652,161),(5485,3653,141),(5486,3653,142),(5479,3653,154),(5480,3653,157),(5481,3653,158),(5482,3653,159),(5483,3653,160),(5484,3653,161),(5493,3654,141),(5494,3654,142),(5487,3654,147),(5488,3654,157),(5489,3654,158),(5490,3654,159),(5491,3654,160),(5492,3654,161),(5501,3655,141),(5502,3655,142),(5495,3655,154),(5496,3655,157),(5497,3655,158),(5498,3655,159),(5499,3655,160),(5500,3655,161),(5509,3656,141),(5510,3656,142),(5503,3656,154),(5504,3656,157),(5505,3656,158),(5506,3656,159),(5507,3656,160),(5508,3656,161),(5517,3657,141),(5518,3657,142),(5511,3657,154),(5512,3657,157),(5513,3657,158),(5514,3657,159),(5515,3657,160),(5516,3657,161),(5525,3658,141),(5526,3658,142),(5519,3658,147),(5520,3658,157),(5521,3658,158),(5522,3658,159),(5523,3658,160),(5524,3658,161),(5533,3659,141),(5534,3659,142),(5527,3659,154),(5528,3659,157),(5529,3659,158),(5530,3659,159),(5531,3659,160),(5532,3659,161),(5541,3660,141),(5542,3660,142),(5535,3660,147),(5536,3660,157),(5537,3660,158),(5538,3660,159),(5539,3660,160),(5540,3660,161),(5549,3661,141),(5550,3661,142),(5543,3661,154),(5544,3661,157),(5545,3661,158),(5546,3661,159),(5547,3661,160),(5548,3661,161),(5557,3662,141),(5558,3662,142),(5551,3662,154),(5552,3662,157),(5553,3662,158),(5554,3662,159),(5555,3662,160),(5556,3662,161),(5565,3663,141),(5566,3663,142),(5559,3663,154),(5560,3663,157),(5561,3663,158),(5562,3663,159),(5563,3663,160),(5564,3663,161),(5573,3664,141),(5574,3664,142),(5567,3664,147),(5568,3664,157),(5569,3664,158),(5570,3664,159),(5571,3664,160),(5572,3664,161),(5581,3665,141),(5582,3665,142),(5575,3665,154),(5576,3665,157),(5577,3665,158),(5578,3665,159),(5579,3665,160),(5580,3665,161),(5589,3666,141),(5590,3666,142),(5583,3666,154),(5584,3666,157),(5585,3666,158),(5586,3666,159),(5587,3666,160),(5588,3666,161),(5597,3667,141),(5598,3667,142),(5591,3667,154),(5592,3667,157),(5593,3667,158),(5594,3667,159),(5595,3667,160),(5596,3667,161),(5605,3668,141),(5606,3668,142),(5599,3668,154),(5600,3668,157),(5601,3668,158),(5602,3668,159),(5603,3668,160),(5604,3668,161),(5613,3669,141),(5614,3669,142),(5607,3669,154),(5608,3669,157),(5609,3669,158),(5610,3669,159),(5611,3669,160),(5612,3669,161),(5621,3670,141),(5622,3670,142),(5615,3670,147),(5616,3670,157),(5617,3670,158),(5618,3670,159),(5619,3670,160),(5620,3670,161),(5629,3671,141),(5630,3671,142),(5623,3671,154),(5624,3671,157),(5625,3671,158),(5626,3671,159),(5627,3671,160),(5628,3671,161),(5637,3672,141),(5638,3672,142),(5631,3672,147),(5632,3672,157),(5633,3672,158),(5634,3672,159),(5635,3672,160),(5636,3672,161),(5645,3673,141),(5646,3673,142),(5639,3673,154),(5640,3673,157),(5641,3673,158),(5642,3673,159),(5643,3673,160),(5644,3673,161),(5653,3674,141),(5654,3674,142),(5647,3674,154),(5648,3674,157),(5649,3674,158),(5650,3674,159),(5651,3674,160),(5652,3674,161),(5661,3675,141),(5662,3675,142),(5655,3675,147),(5656,3675,157),(5657,3675,158),(5658,3675,159),(5659,3675,160),(5660,3675,161),(5669,3676,141),(5670,3676,142),(5663,3676,147),(5664,3676,157),(5665,3676,158),(5666,3676,159),(5667,3676,160),(5668,3676,161),(5677,3677,141),(5678,3677,142),(5671,3677,154),(5672,3677,157),(5673,3677,158),(5674,3677,159),(5675,3677,160),(5676,3677,161),(5685,3678,141),(5686,3678,142),(5679,3678,154),(5680,3678,157),(5681,3678,158),(5682,3678,159),(5683,3678,160),(5684,3678,161),(5693,3679,141),(5694,3679,142),(5687,3679,147),(5688,3679,157),(5689,3679,158),(5690,3679,159),(5691,3679,160),(5692,3679,161),(5701,3680,141),(5702,3680,142),(5695,3680,154),(5696,3680,157),(5697,3680,158),(5698,3680,159),(5699,3680,160),(5700,3680,161),(5709,3681,141),(5710,3681,142),(5703,3681,154),(5704,3681,157),(5705,3681,158),(5706,3681,159),(5707,3681,160),(5708,3681,161),(5717,3682,141),(5718,3682,142),(5711,3682,154),(5712,3682,157),(5713,3682,158),(5714,3682,159),(5715,3682,160),(5716,3682,161),(5725,3683,141),(5726,3683,142),(5719,3683,154),(5720,3683,157),(5721,3683,158),(5722,3683,159),(5723,3683,160),(5724,3683,161),(5733,3684,141),(5734,3684,142),(5727,3684,147),(5728,3684,157),(5729,3684,158),(5730,3684,159),(5731,3684,160),(5732,3684,161),(5741,3685,141),(5742,3685,142),(5735,3685,154),(5736,3685,157),(5737,3685,158),(5738,3685,159),(5739,3685,160),(5740,3685,161),(5749,3686,141),(5750,3686,142),(5743,3686,147),(5744,3686,157),(5745,3686,158),(5746,3686,159),(5747,3686,160),(5748,3686,161),(5757,3687,141),(5758,3687,142),(5751,3687,154),(5752,3687,157),(5753,3687,158),(5754,3687,159),(5755,3687,160),(5756,3687,161),(5765,3688,141),(5766,3688,142),(5759,3688,147),(5760,3688,157),(5761,3688,158),(5762,3688,159),(5763,3688,160),(5764,3688,161),(5773,3689,141),(5774,3689,142),(5767,3689,154),(5768,3689,157),(5769,3689,158),(5770,3689,159),(5771,3689,160),(5772,3689,161),(5781,3690,141),(5782,3690,142),(5775,3690,154),(5776,3690,157),(5777,3690,158),(5778,3690,159),(5779,3690,160),(5780,3690,161),(5789,3691,141),(5790,3691,142),(5783,3691,147),(5784,3691,157),(5785,3691,158),(5786,3691,159),(5787,3691,160),(5788,3691,161),(5797,3692,141),(5798,3692,142),(5791,3692,147),(5792,3692,157),(5793,3692,158),(5794,3692,159),(5795,3692,160),(5796,3692,161),(5805,3693,141),(5806,3693,142),(5799,3693,147),(5800,3693,157),(5801,3693,158),(5802,3693,159),(5803,3693,160),(5804,3693,161),(5813,3694,141),(5814,3694,142),(5807,3694,154),(5808,3694,157),(5809,3694,158),(5810,3694,159),(5811,3694,160),(5812,3694,161),(5821,3695,141),(5822,3695,142),(5815,3695,147),(5816,3695,157),(5817,3695,158),(5818,3695,159),(5819,3695,160),(5820,3695,161),(5829,3696,141),(5830,3696,142),(5823,3696,154),(5824,3696,157),(5825,3696,158),(5826,3696,159),(5827,3696,160),(5828,3696,161),(5837,3697,141),(5838,3697,142),(5831,3697,154),(5832,3697,157),(5833,3697,158),(5834,3697,159),(5835,3697,160),(5836,3697,161),(5845,3698,141),(5846,3698,142),(5839,3698,154),(5840,3698,157),(5841,3698,158),(5842,3698,159),(5843,3698,160),(5844,3698,161),(5853,3699,141),(5854,3699,142),(5847,3699,154),(5848,3699,157),(5849,3699,158),(5850,3699,159),(5851,3699,160),(5852,3699,161),(5861,3700,141),(5862,3700,142),(5855,3700,154),(5856,3700,157),(5857,3700,158),(5858,3700,159),(5859,3700,160),(5860,3700,161),(5869,3701,141),(5870,3701,142),(5863,3701,147),(5864,3701,157),(5865,3701,158),(5866,3701,159),(5867,3701,160),(5868,3701,161),(5877,3702,141),(5878,3702,142),(5871,3702,147),(5872,3702,157),(5873,3702,158),(5874,3702,159),(5875,3702,160),(5876,3702,161),(5885,3703,141),(5886,3703,142),(5879,3703,154),(5880,3703,157),(5881,3703,158),(5882,3703,159),(5883,3703,160),(5884,3703,161),(5893,3704,141),(5894,3704,142),(5887,3704,154),(5888,3704,157),(5889,3704,158),(5890,3704,159),(5891,3704,160),(5892,3704,161),(5901,3705,141),(5902,3705,142),(5895,3705,154),(5896,3705,157),(5897,3705,158),(5898,3705,159),(5899,3705,160),(5900,3705,161),(5909,3706,141),(5910,3706,142),(5903,3706,154),(5904,3706,157),(5905,3706,158),(5906,3706,159),(5907,3706,160),(5908,3706,161),(5917,3707,141),(5918,3707,142),(5911,3707,154),(5912,3707,157),(5913,3707,158),(5914,3707,159),(5915,3707,160),(5916,3707,161),(5925,3708,141),(5926,3708,142),(5919,3708,154),(5920,3708,157),(5921,3708,158),(5922,3708,159),(5923,3708,160),(5924,3708,161),(5933,3709,141),(5934,3709,142),(5927,3709,147),(5928,3709,157),(5929,3709,158),(5930,3709,159),(5931,3709,160),(5932,3709,161),(5941,3710,141),(5942,3710,142),(5935,3710,147),(5936,3710,157),(5937,3710,158),(5938,3710,159),(5939,3710,160),(5940,3710,161),(5949,3711,141),(5950,3711,142),(5943,3711,154),(5944,3711,157),(5945,3711,158),(5946,3711,159),(5947,3711,160),(5948,3711,161),(5957,3712,141),(5958,3712,142),(5951,3712,154),(5952,3712,157),(5953,3712,158),(5954,3712,159),(5955,3712,160),(5956,3712,161),(5965,3713,141),(5966,3713,142),(5959,3713,147),(5960,3713,157),(5961,3713,158),(5962,3713,159),(5963,3713,160),(5964,3713,161),(5973,3714,141),(5974,3714,142),(5967,3714,147),(5968,3714,157),(5969,3714,158),(5970,3714,159),(5971,3714,160),(5972,3714,161),(5981,3715,141),(5982,3715,142),(5975,3715,154),(5976,3715,157),(5977,3715,158),(5978,3715,159),(5979,3715,160),(5980,3715,161),(5989,3716,141),(5990,3716,142),(5983,3716,147),(5984,3716,157),(5985,3716,158),(5986,3716,159),(5987,3716,160),(5988,3716,161),(5997,3717,141),(5998,3717,142),(5991,3717,147),(5992,3717,157),(5993,3717,158),(5994,3717,159),(5995,3717,160),(5996,3717,161),(6005,3718,141),(6006,3718,142),(5999,3718,147),(6000,3718,157),(6001,3718,158),(6002,3718,159),(6003,3718,160),(6004,3718,161),(6013,3719,141),(6014,3719,142),(6007,3719,147),(6008,3719,157),(6009,3719,158),(6010,3719,159),(6011,3719,160),(6012,3719,161),(6021,3720,141),(6022,3720,142),(6015,3720,147),(6016,3720,157),(6017,3720,158),(6018,3720,159),(6019,3720,160),(6020,3720,161),(6029,3721,141),(6030,3721,142),(6023,3721,154),(6024,3721,157),(6025,3721,158),(6026,3721,159),(6027,3721,160),(6028,3721,161),(6037,3722,141),(6038,3722,142),(6031,3722,147),(6032,3722,157),(6033,3722,158),(6034,3722,159),(6035,3722,160),(6036,3722,161),(6045,3723,141),(6046,3723,142),(6039,3723,154),(6040,3723,157),(6041,3723,158),(6042,3723,159),(6043,3723,160),(6044,3723,161),(6053,3724,141),(6054,3724,142),(6047,3724,147),(6048,3724,157),(6049,3724,158),(6050,3724,159),(6051,3724,160),(6052,3724,161),(6061,3725,141),(6062,3725,142),(6055,3725,154),(6056,3725,157),(6057,3725,158),(6058,3725,159),(6059,3725,160),(6060,3725,161),(6069,3726,141),(6070,3726,142),(6063,3726,147),(6064,3726,157),(6065,3726,158),(6066,3726,159),(6067,3726,160),(6068,3726,161),(6077,3727,141),(6078,3727,142),(6071,3727,154),(6072,3727,157),(6073,3727,158),(6074,3727,159),(6075,3727,160),(6076,3727,161),(6085,3728,141),(6086,3728,142),(6079,3728,147),(6080,3728,157),(6081,3728,158),(6082,3728,159),(6083,3728,160),(6084,3728,161),(6093,3729,141),(6094,3729,142),(6087,3729,154),(6088,3729,157),(6089,3729,158),(6090,3729,159),(6091,3729,160),(6092,3729,161),(6101,3730,141),(6102,3730,142),(6095,3730,147),(6096,3730,157),(6097,3730,158),(6098,3730,159),(6099,3730,160),(6100,3730,161),(6109,3731,141),(6110,3731,142),(6103,3731,147),(6104,3731,157),(6105,3731,158),(6106,3731,159),(6107,3731,160),(6108,3731,161),(6117,3732,141),(6118,3732,142),(6111,3732,154),(6112,3732,157),(6113,3732,158),(6114,3732,159),(6115,3732,160),(6116,3732,161),(6125,3733,141),(6126,3733,142),(6119,3733,154),(6120,3733,157),(6121,3733,158),(6122,3733,159),(6123,3733,160),(6124,3733,161),(6133,3734,141),(6134,3734,142),(6127,3734,154),(6128,3734,157),(6129,3734,158),(6130,3734,159),(6131,3734,160),(6132,3734,161),(6141,3735,141),(6142,3735,142),(6135,3735,147),(6136,3735,157),(6137,3735,158),(6138,3735,159),(6139,3735,160),(6140,3735,161),(6149,3736,141),(6150,3736,142),(6143,3736,147),(6144,3736,157),(6145,3736,158),(6146,3736,159),(6147,3736,160),(6148,3736,161),(6157,3737,141),(6158,3737,142),(6151,3737,147),(6152,3737,157),(6153,3737,158),(6154,3737,159),(6155,3737,160),(6156,3737,161),(6165,3738,141),(6166,3738,142),(6159,3738,147),(6160,3738,157),(6161,3738,158),(6162,3738,159),(6163,3738,160),(6164,3738,161),(6173,3739,141),(6174,3739,142),(6167,3739,147),(6168,3739,157),(6169,3739,158),(6170,3739,159),(6171,3739,160),(6172,3739,161),(6181,3740,141),(6182,3740,142),(6175,3740,147),(6176,3740,157),(6177,3740,158),(6178,3740,159),(6179,3740,160),(6180,3740,161),(6189,3741,141),(6190,3741,142),(6183,3741,147),(6184,3741,157),(6185,3741,158),(6186,3741,159),(6187,3741,160),(6188,3741,161),(6197,3742,141),(6198,3742,142),(6191,3742,154),(6192,3742,157),(6193,3742,158),(6194,3742,159),(6195,3742,160),(6196,3742,161),(6205,3743,141),(6206,3743,142),(6199,3743,154),(6200,3743,157),(6201,3743,158),(6202,3743,159),(6203,3743,160),(6204,3743,161),(6213,3744,141),(6214,3744,142),(6207,3744,147),(6208,3744,157),(6209,3744,158),(6210,3744,159),(6211,3744,160),(6212,3744,161),(6221,3745,141),(6222,3745,142),(6215,3745,147),(6216,3745,157),(6217,3745,158),(6218,3745,159),(6219,3745,160),(6220,3745,161),(6229,3746,141),(6230,3746,142),(6223,3746,147),(6224,3746,157),(6225,3746,158),(6226,3746,159),(6227,3746,160),(6228,3746,161),(6237,3747,141),(6238,3747,142),(6231,3747,154),(6232,3747,157),(6233,3747,158),(6234,3747,159),(6235,3747,160),(6236,3747,161),(6245,3748,141),(6246,3748,142),(6239,3748,147),(6240,3748,157),(6241,3748,158),(6242,3748,159),(6243,3748,160),(6244,3748,161),(6253,3749,141),(6254,3749,142),(6247,3749,154),(6248,3749,157),(6249,3749,158),(6250,3749,159),(6251,3749,160),(6252,3749,161),(6261,3750,141),(6262,3750,142),(6255,3750,147),(6256,3750,157),(6257,3750,158),(6258,3750,159),(6259,3750,160),(6260,3750,161),(6269,3751,141),(6270,3751,142),(6263,3751,147),(6264,3751,157),(6265,3751,158),(6266,3751,159),(6267,3751,160),(6268,3751,161),(6277,3752,141),(6278,3752,142),(6271,3752,154),(6272,3752,157),(6273,3752,158),(6274,3752,159),(6275,3752,160),(6276,3752,161),(6285,3753,141),(6286,3753,142),(6279,3753,154),(6280,3753,157),(6281,3753,158),(6282,3753,159),(6283,3753,160),(6284,3753,161),(6293,3754,141),(6294,3754,142),(6287,3754,154),(6288,3754,157),(6289,3754,158),(6290,3754,159),(6291,3754,160),(6292,3754,161),(6301,3755,141),(6302,3755,142),(6295,3755,154),(6296,3755,157),(6297,3755,158),(6298,3755,159),(6299,3755,160),(6300,3755,161),(6309,3756,141),(6310,3756,142),(6303,3756,147),(6304,3756,157),(6305,3756,158),(6306,3756,159),(6307,3756,160),(6308,3756,161),(6317,3757,141),(6318,3757,142),(6311,3757,147),(6312,3757,157),(6313,3757,158),(6314,3757,159),(6315,3757,160),(6316,3757,161),(6325,3758,141),(6326,3758,142),(6319,3758,147),(6320,3758,157),(6321,3758,158),(6322,3758,159),(6323,3758,160),(6324,3758,161),(6333,3759,141),(6334,3759,142),(6327,3759,154),(6328,3759,157),(6329,3759,158),(6330,3759,159),(6331,3759,160),(6332,3759,161),(6341,3760,141),(6342,3760,142),(6335,3760,147),(6336,3760,157),(6337,3760,158),(6338,3760,159),(6339,3760,160),(6340,3760,161),(6349,3761,141),(6350,3761,142),(6343,3761,147),(6344,3761,157),(6345,3761,158),(6346,3761,159),(6347,3761,160),(6348,3761,161),(6357,3762,141),(6358,3762,142),(6351,3762,154),(6352,3762,157),(6353,3762,158),(6354,3762,159),(6355,3762,160),(6356,3762,161),(6365,3763,141),(6366,3763,142),(6359,3763,147),(6360,3763,157),(6361,3763,158),(6362,3763,159),(6363,3763,160),(6364,3763,161),(6373,3764,141),(6374,3764,142),(6367,3764,154),(6368,3764,157),(6369,3764,158),(6370,3764,159),(6371,3764,160),(6372,3764,161),(6381,3765,141),(6382,3765,142),(6375,3765,147),(6376,3765,157),(6377,3765,158),(6378,3765,159),(6379,3765,160),(6380,3765,161),(6389,3766,141),(6390,3766,142),(6383,3766,154),(6384,3766,157),(6385,3766,158),(6386,3766,159),(6387,3766,160),(6388,3766,161),(6397,3767,141),(6398,3767,142),(6391,3767,147),(6392,3767,157),(6393,3767,158),(6394,3767,159),(6395,3767,160),(6396,3767,161),(6405,3768,141),(6406,3768,142),(6399,3768,147),(6400,3768,157),(6401,3768,158),(6402,3768,159),(6403,3768,160),(6404,3768,161);
/*!40000 ALTER TABLE `student_courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_elective_choices`
--

DROP TABLE IF EXISTS `student_elective_choices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_elective_choices` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `hod_selection_id` int NOT NULL COMMENT 'References hod_elective_selections',
  `semester` int NOT NULL,
  `academic_year` varchar(20) NOT NULL,
  `choice_order` int DEFAULT '1' COMMENT 'Priority if multiple electives in same category (1=first choice)',
  `status` enum('PENDING','CONFIRMED','REJECTED','WAITLISTED') DEFAULT 'PENDING',
  `selected_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `confirmed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_student_hod_selection` (`student_id`,`hod_selection_id`),
  KEY `idx_student` (`student_id`),
  KEY `idx_semester` (`semester`),
  KEY `idx_academic_year` (`academic_year`),
  KEY `idx_status` (`status`),
  KEY `fk_student_choice_hod_selection` (`hod_selection_id`),
  KEY `idx_student_sem_year` (`student_id`,`semester`,`academic_year`),
  CONSTRAINT `fk_student_choice_hod_selection` FOREIGN KEY (`hod_selection_id`) REFERENCES `hod_elective_selections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_student_choice_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_elective_choices`
--

LOCK TABLES `student_elective_choices` WRITE;
/*!40000 ALTER TABLE `student_elective_choices` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_elective_choices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_marks`
--

DROP TABLE IF EXISTS `student_marks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_marks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `student_id` int NOT NULL,
  `faculty_id` varchar(50) DEFAULT NULL,
  `assessment_component_id` int NOT NULL,
  `obtained_marks` decimal(6,2) DEFAULT NULL,
  `converted_marks` decimal(6,2) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `idx_course_id` (`course_id`),
  KEY `idx_student_id` (`student_id`),
  KEY `idx_assessment_component_id` (`assessment_component_id`),
  CONSTRAINT `fk_marks_assessment` FOREIGN KEY (`assessment_component_id`) REFERENCES `mark_category_types` (`id`),
  CONSTRAINT `fk_marks_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`),
  CONSTRAINT `fk_marks_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_marks`
--

LOCK TABLES `student_marks` WRITE;
/*!40000 ALTER TABLE `student_marks` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_marks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_teacher_mapping`
--

DROP TABLE IF EXISTS `student_teacher_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_teacher_mapping` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `teacher_id` bigint unsigned NOT NULL,
  `department_id` int NOT NULL,
  `year` int NOT NULL,
  `academic_year` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_student_year` (`student_id`,`year`,`academic_year`),
  KEY `idx_teacher` (`teacher_id`),
  KEY `idx_department_year` (`department_id`,`year`),
  CONSTRAINT `fk_stm_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_stm_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_stm_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_teacher_mapping`
--

LOCK TABLES `student_teacher_mapping` WRITE;
/*!40000 ALTER TABLE `student_teacher_mapping` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_teacher_mapping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
  `id` int NOT NULL AUTO_INCREMENT,
  `enrollment_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `register_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `dte_reg_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `application_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `admission_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `student_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `gender` enum('Male','Female','Other') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `age` int DEFAULT NULL,
  `father_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `mother_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `guardian_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `religion` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `nationality` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `community` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `mother_tongue` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `blood_group` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `aadhar_no` char(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `parent_occupation` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `designation` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `place_of_work` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `parent_income` decimal(10,2) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  `department_id` int DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_students_department` (`department_id`),
  CONSTRAINT `fk_students_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3769 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (3005,'test','234','12','211','188748','Oscar ','Male','2026-01-16',0,'vvbdfv','vjdfjvjhadbvbdhfbh','sdfsd','Christian','Indian','OC','tamil','B+','211223423442','fhbejbfjebrffebrhbf','erg','erg',32323.00,1,NULL),(3048,NULL,'7376242AG101',NULL,NULL,NULL,'BALAMANIGANDAN S V',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3049,NULL,'7376242AG102',NULL,NULL,NULL,'BAVATHARINI P',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3050,NULL,'7376242AG103',NULL,NULL,NULL,'DEEPIKA G',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3051,NULL,'7376242AG104',NULL,NULL,NULL,'GOPI AKASH S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3052,NULL,'7376242AG105',NULL,NULL,NULL,'GURU PRASAD M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3053,NULL,'7376242AG106',NULL,NULL,NULL,'HARITHA M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3054,NULL,'7376242AG107',NULL,NULL,NULL,'HARSHINI K S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3055,NULL,'7376242AG108',NULL,NULL,NULL,'KARTHICK RAJ A',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3056,NULL,'7376242AG109',NULL,NULL,NULL,'KAVIN L',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3057,NULL,'7376242AG110',NULL,NULL,NULL,'MAHIZHAN P',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3058,NULL,'7376242AG111',NULL,NULL,NULL,'MENOJ RAJ T',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3059,NULL,'7376242AG112',NULL,NULL,NULL,'MOHAMED RAJIK M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3060,NULL,'7376242AG113',NULL,NULL,NULL,'MONISHAA N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3061,NULL,'7376242AG114',NULL,NULL,NULL,'MRITHYUN JAY V',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3062,NULL,'7376242AG115',NULL,NULL,NULL,'NATHISH S R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3063,NULL,'7376242AG116',NULL,NULL,NULL,'RAM HARSITH V',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3064,NULL,'7376242AG117',NULL,NULL,NULL,'S SWATHI',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3065,NULL,'7376242AG118',NULL,NULL,NULL,'SANTHOSH K',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3066,NULL,'7376242AG119',NULL,NULL,NULL,'SIMIKA S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3067,NULL,'7376242AG120',NULL,NULL,NULL,'SUGANTH S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3068,NULL,'7376242AG121',NULL,NULL,NULL,'THANIYARASI P',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3069,NULL,'7376242AG122',NULL,NULL,NULL,'THARUN PRASHANTH M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3070,NULL,'7376242AG123',NULL,NULL,NULL,'VARSHA N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3071,NULL,'7376242AG124',NULL,NULL,NULL,'YOGESHWARAN A',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3072,NULL,'7376252AG501',NULL,NULL,NULL,'EZHIL VENDHAN K',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(3073,'ECE24004','7376252AG502','12','211','188748','SYED ABUTHAGIR S R','Male','2026-02-04',-1,'fsd','ssdasf','df','Muslim','Indian','OC','tamil','O-','211223423442','sdf','dsf','dsf',234232.00,1,8),(3507,NULL,'7376242AD102',NULL,NULL,NULL,'AAKILA FATHIMA A',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3508,NULL,'7376242AD102',NULL,NULL,NULL,'AAKILA FATHIMA A',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3509,NULL,'7376242AD103',NULL,NULL,NULL,'AATHIRAI YAAZHINI THIRU',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3510,NULL,'7376242AD104',NULL,NULL,NULL,'ABHISRI V',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3511,NULL,'7376242AD105',NULL,NULL,NULL,'K ABIJITH',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3512,NULL,'7376242AD106',NULL,NULL,NULL,'ABINAV S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3513,NULL,'7376242AD107',NULL,NULL,NULL,'ABINESH S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3514,NULL,'7376242AD108',NULL,NULL,NULL,'ABIRAM P M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3515,NULL,'7376242AD109',NULL,NULL,NULL,'ABIRAMI R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3516,NULL,'7376242AD110',NULL,NULL,NULL,'ADHITHYAN S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3517,NULL,'7376242AD111',NULL,NULL,NULL,'ADITHYA T',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3518,NULL,'7376242AD112',NULL,NULL,NULL,'AFRITHA SHIRIN S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3519,NULL,'7376242AD113',NULL,NULL,NULL,'AKALYA S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3520,NULL,'7376242AD114',NULL,NULL,NULL,'AKASH R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3521,NULL,'7376242AD115',NULL,NULL,NULL,'AKSHAI SELVARAJ',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3522,NULL,'7376242AD116',NULL,NULL,NULL,'ANABAYA SATHRIYAN M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3523,NULL,'7376242AD117',NULL,NULL,NULL,'ANGEL P',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3524,NULL,'7376242AD118',NULL,NULL,NULL,'ANIKSHA N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3525,NULL,'7376242AD119',NULL,NULL,NULL,'ANISHA S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3526,NULL,'7376242AD120',NULL,NULL,NULL,'ANUPRAGHAVAN R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3527,NULL,'7376242AD121',NULL,NULL,NULL,'ARJUN HAREESH S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3528,NULL,'7376242AD122',NULL,NULL,NULL,'ARUN KUMAR S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3529,NULL,'7376242AD123',NULL,NULL,NULL,'ASHWIN R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3530,NULL,'7376242AD124',NULL,NULL,NULL,'ASHWIN PRANOV P',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3531,NULL,'7376242AD125',NULL,NULL,NULL,'ATHISWARAN V',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3532,NULL,'7376242AD126',NULL,NULL,NULL,'BABITHA M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3533,NULL,'7376242AD127',NULL,NULL,NULL,'BALAKRITHIK R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3534,NULL,'7376242AD128',NULL,NULL,NULL,'BALASURYA S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3535,NULL,'7376242AD129',NULL,NULL,NULL,'CHARUNETRA N R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3536,NULL,'7376242AD130',NULL,NULL,NULL,'CHINNAMANI B',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3537,NULL,'7376242AD131',NULL,NULL,NULL,'CHITHA SOWNDARYA R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3538,NULL,'7376242AD132',NULL,NULL,NULL,'DAKSHITA S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3539,NULL,'7376242AD133',NULL,NULL,NULL,'K DAVESH',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3540,NULL,'7376242AD134',NULL,NULL,NULL,'DEEPA T',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3541,NULL,'7376242AD135',NULL,NULL,NULL,'DEEPAK K',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3542,NULL,'7376242AD136',NULL,NULL,NULL,'DEEPAK A',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3543,NULL,'7376242AD137',NULL,NULL,NULL,'DEEPAK K',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3544,NULL,'7376242AD138',NULL,NULL,NULL,'DEEPIKA J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3545,NULL,'7376242AD139',NULL,NULL,NULL,'DEEPIKA SRI N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3546,NULL,'7376242AD140',NULL,NULL,NULL,'DEVA S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3547,NULL,'7376242AD141',NULL,NULL,NULL,'DHANASRI B',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3548,NULL,'7376242AD142',NULL,NULL,NULL,'DHARANI KUMAR T',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3549,NULL,'7376242AD143',NULL,NULL,NULL,'DHARANISELVAM P',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3550,NULL,'7376242AD144',NULL,NULL,NULL,'DHARANISH S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3551,NULL,'7376242AD145',NULL,NULL,NULL,'DHARANITHARAN A V R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3552,NULL,'7376242AD146',NULL,NULL,NULL,'DHARNEESH D',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3553,NULL,'7376242AD147',NULL,NULL,NULL,'DHAYANANTH N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3554,NULL,'7376242AD148',NULL,NULL,NULL,'DHAYANITHI C',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3555,NULL,'7376242AD149',NULL,NULL,NULL,'DHINESH S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3556,NULL,'7376242AD150',NULL,NULL,NULL,'DHIVYADHARSHINI G',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3557,NULL,'7376242AD151',NULL,NULL,NULL,'DHIVYADHARSHINI R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3558,NULL,'7376242AD152',NULL,NULL,NULL,'DINESH M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3559,NULL,'7376242AD153',NULL,NULL,NULL,'DINESHBABU S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3560,NULL,'7376242AD154',NULL,NULL,NULL,'DIVAKAR G',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3561,NULL,'7376242AD155',NULL,NULL,NULL,'DIVYA DHARSHINI S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3562,NULL,'7376242AD156',NULL,NULL,NULL,'DIWYA DHARSHINI S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3563,NULL,'7376242AD157',NULL,NULL,NULL,'DIYA S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3564,NULL,'7376242AD158',NULL,NULL,NULL,'ELAVARASAN K',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3565,NULL,'7376242AD159',NULL,NULL,NULL,'ENITHA P S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3566,NULL,'7376242AD160',NULL,NULL,NULL,'ENIYA A',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3567,NULL,'7376242AD161',NULL,NULL,NULL,'G NIKITHA',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3568,NULL,'7376242AD162',NULL,NULL,NULL,'GAYATHRI U S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3569,NULL,'7376242AD163',NULL,NULL,NULL,'GIRIBALAN M A',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3570,NULL,'7376242AD164',NULL,NULL,NULL,'GIRIJESH S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3571,NULL,'7376242AD165',NULL,NULL,NULL,'GOKUL V',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3572,NULL,'7376242AD166',NULL,NULL,NULL,'GOKUL V',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3573,NULL,'7376242AD167',NULL,NULL,NULL,'GOKULA KRISHNAN D',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3574,NULL,'7376242AD168',NULL,NULL,NULL,'GOPIKA B',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3575,NULL,'7376242AD169',NULL,NULL,NULL,'GUNA M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3576,NULL,'7376242AD170',NULL,NULL,NULL,'HARDIK MUTHUSAMY R P',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3577,NULL,'7376242AD171',NULL,NULL,NULL,'HARI KARTHIKEAYAN S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3578,NULL,'7376242AD172',NULL,NULL,NULL,'HARI KISHORE K S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3579,NULL,'7376242AD173',NULL,NULL,NULL,'HARIHARAN S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3580,NULL,'7376242AD174',NULL,NULL,NULL,'HARINI B',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3581,NULL,'7376242AD175',NULL,NULL,NULL,'HARISANKAR A',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3582,NULL,'7376242AD176',NULL,NULL,NULL,'HARISH M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3583,NULL,'7376242AD177',NULL,NULL,NULL,'HARISHKUMAR M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3584,NULL,'7376242AD178',NULL,NULL,NULL,'HASHMITHA P',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3585,NULL,'7376242AD179',NULL,NULL,NULL,'HEMALATHA A',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3586,NULL,'7376242AD180',NULL,NULL,NULL,'INIYA R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3587,NULL,'7376242AD181',NULL,NULL,NULL,'ISHWARYA S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3588,NULL,'7376242AD182',NULL,NULL,NULL,'J MADHAN KUMAAR',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3589,NULL,'7376242AD183',NULL,NULL,NULL,'JAGAN MOHAN R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3590,NULL,'7376242AD184',NULL,NULL,NULL,'JAGAN P',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3591,NULL,'7376242AD185',NULL,NULL,NULL,'JAGAVI R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3592,NULL,'7376242AD186',NULL,NULL,NULL,'JAISURYA S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3593,NULL,'7376242AD187',NULL,NULL,NULL,'JASWIN K',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3594,NULL,'7376242AD188',NULL,NULL,NULL,'JAYASEELAN G',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3595,NULL,'7376242AD189',NULL,NULL,NULL,'JAYESH S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3596,NULL,'7376242AD190',NULL,NULL,NULL,'JEEVAN M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3597,NULL,'7376242AD191',NULL,NULL,NULL,'JEGAJITH J K',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3598,NULL,'7376242AD192',NULL,NULL,NULL,'JHANANISHRI B',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3599,NULL,'7376242AD193',NULL,NULL,NULL,'JINETH B',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3600,NULL,'7376242AD194',NULL,NULL,NULL,'KALIMUTHU A',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3601,NULL,'7376242AD195',NULL,NULL,NULL,'KAMALESH G',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3602,NULL,'7376242AD196',NULL,NULL,NULL,'KANIMOZHI S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3603,NULL,'7376242AD197',NULL,NULL,NULL,'KARTHICK V',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3604,NULL,'7376242AD198',NULL,NULL,NULL,'KARTHIK RAJA S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3605,NULL,'7376242AD199',NULL,NULL,NULL,'KARTHIKEYAN J V',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3606,NULL,'7376242AD200',NULL,NULL,NULL,'KARTHIKEYAN V',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3607,NULL,'7376242AD201',NULL,NULL,NULL,'KAVINEAYAN R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3608,NULL,'7376242AD202',NULL,NULL,NULL,'KAVIYANIRANJAN R K',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3609,NULL,'7376242AD203',NULL,NULL,NULL,'KIRUBAKARAN B',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3610,NULL,'7376242AD204',NULL,NULL,NULL,'KIRUTHIKA M N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3611,NULL,'7376242AD205',NULL,NULL,NULL,'KISHOR S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3612,NULL,'7376242AD206',NULL,NULL,NULL,'KISHORE R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3613,NULL,'7376242AD207',NULL,NULL,NULL,'KOWSHICK M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3614,NULL,'7376242AD208',NULL,NULL,NULL,'MADHUKANTH M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3615,NULL,'7376242AD209',NULL,NULL,NULL,'MADHUMETHA D B',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3616,NULL,'7376242AD210',NULL,NULL,NULL,'MADHUVIDHYA P',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3617,NULL,'7376242AD211',NULL,NULL,NULL,'MAMTHA SRI P',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3618,NULL,'7376242AD212',NULL,NULL,NULL,'MANOJ P',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3619,NULL,'7376242AD213',NULL,NULL,NULL,'MANORANJAN M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3620,NULL,'7376242AD214',NULL,NULL,NULL,'MANORANJITH S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3621,NULL,'7376242AD215',NULL,NULL,NULL,'MARIYA CHRISTY V',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3622,NULL,'7376242AD216',NULL,NULL,NULL,'MEHILASHWARAN P',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3623,NULL,'7376242AD217',NULL,NULL,NULL,'MOHAMED IMRAN K',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3624,NULL,'7376242AD218',NULL,NULL,NULL,'MOHAMMED NADHEEM S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3625,NULL,'7376242AD219',NULL,NULL,NULL,'MOHAMMED SAHTIQ S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3626,NULL,'7376242AD220',NULL,NULL,NULL,'MOHANRAJ A',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3627,NULL,'7376242AD221',NULL,NULL,NULL,'MOUNESH A',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3628,NULL,'7376242AD222',NULL,NULL,NULL,'MOWLIESWARAN G',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3629,NULL,'7376242AD223',NULL,NULL,NULL,'MUGESH R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3630,NULL,'7376242AD224',NULL,NULL,NULL,'MUKESH S N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3631,NULL,'7376242AD225',NULL,NULL,NULL,'MURUGAN B',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3632,NULL,'7376242AD226',NULL,NULL,NULL,'MUTHAZHAGI E',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3633,NULL,'7376242AD227',NULL,NULL,NULL,'NAKSHATRA S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3634,NULL,'7376242AD228',NULL,NULL,NULL,'NANDANA A',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3635,NULL,'7376242AD229',NULL,NULL,NULL,'NANDHINI M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3636,NULL,'7376242AD230',NULL,NULL,NULL,'NANDITA A K',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3637,NULL,'7376242AD231',NULL,NULL,NULL,'NAVANEETHA KRISHNAN M S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3638,NULL,'7376242AD232',NULL,NULL,NULL,'NAVANEETHAN V K',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3639,NULL,'7376242AD233',NULL,NULL,NULL,'NETHRA R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3640,NULL,'7376242AD234',NULL,NULL,NULL,'NETRA M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3641,NULL,'7376242AD235',NULL,NULL,NULL,'NIRANJAN J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3642,NULL,'7376242AD236',NULL,NULL,NULL,'NIRANJAN R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3643,NULL,'7376242AD237',NULL,NULL,NULL,'NITHIKA S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3644,NULL,'7376242AD238',NULL,NULL,NULL,'NITHISH K',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3645,NULL,'7376242AD239',NULL,NULL,NULL,'NITHISH M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3646,NULL,'7376242AD240',NULL,NULL,NULL,'NITHISH R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3647,NULL,'7376242AD241',NULL,NULL,NULL,'NITHISHWARAN R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3648,NULL,'7376242AD242',NULL,NULL,NULL,'PASMITHA T',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3649,NULL,'7376242AD243',NULL,NULL,NULL,'PAVITHRA R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3650,NULL,'7376242AD244',NULL,NULL,NULL,'PAVITHRA S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3651,NULL,'7376242AD245',NULL,NULL,NULL,'PAVITHRA T',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3652,NULL,'7376242AD246',NULL,NULL,NULL,'PRADEEP RAJAN E',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3653,NULL,'7376242AD247',NULL,NULL,NULL,'S PRAGALYA',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3654,NULL,'7376242AD248',NULL,NULL,NULL,'PRAKASH A',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3655,NULL,'7376242AD249',NULL,NULL,NULL,'PRANAV J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3656,NULL,'7376242AD250',NULL,NULL,NULL,'PRANAV J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3657,NULL,'7376242AD251',NULL,NULL,NULL,'PRANAVI S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3658,NULL,'7376242AD252',NULL,NULL,NULL,'PRANESH KARTHI M S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3659,NULL,'7376242AD253',NULL,NULL,NULL,'PRASANTH S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3660,NULL,'7376242AD254',NULL,NULL,NULL,'PRATEEK D S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3661,NULL,'7376242AD255',NULL,NULL,NULL,'PRATHEEP S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3662,NULL,'7376242AD256',NULL,NULL,NULL,'PREETHI P',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3663,NULL,'7376242AD257',NULL,NULL,NULL,'PREETHIGAA B',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3664,NULL,'7376242AD258',NULL,NULL,NULL,'PRITHIVIKA R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3665,NULL,'7376242AD259',NULL,NULL,NULL,'PRIYADHARSHINI R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3666,NULL,'7376242AD260',NULL,NULL,NULL,'V PRIYAKSHANA',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3667,NULL,'7376242AD261',NULL,NULL,NULL,'PURUSHOTHAMAN L',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3668,NULL,'7376242AD262',NULL,NULL,NULL,'PUZHALMANI S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3669,NULL,'7376242AD263',NULL,NULL,NULL,'RABINESH S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3670,NULL,'7376242AD264',NULL,NULL,NULL,'RAGHAVI RAVISANKAR',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3671,NULL,'7376242AD265',NULL,NULL,NULL,'RAGUL V B',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3672,NULL,'7376242AD266',NULL,NULL,NULL,'RAHUL C',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3673,NULL,'7376242AD267',NULL,NULL,NULL,'RAHUL K',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3674,NULL,'7376242AD268',NULL,NULL,NULL,'RAHUL M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3675,NULL,'7376242AD269',NULL,NULL,NULL,'RASHMIKA N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3676,NULL,'7376242AD270',NULL,NULL,NULL,'RATHISHER V',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3677,NULL,'7376242AD271',NULL,NULL,NULL,'RAVI PRASANTH D',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3678,NULL,'7376242AD272',NULL,NULL,NULL,'RHYTHAN U T',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3679,NULL,'7376242AD273',NULL,NULL,NULL,'RIDA FATHIMA S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3680,NULL,'7376242AD274',NULL,NULL,NULL,'RITHIKA S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3681,NULL,'7376242AD275',NULL,NULL,NULL,'RITHISH M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3682,NULL,'7376242AD276',NULL,NULL,NULL,'RITHISHWAR D',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3683,NULL,'7376242AD277',NULL,NULL,NULL,'RITHVIKA K',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3684,NULL,'7376242AD278',NULL,NULL,NULL,'K S ROHIT',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3685,NULL,'7376242AD279',NULL,NULL,NULL,'ROHITH M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3686,NULL,'7376242AD280',NULL,NULL,NULL,'ROSHAN A',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3687,NULL,'7376242AD281',NULL,NULL,NULL,'ROSHINI K',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3688,NULL,'7376242AD282',NULL,NULL,NULL,'GOBINATH S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3689,NULL,'7376242AD283',NULL,NULL,NULL,'S SHARVESH',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3690,NULL,'7376242AD284',NULL,NULL,NULL,'SAKTHI M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3691,NULL,'7376242AD285',NULL,NULL,NULL,'SAMAN SATHYAN S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3692,NULL,'7376242AD286',NULL,NULL,NULL,'SANDHIYA M K',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3693,NULL,'7376242AD287',NULL,NULL,NULL,'SANJAI V S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3694,NULL,'7376242AD288',NULL,NULL,NULL,'SANJAY RATHINAM MARIMUTHU NITHYA',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3695,NULL,'7376242AD289',NULL,NULL,NULL,'SANJAY S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3696,NULL,'7376242AD290',NULL,NULL,NULL,'SANJITH A S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3697,NULL,'7376242AD291',NULL,NULL,NULL,'SANJIV K S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3698,NULL,'7376242AD292',NULL,NULL,NULL,'SANJIV V',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3699,NULL,'7376242AD293',NULL,NULL,NULL,'SANTHOSH K M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3700,NULL,'7376242AD294',NULL,NULL,NULL,'SARAN V',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3701,NULL,'7376242AD295',NULL,NULL,NULL,'SARAVANAKUMAR D',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3702,NULL,'7376242AD296',NULL,NULL,NULL,'SATCHINDRA R B',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3703,NULL,'7376242AD297',NULL,NULL,NULL,'SELVAGANAPATHY P',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3704,NULL,'7376242AD298',NULL,NULL,NULL,'SHALINI G',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3705,NULL,'7376242AD299',NULL,NULL,NULL,'SHRI KRISHNA S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3706,NULL,'7376242AD300',NULL,NULL,NULL,'SIDDESH KUMAR S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3707,NULL,'7376242AD301',NULL,NULL,NULL,'SIVAGURU M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3708,NULL,'7376242AD302',NULL,NULL,NULL,'SIVAGURU P',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3709,NULL,'7376242AD303',NULL,NULL,NULL,'SONIKA N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3710,NULL,'7376242AD304',NULL,NULL,NULL,'SOUNDARARAJAN R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3711,NULL,'7376242AD305',NULL,NULL,NULL,'SOWBARANI H',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3712,NULL,'7376242AD306',NULL,NULL,NULL,'SREEVIBU S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3713,NULL,'7376242AD307',NULL,NULL,NULL,'SRI CHARAN S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3714,NULL,'7376242AD308',NULL,NULL,NULL,'SRI SABARI SRINIVAS S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3715,NULL,'7376242AD309',NULL,NULL,NULL,'SRI VAJANA S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3716,NULL,'7376242AD310',NULL,NULL,NULL,'SRI VITHYA MIRUTHULA S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3717,NULL,'7376242AD311',NULL,NULL,NULL,'SRIDEVI R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3718,NULL,'7376242AD312',NULL,NULL,NULL,'SRIDHAR R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3719,NULL,'7376242AD313',NULL,NULL,NULL,'SRINISHANTH S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3720,NULL,'7376242AD314',NULL,NULL,NULL,'SRINIVASAN P A',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3721,NULL,'7376242AD315',NULL,NULL,NULL,'M SUBHIKSHA',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3722,NULL,'7376242AD316',NULL,NULL,NULL,'SUBIKA S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3723,NULL,'7376242AD317',NULL,NULL,NULL,'SUDHARSUN A S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3724,NULL,'7376242AD318',NULL,NULL,NULL,'SUJITH KUMAR S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3725,NULL,'7376242AD319',NULL,NULL,NULL,'SUMANRAAJ SELVAN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3726,NULL,'7376242AD320',NULL,NULL,NULL,'SUNIL KRISHNAA K',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3727,NULL,'7376242AD321',NULL,NULL,NULL,'SURIYA KRISHNA M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3728,NULL,'7376242AD322',NULL,NULL,NULL,'SUWETHA M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3729,NULL,'7376242AD323',NULL,NULL,NULL,'SYED AFRIDEEN S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3730,NULL,'7376242AD324',NULL,NULL,NULL,'TAMILMARAN S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3731,NULL,'7376242AD325',NULL,NULL,NULL,'THARUN KIRUTHIK K S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3732,NULL,'7376242AD326',NULL,NULL,NULL,'THEJASHRREE C',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3733,NULL,'7376242AD327',NULL,NULL,NULL,'THILAKESWARAN D G',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3734,NULL,'7376242AD328',NULL,NULL,NULL,'THIYANESH D',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3735,NULL,'7376242AD329',NULL,NULL,NULL,'UTHAYAKUMAR M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3736,NULL,'7376242AD330',NULL,NULL,NULL,'VARISHA FEMIN A',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3737,NULL,'7376242AD331',NULL,NULL,NULL,'VARSHA SHREE A',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3738,NULL,'7376242AD332',NULL,NULL,NULL,'VARSHINI V',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3739,NULL,'7376242AD333',NULL,NULL,NULL,'VASANTH KUMAR T',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3740,NULL,'7376242AD334',NULL,NULL,NULL,'VASANTH T M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3741,NULL,'7376242AD335',NULL,NULL,NULL,'VASUNDRA C',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3742,NULL,'7376242AD336',NULL,NULL,NULL,'VEERENDRA C',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3743,NULL,'7376242AD337',NULL,NULL,NULL,'VETRIAGILAN J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3744,NULL,'7376242AD338',NULL,NULL,NULL,'VIBAKAR S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3745,NULL,'7376242AD339',NULL,NULL,NULL,'VIDHYA P',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3746,NULL,'7376242AD340',NULL,NULL,NULL,'VIGNESHWARAN T',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3747,NULL,'7376242AD341',NULL,NULL,NULL,'VIJAY HARIPRIYAN D',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3748,NULL,'7376242AD342',NULL,NULL,NULL,'VIKNESHKUMAR G J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3749,NULL,'7376242AD343',NULL,NULL,NULL,'VISHNUDHARAN M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3750,NULL,'7376242AD344',NULL,NULL,NULL,'VIVIN C',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3751,NULL,'7376242AD345',NULL,NULL,NULL,'YAKSHANA M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3752,NULL,'7376242AD346',NULL,NULL,NULL,'DHARSHINI S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3753,NULL,'7376252AD501',NULL,NULL,NULL,'AAKASH V',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3754,NULL,'7376252AD502',NULL,NULL,NULL,'CHELLADHURAI V V',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3755,NULL,'7376252AD503',NULL,NULL,NULL,'DHARANESH S P',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3756,NULL,'7376252AD504',NULL,NULL,NULL,'HARIHARASUDHAN S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3757,NULL,'7376252AD505',NULL,NULL,NULL,'HARISH S',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3758,NULL,'7376252AD506',NULL,NULL,NULL,'JAIAKASH N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3759,NULL,'7376252AD507',NULL,NULL,NULL,'KALAIYARASI K',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3760,NULL,'7376252AD508',NULL,NULL,NULL,'NANDIDA K',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3761,NULL,'7376252AD509',NULL,NULL,NULL,'PONNKAVI D',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3762,NULL,'7376252AD510',NULL,NULL,NULL,'PRABANJAN R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3763,NULL,'7376252AD511',NULL,NULL,NULL,'SABARI R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3764,NULL,'7376252AD512',NULL,NULL,NULL,'SHANJAI PRAKASH A K',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3765,NULL,'7376252AD513',NULL,NULL,NULL,'SURYA R',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3766,NULL,'7376252AD514',NULL,NULL,NULL,'TEJASSRI M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3767,NULL,'7376252AD515',NULL,NULL,NULL,'THARUN SARWIN A',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14),(3768,NULL,'7376252AD516',NULL,NULL,NULL,'VISHAL M',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,14);
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `syllabus`
--

DROP TABLE IF EXISTS `syllabus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `syllabus` (
  `id` int NOT NULL AUTO_INCREMENT,
  `model_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `position` int DEFAULT '0',
  `course_id` int NOT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `syllabus_models_fk_courses` (`course_id`) USING BTREE,
  CONSTRAINT `syllabus_models_fk_courses` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `syllabus`
--

LOCK TABLES `syllabus` WRITE;
/*!40000 ALTER TABLE `syllabus` DISABLE KEYS */;
INSERT INTO `syllabus` VALUES (23,'Unit 1','Unit 1',0,13,0),(24,'Unit 1','Unit 1',0,14,0),(25,'Unit 1','Unit 1',0,15,0),(26,'Unit 1','Unit 1',0,16,0),(27,'Unit 1','Unit 1',0,22,0),(28,'Unit 1','Unit 1',0,19,0),(29,'Unit 1','Unit 1',0,88,0),(30,'Unit 1','Unit 1',0,90,0);
/*!40000 ALTER TABLE `syllabus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `syllabus_titles`
--

DROP TABLE IF EXISTS `syllabus_titles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `syllabus_titles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `model_id` int NOT NULL,
  `hours` int DEFAULT '0',
  `title` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `position` int DEFAULT '0',
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `model_id` (`model_id`) USING BTREE,
  CONSTRAINT `syllabus_titles_ibfk_1` FOREIGN KEY (`model_id`) REFERENCES `syllabus` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `syllabus_titles`
--

LOCK TABLES `syllabus_titles` WRITE;
/*!40000 ALTER TABLE `syllabus_titles` DISABLE KEYS */;
INSERT INTO `syllabus_titles` VALUES (19,23,1,'check',0,0),(20,24,1,'delete',0,0),(21,25,2,'check 1',0,0),(22,26,1,'checkc',0,0),(23,27,1,'check main',0,0),(24,28,1,'check main',0,0),(25,29,2,'hello',0,0),(26,30,1,'hello',0,0);
/*!40000 ALTER TABLE `syllabus_titles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `syllabus_topics`
--

DROP TABLE IF EXISTS `syllabus_topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `syllabus_topics` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title_id` int NOT NULL,
  `topic` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `position` int DEFAULT '0',
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `title_id` (`title_id`) USING BTREE,
  CONSTRAINT `syllabus_topics_ibfk_1` FOREIGN KEY (`title_id`) REFERENCES `syllabus_titles` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `syllabus_topics`
--

LOCK TABLES `syllabus_topics` WRITE;
/*!40000 ALTER TABLE `syllabus_topics` DISABLE KEYS */;
INSERT INTO `syllabus_topics` VALUES (31,19,'check ',0,0),(32,20,'delete',0,0),(33,21,'check 1',0,0),(34,22,'checkc',0,0),(35,23,'check main',0,0),(36,24,'check main',0,0),(37,25,'hello',0,0);
/*!40000 ALTER TABLE `syllabus_topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teacher_course_allocation`
--

DROP TABLE IF EXISTS `teacher_course_allocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teacher_course_allocation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `teacher_id` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_assignment` (`course_id`,`teacher_id`),
  KEY `fk_allocation_teacher_new` (`teacher_id`),
  CONSTRAINT `fk_allocation_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_allocation_teacher_new` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`faculty_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=218 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teacher_course_allocation`
--

LOCK TABLES `teacher_course_allocation` WRITE;
/*!40000 ALTER TABLE `teacher_course_allocation` DISABLE KEYS */;
INSERT INTO `teacher_course_allocation` VALUES (115,135,'AG10092'),(102,144,'MA10071'),(103,145,'PH11015');
/*!40000 ALTER TABLE `teacher_course_allocation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teachers`
--

DROP TABLE IF EXISTS `teachers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teachers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `faculty_id` varchar(45) NOT NULL,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `profile_img` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `dept` varchar(100) DEFAULT NULL,
  `desg` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `last_login` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  UNIQUE KEY `email` (`email`) USING BTREE,
  UNIQUE KEY `uq_faculty_id` (`faculty_id`),
  KEY `fk_teachers_dept` (`dept`)
) ENGINE=InnoDB AUTO_INCREMENT=11308 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teachers`
--

LOCK TABLES `teachers` WRITE;
/*!40000 ALTER TABLE `teachers` DISABLE KEYS */;
INSERT INTO `teachers` VALUES (11211,'MA10071','Mrs.PREETHA R','preetha@bitsathy.ac.in','234253443',NULL,'14','Professor','2026-01-30 10:45:39',1),(11212,'PH11015','Dr.GOPI G','gopi@bitsathy.ac.in','23423423343',NULL,'1','Professor','2026-01-30 10:45:39',1),(11222,'AG10092','Dr.VASUDEVAN M','vasudevan@bitsathy.ac.in','+918838879911',NULL,'2','Professor','2026-01-30 10:45:42',1);
/*!40000 ALTER TABLE `teachers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `full_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `role` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'user',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_login` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `username` (`username`) USING BTREE,
  UNIQUE KEY `email` (`email`) USING BTREE,
  KEY `idx_username` (`username`) USING BTREE,
  KEY `idx_email` (`email`) USING BTREE,
  KEY `idx_role` (`role`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','admin123','System Administrator','admin@example.com','admin',1,'2026-01-07 05:52:45','2026-02-02 11:36:52','2026-02-02 17:06:51'),(2,'hr','hr123','hr','parkavi@bitsathy.ac.in','hr',1,'2026-01-31 06:25:55','2026-01-31 09:35:00','2026-01-31 15:05:00'),(3,'hod','hod123','hod','preetha@bitsathy.ac.in','hod',1,'2026-01-31 06:25:57','2026-02-02 12:08:02','2026-02-02 17:38:01'),(4,'hod1','hod123','hod','gopi@bitsathy.ac.in','hod',1,'2026-02-02 10:57:44','2026-02-02 12:06:12','2026-02-02 16:28:41');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-02 17:42:12
