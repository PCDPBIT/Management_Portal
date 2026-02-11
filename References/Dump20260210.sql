-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: 10.10.12.99    Database: cms_test2
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
  `year_level` int NOT NULL COMMENT '1-4 (year of study)',
  `current_semester` int NOT NULL COMMENT '1-8',
  `semester_start_date` date NOT NULL,
  `semester_end_date` date NOT NULL,
  `elective_selection_start` date DEFAULT NULL COMMENT 'When students can start selecting electives',
  `elective_selection_end` date DEFAULT NULL COMMENT 'Deadline for student elective selection',
  `teacher_course_selection_start` date DEFAULT NULL,
  `teacher_course_selection_end` date DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT '0' COMMENT 'Current row per year_level',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_academic_year_year_level_semester` (`academic_year`,`year_level`,`current_semester`),
  KEY `idx_is_current` (`is_current`),
  KEY `idx_year_level` (`year_level`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_calendar`
--

LOCK TABLES `academic_calendar` WRITE;
/*!40000 ALTER TABLE `academic_calendar` DISABLE KEYS */;
INSERT INTO `academic_calendar` VALUES (1,'2025-2026',1,1,'2026-01-01','2026-05-30',NULL,NULL,NULL,NULL,1,'2026-02-09 10:39:50','2026-02-09 10:50:26'),(2,'2025-2026',2,3,'2026-01-01','2026-05-30','2026-02-01','2026-02-15',NULL,NULL,1,'2026-02-09 10:39:50','2026-02-09 10:50:26'),(3,'2025-2026',3,5,'2026-01-01','2026-05-30','2026-02-01','2026-02-15',NULL,NULL,1,'2026-02-09 10:39:50','2026-02-09 10:50:27'),(4,'2025-2026',4,7,'2026-01-01','2026-05-30','2026-02-01','2026-02-15',NULL,NULL,1,'2026-02-09 10:39:50','2026-02-09 10:50:27');
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
INSERT INTO `course_experiment_topics` VALUES (12,4,'Assess the physical parameters of different materials for engineering applications like radius, thickness and\ndiameter to design the electrical wires, bridges and clothes',0,'2026-01-06 22:55:43',1),(13,4,'Evaluate the elastic nature of different solid materials for modern industrial applications like shock absorbers\nof vehicles',1,'2026-01-06 22:55:43',1),(14,11,'Rank of a Matrix',0,'2026-01-22 05:34:33',1),(15,12,'Assess the physical parameters of different materials for engineering applications like radius, thickness and\r\ndiameter to design the electrical wires, bridges and clothes.',0,'2026-02-03 04:51:25',1),(16,13,'Evaluate the elastic nature of different solid materials for modern industrial applications like shock\r\nabsorbers of vehicles.',0,'2026-02-03 04:51:41',1),(17,14,'Analyze the photonic behavior of thin materials for advanced optoelectronic applications like adjusting a\r\npatient’s head, chest and neck positions as a medical tool.',0,'2026-02-03 04:51:53',1),(18,15,'Investigate the phonon behavior of poor conductors for thermionic applications like polymer materials and\r\ntextile materials.',0,'2026-02-03 04:52:10',1),(19,16,'Assess the elongation of different solid materials for industrial applications like buildings, bridges and\r\nvehicles',0,'2026-02-03 04:52:26',1),(20,17,'Analysis of various business sectors',0,'2026-02-03 05:23:39',1),(21,18,'Developing a Design Thinking Output Chart',0,'2026-02-03 05:23:50',1),(22,19,'Creating Buyer Personas',0,'2026-02-03 05:24:01',1),(23,20,'Undertake Market Study to understand market needs and assess market potential',0,'2026-02-03 05:24:19',1),(24,21,'Preparation of Business Model Canvas',0,'2026-02-03 05:24:32',1),(25,22,'Developing Prototypes',0,'2026-02-03 05:24:57',1),(26,23,'Organizing Product Design Sprints',0,'2026-02-03 05:25:10',1),(27,24,'Preparation of Business Plans',0,'2026-02-03 05:25:19',1),(28,25,'Preparation of Pitch Decks',0,'2026-02-03 05:25:30',1);
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
INSERT INTO `course_experiments` VALUES (4,83,1,'Experiment 1',3,'2026-01-06 22:46:38','2026-01-06 22:55:43',1),(5,83,2,'Experiment 2',7,'2026-01-06 22:50:01','2026-01-06 22:50:01',1),(6,83,3,'Experiment 3',4,'2026-01-06 22:50:11','2026-01-06 22:50:11',1),(10,83,4,'Experiment 4',8,'2026-01-06 23:00:23','2026-01-06 23:00:23',1),(11,17,1,'Experiment 1',5,'2026-01-22 05:33:16','2026-01-22 05:34:14',1),(12,103,1,'Experiment 1',5,'2026-02-03 04:50:59','2026-02-03 04:50:59',1),(13,103,2,'Experiment 2',5,'2026-02-03 04:51:33','2026-02-03 04:51:33',1),(14,103,3,'Experiment 3',5,'2026-02-03 04:51:47','2026-02-03 04:51:47',1),(15,103,4,'Experiment 4',4,'2026-02-03 04:52:01','2026-02-03 04:52:01',1),(16,103,5,'Experiment 5',5,'2026-02-03 04:52:16','2026-02-03 04:52:16',1),(17,108,1,'Experiment 1',1,'2026-02-03 05:23:32','2026-02-03 05:23:32',1),(18,108,2,'Experiment 2',2,'2026-02-03 05:23:44','2026-02-03 05:23:44',1),(19,108,3,'Experiment 3',1,'2026-02-03 05:23:55','2026-02-03 05:23:55',1),(20,108,4,'Experiment 4',3,'2026-02-03 05:24:10','2026-02-03 05:24:10',1),(21,108,5,'Experiment 5',2,'2026-02-03 05:24:26','2026-02-03 05:24:26',1),(22,108,6,'Experiment 6',15,'2026-02-03 05:24:52','2026-02-03 05:24:52',1),(23,108,7,'Experiment 7',7,'2026-02-03 05:25:06','2026-02-03 05:25:06',1),(24,108,8,'Experiment 8',2,'2026-02-03 05:25:16','2026-02-03 05:25:16',1),(25,108,9,'Experiment 9',2,'2026-02-03 05:25:27','2026-02-03 05:25:27',1);
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
INSERT INTO `course_objectives` VALUES (4,83,'To impart mathematical modeling to describe and explore real-world phenomena and data.',0,1),(5,83,'To provide basic understanding on Linear, quadratic, power and polynomial, exponential, and multi variable models',1,1),(6,83,'Summarize and apply the methodologies involved in framing the real world problems related to fundamental principles of polynomial equations',2,1),(10,17,'To impart mathematical modeling to describe and explore real-world phenomena and data',0,1),(11,17,'To provide basic understanding on Linear, quadratic, power and polynomial, exponential, and multi variable models',1,1),(12,17,'To summarize and apply the methodologies involved in framing the real-world problems related to fundamental principles of polynomial equations',2,1),(13,103,'Understand the concept and principle of energy possessed by mechanical system',0,1),(14,103,'Exemplify the propagation and exchange of energy',1,1),(15,103,'Identify the properties of materials based on the energy possession',2,1),(16,109,'Describe the linguistic diversity in India, highlighting Dravidian languages and their features.',0,1),(17,109,'Summarize the evolution of art, highlighting key transitions from rock art to modern sculptures.',1,1),(18,109,'Examine the role of sports and games in promoting cultural values and community bonding.',2,1),(19,109,'Discuss the education and literacy systems during the Sangam Age and their impact.',3,1),(20,109,'Outline the importance of inscriptions, manuscripts, and the print history of Tamil books in preserving knowledge and culture.',4,1),(21,108,'Promote entrepreneurial spirit and motivate to build startups',0,1),(22,108,'Provide insights on markets and the dynamics of buyer behaviour',1,1),(23,108,'Train to develop prototypes and refine them to a viable market offering',2,1),(24,108,'Support in developing marketing strategies and financial outlay',3,1),(25,108,'Enable to scale up the prototypes to commercial market offering',4,1),(26,106,'Heighten awareness of grammar in oral and written expression',0,1),(27,106,'Improve speaking potential in formal and informal contexts',1,1),(28,106,'Improve reading fluency and increased vocabulary',2,1),(29,106,'Prowess in interpreting complex texts',3,1),(30,106,'Fluency and comprehensibility in self-expression',4,1),(31,106,'Develop abilities as critical readers and writers',5,1),(32,106,'Improve ability to summarize information from longer text, and distinguish between primary and supporting ideas',6,1);
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
INSERT INTO `course_outcomes` VALUES (136,83,'Implement the concepts of mathematical modeling based on linear functions in Engineering.',0,1),(137,83,'Formulate the real-world problems as a quadratic function model',1,1),(138,83,'Demonstrate the real-world phenomena and data into Power and Polynomial functions',2,1),(139,83,'Apply the concept of mathematical modeling of exponential functions in Engineering',3,1),(140,17,'Implement the concepts of mathematical modeling based on linear functions in Engineering',0,1),(141,17,'Formulate the real-world problems as a quadratic function model',1,1),(142,17,'Demonstrate the real-world phenomena and data into Power and Polynomial functions',2,1),(143,17,'Apply the concept of mathematical modeling of exponential functions in Engineering',3,1),(144,17,'Develop the identification of multivariable functions in the physical dynamical problems',4,1),(145,103,'Apply the work-energy theorem to analyze and optimize mechanical system performance.',0,1),(146,103,'Analyze free and forced mechanical oscillations in vibrational energy systems.',1,1),(147,103,'Analyze the propagation of energy in mechanical systems through transverse and longitudinal waves.',2,1),(148,103,'Analyze the exchange of energy and work between the systems using thermodynamic principles.',3,1),(149,103,'Apply the concept of energy and entropy to understand the mechanical properties of materials.',4,1),(150,109,'Understand the concept of language families in India, with a focus on Dravidian languages',0,1),(151,109,'Trace the evolution of art from ancient rock art to modern sculptures in Tamil heritage.',1,1),(152,109,'Identify and differentiate various forms of folk and martial arts in Tamil heritage.',2,1),(153,109,'Understand the concepts of Flora and Fauna in Tamil culture and literature.',3,1),(154,109,'Evaluate the contributions of Tamils to the Indian Freedom Struggle.',4,1),(155,108,'Generate valid and feasible business ideas.',0,1),(156,108,'Create Business Model Canvas and formulate positioning statement',1,1),(157,108,'Invent prototypes that fulfills an unmet market need.',2,1),(158,108,'Formulate business strategies and create pitch decks.',3,1),(159,108,'Choose appropriate strategies for commercialization.',4,1),(160,106,'Express themselves in a professional manner using error-free language',0,1),(161,106,'Express in both descriptive and narrative formats',1,1),(162,106,'Interpret and make effective use of the English Language in Business contexts',2,1),(163,106,'Actively read and comprehend authentic text',3,1),(164,106,'Express opinions and communicate experiences.',4,1);
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
INSERT INTO `course_references` VALUES (13,103,'C J Fischer, The energy of Physics Part I: Classical Mechanics and Thermodynamics, Cognella Academic Publishing, 2019.',0,1),(14,103,'P G Hewitt, Conceptual Physics, Pearson education, 2017',1,1),(15,103,'R A Serway and J W Jewitt, Physics for Scientists and Engineers, Thomson Brooks/Cole, 2019',2,1),(16,103,'J Walker, D Halliday and R Resnick, Principles of Physics, John Wiley and Sons, Inc, 2018',3,1),(17,103,'H C Verma, Concepts of Physics (Vol I & II), Bharathi Bhawan Publishers & Distributors, New Delhi, 2017',4,1),(18,17,'Erwin Kreyszig, Advanced Engineering Mathematics, Tenth Edition, Wiley India Private Limited, New Delhi 2016',0,1),(19,17,'B. S. Grewal, Numerical Methods in Engineering & Science: With Programs in C, C++ & MATLAB, Khanna, 2014',1,1),(20,17,'S.C. Gupta, V.K. Kapoor, Fundamentals of Mathematical Statistics, Sultan Chand & Sons2020',2,1),(21,17,'Thomas and Finney, Calculus and analytic Geometry, Fourteenth Edition, By Pearson Paperback, 2018',3,1),(22,109,'Dr.K.K.Pillay , Social Life of Tamils, A joint publication of TNTB & ESC and RMRL.',0,1),(23,109,'Dr.S.Singaravelu, Social Life of the Tamils - The Classical Period, International Institute of Tamil Studies',1,1),(24,109,'Dr.S.V.Subatamanian, Dr.K.D. Thirunavukkarasu, Historical Heritage of the Tamils, International Institute of Tamil Studies',2,1),(25,109,'Dr.M.Valarmathi, The Contributions of the Tamils to Indian Culture, International Institute of Tamil Studies',3,1),(26,109,'Keeladi, Sangam City Civilization on the banks of river Vaigai, Department of Archaeology & Tamil Nadu Text Book and Educational Services Corporation, Tamil Nadu',4,1),(27,109,'Dr.K.K.Pillay, Studies in the History of India with Special Reference to Tamil Nadu.',5,1),(28,109,'Porunai Civilization, Department of Archaeology & Tamil Nadu Text Book and Educational Services Corporation, Tamil Nadu',6,1),(29,109,'R.Balakrishnan, Journey of Civilization Indus to Vaigai, RMRL',7,1),(30,108,'Rashmi Bansal, Connect the Dots, Westland and Tranquebar Press, 2012',0,1),(31,108,'Pavan Soni, Design Your Thinking: The Mindsets, Toolsets and Skill Sets for Creative Problemsolving, Penguin Random House India, 2020',1,1),(32,108,'Ronnie Screwvala, Dream with Your Eyes Open: An Entrepreneurial Journey, Rupa Publications, 2015',2,1),(33,108,'Stephen Carter, The Seed Tree: Money Management and Wealth Building Lessonsfor Teens, Seed Tree Group, 2021',3,1),(34,108,'Kotler Philip, Marketing Management, Pearson Education India, 15th Edition',4,1),(35,108,'Elizabeth Verkey and Jithin Saji Isaac, Intellectual Property, Eastern Book Company, 2nd Edition, 2021',5,1);
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
INSERT INTO `course_selflearning` VALUES (1,17,0,1),(2,22,0,1),(3,83,0,1),(17,17,0,1),(103,103,0,1),(106,106,0,1),(108,108,0,1),(109,109,0,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=2174 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_student_teacher_allocation`
--

LOCK TABLES `course_student_teacher_allocation` WRITE;
/*!40000 ALTER TABLE `course_student_teacher_allocation` DISABLE KEYS */;
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
INSERT INTO `course_teamwork` VALUES (1,17,0,1),(2,22,0,1),(3,83,0,1),(17,17,0,1),(103,103,0,1),(106,106,0,1),(108,108,0,1),(109,109,0,1);
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
  `course_id` int NOT NULL,
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
  `name` varchar(50) NOT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_type`
--

LOCK TABLES `course_type` WRITE;
/*!40000 ALTER TABLE `course_type` DISABLE KEYS */;
INSERT INTO `course_type` VALUES (1,'Theory',1),(2,'Lab',1),(3,'Theory with Lab',1);
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
  `course_type` int DEFAULT NULL,
  `credit` int DEFAULT NULL,
  `lecture_hrs` int DEFAULT '0',
  `tutorial_hrs` int DEFAULT '0',
  `practical_hrs` int DEFAULT '0',
  `activity_hrs` int DEFAULT '0',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `cia_marks` int DEFAULT '40',
  `see_marks` int DEFAULT '60',
  `total_marks` int DEFAULT NULL,
  `theory_total_hrs` int DEFAULT '0',
  `tutorial_total_hrs` int DEFAULT '0',
  `practical_total_hrs` int DEFAULT NULL,
  `activity_total_hrs` int DEFAULT '0',
  `tw/sl` int DEFAULT NULL,
  `visibility` enum('UNIQUE','CLUSTER') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'UNIQUE',
  `source_curriculum_id` int DEFAULT NULL,
  `curriculum_ref_id` int DEFAULT NULL,
  `total_hrs` int DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_course_type` (`course_type`),
  CONSTRAINT `fk_course_type` FOREIGN KEY (`course_type`) REFERENCES `course_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=610 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES (1,'CS101','Introduction to Programming',1,3,0,0,0,0,'Core',40,60,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(2,'CS3801','Cloud Computing',1,3,0,0,0,0,'Elective',40,60,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(3,'CS201','Data Structures',1,4,3,1,0,0,'Core',40,60,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(4,'CS3501','Database Management Systems',1,4,3,1,2,0,'Core',40,60,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(17,'22MA101','ENGINEERING MATHEMATICS I ',1,4,3,1,0,1,'BS - Basic Sciences',40,60,100,45,15,0,15,0,'CLUSTER',NULL,NULL,75,1),(18,'22PH102 ','ENGINEERING PHYSICS ',1,3,2,0,2,3,'BS - Basic Sciences',50,50,100,30,0,30,45,0,'UNIQUE',NULL,NULL,105,1),(19,'22CSH01 ','EXPLORATORY DATA ANALYSIS ',1,3,2,0,2,300,'PE - Professional Elective',40,60,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(20,'26MA101','Linear Algebra and Calculus',1,4,3,1,0,0,'ES - Engineering Sciences',40,60,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(21,'26PH102','Engineering Physics',1,3,3,1,0,0,'ES - Engineering Sciences',45,55,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(22,'26CH103','Engineering Chemistry',1,2,2,0,0,0,'ES - Engineering Sciences',30,70,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(23,'26GE004','Digital Computer Electronics',1,3,3,0,0,0,'ES - Engineering Sciences',45,55,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(24,'26GE005','Problem Solving using C',1,3,2,0,0,0,'ES - Engineering Sciences',30,70,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(25,'26HS001','Communicative English',1,2,2,0,0,0,'HSS - Humanities and Social Sciences',30,70,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(26,'26HS002','தமிழர் மரபு / Heritage of Tamils ',1,1,1,0,0,0,'HSS - Humanities and Social Sciences',15,85,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(30,'26MA201','Differential Equations and Transforms',1,4,3,1,0,0,'ES - Engineering Sciences',60,40,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(31,'26PH202','Materials Science',1,3,3,0,0,0,'BS - Basic Sciences',45,55,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(32,'26CS203','Fundamentals of Web Principles',1,3,3,0,0,0,'ES - Engineering Sciences',45,55,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(33,'26CS204','Computer Organization and Architecture',1,3,3,0,0,0,'ES - Engineering Sciences',45,55,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(34,'26GE007','Python Programming',1,3,3,0,0,0,'ES - Engineering Sciences',45,55,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(35,'26HS005','Professional Communication',1,2,2,0,0,0,'HSS - Humanities and Social Sciences',30,70,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(36,'26HS006','தமிழரும் தொழில்நுட்பமும் / Tamils and Technology',1,1,1,0,0,0,'HSS - Humanities and Social Sciences',15,85,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(40,'26CS301','Discrete Mathematics',1,4,3,1,0,0,'BS - Basic Sciences',60,60,120,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(41,'26CS302','Data Structures and Algorithms',1,3,3,0,0,0,'ES - Engineering Sciences',45,55,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(42,'26CS303','Operating Systems',1,3,3,0,0,0,'ES - Engineering Sciences',45,55,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(43,'26CS304','Object Oriented Programming with Java',1,3,2,0,2,0,'ES',30,70,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(44,'26CS305','Software Engineering',1,3,3,0,0,0,'ES - Engineering Sciences',45,55,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(45,'26CS306','Database Management Systems',1,3,3,0,0,0,'ES - Engineering Sciences',45,55,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(46,'26CS307','Standards in Computer Science',1,1,1,0,0,0,'ES - Engineering Sciences',15,85,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(50,'26CS401','Probability and Statistics',1,4,3,1,0,0,'ES - Engineering Sciences',60,40,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(51,'26CS402','Full Stack Development',1,3,3,0,0,0,'ES - Engineering Sciences',45,55,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(52,'26CS403','Artificial Intelligence Essentials',1,3,3,0,0,0,'ES',45,55,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(53,'26CS404','Design and Analysis of Algorithms',1,3,3,0,0,0,'ES - Engineering Sciences',45,55,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(54,'26CS405','Theory of Computation',1,4,3,1,0,0,'ES - Engineering Sciences',60,40,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(55,'26CS406','Computer Networks',1,3,3,0,0,0,'ES - Engineering Sciences',45,55,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(56,'26HS009','Environmental Sciences and Sustainability ',1,2,2,0,0,0,'HSS - Humanities and Social Sciences',30,70,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(58,'26CS409','Computer Networks Laboratory',2,1,0,0,2,0,'ES',40,60,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(60,'26CS501','Compiler Design',1,4,3,1,0,0,'ES - Engineering Sciences',60,40,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(61,'26CS502','Cloud Infrastructure Services',1,3,3,0,0,0,'ES - Engineering Sciences',45,55,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(62,'26CS503','Bigdata Analytics',1,3,3,0,0,0,'ES - Engineering Sciences',45,55,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(63,'26CS504','Machine Learning Essentials',1,3,3,0,0,0,'ES - Engineering Sciences',45,55,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(64,'26XXIV','Professional Elective IV',1,3,0,0,0,0,'ES',40,60,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(68,'26CS601','Software Project Management and Quality Assurance',1,3,3,0,0,0,'ES - Engineering Sciences',45,55,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(69,'26CS602','Deep Learning',1,3,3,0,0,0,'ES - Engineering Sciences',45,55,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(70,'26CS603','Cryptography and Cyber Security',1,3,3,0,0,0,'ES - Engineering Sciences',45,55,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(74,'26CS701','Generative AI and Large Language Models',1,3,3,0,0,0,'ES - Engineering Sciences',45,55,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(75,'26CS702','IoT and Edge Computing',1,3,3,0,0,0,'ES - Engineering Sciences',45,55,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(76,'26XXIV','Professional Elective IV',1,3,0,0,0,0,'ES',40,60,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(77,'26XXV','Professional Elective V',1,3,0,0,0,0,'ES',40,60,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(78,'26XXVI','Professional Elective VI',1,3,0,0,0,0,'ES - Engineering Sciences',40,60,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(82,'hello','efvwbg',1,2,1,0,2,0,'ES - Engineering Sciences',40,60,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(83,'wcnejce','ervewvwrv',1,3,0,0,0,0,'BS - Basic Sciences',40,60,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(84,'bdzhgd','bgbdfb',1,2,1,134,0,0,'ES - Engineering Sciences',40,60,100,13,0,NULL,0,NULL,'UNIQUE',NULL,NULL,13,1),(85,'CS130','check1',1,3,3,15,0,30,'BS - Basic Sciences',40,60,100,45,0,NULL,0,NULL,'UNIQUE',NULL,NULL,45,1),(86,'CS230','check 2',1,3,3,1,0,2,'ES - Engineering Sciences',40,60,100,0,0,NULL,0,NULL,'UNIQUE',NULL,NULL,0,1),(87,'CS303','check 3',1,3,3,1,0,2,'BS - Basic Sciences',40,60,100,45,15,NULL,30,NULL,'UNIQUE',NULL,NULL,90,1),(88,'cs102323','check4',2,3,0,0,3,0,'BS - Basic Sciences',40,60,100,0,0,45,0,10,'UNIQUE',NULL,NULL,45,1),(89,'CS134','check5',3,3,2,1,1,0,'ES - Engineering Sciences',40,60,100,30,15,15,0,0,'UNIQUE',NULL,NULL,60,1),(90,'CS140','1check2022',1,3,1,2,0,0,'ES - Engineering Sciences',40,60,100,15,30,0,0,0,'UNIQUE',NULL,NULL,45,1),(91,'CS120','2Check2022',2,32,1,2,1,0,'BS - Basic Sciences',40,60,100,15,30,15,0,0,'UNIQUE',NULL,NULL,60,1),(92,'CS150','3maincheck',2,3,2,2,4,0,'PE - Professional Elective',40,60,100,30,30,60,0,0,'UNIQUE',NULL,NULL,120,1),(93,'CS1','check2026theory',1,3,1,2,0,3,'BS - Basic Sciences',40,60,100,15,30,0,45,0,'UNIQUE',NULL,NULL,90,1),(94,'CS2','check2026lab',2,3,1,2,3,1,'ES - Engineering Sciences',40,60,100,15,30,45,15,10,'UNIQUE',NULL,NULL,105,1),(95,'CS3','check 123',2,3,1,2,3,3,'ES - Engineering Sciences',40,60,100,0,0,45,0,10,'UNIQUE',NULL,NULL,45,1),(96,'CS1234','1234',1,3,1,3,3,1,'HSS - Humanities and Social Sciences',40,60,100,15,45,0,15,0,'UNIQUE',NULL,NULL,75,1),(97,'CS789','hello',1,3,1,2,0,1,'ES - Engineering Sciences',40,60,100,15,30,0,15,0,'UNIQUE',NULL,NULL,60,1),(98,'CS190','2026 theory check',1,3,1,2,0,1,'ES - Engineering Sciences',40,60,100,15,30,0,15,0,'UNIQUE',NULL,NULL,60,1),(99,'CS600','theory check',1,3,1,2,0,0,'BS - Basic Sciences',40,60,100,15,30,0,0,0,'UNIQUE',NULL,NULL,45,1),(100,'CS601','lathery',2,3,0,0,2,0,'ES - Engineering Sciences',40,60,100,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(101,'CS603','theory&labcheck',3,3,2,2,1,0,'ES - Engineering Sciences',40,60,100,30,30,15,0,0,'UNIQUE',NULL,NULL,75,1),(102,'22MA2','ENGINEERING MATHEMATICS I',1,3,45,15,0,0,'BS - Basic Sciences',40,60,100,675,225,0,0,0,'UNIQUE',NULL,NULL,900,1),(103,'22PH102','ENGINEERING PHYSICS ',3,3,30,0,30,0,'BS - Basic Sciences',50,50,100,450,0,450,0,0,'UNIQUE',NULL,NULL,900,1),(104,'22CH103','ENGINEERING CHEMISTRY I ',3,3,30,0,30,0,'BS - Basic Sciences',50,50,100,450,0,450,0,0,'UNIQUE',NULL,NULL,900,1),(105,'22GE001','FUNDAMENTALS OF COMPUTING',1,3,45,0,0,0,'ES - Engineering Sciences',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(106,'22HS001','FOUNDATIONAL ENGLISH',1,2,15,0,30,0,'HSS - Humanities and Social Sciences',100,60,160,225,0,450,0,0,'UNIQUE',NULL,NULL,675,1),(107,'22GE004','BASICS OF ELECTRONICS ENGINEERING',3,3,30,0,30,0,'ES - Engineering Sciences',50,50,100,450,0,450,0,0,'UNIQUE',NULL,NULL,900,1),(108,'22HS002','STARTUP MANAGEMENT',2,2,15,0,30,0,'EEC - Employability Enhancement Course',50,50,100,225,0,450,0,0,'UNIQUE',NULL,NULL,675,1),(109,'22HS003','தமிழர்மரபு HERITAGE OF TAMILS',1,1,1,0,0,0,'HSS - Humanities and Social Sciences',40,60,100,15,0,0,0,0,'UNIQUE',NULL,NULL,15,1),(110,'22AI108','COMPREHENSIVE WORK',2,1,0,0,30,0,'EEC - Employability Enhancement Course',100,60,160,0,0,450,0,0,'UNIQUE',NULL,NULL,450,1),(111,'22MA201','ENGINEERING MATHEMATICS II',1,4,3,1,0,0,'BS - Basic Sciences',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(113,'22PH202','ELECTROMAGNETISM AND MODERN PHYSICS ',3,3,2,0,2,0,'BS - Basic Sciences',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(114,'22GE001 ','FUNDAMENTALS OF COMPUTING',1,3,3,0,0,0,'ES - Engineering Sciences',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(115,'22AM108 ','COMPREHENSIVE WORK',2,1,0,0,2,0,'EEC - Employability Enhancement Course',100,60,160,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(116,'22CH203 ','ENGINEERING CHEMISTRY II ',3,3,2,0,2,0,'BS - Basic Sciences',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(117,'22GE002','COMPUTATIONAL PROBLEM SOLVING',1,3,3,0,0,0,'ES - Engineering Sciences',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(118,'22GE003','BASICS OF ELECTRICAL ENGINEERING',3,3,2,0,2,0,'ES - Engineering Sciences',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(119,'22AM206','DIGITAL COMPUTER ELECTRONICS ',3,4,3,0,2,0,'ES - Engineering Sciences',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(120,'22HS006','தமிழரும் ததொழில்நுட்பமும் TAMILS AND TECHNOLOGY^',1,1,1,0,0,0,'HSS - Humanities and Social Sciences',40,60,100,15,0,0,0,0,'UNIQUE',NULL,NULL,15,1),(121,'22CS301','PROBABILITY, STATISTICS AND QUEUING THEORY',1,4,3,1,0,0,'BS - Basic Sciences',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(122,'22MA101 ','ENGINEERING MATHEMATICS I',1,4,3,1,0,0,'BS - Basic Sciences',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(123,'22CH103 ','ENGINEERING CHEMISTRY I',3,3,2,0,2,0,'BS - Basic Sciences',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(124,'22HS001 ','FOUNDATIONAL ENGLISH ',3,2,1,0,2,0,'HSS - Humanities and Social Sciences',50,50,100,15,0,30,0,0,'UNIQUE',NULL,NULL,45,1),(125,'22GE005','ENGINEERING DRAWING',3,2,1,0,2,0,'ES - Engineering Sciences',50,50,100,15,0,30,0,0,'UNIQUE',NULL,NULL,45,1),(126,'22ME108 ','COMPREHENSIVE WORK',2,1,0,0,2,0,'EEC - Employability Enhancement Course',100,0,100,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(127,'22PH202 ','ELECTROMAGNETISM AND MODERN PHYSICS ',3,3,2,0,2,0,'BS - Basic Sciences',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(128,'22GE002 ','COMPUTATIONAL PROBLEM SOLVING',1,3,3,0,0,0,'ES - Engineering Sciences',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(129,'22HS002 ','STARTUP MANAGEMENT',3,2,1,0,2,0,'EEC - Employability Enhancement Course',50,50,100,15,0,30,0,0,'UNIQUE',NULL,NULL,45,1),(130,'22HS006 ','தமிழரும் ததொழில்நுட்பமும் TAMILS AND TECHNOLOGY',1,1,1,0,0,0,'HSS - Humanities and Social Sciences',40,60,100,15,0,0,0,0,'UNIQUE',NULL,NULL,15,1),(131,'22CS108','COMPREHENSIVE WORKS',2,1,0,0,2,0,'EEC - Employability Enhancement Course',100,60,160,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(132,'22HS009 ','COCURRICULAR OR EXTRACURRICULAR ACTIVITY',2,0,0,0,0,0,'HSS - Humanities and Social Sciences',100,60,160,0,0,0,0,0,'UNIQUE',NULL,NULL,0,1),(133,'22ME301 ','ENGINEERING MATHEMATICS III',1,4,3,1,0,0,'ES - Engineering Sciences',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(134,'22ME302','ELECTRIC MACHINES AND DRIVES ',3,3,2,0,2,0,'ES - Engineering Sciences',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(135,'22ME303','ENGINEERING THERMODYNAMICS ',1,4,3,1,0,0,'PC - Professional Core',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(136,'22ME304','FLUID MECHANICS AND MACHINERY ',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(137,'22ME305 ','ENGINEERING MECHANICS ',1,4,3,1,0,0,'PC - Professional Core',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(138,'22HS004 ','HUMAN VALUES AND ETHICS ',1,2,2,0,0,0,'HSS - Humanities and Social Sciences',40,60,100,30,0,0,0,0,'UNIQUE',NULL,NULL,30,1),(139,'22HS005','SOFT SKILLS AND EFFECTIVE COMMUNICATION',2,1,0,0,2,0,'HSS - Humanities and Social Sciences',60,40,100,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(140,'22ME309','MODELING AND SIMULATION LABORATORY',2,2,0,0,4,0,'PC - Professional Core',60,40,100,0,0,60,0,0,'UNIQUE',NULL,NULL,60,1),(141,'22CH203','ENGINEERING CHEMISTRY II ',3,3,2,0,2,0,'BS - Basic Sciences',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(142,'22HS003*','தமிழர்மரபு HERITAGE OF TAMILS',1,1,1,0,0,0,'HSS - Humanities and Social Sciences',40,60,100,15,0,0,0,0,'UNIQUE',NULL,NULL,15,1),(143,'22ME401 ','KINEMATICS AND DYNAMICS OFMACHINERY',3,4,2,1,2,5,'PC - Professional Core',50,50,100,30,15,30,0,0,'UNIQUE',NULL,NULL,75,1),(144,'22EC108$','COMPREHENSIVE WORK ',2,1,0,0,2,0,'EEC - Employability Enhancement Course',40,60,100,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(145,'22CS206','DIGITAL COMPUTER ELECTRONICS ',3,4,3,0,2,0,'ES - Engineering Sciences',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(146,'22ME402','SENSORS AND TRANSDUCER ',3,4,3,0,2,5,'ES - Engineering Sciences',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(147,'-','LANGUAGE ELECTIVE ',3,2,1,0,2,0,'HSS - Humanities and Social Sciences',50,50,100,15,0,30,0,0,'UNIQUE',NULL,NULL,45,1),(148,'22ME403','STRENGTH OF MATERIALS ',3,4,2,1,2,5,'PC - Professional Core',50,50,100,30,15,30,0,0,'UNIQUE',NULL,NULL,75,1),(149,'22ME404','INDUSTRIAL AUTOMATION WITH PLC* ',3,4,2,1,2,5,'PC - Professional Core',50,50,100,30,15,30,0,0,'UNIQUE',NULL,NULL,75,1),(150,'22HS009','COCURRICULAR OR EXTRACURRICULAR  ACTIVITY* ',2,0,0,0,0,0,'HSS - Humanities and Social Sciences',100,60,160,0,0,0,0,0,'UNIQUE',NULL,NULL,0,1),(151,'22ME405','MATERIALS AND MANUFACTURING PROCESSES',3,3,2,0,2,4,'PC - Professional Core',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(152,'22CS302','DATA STRUCTURES I ',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(153,'22HS007','ENVIRONMENTAL SCIENCE',1,0,2,0,0,2,'HSS - Humanities and Social Sciences',100,60,160,30,0,0,30,0,'UNIQUE',NULL,NULL,60,1),(154,'22CS303',' COMPUTER ORGANIZATION AND ARCHITECTURE',1,4,3,1,0,0,'ES - Engineering Sciences',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(155,'22CS304','PRINCIPLES OF PROGRAMMING LANGUAGES',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(156,'22HS008 ','ADVANCED ENGLISH AND TECHNICALEXPRESSION ',2,1,0,0,2,2,'HSS - Humanities and Social Sciences',60,40,100,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(157,'22CS305','SOFTWARE ENGINEERING ',1,3,3,0,0,0,'PC - Professional Core',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(158,'22HS004','HUMAN VALUES AND ETHICS ',1,2,2,0,0,0,'HSS - Humanities and Social Sciences',40,60,100,30,0,0,0,0,'UNIQUE',NULL,NULL,30,1),(159,'22HS010 ','SOCIALLY RELEVANT PROJECT',2,0,0,0,0,0,'HSS - Humanities and Social Sciences',100,60,160,0,0,0,0,0,'UNIQUE',NULL,NULL,0,1),(160,'22AM301','PROBABILITY AND STATISTICS',1,4,3,1,0,0,'BS - Basic Sciences',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(161,'22HS006*','தமிழரும் ததொழில்நுட்பமும் TAMILS AND TECHNOLOGY ',1,1,1,0,0,0,'HSS - Humanities and Social Sciences',40,60,100,15,0,0,0,0,'UNIQUE',NULL,NULL,15,1),(162,'22ME501 ','MECHATRONICS',3,3,2,0,2,0,'PC - Professional Core',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(163,'22CS401','DISCRETE MATHEMATICS ',1,4,3,1,0,0,'ES - Engineering Sciences',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(164,'22ME502 ','DESIGN OF MACHINE ELEMENTS',1,4,3,1,0,0,'PC - Professional Core',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(165,'22HS009* ','COCURRICULAR OR EXTRACURRICULAR ACTIVITIE',2,0,0,0,0,0,'HSS - Humanities and Social Sciences',100,60,160,0,0,0,0,0,'UNIQUE',NULL,NULL,0,1),(166,'22ME503 ','THERMAL ENGINEERING ',3,4,2,1,2,0,'PC - Professional Core',50,50,100,30,15,30,0,0,'UNIQUE',NULL,NULL,75,1),(167,'22ME504 ','MACHINING AND METROLOGY ',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(168,'22ME507','MINI PROJECT I',2,1,0,0,2,0,'EEC - Employability Enhancement Course',60,40,100,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(169,'22ME508 ','ADVANCED MODELING LABORATORY ',2,2,0,0,4,0,'EEC - Employability Enhancement Course',60,40,100,0,0,60,0,0,'UNIQUE',NULL,NULL,60,1),(170,'22ME601','HEAT AND MASS TRANSFER ',3,4,2,1,2,0,'PC - Professional Core',50,50,100,30,15,30,0,0,'UNIQUE',NULL,NULL,75,1),(171,'22EC301 ','PROBABILITY, STATISTICS AND RANDOM PROCESS*',1,4,3,1,0,0,'BS - Basic Sciences',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(172,'22ME602','FINITE ELEMENT ANALYSIS',3,4,2,1,2,0,'PC - Professional Core',50,50,100,30,15,30,0,0,'UNIQUE',NULL,NULL,75,1),(173,'22ME603 ','COMPUTER AIDED MANUFACTURING ',3,3,2,0,2,0,'PC - Professional Core',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(174,'22EC302','CIRCUIT ANALYSIS ',1,4,3,1,0,0,'ES - Engineering Sciences',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(175,'22AM302','DATA STRUCTURES I',3,4,3,0,2,0,'ES - Engineering Sciences',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(176,'22ME607 ','MINI PROJECT II ',2,1,0,0,2,0,'EEC - Employability Enhancement Course',60,40,100,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(177,'22CS402','DATA STRUCTURES II',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(178,'22ME701 ','INDUSTRIAL ROBOTICS ',3,3,2,0,2,0,'PC - Professional Core',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(179,'22EC303 ','DIGITAL LOGIC CIRCUIT DESIGN',3,4,3,0,2,0,'PC - Professional Core',40,60,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(180,'22AM303','COMPUTER ORGANIZATION AND ARCHITECTURE',1,4,3,1,0,0,'PC - Professional Core',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(181,'22ME702 ','IoT FOR AUTOMATION ',3,3,2,0,2,0,'PC - Professional Core',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(182,'22AM304','PRINCIPLES OF PROGRAMMING LANGUAGES',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(183,'22ME707 ','PROJECT WORK I ',2,2,0,0,4,0,'EEC - Employability Enhancement Course',60,40,100,0,0,60,0,0,'UNIQUE',NULL,NULL,60,1),(184,'22ME801 ','PROJECT WORK II ',2,10,0,0,20,0,'EEC - Employability Enhancement Course',60,40,100,0,0,300,0,0,'UNIQUE',NULL,NULL,300,1),(185,'22AM305','SOFTWARE ENGINEERING ',1,3,3,0,0,0,'PC - Professional Core',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(186,'22AI206','DIGITAL COMPUTER ELECTRONICS ',3,4,3,0,2,0,'ES - Engineering Sciences',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(187,'22IT108','COMPREHENSIVE WORK',2,1,0,0,2,0,'EEC - Employability Enhancement Course',100,60,160,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(188,'22AM401','APPLIED LINEAR ALGEBRA ',1,4,3,1,0,0,'ES - Engineering Sciences',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(189,'22BT108','COMPREHENSIVE WORK',2,1,0,0,2,0,'EEC - Employability Enhancement Course',100,60,160,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(190,'22AM402','DATA STRUCTURES II',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(191,'22AM403','OPERATING SYSTEMS',1,4,3,1,0,0,'PC - Professional Core',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(192,'22AM404','WEB TECHNOLOGY AND FRAMEWORKS',3,3,2,0,2,0,'PC - Professional Core',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(193,'22AM405','DATABASE MANAGEMENT SYSTEM ',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(194,'22AI301','PROBABILITY AND STATISTICS',1,4,3,1,0,0,'BS - Basic Sciences',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(195,'22AI302','DATA STRUCTURES I ',3,4,3,0,2,0,'ES - Engineering Sciences',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(196,'22IT206','DIGITAL COMPUTER ELECTRONICS',3,4,3,0,2,0,'ES - Engineering Sciences',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(197,'22AI303','COMPUTER ORGANIZATION AND ARCHITECTURE**',1,4,3,1,0,0,'PC - Professional Core',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(198,'22AI304','PRINCIPLES OF PROGRAMMING LANGUAGES',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(199,'22HS008','ADVANCED ENGLISH AND TECHNICAL EXPRESSION',2,1,0,0,2,0,'HSS - Humanities and Social Sciences',60,40,100,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(200,'22AI305','SOFTWARE ENGINEERING',1,3,3,0,0,0,'PC - Professional Core',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(201,'22AM501',' ARTIFICIAL INTELLIGENCE',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(202,'22AM502','BIG DATA TECHNOLOGIES ',1,3,3,0,0,0,'PC - Professional Core',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(203,'22EC304','ANALOG ELECTRONICS AND INTEGRATED CIRCUITS ',3,4,3,0,2,0,'PC - Professional Core',40,60,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(204,'22EC305 ','DATA STRUCTURES AND ALGORITHMS ',3,3,2,0,2,0,'PC - Professional Core',40,60,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(205,'22AM503','MACHINE LEARNING',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(206,'22AI401 ','APPLIED LINEAR ALGEBRA',1,4,3,1,0,0,'ES - Engineering Sciences',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(207,'22AM504','CLOUD COMPUTING',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(208,'22AI402','DATA STRUCTURES II',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(209,'22AM507','MINI PROJECT I',2,1,0,0,2,0,'EEC - Employability Enhancement Course',60,40,100,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(210,'22IT301','PROBABILITY, STATISTICS AND QUEUING THEORY',1,4,4,1,0,0,'ES - Engineering Sciences',39,60,99,60,15,0,0,0,'UNIQUE',NULL,NULL,75,1),(211,'22AI403','OPERATING SYSTEMS',1,4,3,1,0,0,'PC - Professional Core',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(212,'22HS201','COMMUNICATIVE ENGLISH II',3,2,1,0,2,0,'HSS - Humanities and Social Sciences',50,50,100,15,0,30,0,0,'UNIQUE',NULL,NULL,45,0),(213,'22AI404','WEB TECHNOLOGY AND FRAMEWORKS ',3,3,2,0,2,0,'PC - Professional Core',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(214,'22HSH01 ','HINDI',3,2,1,0,2,0,'HSS - Humanities and Social Sciences',50,50,100,15,0,30,0,0,'UNIQUE',NULL,NULL,45,1),(215,'22EC401 ','SIGNALS AND SYSTEMS',1,4,2,1,0,0,'BS - Basic Sciences',40,60,100,30,15,0,0,0,'UNIQUE',NULL,NULL,45,1),(216,'22HSG01','GERMAN ',3,2,1,0,2,0,'HSS - Humanities and Social Sciences',50,50,100,15,0,30,0,0,'UNIQUE',NULL,NULL,45,0),(217,'22AM601','NATURAL LANGUAGE PROCESSING **',3,3,2,0,2,0,'PC - Professional Core',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(218,'22AI405','DATABASE MANAGEMENT SYSTEM',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(219,'22HSJ01','JAPANESE ',3,2,1,0,2,0,'HSS - Humanities and Social Sciences',100,60,160,15,0,30,0,0,'UNIQUE',NULL,NULL,45,0),(220,'22AM602','COMPUTER VISION AND DIGITAL IMAGING',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(221,'22EC402','ANALOG COMMUNICATION',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(222,'22HSF01','FRENCH ',3,2,1,0,2,0,'HSS - Humanities and Social Sciences',50,50,100,15,0,30,0,0,'UNIQUE',NULL,NULL,45,0),(223,'22IT302','DATA STRUCTURES I',3,4,3,0,2,0,'ES - Engineering Sciences',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(224,'22AM603','DEEP LEARNING',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(225,'22IT303 ','COMPUTER ORGANIZATION AND ARCHITECTURE',1,4,4,1,0,0,'PC - Professional Core',40,60,100,60,15,0,0,0,'UNIQUE',NULL,NULL,75,1),(226,'22EC403','ELECTROMAGNETIC FIELDS AND WAVEGUIDES',1,4,3,1,0,0,'BS - Basic Sciences',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(227,'22ME001','CONCEPTS OF ENGINEERING DESIGN ',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(228,'22IT304','PRINCIPLES OF PROGRAMMING LANGUAGES',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(229,'22ME002 ','COMPOSITE MATERIALS AND MECHANICS ',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(230,'22EC404 ','CMOS DIGITAL INTEGRATED CIRCUITS',3,3,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(231,'22ME003 ','COMPUTER AIDED DESIGN',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(232,'22AM607','MINI PROJECT II',2,1,0,0,2,0,'EEC - Employability Enhancement Course',60,40,100,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(233,'22IT305','SOFTWARE ENGINEERING',1,3,3,0,0,0,'PC - Professional Core',37,60,97,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(234,'22ME004 ','MECHANICAL VIBRATIONS ',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(235,'22EC405','EMBEDDED SYSTEMS ',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(236,'22ME005','ENGINEERING TRIBOLOGY',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(237,'22BT301','FOURIER SERIES, TRANSFORMS AND BIOSTATISTICS',1,4,3,1,0,0,'BS - Basic Sciences',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(238,'22ME006 ','FAILURE ANALYSIS AND DESIGN ',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(239,'22AM701','PATTERN AND ANOMALY DETECTION',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(240,'22ME007','DESIGN OF AUTOMOTIVE SYSTEMS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(241,'22AM702','BUSINESS ANALYTICS',1,3,3,0,0,0,'PC - Professional Core',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(242,'22BT302','BIOCHEMISTRY ',3,4,3,0,2,0,'ES - Engineering Sciences',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(243,'22IT401','DISCRETE MATHEMATICS',1,4,4,1,0,0,'ES - Engineering Sciences',40,60,100,60,15,0,0,0,'UNIQUE',NULL,NULL,75,1),(244,'22BT303','ENGINEERING THERMODYNAMICS',1,4,3,1,0,0,'PC - Professional Core',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(245,'22IT402','DATA STRUCTURES II',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(246,'22BT304','MICROBIOLOGY',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(247,'22IT403','OPERATING SYSTEMS',1,4,4,1,0,0,'PC - Professional Core',40,60,100,60,15,0,0,0,'UNIQUE',NULL,NULL,75,1),(248,'22BT305','PROCESS CALCULATIONS AND UNIT OPERATIONS',1,4,3,1,0,0,'BS - Basic Sciences',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(249,'22IT404','WEB TECHNOLOGY AND FRAMEWORKS',3,3,2,0,2,0,'PC - Professional Core',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(250,'22HS010$','SOCIALLY RELEVANT PROJECT ',2,0,0,0,0,0,'HSS - Humanities and Social Sciences',100,60,160,0,0,0,0,0,'UNIQUE',NULL,NULL,0,1),(251,'22AM707','PROJECT WORK I',2,2,0,0,4,0,'EEC - Employability Enhancement Course',60,40,100,0,0,60,0,0,'UNIQUE',NULL,NULL,60,1),(252,'22HS010','SOCIALLY RELEVANT PROJECT ',2,0,0,0,2,0,'HSS - Humanities and Social Sciences',100,60,160,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(253,'22IT405 ','DATABASE MANAGEMENT SYSTEM',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(254,'22AM801','PROJECT WORK II',2,10,0,0,20,0,'EEC - Employability Enhancement Course',60,40,100,0,0,300,0,0,'UNIQUE',NULL,NULL,300,1),(255,'22AI501',' ARTIFICIAL INTELLIGENCE ',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(256,'22BT401','BIOORGANIC CHEMISTRY',3,4,3,0,2,0,'ES - Engineering Sciences',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(257,'22HSH01','HINDI ',3,2,1,0,2,0,'HSS - Humanities and Social Sciences',50,50,100,15,0,30,0,0,'UNIQUE',NULL,NULL,45,0),(258,'22BT402','HEAT AND MASS TRANSFER',3,4,3,0,2,0,'ES - Engineering Sciences',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(259,'22AI502','COMPUTER NETWORKS ',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(260,'22BT403','CELL AND MOLECULAR BIOLOGY',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(261,'22BT404','INSTRUMENTAL METHODS OF ANALYSIS ',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(262,'22AI503 ','MACHINE LEARNING',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(263,'22BT405','PLANT TISSUE CULTURE',3,3,2,0,2,0,'PC - Professional Core',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(264,'22AI504','CLOUD COMPUTING',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(265,'22AM001','AGILE SOFTWARE DEVELOPMENT',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(266,'22AI507',' MINI PROJECT I',2,1,0,0,2,0,'EEC - Employability Enhancement Course',60,40,100,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(267,'22AM002','UI AND UX DESIGN',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(268,'22AM003','WEB FRAMEWORKS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(269,'22AI601','NATURAL LANGUAGE PROCESSING',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(270,'22AM004','APP DEVELOPMENT',3,3,2,0,2,0,'PE - Professional Elective',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(271,'22MEM18','OPERATIONS MANAGEMENT ',1,3,3,0,0,3,'PE - Professional Elective',40,60,100,45,0,0,45,0,'UNIQUE',NULL,NULL,90,1),(272,'22AM005','SOFTWARE TESTING AND AUTOMATION',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(273,'22CE108','COMPREHENSIVE WORK',2,1,0,0,2,0,'EEC - Employability Enhancement Course',100,60,160,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(274,'22AI602','COMPUTER VISION AND DIGITAL IMAGING',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(275,'22MEM18 ','OPERATIONS MANAGEMENT ',1,3,3,0,0,3,'PE - Professional Elective',40,60,100,45,0,0,45,0,'UNIQUE',NULL,NULL,90,1),(276,'22BT501','GENETIC ENGINEERING',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(277,'22AI603','DEEP LEARNING ',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(278,'22BT502','BIOPROCESS ENGINEERING',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(279,'22AI607','MINI PROJECT II ',2,1,0,0,2,0,'EEC - Employability Enhancement Course',60,40,100,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(280,'22EC501 ','DIGITAL COMMUNICATION',3,4,3,0,2,0,'PC - Professional Core',50,47,97,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(281,'22IT501','PRINCIPLES OF COMMUNICATION',1,3,3,0,0,0,'PC - Professional Core',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(282,'22BT503','ANIMAL TISSUE CULTURE',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(283,'22IT502','COMPUTER NETWORKS',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(284,'22EC502','DIGITAL SIGNAL PROCESSING',3,4,3,0,2,0,'PC - Professional Core',50,48,98,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(285,'22BT504','BIOINFORMATICS',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(286,'22IT503','INFORMATION CODING TECHNIQUES',1,4,4,1,0,0,'PC - Professional Core',40,60,100,60,15,0,0,0,'UNIQUE',NULL,NULL,75,1),(287,'22AI701','DATA VISUALIZATION',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(288,'22BT507','MINI PROJECT I',2,1,0,0,2,0,'EEC - Employability Enhancement Course',60,40,100,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(289,'22EC503','TRANSMISSION LINES AND ANTENNAS ',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(290,'22IT504','INTERNET OF THINGS',3,3,2,0,2,0,'PC - Professional Core',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(291,'22IT507','MINI PROJECT I',2,1,0,0,2,0,'EEC - Employability Enhancement Course',60,40,100,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(292,'22BT601','DOWNSTREAM PROCESSING',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(293,'22EC504','INTERNET OF THINGS AND ITS APPLICATIONS ',3,4,3,0,2,0,'PC - Professional Core',50,49,99,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(294,'22AI702','AI FOR ROBOTICS',1,3,3,0,0,0,'PC - Professional Core',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(295,'22BT602','IMMUNOLOGY',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(296,'22IT601','DATA MINING AND WAREHOUSING',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(297,'22EC507 ','MINI PROJECT I',2,1,0,0,2,0,'EEC - Employability Enhancement Course',60,40,100,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(298,'22IT602','PRINCIPLES OF COMPILER DESIGN',1,4,4,1,0,0,'PC - Professional Core',40,60,100,60,15,0,0,0,'UNIQUE',NULL,NULL,75,1),(299,'22BT603','ENZYME AND PROTEIN ENGINEERING',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(300,'22EC601','COMPUTER NETWORKS AND PROTOCOLS ',1,3,3,0,0,0,'PC - Professional Core',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(301,'22IT603','CLOUD COMPUTING',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(302,'22BT607','MINI PROJECT II',2,1,0,0,2,0,'EEC - Employability Enhancement Course',60,40,100,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(303,'22IT607','MINI PROJECT II ',2,1,0,0,2,0,'EEC - Employability Enhancement Course',60,40,100,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(304,'22BT701','GENOMICS AND PROTEOMICS',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(305,'22EC602','DIGITAL SYSTEM DESIGN WITH FPGA',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(306,'22IT701','CRYPTOGRAPHY AND INFORMATION SECURITY',1,3,3,0,0,0,'PC - Professional Core',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(307,'22BT702','BIOPHARMACEUTICAL TECHNOLOGY',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(308,'22IT702','ARTIFICIAL INTELLIGENCE AND EXPERT SYSTEM',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(309,'22EC603 ','ARTIFICIAL INTELLIGENCE AND MACHINE LEARNING',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(310,'22AI707',' PROJECT WORK I ',2,2,0,0,4,0,'EEC - Employability Enhancement Course',60,40,100,0,0,60,0,0,'UNIQUE',NULL,NULL,60,1),(311,'22BT707','PROJECT WORK I',2,2,0,0,4,0,'EEC - Employability Enhancement Course',50,50,100,0,0,60,0,0,'UNIQUE',NULL,NULL,60,1),(312,'22IT707','PROJECT WORK I',2,2,0,0,4,0,'EEC - Employability Enhancement Course',60,40,100,0,0,60,0,0,'UNIQUE',NULL,NULL,60,1),(313,'22EC607 ','MINI PROJECT II ',2,1,0,0,2,0,'EEC - Employability Enhancement Course',60,38,98,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(314,'22BT801','PROJECT WORK II ',2,10,0,0,20,0,'EEC - Employability Enhancement Course',50,50,100,0,0,300,0,0,'UNIQUE',NULL,NULL,300,1),(315,'22EC701','MICROWAVE ENGINEERING',3,3,2,0,2,0,'PC - Professional Core',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(316,'22AI801','PROJECT WORK II',2,10,0,0,20,0,'EEC - Employability Enhancement Course',60,40,100,0,0,300,0,0,'UNIQUE',NULL,NULL,300,1),(317,'22EC702','WIRELESS COMMUNICATION ',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(318,'22EC707','PROJECT WORK I',2,2,0,0,4,0,'EEC - Employability Enhancement Course',60,40,100,0,0,60,0,0,'UNIQUE',NULL,NULL,60,1),(319,'22EC801 ','PROJECT WORK II ',2,10,0,0,20,0,'EEC - Employability Enhancement Course',60,39,99,0,0,300,0,0,'UNIQUE',NULL,NULL,300,1),(320,'22HSC01','CHINESE',3,2,1,0,2,0,'HSS - Humanities and Social Sciences',100,60,160,15,0,30,0,0,'UNIQUE',NULL,NULL,45,1),(321,'22IT001','EXPLORATORY DATA ANALYSIS',3,3,2,0,2,0,'PE - Professional Elective',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(322,'22IT002','RECOMMENDER SYSTEMS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(323,'22CE301','NUMERICAL METHODS AND STATISTICS ',1,4,3,1,0,0,'ES - Engineering Sciences',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(324,'22IT003','BIG DATA ANALYTICS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(325,'22IT004','NEURAL NETWORKS AND DEEP LEARNING',3,3,2,0,2,0,'PE - Professional Elective',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(326,'22CE302','CONSTRUCTION MATERIALS, EQUIPMENT AND TECHNIQUES',3,3,2,0,2,0,'ES - Engineering Sciences',50,49,99,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(327,'22IT005','NATURAL LANGUAGE PROCESSING',3,3,2,0,2,0,'PE - Professional Elective',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(328,'22IT006','COMPUTER VISION ',3,3,2,0,2,0,'PE - Professional Elective',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(329,'22CE303','SURVEY AND GEOMATICS',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(330,'22CE304','FLUID MECHANICS AND MACHINERY ',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(331,'22CE305','ENGINEERING MECHANICS',1,4,3,1,0,0,'PC - Professional Core',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(332,'22HSF01 ','FRENCH',3,2,1,0,2,0,'HSS - Humanities and Social Sciences',50,47,97,15,0,30,0,0,'UNIQUE',NULL,NULL,45,1),(333,'22IT007','AGILE SOFTWARE DEVELOPMENT',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(334,'22IT008','UI AND UX DESIGN',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(335,'22IT009','WEB FRAMEWORKS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(336,'22CE401','WATER RESOURCES ENGINEERING',1,4,3,1,0,0,'ES - Engineering Sciences',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(337,'22IT010','APP DEVELOPMENT ',3,3,2,0,2,0,'PE - Professional Elective',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(338,'22IT011','SOFTWARE TESTING AND AUTOMATION ',1,0,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(339,'22EC001','ADVANCED PROCESSOR ARCHITECTURES',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(340,'22IT012','DEVOPS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(341,'22BT001','FERMENTATION TECHNOLOGY',1,3,3,0,0,3,'PE - Professional Elective',40,60,100,45,0,0,45,0,'UNIQUE',NULL,NULL,90,1),(342,'22IT013','VIRTUALIZATION IN CLOUD COMPUTING ',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(343,'22AI001','AGILE SOFTWARE DEVELOPMENT',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(344,'22IT014','CLOUD SERVICES AND DATA MANAGEMENT',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(345,'22BT002','INDUSTRIAL MICROBIOLOGY',1,3,3,0,0,3,'PE - Professional Elective',40,60,100,45,0,0,45,0,'UNIQUE',NULL,NULL,90,1),(346,'22BT003','ENVIRONMENTAL BIOTECHNOLOGY',1,3,3,0,0,3,'PE - Professional Elective',40,60,100,45,0,0,45,0,'UNIQUE',NULL,NULL,90,1),(347,'22BT004','BIOENERGY AND BIOFUELS',1,3,3,0,0,3,'PE - Professional Elective',40,60,100,45,0,0,45,0,'UNIQUE',NULL,NULL,90,1),(348,'22BT005','BIOREACTOR DESIGN, MODELING AND SIMULATION',1,3,3,0,0,3,'PE - Professional Elective',40,60,100,45,0,0,45,0,'UNIQUE',NULL,NULL,90,1),(349,'22AI002','UI AND UX DESIGN',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(350,'22BT006','BIOPROCESS CONTROL AND INSTRUMENTATION',1,3,3,0,0,3,'PE - Professional Elective',40,60,100,45,0,0,45,0,'UNIQUE',NULL,NULL,90,1),(351,'22CE402','MECHANICS OF DEFORMABLE BODIES',3,4,2,1,2,0,'PC - Professional Core',50,50,100,30,15,30,0,0,'UNIQUE',NULL,NULL,75,1),(352,'22AI003','WEB FRAMEWORKS ',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(353,'22AI004','APP DEVELOPMENT',3,3,2,0,2,0,'PE - Professional Elective',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(354,'22EC003','EMBEDDED C PROGRAMMING ',1,2,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(355,'22AI005','SOFTWARE TESTING AND AUTOMATION',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(356,'22EC002','COMMUNICATION PROTOCOLS AND STANDARDS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(357,'22AI006','DevOps ',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(358,'22EC004','REAL TIME OPERATING SYSTEMS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(359,'22EC005','EMBEDDED LINUX ',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(360,'22EC006','VIRTUAL INSTRUMENTATION IN EMBEDDED SYSTEMS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(361,'22CE403','CONCRETE TECHNOLOGY',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(362,'22CE404','GEOTECHNICAL ENGINEERING I',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(363,'22CE405','CONSTRUCTION MANAGEMENT',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(364,'22AI007','VIRTUALIZATION IN CLOUD COMPUTING',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(365,'22CE501','DESIGN OF RCC ELEMENTS',1,4,3,1,0,0,'PC - Professional Core',40,62,102,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(366,'22CE502','STRUCTURAL ANALYSIS I',1,4,3,1,0,0,'PC - Professional Core',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(367,'22CE503','WATER SUPPLY AND WASTEWATER ENGINEERING',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(368,'22CE504','GEOTECHNICAL ENGINEERING II',1,3,3,0,0,0,'PC - Professional Core',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(369,'22CE507','MINI PROJECT I',2,1,0,0,2,0,'EEC - Employability Enhancement Course',60,38,98,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(370,'22CE601','DESIGN OF RCC STRUCTURES',1,4,3,1,0,0,'PC - Professional Core',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(371,'22CE602','STRUCTURAL ANALYSIS II',1,4,3,1,0,0,'PC - Professional Core',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(372,'22CE603','DESIGN OF STEEL STRUCTURES',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(373,'22CE607','MINI PROJECT II',2,1,0,0,2,0,'EEC - Employability Enhancement Course',60,40,100,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(374,'22CE701','HIGHWAY AND RAILWAY ENGINEERING',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(375,'22CE702','ESTIMATION, COSTING AND QUANTITY SURVEYING',1,4,3,1,0,0,'PC - Professional Core',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(376,'22CE707','PROJECT WORK I',2,2,0,0,4,0,'EEC - Employability Enhancement Course',60,40,100,0,0,60,0,0,'UNIQUE',NULL,NULL,60,1),(377,'22CT108','COMPREHENSIVE WORK',2,1,0,0,2,0,'EEC - Employability Enhancement Course',100,60,160,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(378,'22CE801','PROJECT WORK II',2,10,0,0,20,0,'EEC - Employability Enhancement Course',60,40,100,0,0,300,0,0,'UNIQUE',NULL,NULL,300,1),(379,'22GE003 ','BASICS OF ELECTRICAL ENGINEERING',3,3,2,0,2,0,'ES - Engineering Sciences',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(380,'22CT206','DIGITAL COMPUTER ELECTRONICS',3,4,3,0,2,0,'ES - Engineering Sciences',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(381,'22HSG01 ','GERMAN',3,2,1,0,2,0,'HSS - Humanities and Social Sciences',100,60,160,15,0,30,0,0,'UNIQUE',NULL,NULL,45,1),(382,'22CT301','PROBABILITY, STATISTICS AND QUEUING THEORY',1,4,3,1,0,0,'BS - Basic Sciences',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(383,'22CT302','DATA STRUCTURES I ',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(384,'22CT303','COMPUTER ORGANIZATION AND ARCHITECTURE',1,4,3,1,0,0,'ES - Engineering Sciences',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(385,'22CT304','PRINCIPLES OF PROGRAMMING LANGUAGES',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(386,'22CT305','SOFTWARE ENGINEERING',1,3,3,0,0,0,'PC - Professional Core',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(387,'22CT401','DISCRETE MATHEMATICS',1,4,3,1,0,0,'ES - Engineering Sciences',40,58,98,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(388,'22CT402','DATA STRUCTURES II',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(389,'22CT403','OPERATING SYSTEMS',1,4,3,1,0,0,'PC - Professional Core',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(390,'22CT404 ','WEB TECHNOLOGY AND FRAMEWORKS',3,3,0,0,2,0,'PC - Professional Core',50,50,100,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(391,'22CT405','DATABASE MANAGEMENT SYSTEM',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(392,'22CT501','PRINCIPLES OF COMPILER DESIGN',1,4,3,1,0,0,'PC - Professional Core',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(393,'22CT502','COMPUTER NETWORKS',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(394,'22CT503','EMBEDDED SYSTEMS ',1,3,3,0,0,0,'ES - Engineering Sciences',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(395,'22CT504','ARTIFICIAL INTELLIGENCE SYSTEMS',3,3,2,0,2,0,'PC - Professional Core',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(396,'22CT507','MINI PROJECT I',2,1,0,0,2,0,'EEC - Employability Enhancement Course',60,40,100,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(397,'22BT007','TRANSPORT PHENOMENON IN BIOLOGICAL SYSTEMS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(398,'22BT008','ASTROBIOLOGY AND ASTROCHEMISTRY',1,2,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(399,'22BT009','BIOPROSPECTING AND QUALITY ANALYSIS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(400,'22BT010','FOOD PROCESS AND TECHNOLOGY',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(401,'22BT011','MARINE BIOTECHNOLOGY',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(402,'22BT012','BIODIVERSITY AND AGROFORESTRY',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(403,'22BT013','BIOSENSORS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(404,'22BT014','BIOMATERIALS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(405,'22BT015','PROGRAMS FOR BIOINFORMATICS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(406,'22BT016','FUNDAMENTALS OF ALGORITHMS FOR BIOINFORMATICS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(407,'22BT017','MOLECULAR MODELING',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(408,'22BT018','COMPUTER AIDED DRUG DESIGN',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(409,'22BT019','METABOLOMICS AND GENOMICS- BIG DATA ANALYTICS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(410,'22BT020','DATA MINING AND MACHINE LEARNING TECHNIQUES FOR INFORMATICS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(411,'22BT021','SYSTEMS AND SYNTHETIC BIOLOGY',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(412,'22BT022','PLANT TISSUE CULTURE AND TRANSFORMATION TECHNIQUE',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(413,'22AM006','DevOps',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(414,'22BT023','TRANSGENIC TECHNOLOGY IN AGRICULTURE',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(415,'22AI008','CLOUD SERVICES AND DATA MANAGEMENT',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(416,'22BT024','BIOFERTILIZERS AND BIOPESTICIDES PRODUCTION',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(417,'22AM007','VIRTUALIZATION IN CLOUD COMPUTING ',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(418,'22BT025','MUSHROOM CULTIVATION AND VERMICOMPOSTING',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(419,'22AI009','CLOUD STORAGE TECHNOLOGIES',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(420,'22AM008','CLOUD SERVICES AND DATA MANAGEMENT',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(421,'22BT026','FUNGAL AND ALGAL TECHNOLOGY',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(422,'22BT027','PHYTOTHERAPEUTICS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(423,'22AM009','CLOUD STORAGE TECHNOLOGIES',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(424,'22AI010','CLOUD AUTOMATION TOOLS AND APPLICATIONS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(425,'22AM010','CLOUD AUTOMATION TOOLS AND APPLICATIONS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(426,'22AM011','SOFTWARE DEFINED NETWORKS ',3,3,2,0,2,0,'PE - Professional Elective',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(427,'22AI011','SOFTWARE DEFINED NETWORKS',3,3,2,0,2,0,'PE - Professional Elective',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(428,'22AM012','SECURITY AND PRIVACY IN CLOUD',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(429,'22AI012','SECURITY AND PRIVACY IN CLOUD',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(430,'22AM013','CYBER SECURITY',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(431,'22AI013','CYBER SECURITY',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(432,'22AM014','MODERN CRYPTOGRAPHY',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(433,'22AI014','MODERN CRYPTOGRAPHY',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(434,'22AM015','CYBER FORENSICS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(435,'22AM016','ETHICAL HACKING',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(436,'22AI015','CYBER FORENSICS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(437,'22AM017','CRYPTOCURRENCY AND BLOCKCHAIN TECHNOLOGIES',3,3,2,0,2,0,'PE - Professional Elective',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(438,'22AI016','ETHICAL HACKING',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(439,'22AM018','MALWARE ANALYSIS ',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(440,'22AI017','CRYPTOCURRENCY AND BLOCKCHAIN TECHNOLOGIES',3,3,2,0,2,0,'PE - Professional Elective',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(441,'22AM019','ROBOTIC PROCESS AUTOMATION',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(442,'22AI018','MALWARE ANALYSIS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(443,'22AM020','TEXT AND SPEECH ANALYSIS',3,3,2,0,2,0,'PE - Professional Elective',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(444,'22CS403 ','OPERATING SYSTEMS',1,4,3,1,0,0,'PC - Professional Core',40,60,100,45,15,0,0,0,'UNIQUE',NULL,NULL,60,1),(445,'22AM021','EDGE COMPUTING',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(446,'22AM022','INTELLIGENT ROBOTS AND DRONE TECHNOLOGY',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(447,'22BT028','ANIMAL PHYSIOLOGY AND METABOLISM',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(448,'22AM023','INTELLIGENT TRANSPORTATION SYSTEMS ',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(449,'22AM024','EXPERT SYSTEMS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(450,'22AI019','ROBOTIC PROCESS AUTOMATION',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(451,'22AI020','REINFORCEMENT LEARNING',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(452,'22AI021','EDGE COMPUTING',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(453,'22AI022','INTELLIGENT ROBOTS AND DRONE TECHNOLOGY',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(454,'22AI023','INTELLIGENT TRANSPORTATION SYSTEMS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(455,'22BT029','ANIMAL HEALTH AND NUTRITION',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(456,'22AM025','WEB FRAMEWORKS AND APPLICATIONS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(457,'22AI024','EXPERT SYSTEMS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(458,'22AI025','KNOWLEDGE ENGINEERING',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(459,'22AM026','ECOMMERCE AND WEB DEVELOPMENT',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(460,'22AM027','MOBILE AND WEB APPLICATION ',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(461,'22AI026','HEALTH CARE ANALYTICS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(462,'22AI027','OPTIMIZATION TECHNIQUES',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(463,'22AM028','NoSQL DATABASE',3,3,2,0,2,0,'PE - Professional Elective',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(464,'22AI028','BIG DATA ANALYTICS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(465,'22AM029','SMART PRODUCT DEVELOPMENT ',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(466,'22AI029','QUANTUM COMPUTING',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(467,'22AM030','BIO MEDICAL IMAGE ANALYSIS ',3,3,2,0,2,0,'PE - Professional Elective',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(468,'22AI030','COGNITIVE SCIENCE ',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(469,'22AM031',' DATA ANALYTICS AND DATA SCIENCE',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(470,'22AM032','VIDEO ANALYTICS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(471,'22AM033','CYBER THREAT ANALYTICS ',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(472,'22AI031','BIO MEDICAL IMAGE ANALYSIS',3,3,2,0,2,0,'PE - Professional Elective',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(473,'22AM034','BUSINESS INTELLIGENCE',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(474,'22AI032','RECOMMENDER SYSTEMS ',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(475,'22AM035','DIGITAL MARKETING AND MANAGEMENT',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(476,'22AI033','IMAGE AND VIDEO ANALYTICS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(477,'22AM036','INTERNET OF THINGS AND ITS APPLICATIONS ',1,2,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(478,'22AM037','BIOINFORMATICS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(479,'22AI034','CYBER THREAT ANALYTICS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(480,'22CS404 ','WEB TECHNOLOGY AND FRAMEWORKS',3,3,2,0,2,0,'PC - Professional Core',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(481,'22CT601','DISTRIBUTED COMPUTING',1,3,3,0,0,0,'PC - Professional Core',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(482,'22CT602','MACHINE LEARNING ESSENTIALS',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(483,'22CT603','CLOUD COMPUTING',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(484,'22CT607','MINI PROJECT II ',2,1,0,0,2,0,'EEC - Employability Enhancement Course',60,40,100,0,0,30,0,0,'UNIQUE',NULL,NULL,30,1),(485,'22CT701','BLOCKCHAIN TECHNOLOGY',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(486,'22CT702','MOBILE APPLICATION DEVELOPMENT',3,4,3,0,2,0,'PC - Professional Core',50,50,100,45,0,30,0,0,'UNIQUE',NULL,NULL,75,1),(487,'22CT707','PROJECT WORK I ',2,2,0,0,4,0,'EEC - Employability Enhancement Course',60,40,100,0,0,60,0,0,'UNIQUE',NULL,NULL,60,1),(488,'22CT001','EXPLORATORY DATA ANALYSIS',3,3,2,0,2,0,'PE - Professional Elective',50,50,100,30,0,30,0,0,'UNIQUE',NULL,NULL,60,1),(489,'22CT002','RECOMMENDER SYSTEMS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(490,'22CE001','REPAIR AND REHABILITATION OF STRUCTURES ',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(491,'22CE002','PRESTRESSED CONCRETE STRUCTURES',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(492,'22CE003','STRUCTURAL DYNAMICS AND EARTHQUAKE ENGINEERING',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(493,'22CE004','BRIDGE ENGINEERING',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(494,'22CE005','TALL STRUCTURES',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(495,'22CE006','STRUCTURAL HEALTH MONITORING',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(496,'22CE007 ','DESIGN OF TIMBER AND MASONRY ELEMENTS ',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(497,'22CE008','ADVANCED RC DESIGN',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(498,'22CE009','ADVANCED STEEL DESIGN',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(499,'22CE010','INDUSTRIAL STRUCTURES',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(500,'22CE011','FINITE ELEMENT ANALYSIS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(501,'22CE012','STEEL CONCRETE COMPOSITE STRUCTURES ',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(502,'22CE013','BUILDING SERVICES',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(503,'22CE014','CONCEPTUAL PLANNING AND BYE LAWS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(504,'22CE015','COST EFFECTIVE CONSTRUCTION AND GREEN BUILDING',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(505,'22CE016','PREFABRICATED STRUCTURES AND PREENGINEEREDBUILDING',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(506,'22CE017','ENERGY EFFICIENT BUILDINGS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(507,'22CE018','CONSTRUCTION MANAGEMENT AND SAFETY ',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(508,'22CE019','GROUND IMPROVEMENT TECHNIQUES',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(509,'22CE020 ','GEOENVIRONMENTAL ENGINEERING',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(510,'22CE021','INTRODUCTION TO GEOTECHNICAL EARTHQUAKE ENGINEERING',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(511,'22CE022','REINFORCED SOIL STRUCTURES',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(512,'22CE023','ROCK MECHANICS AND APPLICATIONS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(513,'22CE024','EARTH RETAINING STRUCTURES',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(514,'22CE025','URBAN TRANSPORTATION PLANNING AND SYSTEMS',1,1,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(515,'22CE026','MASS TRANSPORTATION SYSTEMS',1,3,3,0,0,0,'PE - Professional Elective',40,60,100,45,0,0,0,0,'UNIQUE',NULL,NULL,45,1),(516,'22AI035','BUSINESS ANALYTICS',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(517,'22AI036 ','DIGITAL MARKETING AND MANAGEMENT',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(518,'22AI037','TIME SERIES ANALYSIS AND FORECASTING',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(519,'22AI038 ','HUMAN COMPUTER INTERACTION',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(520,'22AI039 ','PATTERN RECOGNITION ',1,3,0,0,0,0,'PE - Professional Elective',39,60,99,0,0,0,0,0,'UNIQUE',NULL,NULL,0,1),(521,'22AI040 ','ETHICS AND AI',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(522,'22AI041','MULTIMEDIA AND ANIMATION',3,3,30,0,30,0,'PE - Professional Elective',40,60,100,450,0,450,0,0,'UNIQUE',NULL,NULL,900,1),(523,'22AI042 ','SOFTWARE PROJECT MANAGEMENT',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(524,'22AI043 ','PYTHON FOR DATA SCIENCE ',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(525,'22AI044 ','EXPLORATORY DATA ANALYSIS',3,3,30,0,30,0,'PE - Professional Elective',40,60,100,450,0,450,0,0,'UNIQUE',NULL,NULL,900,1),(526,'22AI045','FUNDAMENTALS OF MACHINE LEARNING',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(527,'22AI046','DEEP LEARNING ESSENTIALS',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(528,'22AI047 ','TEXT AND SPEECH ANALYSIS',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(529,'22AI048 ','COMPUTER VISION AND IMAGE PROCESSING',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(530,'22AI049 ','ETHICS IN DATA SCIENCE ',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(531,'22OAI01','FUNDAMENTALS OF DATA SCIENCE',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,0),(532,'22AIH07','VIRTUALIZATION IN CLOUD COMPUTING',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(533,'22AIH08','CLOUD SERVICES AND DATA MANAGEMENT',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(534,'22AIH09 ','CLOUD STORAGE TECHNOLOGIES',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(535,'22AIH10','CLOUD AUTOMATION TOOLS AND APPLICATIONS',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,645,0,0,0,0,'UNIQUE',NULL,NULL,645,1),(536,'22AIH11 ','SOFTWARE DEFINED NETWORKS',3,3,30,0,30,0,'PE - Professional Elective',40,60,100,450,0,450,0,0,'UNIQUE',NULL,NULL,900,1),(537,'22AIH12','SECURITY AND PRIVACY IN CLOUD',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(538,'22AIH13','CYBER SECURITY ',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(539,'22AIH14 ',' MODERN CRYPTOGRAPHY',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,630,0,0,0,0,'UNIQUE',NULL,NULL,630,1),(540,'22AIH15','CYBER FORENSICS ',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(541,'22AIH16','ETHICAL HACKING',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(542,'22AIH17','CRYPTOCURRENCY AND BLOCKCHAIN TECHNOLOGIES',3,3,30,0,30,0,'PE - Professional Elective',40,60,100,450,0,450,0,0,'UNIQUE',NULL,NULL,900,1),(543,'22AIH18 ','MALWARE ANALYSIS ',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,570,0,0,0,0,'UNIQUE',NULL,NULL,570,1),(544,'22AIM43','PYTHON FOR DATA SCIENCE',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(545,'22AIM44','EXPLORATORY DATA ANALYSIS',3,3,30,0,30,0,'PE - Professional Elective',40,60,100,450,0,420,0,0,'UNIQUE',NULL,NULL,870,1),(546,'22AIM45 ','FUNDAMENTALS OF MACHINE LEARNING',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(547,'22AIM46 ','DEEP LEARNING ESSENTIALS',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,630,0,0,0,0,'UNIQUE',NULL,NULL,630,1),(548,'22AIM47 ','TEXT AND SPEECH ANALYSIS',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,600,0,0,0,0,'UNIQUE',NULL,NULL,600,1),(549,'22AIM48 ','COMPUTER VISION AND IMAGE PROCESSING',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,585,0,0,0,0,'UNIQUE',NULL,NULL,585,1),(550,'22AIM49','ETHICS IN DATA SCIENCE ',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(551,'22AI0XA','MACHINE LEARNING IN INTERNET OF ROBOTIC THINGS (IoRT)',1,1,15,0,0,0,'EEC - Employability Enhancement Course',40,60,100,225,0,0,0,0,'UNIQUE',NULL,NULL,225,1),(552,'22AI0XB','AUGMENTED REALITY',1,1,15,0,0,0,'EEC - Employability Enhancement Course',40,60,100,225,0,0,0,0,'UNIQUE',NULL,NULL,225,1),(553,'22AI0XC','STATISTICAL MODELLING IN R PROGRAMMING ',1,1,15,0,0,0,'EEC - Employability Enhancement Course',40,60,100,225,0,0,0,0,'UNIQUE',NULL,NULL,225,1),(554,'22AI0XD ','NODE.JS',1,1,15,0,0,0,'EEC - Employability Enhancement Course',40,60,100,225,0,0,0,0,'UNIQUE',NULL,NULL,225,1),(555,'22AI0XE ','MLOps ESSENTIALS',1,1,15,0,0,0,'EEC - Employability Enhancement Course',40,60,100,225,0,0,0,0,'UNIQUE',NULL,NULL,225,1),(556,'22AI0XF','APACHE KAFKA',1,1,15,0,0,0,'EEC - Employability Enhancement Course',40,60,100,225,0,0,0,0,'UNIQUE',NULL,NULL,225,1),(557,'22AI0XG ','FULL STACK DEVELOPMENT USING ADAPTIVE AI ',1,1,15,0,0,0,'EEC - Employability Enhancement Course',40,60,100,225,0,0,0,0,'UNIQUE',NULL,NULL,225,1),(558,'22AI0XH','DEMYSTIFYING DIALOGUECRAFT AI AND APPLICATIONS',1,1,15,0,0,0,'EEC - Employability Enhancement Course',40,60,100,225,0,0,0,0,'UNIQUE',NULL,NULL,225,1),(559,'22AI0XI ','AI BASED DEEPFAKE IMAGE CREATION ',1,1,15,0,0,0,'EEC - Employability Enhancement Course',40,60,100,225,0,0,0,0,'UNIQUE',NULL,NULL,225,1),(560,'NA','PROFESSIONAL ELECTIVE I ',1,3,0,0,0,0,'PE - Professional Elective',40,60,100,0,0,0,0,0,'UNIQUE',NULL,NULL,0,1),(561,'NA','PROFESSIONAL ELECTIVE II',1,3,0,0,0,0,'PE - Professional Elective',40,60,100,0,0,0,0,0,'UNIQUE',NULL,NULL,0,1),(562,'NA','OPEN ELECTIVE',1,3,45,0,0,0,'PE - Professional Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(563,'NA','PROFESSIONAL ELECTIVE III',1,3,0,0,0,0,'PE - Professional Elective',40,60,100,0,0,0,0,0,'UNIQUE',NULL,NULL,0,1),(564,'NA','PROFESSIONAL ELECTIVE IV ',1,3,0,0,0,0,'PE - Professional Elective',40,60,100,0,0,0,0,0,'UNIQUE',NULL,NULL,0,1),(565,'NA','PROFESSIONAL ELECTIVE V',1,3,0,0,0,0,'PE - Professional Elective',40,60,100,0,0,0,0,0,'UNIQUE',NULL,NULL,0,1),(566,'NA','PROFESSIONAL ELECTIVE VI ',1,3,0,0,0,0,'PE - Professional Elective',40,60,100,0,0,0,0,0,'UNIQUE',NULL,NULL,0,1),(567,'NA','PROFESSIONAL ELECTIVE VII',1,3,0,0,0,0,'PE - Professional Elective',40,60,100,0,0,0,0,0,'UNIQUE',NULL,NULL,0,1),(568,'NA','PROFESSIONAL ELECTIVE VII',1,3,0,0,0,0,'PE - Professional Elective',40,60,100,0,0,0,0,0,'UNIQUE',NULL,NULL,0,1),(569,'NA','PROFESSIONAL ELECTIVE IX ',1,3,0,0,0,0,'PE - Professional Elective',40,60,100,0,0,0,0,0,'UNIQUE',NULL,NULL,0,1),(570,'22OCE01','ENERGY CONSERVATION AND MANAGEMENT',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(571,'22OCE02','COST MANAGEMENT OF ENGINEERING PROJECTS',1,3,45,0,45,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(572,'22OEC02','MICROCONTROLLER PROGRAMMING ',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(573,'22OEC03 ','PRINCIPLES OF COMMUNICATION SYSTEMS',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(574,'22OEI01','PROGRAMMABLE LOGIC CONTROLLER',1,3,0,0,0,0,'OE - Open Elective',40,60,100,0,0,0,0,0,'UNIQUE',NULL,NULL,0,1),(575,'22OEI02','SENSOR TECHNOLOGY',1,3,0,0,0,0,'OE - Open Elective',40,60,100,0,0,0,0,0,'UNIQUE',NULL,NULL,0,1),(576,'22OEI03','FUNDAMENTALS OF VIRTUAL INSTRUMENTATION',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(577,'22OEI04','OPTOELECTRONICS AND LASER INSTRUMENTATION',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(578,'22OME0','DIGITAL MANUFACTURING',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(579,'22OME02','INDUSTRIAL PROCESS ENGINEERING',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(580,'22OME03','MAINTENANCE ENGINEERING',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(581,'22OME04 ','SAFETY ENGINEERING ',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(582,'22OBT01','BIOFUELS',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(583,'22OFD01','TRADITIONAL FOODS',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(584,'22OFD02 ','FOOD LAWS AND REGULATIONS',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(585,'22OFD03','POST HARVEST TECHNOLOGY OF FRUITS AND VEGETABLES',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(586,'22OFD04','CEREAL, PULSES AND OILSEED TECHNOLOGY ',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(587,'22OFT01','FASHION CRAFTSMANSHIP',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(588,'22OFT02 ','INTERIOR DESIGN IN FASHION ',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(589,'22OFT03 ','SURFACE ORNAMENTATION',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(590,'22OPH02','SEMICONDUCTOR PHYSICS AND DEVICES ',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(591,'22OPH03 ','APPLIED LASER SCIENCE',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(592,'22OPH04 ','BIOPHOTONICS',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(593,'22OPH05 ','PHYSICS OF SOFT MATTER',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(594,'22OCH01','CORROSION SCIENCE AND ENGINEERING',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(595,'22OCH02','POLYMER SCIENCE ',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(596,'22OCH03 ','ENERGY STORING DEVICES',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(597,'22OGE01','PRINCIPLES OF MANAGEMENT ',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(598,'22OGE02 ','ENTREPRENEURSHIP DEVELOPMENT I',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(599,'22OGE03','ENTREPRENEURSHIP DEVELOPMENT II',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(600,'22OGE04','NATION BUILDING, LEADERSHIP AND SOCIAL RESPONSIBILITY',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(601,'22OBM01','OCCUPATIONAL SAFETY AND HEALTH IN PUBLIC HEALTH EMERGENCIES',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(602,'22OBM02','AMBULANCE AND EMERGENCY MEDICAL SERVICE MANAGEMENT',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(603,'22OBM03','HOSPITAL AUTOMATION ',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(604,'22OAG01','RAIN WATER HARVESTING TECHNIQUES',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(605,'22OEE01 ','VALUE ENGINEERING',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(606,'22OEE02 ','ELECTRICAL SAFETY',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(607,'22OCB01','INTERNATIONAL BUSINESS MANAGEMENT',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(608,'22OAI01 ','FUNDAMENTALS OF DATA SCIENCE',1,3,45,0,0,0,'OE - Open Elective',40,60,100,675,0,0,0,0,'UNIQUE',NULL,NULL,675,1),(609,'22HS201 ','COMMUNICATIVE ENGLISH II',3,2,15,0,30,0,'HSS - Humanities and Social Sciences',40,60,100,225,0,450,0,0,'UNIQUE',NULL,NULL,675,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=298 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curriculum`
--

LOCK TABLES `curriculum` WRITE;
/*!40000 ALTER TABLE `curriculum` DISABLE KEYS */;
INSERT INTO `curriculum` VALUES (15,'R2022- B.Tech - AGRI','2025-2026','2022','2026-01-21 06:03:42',165,1,NULL),(16,'R2022- B.TECH - AI&DS','2025-2026','2022','2026-01-21 06:20:21',165,1,NULL),(17,'R2022- B.TECH - AIML','2025-2026','2022','2026-01-21 06:27:52',163,1,NULL),(18,'R2022- B.E- BME','2025-2026','2022','2026-01-21 06:32:32',163,1,NULL),(20,'R2022- B.E- CIVIL','2025-2026','2022','2026-01-21 06:46:08',164,1,NULL),(21,'R2022- B.TECH - BT','2025-2026','2022','2026-01-21 06:53:55',165,1,NULL),(22,'R2022- B.TECH - CSBS','2025-2026','2022','2026-01-21 06:58:26',163,1,NULL),(23,'R2022- B.E - CSD','2025-2026','2022','2026-01-21 08:39:35',163,1,NULL),(24,'R2022- B.E- CSE','2025-2026','2022','2026-01-21 08:42:12',163,1,NULL),(25,'R2022- B.TECH - CT','2025-2026','2022','2026-01-21 08:45:53',163,1,NULL),(26,'R2022- B.E - EEE','2025-2026','2022','2026-01-21 08:48:07',163,1,NULL),(27,'R2022- B.E - ECE','2025-2026','2022','2026-01-21 08:51:40',163,1,NULL),(28,'R2022- B.E - EIE','2025-2026','2022','2026-01-21 08:53:35',163,1,NULL),(29,'R2022- B.TECH - FT','2025-2026','2022','2026-01-21 08:55:25',163,1,NULL),(30,'R2022- B.TECH - FD','2025-2026','2022','2026-01-21 08:57:21',163,1,NULL),(31,'R2022- B.E- ISE','2025-2026','2022','2026-01-21 08:59:18',162,1,NULL),(32,'R2022- B.TECH - IT','2025-2026','2022','2026-01-21 09:01:37',163,1,NULL),(33,'REVISED R2022- B.E - ME','2025-2026','2022','2026-01-21 09:05:35',164,1,NULL),(34,'R2022- B.E - MTRS','2025-2026','2022','2026-01-21 09:07:38',165,1,NULL),(35,'R2022- B.TECH - TXT','2025-2026','2022','2026-01-21 09:10:05',163,1,NULL),(36,'R2024- M.E - CSE','2025-2026','2022','2026-01-21 09:14:28',71,1,NULL),(37,'R2024- M.E-INDUSTRIAL SAFETY ENGINEERING ','2025-2026','2022','2026-01-21 09:18:18',71,1,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=883 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curriculum_courses`
--

LOCK TABLES `curriculum_courses` WRITE;
/*!40000 ALTER TABLE `curriculum_courses` DISABLE KEYS */;
INSERT INTO `curriculum_courses` VALUES (229,36,73,102,1),(230,16,75,17,1),(231,16,75,103,1),(232,16,75,104,1),(233,16,75,105,1),(234,16,75,106,1),(235,16,75,107,1),(236,16,75,108,1),(237,16,75,109,1),(238,16,75,110,1),(239,16,76,111,1),(241,16,76,113,1),(242,17,77,17,1),(243,17,77,103,1),(244,17,77,104,1),(245,17,77,114,1),(246,17,77,106,1),(247,17,77,107,1),(248,17,77,108,1),(249,17,77,109,1),(250,17,77,115,1),(251,17,78,111,1),(252,17,78,113,1),(253,17,78,116,1),(254,17,78,117,1),(255,17,78,118,1),(256,17,78,119,1),(257,17,78,120,1),(258,17,79,121,1),(259,33,80,122,1),(260,33,80,18,1),(261,33,80,123,1),(262,33,80,105,1),(263,33,80,124,1),(264,33,80,118,1),(265,33,80,125,1),(266,33,80,109,1),(267,33,80,126,1),(268,33,81,111,1),(269,24,88,122,1),(270,24,88,18,1),(271,24,88,123,1),(272,33,81,127,1),(273,24,88,114,1),(274,33,81,116,1),(275,24,88,106,1),(276,33,81,128,1),(277,33,81,107,1),(278,33,81,108,1),(279,24,88,107,1),(280,24,88,129,1),(281,24,88,109,1),(282,33,81,130,1),(283,24,88,131,1),(284,24,90,111,1),(285,27,91,17,1),(286,33,81,132,1),(287,33,82,133,1),(288,27,91,18,1),(289,33,82,134,1),(290,33,82,135,1),(291,27,91,104,1),(292,33,82,136,1),(293,27,91,114,1),(294,33,82,137,1),(295,33,82,138,1),(296,27,91,106,1),(297,33,82,139,1),(298,33,82,140,1),(299,27,91,118,1),(300,27,91,108,1),(301,24,90,113,1),(302,24,90,141,1),(303,27,91,142,1),(304,33,83,143,1),(305,24,90,117,1),(306,27,91,144,1),(307,24,90,118,1),(308,24,90,145,1),(309,27,92,111,1),(310,33,83,146,1),(311,24,90,147,1),(312,33,83,148,1),(313,24,90,120,1),(314,33,83,149,1),(315,24,93,121,1),(316,24,90,150,1),(317,27,92,127,1),(318,33,83,151,1),(319,24,93,152,1),(320,27,92,116,1),(321,27,92,128,1),(322,33,83,153,1),(323,24,93,154,1),(324,27,92,107,1),(325,24,93,155,1),(326,33,83,156,1),(327,27,92,125,1),(328,24,93,157,1),(329,24,93,158,1),(330,33,83,159,1),(331,27,92,147,1),(332,17,79,160,1),(333,21,94,17,1),(334,27,92,161,1),(335,24,93,139,1),(336,33,84,162,1),(337,24,95,163,1),(338,33,84,164,1),(339,21,94,103,1),(340,27,92,165,1),(341,33,84,166,1),(342,33,84,167,1),(343,33,84,168,1),(344,32,72,17,1),(345,33,84,169,1),(346,32,72,103,1),(347,33,85,170,1),(348,27,96,171,1),(349,33,85,172,1),(350,32,72,104,1),(351,21,94,104,1),(352,33,85,173,1),(353,27,96,174,1),(354,17,79,175,1),(355,16,76,141,1),(356,33,85,176,1),(357,32,72,105,1),(358,24,95,177,1),(359,33,86,178,1),(360,32,72,106,1),(361,27,96,179,1),(362,21,94,105,1),(363,17,79,180,1),(364,32,72,107,1),(365,16,76,117,1),(366,33,86,181,1),(367,32,72,129,1),(368,17,79,182,1),(369,33,86,183,1),(370,16,76,118,1),(371,33,87,184,1),(372,17,79,185,1),(373,16,76,186,1),(374,17,79,158,1),(375,21,94,106,1),(376,32,72,109,1),(377,21,94,118,1),(378,32,72,187,1),(379,17,79,139,1),(380,21,94,108,1),(381,21,94,109,1),(382,17,89,188,1),(383,21,94,189,1),(384,16,76,130,1),(385,17,89,190,1),(386,32,102,111,1),(387,17,89,191,1),(388,32,102,113,1),(389,32,102,141,1),(390,17,89,192,1),(391,17,89,193,1),(392,32,102,117,1),(393,16,103,194,1),(394,32,102,118,1),(395,17,89,153,1),(396,16,103,195,1),(397,20,104,17,1),(398,32,102,196,1),(399,16,103,197,1),(400,32,102,120,1),(401,16,103,198,1),(402,17,89,199,1),(403,16,103,200,1),(404,16,103,158,1),(405,17,108,201,1),(406,21,107,111,1),(407,16,103,139,1),(408,17,108,202,1),(409,27,96,203,1),(410,21,107,113,1),(411,27,96,204,1),(412,17,108,205,1),(413,16,109,206,1),(414,21,107,141,1),(415,27,96,158,1),(416,17,108,207,1),(417,21,107,117,1),(418,27,96,139,1),(419,16,109,208,1),(420,21,107,107,1),(421,17,108,209,1),(422,32,111,210,1),(423,16,109,211,1),(424,21,107,125,1),(425,33,110,212,1),(426,16,109,213,1),(427,33,110,214,1),(428,27,97,215,1),(429,33,110,216,1),(430,17,112,217,1),(431,16,109,218,1),(432,33,110,219,1),(433,17,112,220,1),(434,27,97,221,1),(435,33,110,222,1),(436,20,104,18,1),(437,32,111,223,1),(438,17,112,224,1),(439,16,109,153,1),(440,21,107,120,1),(441,32,111,225,1),(442,27,97,226,1),(443,20,104,104,1),(444,33,113,227,1),(445,32,111,228,1),(446,33,113,229,1),(447,27,97,230,1),(448,21,107,150,1),(449,33,113,231,1),(450,17,112,232,1),(451,32,111,233,1),(452,33,113,234,1),(453,27,97,235,1),(454,33,113,236,1),(455,21,114,237,1),(456,33,113,238,1),(457,17,115,239,1),(458,32,111,158,1),(459,16,109,156,1),(460,20,104,103,1),(461,33,113,240,1),(462,32,111,139,1),(463,17,115,241,1),(464,21,114,242,1),(465,32,116,243,1),(466,21,114,244,1),(467,32,116,245,1),(468,27,96,153,1),(469,21,114,246,1),(470,32,116,247,1),(471,21,114,248,1),(472,27,96,156,1),(473,20,104,105,1),(474,21,114,158,1),(475,32,116,249,1),(476,27,96,250,1),(477,21,114,139,1),(478,17,115,251,1),(479,16,109,252,1),(480,32,116,253,1),(481,20,104,106,1),(482,17,119,254,1),(483,32,116,153,1),(484,16,120,255,1),(485,21,118,256,1),(486,32,116,199,1),(487,17,121,212,1),(488,17,121,257,1),(489,21,118,258,1),(490,16,120,259,1),(491,17,121,216,1),(492,21,118,260,1),(493,17,121,219,1),(494,21,118,261,1),(495,16,120,262,1),(496,21,118,263,1),(497,17,121,222,1),(498,16,120,264,1),(499,20,104,118,1),(500,21,118,153,1),(501,17,130,265,1),(502,21,118,199,1),(503,20,104,125,1),(504,16,120,266,1),(505,17,130,267,1),(506,21,118,252,1),(507,17,130,268,1),(508,27,97,199,1),(509,20,104,109,1),(510,16,131,269,1),(511,17,130,270,1),(512,17,130,272,1),(513,20,104,273,1),(514,16,131,274,1),(515,21,132,276,1),(516,16,131,277,1),(517,21,132,278,1),(518,16,131,279,1),(519,27,98,280,1),(520,32,133,281,1),(521,21,132,282,1),(522,32,133,283,1),(523,27,98,284,1),(524,21,132,285,1),(525,32,133,286,1),(526,20,134,111,1),(527,16,135,287,1),(528,21,132,288,1),(529,27,98,289,1),(530,32,133,290,1),(531,20,134,113,1),(532,32,133,291,1),(533,21,136,292,1),(534,27,98,293,1),(535,16,135,294,1),(536,21,136,295,1),(537,32,137,296,1),(538,27,98,297,1),(539,32,137,298,1),(540,21,136,299,1),(541,27,99,300,1),(542,32,137,301,1),(543,21,136,302,1),(544,32,137,303,1),(545,20,134,141,1),(546,21,139,304,1),(547,27,99,305,1),(548,32,140,306,1),(549,21,139,307,1),(550,32,140,308,1),(551,27,99,309,1),(552,16,135,310,1),(553,21,139,311,1),(554,32,140,312,1),(555,27,99,313,1),(556,21,142,314,1),(557,20,134,117,1),(558,27,100,315,1),(559,20,134,107,1),(560,16,141,316,1),(561,27,100,317,1),(562,21,144,212,1),(563,20,134,108,1),(564,27,100,318,1),(565,21,144,257,1),(566,16,138,212,1),(567,27,101,319,1),(568,21,144,216,1),(569,20,134,120,1),(570,16,138,257,1),(571,21,144,219,1),(572,21,144,320,1),(573,16,138,216,1),(574,32,157,321,1),(575,21,144,222,1),(576,32,157,322,1),(577,20,168,323,1),(578,32,157,324,1),(579,16,138,219,1),(580,32,157,325,1),(581,16,138,222,1),(582,20,168,326,1),(583,32,157,327,1),(584,32,157,328,1),(585,20,168,329,1),(586,27,171,212,1),(587,20,168,330,1),(588,27,171,214,1),(589,20,168,331,1),(590,27,171,216,1),(591,20,168,158,1),(592,27,171,219,1),(593,27,171,332,1),(594,20,168,139,1),(595,32,173,333,1),(596,32,173,334,1),(597,32,173,335,1),(598,20,183,336,1),(599,32,173,337,1),(600,32,173,338,1),(601,27,184,339,1),(602,32,173,340,1),(603,21,185,341,1),(604,32,188,342,1),(605,16,172,343,1),(606,32,188,344,1),(607,21,185,345,1),(608,21,185,346,1),(609,21,185,347,1),(610,21,185,348,1),(611,16,172,349,1),(612,21,185,350,1),(613,20,183,351,1),(614,16,172,352,1),(615,16,172,353,1),(616,27,184,354,1),(617,16,172,355,1),(618,27,184,356,1),(619,16,172,357,1),(620,27,184,358,1),(621,27,184,359,1),(622,15,146,17,1),(623,27,184,360,1),(624,20,183,361,1),(625,15,146,103,1),(626,20,183,362,1),(627,15,146,104,1),(628,20,183,363,1),(629,15,146,105,1),(630,15,146,106,1),(631,16,175,364,1),(632,15,146,118,1),(633,15,146,125,1),(634,15,146,109,1),(635,20,183,199,1),(636,20,191,365,1),(637,20,191,366,1),(638,20,191,367,1),(639,20,191,368,1),(640,20,191,369,1),(641,25,193,17,1),(642,25,193,103,1),(643,25,193,123,1),(644,20,192,370,1),(645,20,192,371,1),(646,20,192,372,1),(647,25,193,105,1),(648,20,192,373,1),(649,25,193,106,1),(650,25,193,107,1),(651,20,194,374,1),(652,25,193,108,1),(653,20,194,375,1),(654,25,193,109,1),(655,20,194,376,1),(656,25,193,377,1),(657,25,195,111,1),(658,20,196,378,1),(659,25,195,127,1),(660,25,195,141,1),(661,25,195,117,1),(662,25,195,379,1),(663,25,195,380,1),(664,25,195,120,1),(665,20,198,212,1),(666,20,198,257,1),(667,20,198,381,1),(668,20,198,219,1),(669,20,198,222,1),(670,25,197,382,1),(671,25,197,383,1),(672,25,197,384,1),(673,25,197,385,1),(674,25,197,386,1),(675,25,197,158,1),(676,25,197,139,1),(677,25,199,387,1),(678,25,199,388,1),(679,25,199,389,1),(680,25,199,390,1),(681,25,199,391,1),(682,25,199,153,1),(683,25,199,199,1),(684,25,200,392,1),(685,25,200,393,1),(686,25,200,394,1),(687,25,200,395,1),(688,25,200,396,1),(689,21,185,397,1),(690,21,202,398,1),(691,21,202,399,1),(692,21,202,400,1),(693,21,202,401,1),(694,21,202,402,1),(695,21,202,403,1),(696,21,202,404,1),(697,21,203,405,1),(698,21,203,406,1),(699,21,203,407,1),(700,21,203,408,1),(701,21,203,409,1),(702,21,203,410,1),(703,21,203,411,1),(704,21,204,412,1),(705,17,130,413,1),(706,21,204,414,1),(707,16,175,415,1),(708,21,204,416,1),(709,17,145,417,1),(710,21,204,418,1),(711,16,175,419,1),(712,17,145,420,1),(713,21,204,421,1),(714,21,204,422,1),(715,17,145,423,1),(716,16,175,424,1),(717,17,145,425,1),(718,17,145,426,1),(719,16,175,427,1),(720,17,145,428,1),(721,16,175,429,1),(722,17,149,430,1),(723,16,176,431,1),(724,17,149,432,1),(725,16,176,433,1),(726,17,149,434,1),(727,17,149,435,1),(728,16,176,436,1),(729,17,149,437,1),(730,16,176,438,1),(731,17,149,439,1),(732,16,176,440,1),(733,17,152,441,1),(734,16,176,442,1),(735,17,152,443,1),(736,24,95,444,1),(737,17,152,445,1),(738,17,152,446,1),(739,21,205,447,1),(740,17,152,448,1),(741,17,152,449,1),(742,16,178,450,1),(743,16,178,451,1),(744,16,178,452,1),(745,16,178,453,1),(746,16,178,454,1),(747,21,205,455,1),(748,17,158,456,1),(749,16,178,457,1),(750,16,179,458,1),(751,17,158,459,1),(752,17,158,460,1),(753,16,179,461,1),(754,16,179,462,1),(755,17,158,463,1),(756,16,179,464,1),(757,17,158,465,1),(758,16,179,466,1),(759,17,159,467,1),(760,16,179,468,1),(761,17,159,469,1),(762,17,159,470,1),(763,17,159,471,1),(764,16,180,472,1),(765,17,159,473,1),(766,16,180,474,1),(767,17,159,475,1),(768,16,180,476,1),(769,17,160,477,1),(770,17,160,478,1),(771,16,180,479,1),(772,24,95,480,1),(773,25,201,481,1),(774,25,201,482,1),(775,25,201,483,1),(776,25,201,484,1),(777,25,207,485,1),(778,25,207,486,1),(779,25,207,487,1),(780,25,209,488,1),(781,25,209,489,1),(782,20,257,490,1),(783,20,257,491,1),(784,20,257,492,1),(785,20,257,493,1),(786,20,257,494,1),(787,20,257,495,1),(788,20,258,496,1),(789,20,258,497,1),(790,20,258,498,1),(791,20,258,499,1),(792,20,258,500,1),(793,20,258,501,1),(794,20,259,502,1),(795,20,259,503,1),(796,20,259,504,1),(797,20,259,505,1),(798,20,259,506,1),(799,20,259,507,1),(800,20,260,508,1),(801,20,260,509,1),(802,20,260,510,1),(803,20,260,511,1),(804,20,260,512,1),(805,20,260,513,1),(806,20,261,514,1),(807,20,261,515,1),(808,16,180,516,1),(809,16,180,517,1),(810,16,181,518,1),(811,16,181,519,1),(812,16,181,520,1),(813,16,181,521,1),(814,16,181,522,1),(815,16,181,523,1),(816,16,182,524,1),(817,16,182,525,1),(818,16,182,526,1),(819,16,182,527,1),(820,16,182,528,1),(821,16,182,529,1),(822,16,182,530,1),(823,16,186,531,1),(824,16,187,551,1),(825,16,187,552,1),(826,16,187,553,1),(827,16,187,554,1),(828,16,187,555,1),(829,16,187,556,1),(830,16,187,557,1),(831,16,187,558,1),(832,16,187,559,1),(833,16,109,560,1),(834,16,120,561,1),(835,16,120,562,1),(836,16,131,563,1),(837,16,131,564,1),(838,16,131,565,1),(839,16,135,566,1),(840,16,135,567,1),(841,16,135,568,1),(842,16,135,569,1),(843,16,186,570,1),(844,16,186,571,1),(845,16,186,572,1),(846,16,186,573,1),(847,16,186,574,1),(848,16,186,575,1),(849,16,186,576,1),(850,16,186,577,1),(851,16,186,578,1),(852,16,186,579,1),(853,16,186,580,1),(854,16,186,581,1),(855,16,186,582,1),(856,16,186,583,1),(857,16,186,584,1),(858,16,186,585,1),(859,16,186,586,1),(860,16,186,587,1),(861,16,186,588,1),(862,16,186,589,1),(863,16,186,590,1),(864,16,186,591,1),(865,16,186,592,1),(866,16,186,593,1),(867,16,186,594,1),(868,16,186,595,1),(869,16,186,596,1),(870,16,186,597,1),(871,16,186,598,1),(872,16,186,599,1),(873,16,186,600,1),(874,16,186,601,1),(875,16,186,602,1),(876,16,186,603,1),(877,16,186,604,1),(878,16,186,605,1),(879,16,186,606,1),(880,16,186,607,1),(881,16,190,608,1),(882,16,262,609,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=1307 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curriculum_logs`
--

LOCK TABLES `curriculum_logs` WRITE;
/*!40000 ALTER TABLE `curriculum_logs` DISABLE KEYS */;
INSERT INTO `curriculum_logs` VALUES (265,15,'Curriculum Created','Created new curriculum: R2022- AGRI (2025-2026)','System','2026-01-21 06:03:43',NULL),(266,15,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-21 06:09:22',NULL),(267,15,'PEO-PO Mapping Saved','Updated PEO-PO mappings for the curriculum','System','2026-01-21 06:16:06',NULL),(268,15,'Curriculum Updated','Updated curriculum details','System','2026-01-21 06:19:01','{\"name\": {\"new\": \"R2022- B.Tech - AGRI\", \"old\": \"R2022- AGRI\"}}'),(269,16,'Curriculum Created','Created new curriculum: R2022- B.TECH - AI&DS (2025-2026)','System','2026-01-21 06:20:21',NULL),(270,16,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-21 06:24:31',NULL),(271,16,'PEO-PO Mapping Saved','Updated PEO-PO mappings for the curriculum','System','2026-01-21 06:25:47',NULL),(272,17,'Curriculum Created','Created new curriculum: R2022- B.TECH - AIML (2025-2026)','System','2026-01-21 06:27:53',NULL),(273,17,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-21 06:29:15',NULL),(274,18,'Curriculum Created','Created new curriculum: R2022- B.E- BME (2025-2026)','System','2026-01-21 06:32:33',NULL),(275,18,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-21 06:34:36',NULL),(279,20,'Curriculum Created','Created new curriculum: R2022- B.E- CIVIL (2025-2026)','System','2026-01-21 06:46:08',NULL),(280,20,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-21 06:51:34',NULL),(281,20,'PEO-PO Mapping Saved','Updated PEO-PO mappings for the curriculum','System','2026-01-21 06:52:58',NULL),(282,21,'Curriculum Created','Created new curriculum: R2022- B.TECH - BT (2025-2026)','System','2026-01-21 06:53:55',NULL),(283,21,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-21 06:56:40',NULL),(284,21,'PEO-PO Mapping Saved','Updated PEO-PO mappings for the curriculum','System','2026-01-21 06:57:32',NULL),(285,22,'Curriculum Created','Created new curriculum: R2022- B.TECH - CSBS (2025-2026)','System','2026-01-21 06:58:26',NULL),(286,22,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-21 06:59:47',NULL),(287,23,'Curriculum Created','Created new curriculum: R2022- B.E - CSD (2025-2026)','System','2026-01-21 08:39:35',NULL),(288,23,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-21 08:40:51',NULL),(289,24,'Curriculum Created','Created new curriculum: R2022- B.E- CSE (2025-2026)','System','2026-01-21 08:42:12',NULL),(290,24,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-21 08:45:12',NULL),(291,25,'Curriculum Created','Created new curriculum: R2022- B.TECH - CT (2025-2026)','System','2026-01-21 08:45:53',NULL),(292,25,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-21 08:46:56',NULL),(293,26,'Curriculum Created','Created new curriculum: R2022- B.E - EEE (2025-2026)','System','2026-01-21 08:48:07',NULL),(294,26,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-21 08:49:22',NULL),(295,27,'Curriculum Created','Created new curriculum: R2022- B.E - ECE (2025-2026)','System','2026-01-21 08:51:40',NULL),(296,27,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-21 08:52:39',NULL),(297,28,'Curriculum Created','Created new curriculum: R2022- B.E - EIE (2025-2026)','System','2026-01-21 08:53:35',NULL),(298,28,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-21 08:54:42',NULL),(299,29,'Curriculum Created','Created new curriculum: R2022- B.TECH - FT (2025-2026)','System','2026-01-21 08:55:25',NULL),(300,29,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-21 08:56:30',NULL),(301,30,'Curriculum Created','Created new curriculum: R2022- B.TECH - FD (2025-2026)','System','2026-01-21 08:57:22',NULL),(302,30,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-21 08:58:27',NULL),(303,31,'Curriculum Created','Created new curriculum: R2022- B.E- ISE (2025-2026)','System','2026-01-21 08:59:18',NULL),(304,31,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-21 09:00:40',NULL),(305,32,'Curriculum Created','Created new curriculum: R2022- B.TECH - IT (2025-2026)','System','2026-01-21 09:01:37',NULL),(306,32,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-21 09:03:21',NULL),(307,33,'Curriculum Created','Created new curriculum: REVISED R2022- B.E - ME (2025-2026)','System','2026-01-21 09:05:35',NULL),(308,33,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-21 09:06:46',NULL),(309,34,'Curriculum Created','Created new curriculum: R2022- B.E - MTRS (2025-2026)','System','2026-01-21 09:07:39',NULL),(310,34,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-21 09:08:48',NULL),(311,35,'Curriculum Created','Created new curriculum: R2022- B.TECH - TXT (2025-2026)','System','2026-01-21 09:10:06',NULL),(312,35,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-21 09:11:06',NULL),(313,36,'Curriculum Created','Created new curriculum: R2024- M.E - CSE (2025-2026)','System','2026-01-21 09:14:28',NULL),(314,36,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-21 09:16:11',NULL),(315,36,'PEO-PO Mapping Saved','Updated PEO-PO mappings for the curriculum','System','2026-01-21 09:16:43',NULL),(316,37,'Curriculum Created','Created new curriculum: R2022- M.E-INDUSTRIAL SAFETY ENGINEERING  (2025-2026)','System','2026-01-21 09:18:18',NULL),(317,37,'Department Overview Created','Created department vision, mission, PEOs, POs, and PSOs','System','2026-01-21 09:19:38',NULL),(318,37,'PEO-PO Mapping Saved','Updated PEO-PO mappings for the curriculum','System','2026-01-21 09:20:01',NULL),(319,37,'Curriculum Updated','Updated curriculum details','System','2026-01-21 09:20:54','{\"name\": {\"new\": \"R2024- M.E-INDUSTRIAL SAFETY ENGINEERING \", \"old\": \"R2022- M.E-INDUSTRIAL SAFETY ENGINEERING \"}}'),(320,32,'Card Added','Added Semester 1','System','2026-01-21 09:23:12',NULL),(321,36,'Card Added','Added Semester 1','System','2026-01-21 09:26:28',NULL),(322,36,'Course Added','Added course 22MA2 - ENGINEERING MATHEMATICS I to Semester 73','System','2026-01-21 09:29:02',NULL),(323,36,'Card Added','Added New Card','System','2026-01-21 09:30:30',NULL),(324,16,'Card Added','Added Semester 1','System','2026-01-22 04:31:17',NULL),(325,16,'Course Added','Added course 22MA101 - ENGINEERING MATHEMATICS I  to Semester 75','System','2026-01-22 04:32:44',NULL),(326,16,'Course Added','Added course 22PH102 - ENGINEERING PHYSICS  to Semester 75','System','2026-01-22 04:34:24',NULL),(327,16,'Course Added','Added course 22CH103 - ENGINEERING CHEMISTRY I  to Semester 75','System','2026-01-22 04:39:50',NULL),(328,16,'Course Added','Added course 22GE001 - FUNDAMENTALS OF COMPUTING to Semester 75','System','2026-01-22 04:40:45',NULL),(329,16,'Course Added','Added course 22HS001 - FOUNDATIONAL ENGLISH to Semester 75','System','2026-01-22 04:41:29',NULL),(330,16,'Course Added','Added course 22GE004 - BASICS OF ELECTRONICS ENGINEERING to Semester 75','System','2026-01-22 04:42:15',NULL),(331,16,'Course Added','Added course 22HS002 - STARTUP MANAGEMENT to Semester 75','System','2026-01-22 04:43:07',NULL),(332,16,'Course Added','Added course 22HS003 - தமிழர்மரபு HERITAGE OF TAMILS to Semester 75','System','2026-01-22 04:44:28',NULL),(333,16,'Course Added','Added course 22AI108 - COMPREHENSIVE WORK to Semester 75','System','2026-01-22 04:45:13',NULL),(334,16,'Card Added','Added Semester 2','System','2026-01-22 04:45:57',NULL),(335,16,'Course Added','Added course 22MA201 - ENGINEERING MATHEMATICS II to Semester 76','System','2026-01-22 04:46:35',NULL),(336,16,'Course Added','Added course 22PH202 - ELECTROMAGNETISM AND MODERN PHYSICS to Semester 76','System','2026-01-22 04:47:18',NULL),(337,16,'Course Removed','Removed course ELECTROMAGNETISM AND MODERN PHYSICS from Semester 76','System','2026-01-22 05:25:41',NULL),(338,16,'Course Added','Added course 22PH202 - ELECTROMAGNETISM AND MODERN PHYSICS  to Semester 76','System','2026-01-22 06:16:24',NULL),(339,32,'PO[5] Added','Added PO item at index 5','System','2026-01-22 06:20:03','{\"PO[5]\": {\"new\": \"The Engineer and The World: Analyze and evaluate societal and environmental aspects while solving complex engineering problems for its impact on sustainability with reference to economy, health, safety, legal framework, culture and environment. (WK1, WK5, and WK7).\", \"old\": \"\"}}'),(340,32,'PO[0] Added','Added PO item at index 0','System','2026-01-22 06:20:03','{\"PO[0]\": {\"new\": \"Engineering Knowledge: Apply knowledge of mathematics, natural science, computing, engineering fundamentals and an engineering specialization as specified in WK1 to WK4 respectively to develop to the solution of complex engineering problems.\", \"old\": \"\"}}'),(341,32,'PO[6] Added','Added PO item at index 6','System','2026-01-22 06:20:03','{\"PO[6]\": {\"new\": \" Ethics: Apply ethical principles and commit to professional ethics, human values, diversity and inclusion; adhere to national & international laws. (WK9)\", \"old\": \"\"}}'),(342,32,'PO[7] Added','Added PO item at index 7','System','2026-01-22 06:20:03','{\"PO[7]\": {\"new\": \"Individual and Collaborative Team work: Function effectively as an individual, and as a member or leader in diverse/multi-disciplinary teams.\", \"old\": \"\"}}'),(343,32,'PO[1] Added','Added PO item at index 1','System','2026-01-22 06:20:03','{\"PO[1]\": {\"new\": \"Problem Analysis: Identify, formulate, review research literature and analyze complex engineering problems reaching substantiated conclusions with consideration for sustainable development. (WK1 to WK4)\", \"old\": \"\"}}'),(344,32,'PO[4] Added','Added PO item at index 4','System','2026-01-22 06:20:03','{\"PO[4]\": {\"new\": \"Engineering Tool Usage: Create, select and apply appropriate techniques, resources and modern engineering & IT tools, including prediction and modelling recognizing their limitations to solve complex engineering problems. (WK2 and WK6)\", \"old\": \"\"}}'),(345,32,'PO[2] Added','Added PO item at index 2','System','2026-01-22 06:20:03','{\"PO[2]\": {\"new\": \"Design/Development of Solutions: Design creative solutions for complex engineering problems and design/develop systems/components/processes to meet identified needs with consideration for the public health and safety, whole-life cost, net zero carbon, culture, society and environment as required. (WK5)\", \"old\": \"\"}}'),(346,32,'PO[8] Added','Added PO item at index 8','System','2026-01-22 06:20:03','{\"PO[8]\": {\"new\": \"Communication: Communicate effectively and inclusively within the engineering community and society at large, such as being able to comprehend and write effective reports and design documentation, make effective presentations considering cultural, language, and learning differences\", \"old\": \"\"}}'),(347,32,'PO[3] Added','Added PO item at index 3','System','2026-01-22 06:20:03','{\"PO[3]\": {\"new\": \"Conduct Investigations of Complex Problems: Conduct investigations of complex engineering problems using research-based knowledge including design of experiments, modelling, analysis & interpretation of data to provide valid conclusions. (WK8).\", \"old\": \"\"}}'),(348,32,'PO[10] Added','Added PO item at index 10','System','2026-01-22 06:20:39','{\"PO[10]\": {\"new\": \"Life-Long Learning: Recognize the need for, and have the preparation and ability for i) independent and life-long learning ii) adaptability to new and emerging technologies and iii) critical thinking in the broadest context of technological change. (WK8)\", \"old\": \"\"}}'),(349,32,'PO[9] Added','Added PO item at index 9','System','2026-01-22 06:20:39','{\"PO[9]\": {\"new\": \"Project Management and Finance: Apply knowledge and understanding of engineering management principles and economic decision-making and apply these to one’s own work, as a member and leader in a team, and to manage projects and in multidisciplinary environments\", \"old\": \"\"}}'),(350,32,'PEO-PO Mapping Saved','Updated PEO-PO mappings for the curriculum','System','2026-01-22 06:22:34',NULL),(351,17,'PO[9] Added','Added PO item at index 9','System','2026-01-22 06:31:46','{\"PO[9]\": {\"new\": \"Project Management and Finance: Apply knowledge and understanding of engineering management principles and economic decision-making and apply these to one’s own work, as a member and leader in a team, and to manage projects and in multidisciplinary environments.\", \"old\": \"\"}}'),(352,17,'PO[1] Added','Added PO item at index 1','System','2026-01-22 06:31:46','{\"PO[1]\": {\"new\": \"Problem Analysis: Identify, formulate, review research literature, and analyse complex engineering problems reaching substantiated conclusions using first principles of mathematics, natural sciences, and engineering sciences.\", \"old\": \"\"}}'),(353,17,'PO[0] Added','Added PO item at index 0','System','2026-01-22 06:31:46','{\"PO[0]\": {\"new\": \"Engineering Knowledge: Apply the knowledge of mathematics, science, engineering fundamentals, and an engineering specialization to the solution of complex engineering problems.\", \"old\": \"\"}}'),(354,17,'PO[10] Added','Added PO item at index 10','System','2026-01-22 06:31:46','{\"PO[10]\": {\"new\": \"Life-Long Learning: Recognize the need for, and have the preparation and ability for i) independent and life-long learning ii) adaptability to new and emerging technologies and iii) critical thinking in the broadest context of technological change.\", \"old\": \"\"}}'),(355,17,'PO[6] Added','Added PO item at index 6','System','2026-01-22 06:31:46','{\"PO[6]\": {\"new\": \"Ethics: Apply ethical principles and commit to professional ethics, human values, diversity and inclusion; adhere to national & international laws.\", \"old\": \"\"}}'),(356,17,'PO[5] Added','Added PO item at index 5','System','2026-01-22 06:31:46','{\"PO[5]\": {\"new\": \"The Engineer and The World: Analyze and evaluate societal and environmental aspects while solving complex engineering problems for its impact on sustainability with reference to economy, health, safety, legal framework, culture and environment.\", \"old\": \"\"}}'),(357,17,'PO[7] Added','Added PO item at index 7','System','2026-01-22 06:31:46','{\"PO[7]\": {\"new\": \"Individual and Collaborative Team work: Function effectively as an individual, and as a member or leader in diverse/multi-disciplinary teams.\", \"old\": \"\"}}'),(358,17,'PO[4] Added','Added PO item at index 4','System','2026-01-22 06:31:46','{\"PO[4]\": {\"new\": \"Engineering Tool Usage: Create, select and apply appropriate techniques, resources and modern engineering & IT tools, including prediction and modelling recognizing their limitations to solve complex engineering problems.\", \"old\": \"\"}}'),(359,17,'PO[3] Added','Added PO item at index 3','System','2026-01-22 06:31:46','{\"PO[3]\": {\"new\": \"Conduct Investigations of Complex Problems: Use research-based knowledge and research methods including design of experiments, analysis and interpretation of data, and synthesis of the information to provide valid conclusions.\", \"old\": \"\"}}'),(360,17,'PO[8] Added','Added PO item at index 8','System','2026-01-22 06:31:46','{\"PO[8]\": {\"new\": \"Communication: Communicate effectively and inclusively within the engineering community and society at large, such as being able to comprehend and write effective reports and design documentation, make effective presentations considering cultural, language, and learning differences.\", \"old\": \"\"}}'),(361,17,'PO[2] Added','Added PO item at index 2','System','2026-01-22 06:31:46','{\"PO[2]\": {\"new\": \"Design/Development of Solutions: Design solutions for complex engineering problems and design system components or processes that meet the specified needs with appropriate consideration for the public health and safety, and the cultural, societal, and environmental considerations.\", \"old\": \"\"}}'),(362,17,'PEO-PO Mapping Saved','Updated PEO-PO mappings for the curriculum','System','2026-01-22 06:33:37',NULL),(363,17,'Card Added','Added Semester 1','System','2026-01-22 06:34:14',NULL),(364,17,'Course Added','Added course 22MA101 - ENGINEERING MATHEMATICS I to Semester 77','System','2026-01-22 06:44:24',NULL),(365,16,'Course Updated','Updated course: 22MA101 - ENGINEERING MATHEMATICS I ','System','2026-01-22 06:45:37','{\"lecture_hrs\": {\"new\": 3, \"old\": 0}, \"tutorial_hrs\": {\"new\": 1, \"old\": 10}, \"practical_hrs\": {\"new\": 0, \"old\": 3}}'),(366,17,'Course Added','Added course 22PH102 - ENGINEERING PHYSICS to Semester 77','System','2026-01-22 06:46:35',NULL),(367,17,'Course Added','Added course 22CH103 - ENGINEERING CHEMISTRY I to Semester 77','System','2026-01-22 06:52:24',NULL),(368,16,'Course Updated','Updated course: 22MA101 - ENGINEERING MATHEMATICS I ','System','2026-01-22 06:52:51','{\"lecture_hrs\": {\"new\": 45, \"old\": 3}, \"tutorial_hrs\": {\"new\": 15, \"old\": 1}}'),(369,17,'Course Added','Added course 22GE001  - FUNDAMENTALS OF COMPUTING to Semester 77','System','2026-01-22 06:53:48',NULL),(370,16,'Course Updated','Updated course: 22MA101 - ENGINEERING MATHEMATICS I ','System','2026-01-22 06:55:40','{\"lecture_hrs\": {\"new\": 3, \"old\": 45}, \"tutorial_hrs\": {\"new\": 1, \"old\": 15}}'),(371,17,'Course Added','Added course 22HS001 - FOUNDATIONAL ENGLISH  to Semester 77','System','2026-01-22 06:56:51',NULL),(372,17,'Course Added','Added course 22GE004 - BASICS OF ELECTRONICS ENGINEERING to Semester 77','System','2026-01-22 06:59:30',NULL),(373,17,'Course Added','Added course 22HS002 - STARTUP MANAGEMENT  to Semester 77','System','2026-01-22 07:00:13',NULL),(374,17,'Course Added','Added course 22HS003 - தமிழர்மரபு HERITAGE OF TAMILS to Semester 77','System','2026-01-22 07:00:57',NULL),(375,17,'Course Added','Added course 22AM108  - COMPREHENSIVE WORK to Semester 77','System','2026-01-22 07:01:53',NULL),(376,17,'Card Added','Added Semester 2','System','2026-01-22 07:02:33',NULL),(377,17,'Course Added','Added course 22MA201 - ENGINEERING MATHEMATICS II to Semester 78','System','2026-01-22 07:03:11',NULL),(378,17,'Course Added','Added course 22PH202 - ELECTROMAGNETISM AND MODERN PHYSICS to Semester 78','System','2026-01-22 07:04:01',NULL),(379,17,'Course Added','Added course 22CH203  - ENGINEERING CHEMISTRY II  to Semester 78','System','2026-01-22 07:04:40',NULL),(380,17,'Course Added','Added course 22GE002 - COMPUTATIONAL PROBLEM SOLVING to Semester 78','System','2026-01-22 07:05:18',NULL),(381,17,'Course Added','Added course 22GE003 - BASICS OF ELECTRICAL ENGINEERING to Semester 78','System','2026-01-22 07:06:05',NULL),(382,17,'Course Added','Added course 22AM206 - DIGITAL COMPUTER ELECTRONICS  to Semester 78','System','2026-01-22 07:06:58',NULL),(383,17,'Course Added','Added course 22HS006 - தமிழரும் ததொழில்நுட்பமும் TAMILS AND TECHNOLOGY^ to Semester 78','System','2026-01-22 07:07:43',NULL),(384,17,'PEO-PO Mapping Saved','Updated PEO-PO mappings for the curriculum','System','2026-01-22 08:11:38',NULL),(385,17,'Card Added','Added Semester 3','System','2026-01-22 08:13:13',NULL),(386,17,'Course Added','Added course 22CS301 - PROBABILITY, STATISTICS AND QUEUING THEORY to Semester 79','System','2026-01-22 08:15:33',NULL),(387,33,'PO[1] Added','Added PO item at index 1','System','2026-01-22 08:37:19','{\"PO[1]\": {\"new\": \"Problem Analysis: Identify, formulate, review research literature and analyze complex engineering problems reaching substantiated conclusions with consideration for sustainable development. (WK1 to WK4)\", \"old\": \"\"}}'),(388,33,'PSO[0] Updated','Updated PSO item at index 0','System','2026-01-22 08:37:19','{\"PSO[0]\": {\"new\": \"Implement new ideas on product / process development by utilizing the knowledge of design and manufacturing. \", \"old\": \" Implement new ideas on product / process development by utilizing the knowledge of design and manufacturing. \"}}'),(389,33,'PO[6] Updated','Updated PO item at index 6','System','2026-01-22 08:37:45','{\"PO[6]\": {\"new\": \"Ethics: Apply ethical principles and commit to professional ethics, human values, diversity and inclusion; adhere to national & international laws. (WK9)\", \"old\": \" Ethics: Apply ethical principles and commit to professional ethics, human values, diversity and inclusion; adhere to national & international laws. (WK9)\"}}'),(390,33,'PEO-PO Mapping Saved','Updated PEO-PO mappings for the curriculum','System','2026-01-22 08:39:55',NULL),(391,33,'PEO-PO Mapping Saved','Updated PEO-PO mappings for the curriculum','System','2026-01-22 08:40:36',NULL),(392,33,'Card Added','Added Semester 1','System','2026-01-22 08:41:13',NULL),(393,33,'Card Added','Added Semester 2','System','2026-01-22 08:41:39',NULL),(394,33,'Card Added','Added Semester 3','System','2026-01-22 08:42:10',NULL),(395,33,'Card Added','Added Semester 4','System','2026-01-22 08:42:18',NULL),(396,33,'Card Added','Added Semester 5','System','2026-01-22 08:42:28',NULL),(397,33,'Card Added','Added Semester 6','System','2026-01-22 08:42:33',NULL),(398,33,'Card Added','Added Semester 7','System','2026-01-22 08:42:40',NULL),(399,33,'Card Added','Added Semester 8','System','2026-01-22 08:42:51',NULL),(400,33,'Course Added','Added course 22MA101  - ENGINEERING MATHEMATICS I to Semester 80','System','2026-01-22 08:44:36',NULL),(401,33,'Course Added','Added course 22PH102  - ENGINEERING PHYSICS to Semester 80','System','2026-01-22 08:45:58',NULL),(402,33,'Course Updated','Updated course: 22PH102  - ENGINEERING PHYSICS ','System','2026-01-22 08:46:57','{\"cia_marks\": {\"new\": 50, \"old\": 40}, \"see_marks\": {\"new\": 50, \"old\": 60}, \"lecture_hrs\": {\"new\": 2, \"old\": 0}, \"tutorial_hrs\": {\"new\": 0, \"old\": 10}}'),(403,33,'Course Added','Added course 22CH103  - ENGINEERING CHEMISTRY I to Semester 80','System','2026-01-22 08:48:09',NULL),(404,33,'Course Added','Added course 22GE001 - FUNDAMENTALS OF COMPUTING  to Semester 80','System','2026-01-22 08:49:14',NULL),(405,33,'Course Added','Added course 22HS001  - FOUNDATIONAL ENGLISH  to Semester 80','System','2026-01-22 08:50:17',NULL),(406,33,'Course Added','Added course 22GE003 - BASICS OF ELECTRICAL ENGINEERING to Semester 80','System','2026-01-22 08:51:42',NULL),(407,33,'Course Added','Added course 22GE005 - ENGINEERING DRAWING to Semester 80','System','2026-01-22 08:52:40',NULL),(408,33,'Course Added','Added course 22HS003 - தமிழர்மரபு HERITAGE OF TAMILS #* to Semester 80','System','2026-01-22 08:53:38',NULL),(409,16,'Course Updated','Updated course: 22HS003 - தமிழர்மரபு HERITAGE OF TAMILS','System','2026-01-22 08:53:55','{\"lecture_hrs\": {\"new\": 1, \"old\": 15}}'),(410,33,'Course Added','Added course 22ME108  - COMPREHENSIVE WORK to Semester 80','System','2026-01-22 08:54:59',NULL),(411,24,'PO[0] Added','Added PO item at index 0','System','2026-01-22 08:55:08','{\"PO[0]\": {\"new\": \"Engineering Knowledge: Apply the knowledge of mathematics, science, engineering fundamentals, and an engineering specialization to the solution of complex engineering problems. \", \"old\": \"\"}}'),(412,24,'PO[1] Added','Added PO item at index 1','System','2026-01-22 08:55:08','{\"PO[1]\": {\"new\": \"Problem Analysis: Identify, formulate, review research literature, and analyse complex engineering problems reaching substantiated conclusions using first principles of  mathematics, natural sciences, and engineering sciences. \", \"old\": \"\"}}'),(413,24,'PEO-PO Mapping Saved','Updated PEO-PO mappings for the curriculum','System','2026-01-22 08:57:13',NULL),(414,24,'Card Added','Added Semester 1','System','2026-01-22 08:57:34',NULL),(415,33,'Course Added','Added course 22MA201 - ENGINEERING MATHEMATICS II to Semester 81','System','2026-01-22 08:57:48',NULL),(416,16,'Course Updated','Updated course: 22MA201 - ENGINEERING MATHEMATICS II','System','2026-01-22 08:58:07','{\"lecture_hrs\": {\"new\": 3, \"old\": 45}, \"tutorial_hrs\": {\"new\": 1, \"old\": 15}}'),(417,24,'Course Added','Added course 22MA101  - ENGINEERING MATHEMATICS I  to Semester 88','System','2026-01-22 08:58:23',NULL),(418,24,'Course Added','Added course 22PH102  - ENGINEERING PHYSICS  to Semester 88','System','2026-01-22 09:04:41',NULL),(419,24,'Course Added','Added course 22CH103  - ENGINEERING CHEMISTRY I  to Semester 88','System','2026-01-22 09:05:16',NULL),(420,33,'Course Added','Added course 22PH202  - ELECTROMAGNETISM AND MODERN PHYSICS  to Semester 81','System','2026-01-22 09:05:35',NULL),(421,24,'Course Added','Added course 22GE001  - FUNDAMENTALS OF COMPUTING  to Semester 88','System','2026-01-22 09:05:53',NULL),(422,33,'Course Added','Added course 22CH203  - ENGINEERING CHEMISTRY II  to Semester 81','System','2026-01-22 09:07:03',NULL),(423,24,'Course Added','Added course 22HS001 - FOUNDATIONAL ENGLISH  to Semester 88','System','2026-01-22 09:07:04',NULL),(424,33,'Course Added','Added course 22GE002  - COMPUTATIONAL PROBLEM SOLVING to Semester 81','System','2026-01-22 09:07:46',NULL),(425,33,'Course Added','Added course 22GE004 - BASICS OF ELECTRONICS ENGINEERING to Semester 81','System','2026-01-22 09:08:42',NULL),(426,27,'PO[0] Added','Added PO item at index 0','System','2026-01-22 09:10:04','{\"PO[0]\": {\"new\": \"Engineering Knowledge: Apply knowledge of mathematics, natural science, computing, engineering fundamentals and an engineering specialization to develop to the solution of complex engineering problems.\", \"old\": \"\"}}'),(427,27,'PO[1] Added','Added PO item at index 1','System','2026-01-22 09:10:04','{\"PO[1]\": {\"new\": \"Problem Analysis: Identify, formulate, review research literature and analyze complex engineering problems reaching substantiated conclusions with consideration for sustainable development.\", \"old\": \"\"}}'),(428,17,'PEO-PO Mapping Saved','Updated PEO-PO mappings for the curriculum','System','2026-01-22 09:10:08',NULL),(429,33,'Course Added','Added course 22HS002 - STARTUP MANAGEMENT to Semester 81','System','2026-01-22 09:10:13',NULL),(430,24,'Course Added','Added course 22GE004 - BASICS OF ELECTRONICS ENGINEERING to Semester 88','System','2026-01-22 09:10:31',NULL),(431,17,'Card Added','Added Semester 4','System','2026-01-22 09:12:08',NULL),(432,24,'Course Added','Added course 22HS002  - STARTUP MANAGEMENT to Semester 88','System','2026-01-22 09:12:40',NULL),(433,27,'PEO-PO Mapping Saved','Updated PEO-PO mappings for the curriculum','System','2026-01-22 09:13:21',NULL),(434,27,'PEO-PO Mapping Saved','Updated PEO-PO mappings for the curriculum','System','2026-01-22 09:13:25',NULL),(435,24,'Course Added','Added course 22HS003 - தமிழர் மரபு  HERITAGE OF TAMILS#*  to Semester 88','System','2026-01-22 09:13:47',NULL),(436,33,'Course Added','Added course 22HS006  - தமிழரும் ததொழில்நுட்பமும் TAMILS AND TECHNOLOGY to Semester 81','System','2026-01-22 09:15:06',NULL),(437,24,'Course Added','Added course 22CS108 - COMPREHENSIVE WORKS to Semester 88','System','2026-01-22 09:15:06',NULL),(438,24,'Card Added','Added Semester 2','System','2026-01-22 09:15:24',NULL),(439,27,'Card Added','Added Semester 1','System','2026-01-22 09:15:44',NULL),(440,24,'Course Added','Added course 22MA201 - ENGINEERING MATHEMATICS II  to Semester 90','System','2026-01-22 09:16:06',NULL),(441,27,'Course Added','Added course 22MA101 - ENGINEERING MATHEMATICS I to Semester 91','System','2026-01-22 09:16:48',NULL),(442,33,'Course Added','Added course 22HS009  - COCURRICULAR OR EXTRACURRICULAR ACTIVITY to Semester 81','System','2026-01-22 09:16:55',NULL),(443,27,'Card Added','Added Semester 2','System','2026-01-22 09:17:03',NULL),(444,33,'Course Added','Added course 22ME301  - ENGINEERING MATHEMATICS III to Semester 82','System','2026-01-22 09:18:13',NULL),(445,27,'Course Added','Added course 22PH102  - ENGINEERING PHYSICS to Semester 91','System','2026-01-22 09:18:22',NULL),(446,33,'Course Added','Added course 22ME302 - ELECTRIC MACHINES AND DRIVES  to Semester 82','System','2026-01-22 09:19:00',NULL),(447,33,'Course Added','Added course 22ME303 - ENGINEERING THERMODYNAMICS  to Semester 82','System','2026-01-22 09:19:40',NULL),(448,27,'Course Added','Added course 22CH103 - ENGINEERING CHEMISTRY I  to Semester 91','System','2026-01-22 09:19:48',NULL),(449,33,'Course Added','Added course 22ME304 - FLUID MECHANICS AND MACHINERY  to Semester 82','System','2026-01-22 09:20:26',NULL),(450,27,'Course Added','Added course 22GE001  - FUNDAMENTALS OF COMPUTING to Semester 91','System','2026-01-22 09:21:07',NULL),(451,33,'Course Added','Added course 22ME305  - ENGINEERING MECHANICS  to Semester 82','System','2026-01-22 09:21:14',NULL),(452,33,'Course Added','Added course 22HS004  - HUMAN VALUES AND ETHICS  to Semester 82','System','2026-01-22 09:21:53',NULL),(453,27,'Course Added','Added course 22HS001 - FOUNDATIONAL ENGLISH  to Semester 91','System','2026-01-22 09:22:40',NULL),(454,33,'Course Added','Added course 22HS005 - SOFT SKILLS AND EFFECTIVE COMMUNICATION to Semester 82','System','2026-01-22 09:22:41',NULL),(455,33,'Course Added','Added course 22ME309 - MODELING AND SIMULATION LABORATORY to Semester 82','System','2026-01-22 09:23:24',NULL),(456,27,'Course Added','Added course 22GE003 - BASICS OF ELECTRICAL ENGINEERING to Semester 91','System','2026-01-22 09:23:38',NULL),(457,27,'Course Added','Added course 22HS002 - STARTUP MANAGEMENT  to Semester 91','System','2026-01-22 09:24:32',NULL),(458,24,'Course Added','Added course 22PH202 - ELECTROMAGNETISM AND MODERN PHYSICS  to Semester 90','System','2026-01-22 09:24:35',NULL),(459,24,'Course Added','Added course 22CH203 - ENGINEERING CHEMISTRY II  to Semester 90','System','2026-01-22 09:25:16',NULL),(460,27,'Course Added','Added course 22HS003* - தமிழர்மரபு HERITAGE OF TAMILS to Semester 91','System','2026-01-22 09:25:17',NULL),(461,33,'Course Added','Added course 22ME401  - KINEMATICS AND DYNAMICS OFMACHINERY to Semester 83','System','2026-01-22 09:25:29',NULL),(462,24,'Course Added','Added course 22GE002 -  COMPUTATIONAL PROBLEM SOLVING  to Semester 90','System','2026-01-22 09:25:49',NULL),(463,27,'Course Added','Added course 22EC108$ - COMPREHENSIVE WORK  to Semester 91','System','2026-01-22 09:26:31',NULL),(464,24,'Course Added','Added course 22GE003 - BASICS OF ELECTRICAL ENGINEERING  to Semester 90','System','2026-01-22 09:26:57',NULL),(465,24,'Course Added','Added course 22CS206 - DIGITAL COMPUTER ELECTRONICS  to Semester 90','System','2026-01-22 09:27:55',NULL),(466,27,'Course Added','Added course 22MA201 - ENGINEERING MATHEMATICS II  to Semester 92','System','2026-01-22 09:27:58',NULL),(467,33,'Course Added','Added course 22ME402 - SENSORS AND TRANSDUCER  to Semester 83','System','2026-01-22 09:28:12',NULL),(468,24,'Course Added','Added course - - LANGUAGE ELECTIVE  to Semester 90','System','2026-01-22 09:28:57',NULL),(469,33,'Course Added','Added course 22ME403 - STRENGTH OF MATERIALS  to Semester 83','System','2026-01-22 09:29:14',NULL),(470,24,'Course Added','Added course 22HS006 - தமிழரும்  ததொழில்நுட்பமும்  TAMILS AND TECHNOLOGY to Semester 90','System','2026-01-22 09:29:34',NULL),(471,33,'Course Added','Added course 22ME404 - INDUSTRIAL AUTOMATION WITH PLC*  to Semester 83','System','2026-01-22 09:30:11',NULL),(472,24,'Card Added','Added Semester 3','System','2026-01-22 09:30:23',NULL),(473,24,'Course Added','Added course 22CS301 - PROBABILITY, STATISTICS AND QUEUING THEORY  to Semester 93','System','2026-01-22 09:31:07',NULL),(474,24,'Course Added','Added course 22HS009 - COCURRICULAR OR EXTRACURRICULAR  ACTIVITY*  to Semester 90','System','2026-01-22 09:32:16',NULL),(475,27,'Course Added','Added course 22PH202  - ELECTROMAGNETISM AND MODERN PHYSICS  to Semester 92','System','2026-01-22 09:32:35',NULL),(476,33,'Course Added','Added course 22ME405 - MATERIALS AND MANUFACTURING PROCESSES to Semester 83','System','2026-01-22 09:32:42',NULL),(477,24,'Course Added','Added course 22CS302 - DATA STRUCTURES I  to Semester 93','System','2026-01-22 09:33:25',NULL),(478,27,'Course Added','Added course 22CH203  - ENGINEERING CHEMISTRY II to Semester 92','System','2026-01-22 09:33:41',NULL),(479,21,'PO[0] Updated','Updated PO item at index 0','System','2026-01-22 09:34:03','{\"PO[0]\": {\"new\": \"Engineering Knowledge: Apply knowledge of mathematics, natural science, computing, engineering fundamentals and an engineering specialization to develop to the solution of complex engineering problems.\", \"old\": \"Engineering Knowledge: Apply the knowledge of mathematics, science, engineering fundamentals, and an engineering specialization to the solution of complex engineering problems.\"}}'),(480,21,'PO[2] Updated','Updated PO item at index 2','System','2026-01-22 09:34:03','{\"PO[2]\": {\"new\": \"Design/Development of Solutions: Design creative solutions for complex engineering problems and design/develop systems/components/processes to meet identified needs with consideration for the public health and safety, whole-life cost, net zero carbon, culture, society and environment as required.\", \"old\": \"Design/ Development of Solutions: Design solutions for complex engineering problems and design system components or processes that meet the specified needs with appropriate consideration for the public health and safety, and the cultural, societal, and environmental considerations.\"}}'),(481,27,'Course Added','Added course 22GE002  - COMPUTATIONAL PROBLEM SOLVING to Semester 92','System','2026-01-22 09:34:42',NULL),(482,33,'Course Added','Added course 22HS007 - ENVIRONMENTAL SCIENCE to Semester 83','System','2026-01-22 09:34:49',NULL),(483,33,'Course Updated','Updated course: 22HS007 - ENVIRONMENTAL SCIENCE','System','2026-01-22 09:35:06','{\"tutorial_hrs\": {\"new\": 0, \"old\": 2}}'),(484,24,'Course Added','Added course 22CS303 -  COMPUTER ORGANIZATION AND ARCHITECTURE to Semester 93','System','2026-01-22 09:35:13',NULL),(485,27,'Course Added','Added course 22GE004 - BASICS OF ELECTRONICS ENGINEERING  to Semester 92','System','2026-01-22 09:35:21',NULL),(486,32,'PEO-PO Mapping Saved','Updated PEO-PO mappings for the curriculum','System','2026-01-22 09:35:22',NULL),(487,32,'PEO-PO Mapping Saved','Updated PEO-PO mappings for the curriculum','System','2026-01-22 09:35:25',NULL),(488,21,'Card Added','Added Semester 1','System','2026-01-22 09:35:36',NULL),(489,24,'Course Added','Added course 22CS304 - PRINCIPLES OF PROGRAMMING LANGUAGES to Semester 93','System','2026-01-22 09:35:50',NULL),(490,33,'Course Added','Added course 22HS008  - ADVANCED ENGLISH AND TECHNICALEXPRESSION  to Semester 83','System','2026-01-22 09:35:59',NULL),(491,27,'Course Added','Added course 22GE005 - ENGINEERING DRAWING  to Semester 92','System','2026-01-22 09:36:12',NULL),(492,24,'Course Added','Added course 22CS305 - SOFTWARE ENGINEERING  to Semester 93','System','2026-01-22 09:36:22',NULL),(493,24,'Course Added','Added course 22HS004 - HUMAN VALUES AND ETHICS  to Semester 93','System','2026-01-22 09:36:56',NULL),(494,33,'Course Added','Added course 22HS010  - SOCIALLY RELEVANT PROJECT to Semester 83','System','2026-01-22 09:36:59',NULL),(495,27,'Course Added','Added course - - LANGUAGE ELECTIVE  to Semester 92','System','2026-01-22 09:37:00',NULL),(496,17,'Course Added','Added course 22AM301 - PROBABILITY AND STATISTICS to Semester 79','System','2026-01-22 09:37:06',NULL),(497,21,'Course Added','Added course 22MA101 - ENGINEERING MATHEMATICS I to Semester 94','System','2026-01-22 09:37:36',NULL),(498,27,'Course Added','Added course 22HS006* - தமிழரும் ததொழில்நுட்பமும் TAMILS AND TECHNOLOGY  to Semester 92','System','2026-01-22 09:37:45',NULL),(499,24,'Course Added','Added course 22HS005 -  SOFT SKILLS AND EFFECTIVE COMMUNICATION to Semester 93','System','2026-01-22 09:37:47',NULL),(500,24,'Card Added','Added Semester 4','System','2026-01-22 09:37:57',NULL),(501,33,'Course Added','Added course 22ME501  - MECHATRONICS to Semester 84','System','2026-01-22 09:38:02',NULL),(502,24,'Course Added','Added course 22CS401 - DISCRETE MATHEMATICS  to Semester 95','System','2026-01-22 09:38:36',NULL),(503,33,'Course Added','Added course 22ME502  - DESIGN OF MACHINE ELEMENTS to Semester 84','System','2026-01-22 09:38:54',NULL),(504,21,'Course Added','Added course 22PH102 - ENGINEERING PHYSICS to Semester 94','System','2026-01-22 09:39:05',NULL),(505,27,'Course Added','Added course 22HS009*  - COCURRICULAR OR EXTRACURRICULAR ACTIVITIE to Semester 92','System','2026-01-22 09:39:15',NULL),(506,33,'Course Added','Added course 22ME503  - THERMAL ENGINEERING  to Semester 84','System','2026-01-22 09:39:30',NULL),(507,27,'Course Updated','Updated course: 22HS009*  - COCURRICULAR OR EXTRACURRICULAR ACTIVITIE','System','2026-01-22 09:39:55','{\"cia_marks\": {\"new\": 100, \"old\": 40}}'),(508,33,'Course Added','Added course 22ME504  - MACHINING AND METROLOGY  to Semester 84','System','2026-01-22 09:40:11',NULL),(509,27,'Card Added','Added Semester 3','System','2026-01-22 09:40:18',NULL),(510,27,'Card Added','Added Semester 4','System','2026-01-22 09:40:27',NULL),(511,27,'Card Added','Added Semester 5','System','2026-01-22 09:40:36',NULL),(512,27,'Card Added','Added Semester 6','System','2026-01-22 09:40:43',NULL),(513,27,'Card Added','Added Semester 7','System','2026-01-22 09:40:52',NULL),(514,27,'Card Added','Added Semester 8','System','2026-01-22 09:40:58',NULL),(515,33,'Course Added','Added course 22ME507 - MINI PROJECT I to Semester 84','System','2026-01-22 09:41:02',NULL),(516,32,'Course Added','Added course 22MA101 - ENGINEERING MATHEMATICS I to Semester 72','System','2026-01-22 09:41:05',NULL),(517,33,'Course Added','Added course 22ME508  - ADVANCED MODELING LABORATORY  to Semester 84','System','2026-01-22 09:41:35',NULL),(518,32,'Course Added','Added course 22PH102 - ENGINEERING PHYSICS to Semester 72','System','2026-01-22 09:42:23',NULL),(519,33,'Course Added','Added course 22ME601 - HEAT AND MASS TRANSFER  to Semester 85','System','2026-01-22 09:42:24',NULL),(520,27,'Course Added','Added course 22EC301  - PROBABILITY, STATISTICS AND RANDOM PROCESS* to Semester 96','System','2026-01-22 09:42:51',NULL),(521,33,'Course Added','Added course 22ME602 - FINITE ELEMENT ANALYSIS to Semester 85','System','2026-01-22 09:42:57',NULL),(522,32,'Course Added','Added course 22CH103 - ENGINEERING CHEMISTRY I to Semester 72','System','2026-01-22 09:43:05',NULL),(523,21,'Course Added','Added course 22CH103 - ENGINEERING CHEMISTRY I  to Semester 94','System','2026-01-22 09:43:24',NULL),(524,33,'Course Added','Added course 22ME603  - COMPUTER AIDED MANUFACTURING  to Semester 85','System','2026-01-22 09:43:30',NULL),(525,27,'Course Added','Added course 22EC302 - CIRCUIT ANALYSIS  to Semester 96','System','2026-01-22 09:43:44',NULL),(526,17,'Course Added','Added course 22AM302 - DATA STRUCTURES I to Semester 79','System','2026-01-22 09:43:46',NULL),(527,16,'Course Added','Added course 22CH203 - ENGINEERING CHEMESTRY II to Semester 76','System','2026-01-22 09:43:47',NULL),(528,33,'Course Added','Added course 22ME607  - MINI PROJECT II  to Semester 85','System','2026-01-22 09:44:07',NULL),(529,32,'Course Added','Added course 22GE001 - FUNDAMENTALS OF COMPUTING to Semester 72','System','2026-01-22 09:44:09',NULL),(530,24,'Course Added','Added course 22CS402 - DATA STRUCTURES II to Semester 95','System','2026-01-22 09:44:41',NULL),(531,33,'Course Added','Added course 22ME701  - INDUSTRIAL ROBOTICS  to Semester 86','System','2026-01-22 09:44:52',NULL),(532,32,'Course Added','Added course 22HS001 - FOUNDATIONAL ENGLISH to Semester 72','System','2026-01-22 09:44:54',NULL),(533,27,'Course Added','Added course 22EC303  - DIGITAL LOGIC CIRCUIT DESIGN to Semester 96','System','2026-01-22 09:45:05',NULL),(534,21,'Course Added','Added course 22GE001 - FUNDAMENTALS OF COMPUTING to Semester 94','System','2026-01-22 09:45:13',NULL),(535,17,'Course Added','Added course 22AM303 - COMPUTER ORGANIZATION AND ARCHITECTURE to Semester 79','System','2026-01-22 09:45:24',NULL),(536,32,'Course Added','Added course 22GE004 - BASICS OF ELECTRONICS ENGINEERING to Semester 72','System','2026-01-22 09:45:35',NULL),(537,16,'Course Added','Added course 22GE002 - COMPUTATIONAL PROBLEM SOLVING to Semester 76','System','2026-01-22 09:45:39',NULL),(538,33,'Course Added','Added course 22ME702  - IoT FOR AUTOMATION  to Semester 86','System','2026-01-22 09:45:58',NULL),(539,32,'Course Added','Added course 22HS002  - STARTUP MANAGEMENT  to Semester 72','System','2026-01-22 09:46:19',NULL),(540,17,'Course Added','Added course 22AM304 - PRINCIPLES OF PROGRAMMING LANGUAGES to Semester 79','System','2026-01-22 09:46:35',NULL),(541,33,'Course Added','Added course 22ME707  - PROJECT WORK I  to Semester 86','System','2026-01-22 09:46:40',NULL),(542,16,'Course Added','Added course 22GE003 - BASICS OF ELECTRICAL ENGINEERING to Semester 76','System','2026-01-22 09:47:11',NULL),(543,33,'Course Added','Added course 22ME801  - PROJECT WORK II  to Semester 87','System','2026-01-22 09:47:22',NULL),(544,17,'Course Added','Added course 22AM305 - SOFTWARE ENGINEERING  to Semester 79','System','2026-01-22 09:47:30',NULL),(545,16,'Course Added','Added course 22AI206 - DIGITAL COMPUTER ELECTRONICS  to Semester 76','System','2026-01-22 09:48:18',NULL),(546,17,'Course Added','Added course 22HS004 - HUMAN VALUES AND ETHICS to Semester 79','System','2026-01-22 09:48:19',NULL),(547,21,'Course Added','Added course 22HS001 - FOUNDATIONAL ENGLISH to Semester 94','System','2026-01-22 09:48:28',NULL),(548,32,'Course Added','Added course 22HS003 - தமழர மரபு  HERITAGE OF TAMILS to Semester 72','System','2026-01-22 09:48:50',NULL),(549,21,'Course Added','Added course 22GE003 - BASICS OF ELECTRICAL ENGINEERING to Semester 94','System','2026-01-22 09:49:47',NULL),(550,32,'Course Added','Added course 22IT108 - COMPREHENSIVE WORK to Semester 72','System','2026-01-22 09:49:48',NULL),(551,32,'Card Added','Added Semester 2','System','2026-01-22 09:49:59',NULL),(552,17,'Course Added','Added course 22HS005 - SOFT SKILLS AND EFFECTIVE COMMUNICATION to Semester 79','System','2026-01-22 09:50:17',NULL),(553,21,'Course Added','Added course 22HS002 - STARTUP MANAGEMENT to Semester 94','System','2026-01-22 09:50:38',NULL),(554,21,'Course Added','Added course 22HS003 - தமிழர்மரபு HERITAGE OF TAMILS to Semester 94','System','2026-01-22 09:51:23',NULL),(555,17,'Course Added','Added course 22AM401 - APPLIED LINEAR ALGEBRA  to Semester 89','System','2026-01-22 09:51:46',NULL),(556,21,'Course Added','Added course 22BT108 - COMPREHENSIVE WORK to Semester 94','System','2026-01-22 09:52:16',NULL),(557,16,'Course Added','Added course 22HS006  - தமிழரும் ததொழில்நுட்பமும் TAMILS AND TECHNOLOGY^* to Semester 76','System','2026-01-22 09:52:23',NULL),(558,17,'Course Added','Added course 22AM402 - DATA STRUCTURES II to Semester 89','System','2026-01-22 09:52:26',NULL),(559,32,'Course Added','Added course 22MA201 - ENGINEERING MATHEMATICS II to Semester 102','System','2026-01-22 09:52:27',NULL),(560,17,'Course Added','Added course 22AM403 - OPERATING SYSTEMS to Semester 89','System','2026-01-22 09:53:24',NULL),(561,16,'Card Added','Added Semester 3','System','2026-01-22 09:53:30',NULL),(562,32,'Course Added','Added course 22PH202 - ELECTROMAGNETISM AND MODERN PHYSICS to Semester 102','System','2026-01-22 09:53:32',NULL),(563,32,'Course Added','Added course 22CH203 - ENGINEERING CHEMISTRY II to Semester 102','System','2026-01-22 09:54:05',NULL),(564,17,'Course Added','Added course 22AM404 - WEB TECHNOLOGY AND FRAMEWORKS to Semester 89','System','2026-01-22 09:54:07',NULL),(565,17,'Course Added','Added course 22AM405 - DATABASE MANAGEMENT SYSTEM  to Semester 89','System','2026-01-22 09:54:51',NULL),(566,32,'Course Added','Added course 22GE002 - COMPUTATIONALPROBLEM SOLVING to Semester 102','System','2026-01-22 09:54:51',NULL),(567,20,'PO[2] Updated','Updated PO item at index 2','System','2026-01-22 09:54:57','{\"PO[2]\": {\"new\": \"Design/Development of Solutions: Design creative solutions for complex engineering problems and design/develop systems/components/processes to meet identified needs with consideration for the public health and safety, whole-life cost, net zero carbon, culture, society and environment as required.\", \"old\": \"Design solutionsfor complex engineering problems and design system components or processes that meet the specified needs with appropriate consideration for the public health and safety, andthe cultural, societal, and environmental considerations.\"}}'),(568,20,'PO[5] Updated','Updated PO item at index 5','System','2026-01-22 09:54:57','{\"PO[5]\": {\"new\": \"The Engineer and The World: Analyze and evaluate societal and environmental aspects while solving complex engineering problems for its impact on sustainability with reference to economy, health, safety, legal framework, culture and environment.\", \"old\": \"Apply reasoning informed by the contextual knowledge to assess societal, health, safety, legal and cultural issues and the consequent responsibilities relevant to the professional engineering practice.\"}}'),(569,16,'Course Added','Added course 22AI301 - PROBABILITY AND STATISTICS to Semester 103','System','2026-01-22 09:55:06',NULL),(570,20,'Card Added','Added Semester 1','System','2026-01-22 09:55:07',NULL),(571,32,'Course Added','Added course 22GE003 - BASICS OF ELECTRICAL ENGINEERING  to Semester 102','System','2026-01-22 09:55:28',NULL),(572,17,'Course Added','Added course 22HS007 - ENVIRONMENTAL SCIENCE to Semester 89','System','2026-01-22 09:55:59',NULL),(573,16,'Course Added','Added course 22AI302 - DATA STRUCTURES I  to Semester 103','System','2026-01-22 09:56:08',NULL),(574,20,'Course Added','Added course 22MA101 - ENGINEERING MATHEMATICS I to Semester 104','System','2026-01-22 09:56:18',NULL),(575,32,'Course Added','Added course 22IT206 - DIGITAL COMPUTER ELECTRONICS to Semester 102','System','2026-01-22 09:56:32',NULL),(576,17,'Course Removed','Removed course ENVIRONMENTAL SCIENCE from Semester 89','System','2026-01-22 09:57:18',NULL),(577,16,'Course Added','Added course 22AI303 - COMPUTER ORGANIZATION AND ARCHITECTURE** to Semester 103','System','2026-01-22 09:58:08',NULL),(578,32,'Course Added','Added course 22HS006 - தமிழரும் ததொழில்நுட்பமும் TAMILS AND TECHNOLOGY to Semester 102','System','2026-01-22 09:58:48',NULL),(579,16,'Card Added','Added New Card','System','2026-01-22 09:59:16',NULL),(580,16,'Course Added','Added course 22AI304 - PRINCIPLES OF PROGRAMMING LANGUAGES to Semester 103','System','2026-01-22 09:59:28',NULL),(581,17,'Course Added','Added course 22HS008 - ADVANCED ENGLISH AND TECHNICAL EXPRESSION to Semester 89','System','2026-01-22 09:59:50',NULL),(582,16,'Course Added','Added course 22AI305 - SOFTWARE ENGINEERING to Semester 103','System','2026-01-22 10:00:24',NULL),(583,16,'Card Added','Added Vertical 1','System','2026-01-22 10:00:38',NULL),(584,21,'Card Added','Added Semester 2','System','2026-01-22 10:01:01',NULL),(585,16,'Course Added','Added course 22HS004 - HUMAN VALUES AND ETHICS to Semester 103','System','2026-01-22 10:01:06',NULL),(586,17,'Card Added','Added Semester 5','System','2026-01-22 10:01:11',NULL),(587,17,'Course Added','Added course 22AM501 -  ARTIFICIAL INTELLIGENCE to Semester 108','System','2026-01-22 10:01:52',NULL),(588,21,'Course Added','Added course 22MA201 - ENGINEERING MATHEMATICS II to Semester 107','System','2026-01-22 10:01:55',NULL),(589,16,'Course Added','Added course 22HS005 - SOFT SKILLS AND EFFECTIVE COMMUNICATION to Semester 103','System','2026-01-22 10:02:16',NULL),(590,17,'Course Added','Added course 22AM502 - BIG DATA TECHNOLOGIES  to Semester 108','System','2026-01-22 10:02:20',NULL),(591,27,'Course Added','Added course 22EC304 - ANALOG ELECTRONICS AND INTEGRATED CIRCUITS  to Semester 96','System','2026-01-22 10:02:23',NULL),(592,16,'Card Added','Added Semester 4','System','2026-01-22 10:02:35',NULL),(593,21,'Course Added','Added course 22PH202 - ELECTROMAGNETISM AND MODERN PHYSICS  to Semester 107','System','2026-01-22 10:02:42',NULL),(594,27,'Course Added','Added course 22EC305  - DATA STRUCTURES AND ALGORITHMS  to Semester 96','System','2026-01-22 10:03:07',NULL),(595,17,'Course Added','Added course 22AM503 - MACHINE LEARNING to Semester 108','System','2026-01-22 10:03:14',NULL),(596,16,'Course Added','Added course 22AI401  - APPLIED LINEAR ALGEBRA to Semester 109','System','2026-01-22 10:03:30',NULL),(597,21,'Course Added','Added course 22CH203 - ENGINEERING CHEMISTRY II  to Semester 107','System','2026-01-22 10:03:31',NULL),(598,27,'Course Added','Added course 22HS004 - HUMAN VALUES AND ETHICS  to Semester 96','System','2026-01-22 10:03:41',NULL),(599,17,'Course Added','Added course 22AM504 - CLOUD COMPUTING to Semester 108','System','2026-01-22 10:03:52',NULL),(600,33,'Card Added','Added New Card','System','2026-01-22 10:03:53',NULL),(601,21,'Course Added','Added course 22GE002 - COMPUTATIONAL PROBLEM SOLVING to Semester 107','System','2026-01-22 10:04:08',NULL),(602,32,'Card Added','Added Semester 3','System','2026-01-22 10:04:35',NULL),(603,27,'Course Added','Added course 22HS005 - SOFT SKILLS AND EFFECTIVE COMMUNICATION to Semester 96','System','2026-01-22 10:04:41',NULL),(604,16,'Course Added','Added course 22AI402 - DATA STRUCTURES II to Semester 109','System','2026-01-22 10:04:42',NULL),(605,21,'Course Added','Added course 22GE004 - BASICS OF ELECTRONICS ENGINEERING to Semester 107','System','2026-01-22 10:04:46',NULL),(606,17,'Course Added','Added course 22AM507 - MINI PROJECT I to Semester 108','System','2026-01-22 10:05:06',NULL),(607,32,'Course Added','Added course 22IT301 - PROBABILITY, STATISTICS AND QUEUING THEORY to Semester 111','System','2026-01-22 10:05:17',NULL),(608,16,'Course Added','Added course 22AI403 - OPERATING SYSTEMS to Semester 109','System','2026-01-22 10:05:19',NULL),(609,21,'Course Added','Added course 22GE005 - ENGINEERING DRAWING to Semester 107','System','2026-01-22 10:05:38',NULL),(610,33,'Course Added','Added course 22HS201 - COMMUNICATIVE ENGLISH II to Semester 110','System','2026-01-22 10:05:51',NULL),(611,16,'Course Added','Added course 22AI404 - WEB TECHNOLOGY AND FRAMEWORKS  to Semester 109','System','2026-01-22 10:06:05',NULL),(612,33,'Course Added','Added course 22HSH01  - HINDI to Semester 110','System','2026-01-22 10:06:26',NULL),(613,17,'Card Added','Added Semester 6','System','2026-01-22 10:06:28',NULL),(614,27,'Course Added','Added course 22EC401  - SIGNALS AND SYSTEMS to Semester 97','System','2026-01-22 10:06:53',NULL),(615,33,'Course Added','Added course 22HSG01 - GERMAN  to Semester 110','System','2026-01-22 10:06:56',NULL),(616,17,'Course Added','Added course 22AM601 - NATURAL LANGUAGE PROCESSING ** to Semester 112','System','2026-01-22 10:07:07',NULL),(617,16,'Course Added','Added course 22AI405 - DATABASE MANAGEMENT SYSTEM to Semester 109','System','2026-01-22 10:07:20',NULL),(618,33,'Course Added','Added course 22HSJ01 - JAPANESE  to Semester 110','System','2026-01-22 10:07:23',NULL),(619,17,'Course Added','Added course 22AM602 - COMPUTER VISION AND DIGITAL IMAGING to Semester 112','System','2026-01-22 10:07:45',NULL),(620,27,'Course Added','Added course 22EC402 - ANALOG COMMUNICATION to Semester 97','System','2026-01-22 10:07:47',NULL),(621,33,'Course Added','Added course 22HSF01 - FRENCH  to Semester 110','System','2026-01-22 10:07:54',NULL),(622,20,'Course Added','Added course 22PH102  - ENGINEERING PHYSICS to Semester 104','System','2026-01-22 10:08:05',NULL),(623,32,'Course Added','Added course 22IT302 - DATA STRUCTURES I to Semester 111','System','2026-01-22 10:08:10',NULL),(624,33,'Card Added','Added Vertical 1','System','2026-01-22 10:08:27',NULL),(625,17,'Course Added','Added course 22AM603 - DEEP LEARNING to Semester 112','System','2026-01-22 10:08:28',NULL),(626,16,'Course Added','Added course 22HS007 - ENVIRONMENTAL SCIENCE to Semester 109','System','2026-01-22 10:08:39',NULL),(627,21,'Course Added','Added course 22HS006 - தமிழரும் ததொழில்நுட்பமும் TAMILS AND TECHNOLOGY to Semester 107','System','2026-01-22 10:08:52',NULL),(628,32,'Course Added','Added course 22IT303  - COMPUTER ORGANIZATION AND ARCHITECTURE to Semester 111','System','2026-01-22 10:08:55',NULL),(629,27,'Course Added','Added course 22EC403 - ELECTROMAGNETIC FIELDS AND WAVEGUIDES to Semester 97','System','2026-01-22 10:08:56',NULL),(630,20,'Course Added','Added course 22CH103 - ENGINEERING CHEMISTRY I to Semester 104','System','2026-01-22 10:09:08',NULL),(631,33,'Course Added','Added course 22ME001 - CONCEPTS OF ENGINEERING DESIGN  to Semester 113','System','2026-01-22 10:09:11',NULL),(632,32,'Course Added','Added course 22IT304 - PRINCIPLES OF PROGRAMMING LANGUAGES to Semester 111','System','2026-01-22 10:09:31',NULL),(633,33,'Course Added','Added course 22ME002  - COMPOSITE MATERIALS AND MECHANICS  to Semester 113','System','2026-01-22 10:09:32',NULL),(634,27,'Course Added','Added course 22EC404  - CMOS DIGITAL INTEGRATED CIRCUITS to Semester 97','System','2026-01-22 10:09:39',NULL),(635,21,'Course Added','Added course 22HS009 - CO-CURRICULAR OR EXTRACURRICULAR ACTIVITY to Semester 107','System','2026-01-22 10:09:52',NULL),(636,33,'Course Added','Added course 22ME003  - COMPUTER AIDED DESIGN to Semester 113','System','2026-01-22 10:09:57',NULL),(637,17,'Course Added','Added course 22AM607 - MINI PROJECT II to Semester 112','System','2026-01-22 10:10:02',NULL),(638,32,'Course Added','Added course 22IT305 - SOFTWARE ENGINEERING to Semester 111','System','2026-01-22 10:10:07',NULL),(639,33,'Course Added','Added course 22ME004  - MECHANICAL VIBRATIONS  to Semester 113','System','2026-01-22 10:10:22',NULL),(640,20,'Course Removed','Removed course ENGINEERING PHYSICS  from Semester 104','System','2026-01-22 10:10:24',NULL),(641,20,'Course Removed','Removed course ENGINEERING CHEMISTRY I  from Semester 104','System','2026-01-22 10:10:28',NULL),(642,21,'Card Added','Added Semester 3','System','2026-01-22 10:10:29',NULL),(643,17,'Card Added','Added Semester 7','System','2026-01-22 10:10:35',NULL),(644,27,'Course Added','Added course 22EC405 - EMBEDDED SYSTEMS  to Semester 97','System','2026-01-22 10:10:39',NULL),(645,33,'Course Added','Added course 22ME005 - ENGINEERING TRIBOLOGY to Semester 113','System','2026-01-22 10:10:45',NULL),(646,21,'Course Added','Added course 22BT301 - FOURIER SERIES, TRANSFORMS AND BIOSTATISTICS to Semester 114','System','2026-01-22 10:11:10',NULL),(647,33,'Course Added','Added course 22ME006  - FAILURE ANALYSIS AND DESIGN  to Semester 113','System','2026-01-22 10:11:11',NULL),(648,17,'Course Added','Added course 22AM701 - PATTERN AND ANOMALY DETECTION to Semester 115','System','2026-01-22 10:11:12',NULL),(649,32,'Course Added','Added course 22HS004 - HUMAN VALUES AND ETHICS to Semester 111','System','2026-01-22 10:11:16',NULL),(650,16,'Course Added','Added course 22HS008  - ADVANCED ENGLISH AND TECHNICAL EXPRESSION  to Semester 109','System','2026-01-22 10:11:21',NULL),(651,20,'Course Added','Added course 22PH102 - ENGINEERING PHYSICS to Semester 104','System','2026-01-22 10:11:28',NULL),(652,33,'Course Added','Added course 22ME007 - DESIGN OF AUTOMOTIVE SYSTEMS to Semester 113','System','2026-01-22 10:11:31',NULL),(653,32,'Course Added','Added course 22HS005 - SOFT SKILLS AND EFFECTIVE COMMUNICATION to Semester 111','System','2026-01-22 10:11:49',NULL),(654,17,'Course Added','Added course 22AM702 - BUSINESS ANALYTICS to Semester 115','System','2026-01-22 10:12:01',NULL),(655,32,'Card Added','Added Semester 4','System','2026-01-22 10:12:01',NULL),(656,21,'Course Added','Added course 22BT302 - BIOCHEMISTRY  to Semester 114','System','2026-01-22 10:12:02',NULL),(657,21,'Course Updated','Updated course: 22BT301 - FOURIER SERIES, TRANSFORMS AND BIOSTATISTICS','System','2026-01-22 10:12:26','{\"lecture_hrs\": {\"new\": 3, \"old\": 1}}'),(658,32,'Course Added','Added course 22IT401 - DISCRETE MATHEMATICS to Semester 116','System','2026-01-22 10:12:43',NULL),(659,21,'Course Added','Added course 22BT303 - ENGINEERING THERMODYNAMICS to Semester 114','System','2026-01-22 10:13:14',NULL),(660,32,'Course Added','Added course 22IT402 - DATA STRUCTURES II to Semester 116','System','2026-01-22 10:13:18',NULL),(661,27,'Course Added','Added course 22HS007 - ENVIRONMENTAL SCIENCE  to Semester 96','System','2026-01-22 10:13:47',NULL),(662,21,'Course Added','Added course 22BT304 - MICROBIOLOGY to Semester 114','System','2026-01-22 10:13:58',NULL),(663,33,'Card Added','Added Vertical 2','System','2026-01-22 10:14:21',NULL),(664,32,'Course Added','Added course 22IT403 - OPERATING SYSTEMS to Semester 116','System','2026-01-22 10:14:27',NULL),(665,21,'Course Added','Added course 22BT305 - PROCESS CALCULATIONS AND UNIT OPERATIONS to Semester 114','System','2026-01-22 10:14:30',NULL),(666,27,'Course Added','Added course 22HS008  - ADVANCED ENGLISH AND TECHNICAL EXPRESSION  to Semester 96','System','2026-01-22 10:14:31',NULL),(667,20,'Course Added','Added course 22GE001 - FUNDAMENTALS OF COMPUTING to Semester 104','System','2026-01-22 10:14:51',NULL),(668,21,'Course Added','Added course 22HS004 - HUMAN VALUES AND ETHICS to Semester 114','System','2026-01-22 10:15:03',NULL),(669,32,'Course Added','Added course 22IT404 - WEB TECHNOLOGY AND FRAMEWORKS to Semester 116','System','2026-01-22 10:15:09',NULL),(670,27,'Course Added','Added course 22HS010$ - SOCIALLY RELEVANT PROJECT  to Semester 96','System','2026-01-22 10:15:16',NULL),(671,21,'Course Added','Added course 22HS005 - SOFT SKILLS AND EFFECTIVE COMMUNICATION to Semester 114','System','2026-01-22 10:15:40',NULL),(672,17,'Course Added','Added course 22AM707 - PROJECT WORK I to Semester 115','System','2026-01-22 10:15:45',NULL),(673,21,'Card Added','Added Semester 4','System','2026-01-22 10:15:55',NULL),(674,16,'Course Added','Added course 22HS010 - SOCIALLY RELEVANT PROJECT  to Semester 109','System','2026-01-22 10:15:57',NULL),(675,32,'Course Added','Added course 22IT405  - DATABASE MANAGEMENT SYSTEM to Semester 116','System','2026-01-22 10:15:57',NULL),(676,20,'Course Added','Added course 22HS001 - FOUNDATIONAL ENGLISH to Semester 104','System','2026-01-22 10:15:59',NULL),(677,17,'Card Added','Added Semester 8','System','2026-01-22 10:16:03',NULL),(678,27,'Course Removed','Removed course ENVIRONMENTAL SCIENCE from Semester 96','System','2026-01-22 10:16:06',NULL),(679,27,'Course Removed','Removed course ADVANCED ENGLISH AND TECHNICALEXPRESSION  from Semester 96','System','2026-01-22 10:16:20',NULL),(680,27,'Course Removed','Removed course SOCIALLY RELEVANT PROJECT  from Semester 96','System','2026-01-22 10:16:28',NULL),(681,16,'Card Added','Added Semester 5','System','2026-01-22 10:16:29',NULL),(682,17,'Course Added','Added course 22AM801 - PROJECT WORK II to Semester 119','System','2026-01-22 10:16:43',NULL),(683,17,'Card Added','Added New Card','System','2026-01-22 10:16:58',NULL),(684,32,'Course Added','Added course 22HS007 - ENVIRONMENTALSCIENCE to Semester 116','System','2026-01-22 10:17:01',NULL),(685,16,'Course Added','Added course 22AI501 -  ARTIFICIAL INTELLIGENCE  to Semester 120','System','2026-01-22 10:17:31',NULL),(686,21,'Course Added','Added course 22BT401 - BIOORGANIC CHEMISTRY to Semester 118','System','2026-01-22 10:17:41',NULL),(687,32,'Course Added','Added course 22HS008 - ADVANCED ENGLISH AND TECHNICAL EXPRESSION to Semester 116','System','2026-01-22 10:17:45',NULL),(688,17,'Course Added','Added course 22HS201 - COMMUNICATIVE ENGLISH II to Semester 121','System','2026-01-22 10:17:50',NULL),(689,33,'Card Added','Added Vertical 3','System','2026-01-22 10:17:57',NULL),(690,33,'Card Added','Added Vertical 4','System','2026-01-22 10:18:05',NULL),(691,33,'Card Added','Added Vertical 5','System','2026-01-22 10:18:14',NULL),(692,33,'Card Added','Added Vertical 6','System','2026-01-22 10:18:23',NULL),(693,17,'Course Added','Added course 22HSH01 - HINDI  to Semester 121','System','2026-01-22 10:18:35',NULL),(694,33,'Card Added','Added Vertical 7','System','2026-01-22 10:18:36',NULL),(695,21,'Course Added','Added course 22BT402 - HEAT AND MASS TRANSFER to Semester 118','System','2026-01-22 10:18:39',NULL),(696,33,'Card Added','Added Vertical 8','System','2026-01-22 10:18:46',NULL),(697,16,'Course Added','Added course 22AI502 - COMPUTER NETWORKS  to Semester 120','System','2026-01-22 10:19:14',NULL),(698,17,'Course Added','Added course 22HSG01 - GERMAN to Semester 121','System','2026-01-22 10:19:14',NULL),(699,21,'Course Added','Added course 22BT403 - CELL AND MOLECULAR BIOLOGY to Semester 118','System','2026-01-22 10:19:20',NULL),(700,17,'Course Added','Added course 22HSJ01 - JAPANESE to Semester 121','System','2026-01-22 10:19:53',NULL),(701,33,'Honour Card Added','Added Honour Card: HONOURS DEGREE','System','2026-01-22 10:20:00',NULL),(702,21,'Course Added','Added course 22BT404 - INSTRUMENTAL METHODS OF ANALYSIS  to Semester 118','System','2026-01-22 10:20:01',NULL),(703,16,'Course Added','Added course 22AI503  - MACHINE LEARNING to Semester 120','System','2026-01-22 10:20:06',NULL),(704,33,'Honour Card Added','Added Honour Card: MINOR DEGREE (Other than MECHANICAL Students )','System','2026-01-22 10:20:14',NULL),(705,21,'Course Added','Added course 22BT405 - PLANT TISSUE CULTURE to Semester 118','System','2026-01-22 10:20:36',NULL),(706,17,'Course Added','Added course 22HSF01 - FRENCH to Semester 121','System','2026-01-22 10:20:43',NULL),(707,33,'Card Added','Added New Card','System','2026-01-22 10:20:46',NULL),(708,16,'Course Added','Added course 22AI504 - CLOUD COMPUTING to Semester 120','System','2026-01-22 10:20:50',NULL),(709,33,'Card Added','Added New Card','System','2026-01-22 10:20:58',NULL),(710,20,'Course Added','Added course 22GE003 - BASICS OF ELECTRICAL ENGINEERING to Semester 104','System','2026-01-22 10:21:00',NULL),(711,21,'Course Added','Added course 22HS007 - ENVIRONMENTAL SCIENCE to Semester 118','System','2026-01-22 10:21:19',NULL),(712,17,'Card Added','Added Vertical 1','System','2026-01-22 10:21:21',NULL),(713,17,'Course Added','Added course 22AM001 - AGILE SOFTWARE DEVELOPMENT to Semester 130','System','2026-01-22 10:21:53',NULL),(714,21,'Course Added','Added course 22HS008 - ADVANCED ENGLISH AND TECHNICAL EXPRESSION to Semester 118','System','2026-01-22 10:22:03',NULL),(715,20,'Course Added','Added course 22GE005 - ENGINEERING DRAWING to Semester 104','System','2026-01-22 10:22:10',NULL),(716,16,'Course Added','Added course 22AI507 -  MINI PROJECT I to Semester 120','System','2026-01-22 10:22:20',NULL),(717,16,'Card Added','Added Semester 6','System','2026-01-22 10:22:39',NULL),(718,17,'Course Added','Added course 22AM002 - UI AND UX DESIGN to Semester 130','System','2026-01-22 10:22:44',NULL),(719,21,'Course Added','Added course 22HS010 - SOCIALLY RELEVANT PROJECT to Semester 118','System','2026-01-22 10:22:45',NULL),(720,16,'Course Updated','Updated course: 22HS010 - SOCIALLY RELEVANT PROJECT ','System','2026-01-22 10:23:01','{\"practical_hrs\": {\"new\": 2, \"old\": 0}}'),(721,17,'Course Added','Added course 22AM003 - WEB FRAMEWORKS to Semester 130','System','2026-01-22 10:23:08',NULL),(722,27,'Course Added','Added course 22HS008 - ADVANCED ENGLISH AND TECHNICAL EXPRESSION to Semester 97','System','2026-01-22 10:23:15',NULL),(723,20,'Course Added','Added course 22HS003 - HERITAGE OF TAMILS to Semester 104','System','2026-01-22 10:23:18',NULL),(724,16,'Course Added','Added course 22AI601 - NATURAL LANGUAGE PROCESSING to Semester 131','System','2026-01-22 10:23:43',NULL),(725,17,'Course Added','Added course 22AM004 - APP DEVELOPMENT to Semester 130','System','2026-01-22 10:23:45',NULL),(726,21,'Card Added','Added Semester 5','System','2026-01-22 10:23:52',NULL),(727,32,'Card Added','Added Semester 5','System','2026-01-22 10:24:05',NULL),(728,17,'Course Added','Added course 22AM005 - SOFTWARE TESTING AND AUTOMATION to Semester 130','System','2026-01-22 10:24:10',NULL),(729,20,'Course Added','Added course 22CE108 - COMPREHENSIVE WORK to Semester 104','System','2026-01-22 10:24:11',NULL),(730,16,'Course Added','Added course 22AI602 - COMPUTER VISION AND DIGITAL IMAGING to Semester 131','System','2026-01-22 10:24:21',NULL),(731,21,'Course Added','Added course 22BT501 - GENETIC ENGINEERING to Semester 132','System','2026-01-22 10:24:34',NULL),(732,16,'Course Added','Added course 22AI603 - DEEP LEARNING  to Semester 131','System','2026-01-22 10:24:56',NULL),(733,21,'Course Added','Added course 22BT502 - BIOPROCESS ENGINEERING to Semester 132','System','2026-01-22 10:25:26',NULL),(734,16,'Course Added','Added course 22AI607 - MINI PROJECT II  to Semester 131','System','2026-01-22 10:25:31',NULL),(735,27,'Course Added','Added course 22EC501  - DIGITAL COMMUNICATION to Semester 98','System','2026-01-22 10:25:36',NULL),(736,32,'Course Added','Added course 22IT501 - PRINCIPLES OF COMMUNICATION to Semester 133','System','2026-01-22 10:25:49',NULL),(737,21,'Course Added','Added course 22BT503 - ANIMAL TISSUE CULTURE to Semester 132','System','2026-01-22 10:25:59',NULL),(738,20,'Card Added','Added Semester 2','System','2026-01-22 10:26:20',NULL),(739,32,'Course Added','Added course 22IT502 - COMPUTER NETWORKS to Semester 133','System','2026-01-22 10:26:22',NULL),(740,27,'Course Added','Added course 22EC502 - DIGITAL SIGNAL PROCESSING to Semester 98','System','2026-01-22 10:26:26',NULL),(741,16,'Card Added','Added Semester 7','System','2026-01-22 10:26:28',NULL),(742,21,'Course Added','Added course 22BT504 - BIOINFORMATICS to Semester 132','System','2026-01-22 10:26:50',NULL),(743,32,'Course Added','Added course 22IT503 - INFORMATION CODING TECHNIQUES to Semester 133','System','2026-01-22 10:26:59',NULL),(744,20,'Course Added','Added course 22MA201 - ENGINEERING MATHEMATICS II to Semester 134','System','2026-01-22 10:27:03',NULL),(745,16,'Course Added','Added course 22AI701 - DATA VISUALIZATION to Semester 135','System','2026-01-22 10:27:23',NULL),(746,21,'Course Added','Added course 22BT507 - MINI PROJECT I to Semester 132','System','2026-01-22 10:27:25',NULL),(747,27,'Course Added','Added course 22EC503 - TRANSMISSION LINES AND ANTENNAS  to Semester 98','System','2026-01-22 10:27:39',NULL),(748,21,'Card Added','Added Semester 6','System','2026-01-22 10:27:43',NULL),(749,32,'Course Added','Added course 22IT504 - INTERNET OF THINGS to Semester 133','System','2026-01-22 10:27:44',NULL),(750,20,'Course Added','Added course 22PH202 - ELECTROMAGNETISM AND MODERN PHYSICS to Semester 134','System','2026-01-22 10:28:12',NULL),(751,32,'Course Added','Added course 22IT507 - MINI PROJECT I to Semester 133','System','2026-01-22 10:28:17',NULL),(752,32,'Card Added','Added Semester 6','System','2026-01-22 10:28:27',NULL),(753,21,'Course Added','Added course 22BT601 - DOWNSTREAM PROCESSING to Semester 136','System','2026-01-22 10:28:28',NULL),(754,27,'Course Added','Added course 22EC504 - INTERNET OF THINGS AND ITS APPLICATIONS  to Semester 98','System','2026-01-22 10:28:33',NULL),(755,16,'Course Added','Added course 22AI702 - AI FOR ROBOTICS to Semester 135','System','2026-01-22 10:28:53',NULL),(756,21,'Course Added','Added course 22BT602 - IMMUNOLOGY to Semester 136','System','2026-01-22 10:29:00',NULL),(757,32,'Course Added','Added course 22IT601 - DATA MINING AND WAREHOUSING to Semester 137','System','2026-01-22 10:29:01',NULL),(758,27,'Course Added','Added course 22EC507  - MINI PROJECT I to Semester 98','System','2026-01-22 10:29:18',NULL),(759,32,'Course Added','Added course 22IT602 - PRINCIPLES OF COMPILER DESIGN to Semester 137','System','2026-01-22 10:29:32',NULL),(760,16,'Card Added','Added New Card','System','2026-01-22 10:29:35',NULL),(761,21,'Course Added','Added course 22BT603 - ENZYME AND PROTEIN ENGINEERING to Semester 136','System','2026-01-22 10:29:39',NULL),(762,27,'Course Added','Added course 22EC601 - COMPUTER NETWORKS AND PROTOCOLS  to Semester 99','System','2026-01-22 10:29:57',NULL),(763,32,'Course Added','Added course 22IT603 - CLOUD COMPUTING to Semester 137','System','2026-01-22 10:30:04',NULL),(764,21,'Course Added','Added course 22BT607 - MINI PROJECT II to Semester 136','System','2026-01-22 10:30:07',NULL),(765,21,'Card Added','Added Semester 7','System','2026-01-22 10:30:26',NULL),(766,32,'Course Added','Added course 22IT607 - MINI PROJECT II  to Semester 137','System','2026-01-22 10:30:41',NULL),(767,32,'Card Added','Added Semester 7','System','2026-01-22 10:30:51',NULL),(768,20,'Course Added','Added course 22CH203 - ENGINEERING CHEMISTRY II to Semester 134','System','2026-01-22 10:30:57',NULL),(769,21,'Course Added','Added course 22BT701 - GENOMICS AND PROTEOMICS to Semester 139','System','2026-01-22 10:31:03',NULL),(770,27,'Course Added','Added course 22EC602 - DIGITAL SYSTEM DESIGN WITH FPGA to Semester 99','System','2026-01-22 10:31:05',NULL),(771,17,'Course Removed','Removed course PROBABILITY, STATISTICS AND QUEUING THEORY from Semester 79','System','2026-01-22 10:31:14',NULL),(772,32,'Course Added','Added course 22IT701 - CRYPTOGRAPHY AND INFORMATION SECURITY to Semester 140','System','2026-01-22 10:31:20',NULL),(773,21,'Course Added','Added course 22BT702 - BIOPHARMACEUTICAL TECHNOLOGY to Semester 139','System','2026-01-22 10:31:33',NULL),(774,32,'Course Added','Added course 22IT702 - ARTIFICIAL INTELLIGENCE AND EXPERT SYSTEM to Semester 140','System','2026-01-22 10:31:53',NULL),(775,27,'Course Added','Added course 22EC603  - ARTIFICIAL INTELLIGENCE AND MACHINE LEARNING to Semester 99','System','2026-01-22 10:31:55',NULL),(776,16,'Course Added','Added course 22AI707 -  PROJECT WORK I  to Semester 135','System','2026-01-22 10:32:02',NULL),(777,21,'Course Added','Added course 22BT707 - PROJECT WORK I to Semester 139','System','2026-01-22 10:32:08',NULL),(778,16,'Card Added','Added Semester 8','System','2026-01-22 10:32:12',NULL),(779,21,'Card Added','Added Semester 8','System','2026-01-22 10:32:18',NULL),(780,32,'Course Added','Added course 22IT707 - PROJECT WORK I to Semester 140','System','2026-01-22 10:32:27',NULL),(781,27,'Course Added','Added course 22EC607  - MINI PROJECT II  to Semester 99','System','2026-01-22 10:32:33',NULL),(782,32,'Card Added','Added Semester 8','System','2026-01-22 10:32:34',NULL),(783,21,'Course Added','Added course 22BT801 - PROJECT WORK II  to Semester 142','System','2026-01-22 10:32:58',NULL),(784,20,'Course Added','Added course 22GE002 - COMPUTATIONAL PROBLEM SOLVING to Semester 134','System','2026-01-22 10:33:04',NULL),(785,27,'Course Added','Added course 22EC701 - MICROWAVE ENGINEERING to Semester 100','System','2026-01-22 10:33:31',NULL),(786,20,'Course Added','Added course 22GE004 - BASICS OF ELECTRONICS ENGINEERING to Semester 134','System','2026-01-22 10:34:04',NULL),(787,21,'Card Added','Added New Card','System','2026-01-22 10:34:09',NULL),(788,17,'Card Added','Added Vertical 2','System','2026-01-22 10:34:20',NULL),(789,15,'Card Added','Added Semester 1','System','2026-01-22 10:34:20',NULL),(790,16,'Course Added','Added course 22AI801 - PROJECT WORK II to Semester 141','System','2026-01-22 10:34:23',NULL),(791,15,'Card Added','Added Semester 2','System','2026-01-22 10:34:25',NULL),(792,15,'Card Added','Added Semester 3','System','2026-01-22 10:34:30',NULL),(793,27,'Course Added','Added course 22EC702 - WIRELESS COMMUNICATION  to Semester 100','System','2026-01-22 10:34:30',NULL),(794,17,'Card Added','Added Vertical 3','System','2026-01-22 10:34:32',NULL),(795,15,'Card Added','Added Semester 4','System','2026-01-22 10:34:34',NULL),(796,15,'Card Added','Added Semester 5','System','2026-01-22 10:34:41',NULL),(797,17,'Card Added','Added Vertical 4','System','2026-01-22 10:34:41',NULL),(798,15,'Card Added','Added Semester 6','System','2026-01-22 10:34:45',NULL),(799,15,'Card Added','Added Semester 7','System','2026-01-22 10:34:50',NULL),(800,15,'Card Added','Added Semester 8','System','2026-01-22 10:34:55',NULL),(801,21,'Course Added','Added course 22HS201 - COMMUNICATIVE ENGLISH II to Semester 144','System','2026-01-22 10:34:59',NULL),(802,20,'Course Added','Added course 22HS002 - STARTUP MANAGEMENT to Semester 134','System','2026-01-22 10:35:01',NULL),(803,15,'Card Added','Added New Card','System','2026-01-22 10:35:09',NULL),(804,32,'Card Added','Added Vertical 1','System','2026-01-22 10:35:09',NULL),(805,17,'Card Added','Added Vertical 5','System','2026-01-22 10:35:18',NULL),(806,27,'Course Added','Added course 22EC707 - PROJECT WORK I to Semester 100','System','2026-01-22 10:35:22',NULL),(807,21,'Course Added','Added course 22HSH01 - HINDI to Semester 144','System','2026-01-22 10:35:30',NULL),(808,17,'Card Added','Added Vertical 6','System','2026-01-22 10:35:31',NULL),(809,16,'Course Added','Added course 22HS201 - COMMUNICATIVE ENGLISH II to Semester 138','System','2026-01-22 10:35:44',NULL),(810,17,'Card Added','Added Vertical 7','System','2026-01-22 10:35:45',NULL),(811,15,'Card Added','Added Vertical 1','System','2026-01-22 10:35:48',NULL),(812,32,'Card Added','Added New Card','System','2026-01-22 10:35:53',NULL),(813,15,'Card Added','Added Vertical 2','System','2026-01-22 10:35:57',NULL),(814,27,'Course Added','Added course 22EC801  - PROJECT WORK II  to Semester 101','System','2026-01-22 10:35:59',NULL),(815,21,'Course Added','Added course 22HSG01 - GERMAN to Semester 144','System','2026-01-22 10:36:02',NULL),(816,20,'Course Added','Added course 22HS006 - TAMILS AND TECHNOLOGY to Semester 134','System','2026-01-22 10:36:06',NULL),(817,15,'Card Added','Added Vertical 3','System','2026-01-22 10:36:10',NULL),(818,15,'Card Added','Added Vertical 4','System','2026-01-22 10:36:17',NULL),(819,17,'Card Added','Added Vertical 8','System','2026-01-22 10:36:21',NULL),(820,16,'Course Added','Added course 22HSH01 - HINDI to Semester 138','System','2026-01-22 10:36:29',NULL),(821,21,'Course Added','Added course 22HSJ01 - JAPANESE to Semester 144','System','2026-01-22 10:36:31',NULL),(822,21,'Course Added','Added course 22HSC01 - CHINESE to Semester 144','System','2026-01-22 10:37:00',NULL),(823,16,'Course Added','Added course 22HSG01 - GERMAN to Semester 138','System','2026-01-22 10:37:09',NULL),(824,32,'Course Added','Added course 22IT001 - EXPLORATORY DATA ANALYSIS to Semester 157','System','2026-01-22 10:37:17',NULL),(825,16,'Course Updated','Updated course: 22HS002 - STARTUP MANAGEMENT','System','2026-01-22 10:37:19','{\"cia_marks\": {\"new\": 50, \"old\": 40}, \"see_marks\": {\"new\": 50, \"old\": 60}, \"course_type\": {\"new\": \"Theory\", \"old\": \"Theory&Lab\"}}'),(826,15,'Card Added','Added Vertical 5','System','2026-01-22 10:37:21',NULL),(827,21,'Course Added','Added course 22HSF01 - FRENCH to Semester 144','System','2026-01-22 10:37:29',NULL),(828,20,'Card Added','Added Semester 3','System','2026-01-22 10:37:29',NULL),(829,32,'Course Added','Added course 22IT002 - RECOMMENDER SYSTEMS to Semester 157','System','2026-01-22 10:37:48',NULL),(830,15,'Card Added','Added Vertical 6','System','2026-01-22 10:37:51',NULL),(831,15,'Card Added','Added Vertical 7','System','2026-01-22 10:38:03',NULL),(832,20,'Course Added','Added course 22CE301 - NUMERICAL METHODS AND STATISTICS  to Semester 168','System','2026-01-22 10:38:12',NULL),(833,32,'Course Added','Added course 22IT003 - BIG DATA ANALYTICS to Semester 157','System','2026-01-22 10:38:12',NULL),(834,16,'Course Added','Added course 22HSJ01 - JAPANESE to Semester 138','System','2026-01-22 10:38:15',NULL),(835,16,'Course Updated','Updated course: 22HS002 - STARTUP MANAGEMENT','System','2026-01-22 10:38:23','{\"course_type\": {\"new\": \"Lab\", \"old\": \"Theory\"}}'),(836,32,'Course Added','Added course 22IT004 - NEURAL NETWORKS AND DEEP LEARNING to Semester 157','System','2026-01-22 10:38:54',NULL),(837,16,'Course Added','Added course 22HSF01 - FRENCH to Semester 138','System','2026-01-22 10:39:05',NULL),(838,20,'Course Added','Added course 22CE302 - CONSTRUCTION MATERIALS, EQUIPMENT AND TECHNIQUES to Semester 168','System','2026-01-22 10:39:08',NULL),(839,21,'Course Removed','Removed course COMMUNICATIVE ENGLISH II from Semester 144','System','2026-01-22 10:39:18',NULL),(840,32,'Course Added','Added course 22IT005 - NATURAL LANGUAGE PROCESSING to Semester 157','System','2026-01-22 10:39:23',NULL),(841,27,'Card Added','Added New Card','System','2026-01-22 10:39:35',NULL),(842,16,'Card Added','Added Vertical 1','System','2026-01-22 10:39:37',NULL),(843,32,'Course Added','Added course 22IT006 - COMPUTER VISION  to Semester 157','System','2026-01-22 10:39:51',NULL),(844,20,'Course Added','Added course 22CE303 - SURVEY AND GEOMATICS to Semester 168','System','2026-01-22 10:39:57',NULL),(845,32,'Card Added','Added Vertical 2','System','2026-01-22 10:40:00',NULL),(846,27,'Course Added','Added course 22HS201 - COMMUNICATIVE ENGLISH II to Semester 171','System','2026-01-22 10:40:26',NULL),(847,20,'Course Added','Added course 22CE304 - FLUID MECHANICS AND MACHINERY  to Semester 168','System','2026-01-22 10:40:47',NULL),(848,17,'Honour Card Added','Added Honour Card: HONORS/MINORS','System','2026-01-22 10:40:49',NULL),(849,17,'Card Added','Added New Card','System','2026-01-22 10:41:05',NULL),(850,16,'Card Added','Added Vertical 2','System','2026-01-22 10:41:06',NULL),(851,16,'Card Added','Added Vertical 3','System','2026-01-22 10:41:16',NULL),(852,17,'Card Added','Added New Card','System','2026-01-22 10:41:16',NULL),(853,27,'Course Added','Added course 22HSH01  - HINDI  to Semester 171','System','2026-01-22 10:41:22',NULL),(854,20,'Course Added','Added course 22CE305 - ENGINEERING MECHANICS to Semester 168','System','2026-01-22 10:41:39',NULL),(855,27,'Course Added','Added course 22HSG01 - GERMAN to Semester 171','System','2026-01-22 10:42:13',NULL),(856,16,'Card Added','Added Vertical 4','System','2026-01-22 10:42:24',NULL),(857,16,'Card Added','Added Vertical 5','System','2026-01-22 10:42:36',NULL),(858,16,'Card Added','Added Vertical 6','System','2026-01-22 10:42:50',NULL),(859,20,'Course Added','Added course 22HS004 - HUMAN VALUES AND ETHICS to Semester 168','System','2026-01-22 10:42:53',NULL),(860,27,'Course Added','Added course 22HSJ01 - JAPANESE to Semester 171','System','2026-01-22 10:42:56',NULL),(861,16,'Card Added','Added Vertical 7','System','2026-01-22 10:42:59',NULL),(862,16,'Card Added','Added Vertical 8','System','2026-01-22 10:43:06',NULL),(863,27,'Course Added','Added course 22HSF01  - FRENCH to Semester 171','System','2026-01-22 10:43:47',NULL),(864,20,'Course Added','Added course 22HS005 - SOFT SKILLS AND EFFECTIVE COMMUNICATION to Semester 168','System','2026-01-22 10:44:09',NULL),(865,32,'Course Added','Added course 22IT007 - AGILE SOFTWARE DEVELOPMENT to Semester 173','System','2026-01-22 10:44:22',NULL),(866,17,'Honour Card Added','Added Honour Card: HONORS','System','2026-01-22 10:44:37',NULL),(867,16,'Honour Card Added','Added Honour Card: HONOUR','System','2026-01-22 10:44:38',NULL),(868,32,'Course Added','Added course 22IT008 - UI AND UX DESIGN to Semester 173','System','2026-01-22 10:44:41',NULL),(869,20,'Card Added','Added Semester 4','System','2026-01-22 10:44:45',NULL),(870,32,'Course Added','Added course 22IT009 - WEB FRAMEWORKS to Semester 173','System','2026-01-22 10:44:59',NULL),(871,16,'Honour Card Added','Added Honour Card: MINOR','System','2026-01-22 10:45:01',NULL),(872,17,'Honour Card Added','Added Honour Card: MINORS','System','2026-01-22 10:45:02',NULL),(873,27,'Card Added','Added Vertical 1','System','2026-01-22 10:45:25',NULL),(874,20,'Course Added','Added course 22CE401 - WATER RESOURCES ENGINEERING to Semester 183','System','2026-01-22 10:45:28',NULL),(875,32,'Course Added','Added course 22IT010 - APP DEVELOPMENT  to Semester 173','System','2026-01-22 10:45:30',NULL),(876,21,'Card Added','Added Vertical 1','System','2026-01-22 10:45:45',NULL),(877,32,'Course Added','Added course 22IT011 - SOFTWARE TESTING AND AUTOMATION  to Semester 173','System','2026-01-22 10:46:04',NULL),(878,27,'Course Added','Added course 22EC001 - ADVANCED PROCESSOR ARCHITECTURES to Semester 184','System','2026-01-22 10:46:14',NULL),(879,16,'Card Added','Added New Card','System','2026-01-22 10:46:20',NULL),(880,32,'Course Added','Added course 22IT012 - DEVOPS to Semester 173','System','2026-01-22 10:46:29',NULL),(881,16,'Card Added','Added New Card','System','2026-01-22 10:46:34',NULL),(882,32,'Card Added','Added Vertical 3','System','2026-01-22 10:46:40',NULL),(883,21,'Course Added','Added course 22BT001 - FERMENTATION TECHNOLOGY to Semester 185','System','2026-01-22 10:46:57',NULL),(884,32,'Course Added','Added course 22IT013 - VIRTUALIZATION IN CLOUD COMPUTING  to Semester 188','System','2026-01-22 10:47:23',NULL),(885,16,'Course Added','Added course 22AI001 - AGILE SOFTWARE DEVELOPMENT to Semester 172','System','2026-01-22 10:47:30',NULL),(886,32,'Course Added','Added course 22IT014 - CLOUD SERVICES AND DATA MANAGEMENT to Semester 188','System','2026-01-22 10:47:45',NULL),(887,21,'Course Added','Added course 22BT002 - INDUSTRIAL MICROBIOLOGY to Semester 185','System','2026-01-22 10:47:51',NULL),(888,21,'Course Updated','Updated course: 22BT001 - FERMENTATION TECHNOLOGY','System','2026-01-22 10:48:05','{\"activity_hrs\": {\"new\": 3, \"old\": 0}}'),(889,21,'Course Added','Added course 22BT003 - ENVIRONMENTAL BIOTECHNOLOGY to Semester 185','System','2026-01-22 10:48:29',NULL),(890,21,'Course Added','Added course 22BT004 - BIOENERGY AND BIOFUELS to Semester 185','System','2026-01-22 10:48:52',NULL),(891,21,'Course Added','Added course 22BT005 - BIOREACTOR DESIGN, MODELING AND SIMULATION to Semester 185','System','2026-01-22 10:49:15',NULL),(892,16,'Course Added','Added course 22AI002 - UI AND UX DESIGN to Semester 172','System','2026-01-22 10:49:40',NULL),(893,21,'Course Added','Added course 22BT006 - BIOPROCESS CONTROL AND INSTRUMENTATION to Semester 185','System','2026-01-22 10:49:43',NULL),(894,20,'Course Added','Added course 22CE402 - MECHANICS OF DEFORMABLE BODIES to Semester 183','System','2026-01-22 10:49:58',NULL),(895,16,'Course Added','Added course 22AI003 - WEB FRAMEWORKS  to Semester 172','System','2026-01-22 10:50:09',NULL),(896,16,'Course Added','Added course 22AI004 - APP DEVELOPMENT to Semester 172','System','2026-01-22 10:50:53',NULL),(897,27,'Course Added','Added course 22EC003 - EMBEDDED C PROGRAMMING  to Semester 184','System','2026-01-22 10:50:59',NULL),(898,16,'Course Added','Added course 22AI005 - SOFTWARE TESTING AND AUTOMATION to Semester 172','System','2026-01-22 10:51:24',NULL),(899,27,'Course Added','Added course 22EC002 - COMMUNICATION PROTOCOLS AND STANDARDS to Semester 184','System','2026-01-22 10:51:39',NULL),(900,16,'Course Added','Added course 22AI006 - DevOps  to Semester 172','System','2026-01-22 10:51:57',NULL),(901,27,'Course Added','Added course 22EC004 - REAL TIME OPERATING SYSTEMS to Semester 184','System','2026-01-22 10:52:15',NULL),(902,27,'Course Added','Added course 22EC005 - EMBEDDED LINUX  to Semester 184','System','2026-01-22 10:52:43',NULL),(903,15,'Course Added','Added course 22MA101 - ENGINEERING MATHEMATICS I to Semester 146','System','2026-01-22 10:53:08',NULL),(904,27,'Course Added','Added course 22EC006 - VIRTUAL INSTRUMENTATION IN EMBEDDED SYSTEMS to Semester 184','System','2026-01-22 10:53:18',NULL),(905,20,'Course Added','Added course 22CE403 - CONCRETE TECHNOLOGY to Semester 183','System','2026-01-22 10:53:28',NULL),(906,15,'Course Added','Added course 22PH102 - ENGINEERING PHYSICS to Semester 146','System','2026-01-22 10:53:56',NULL),(907,20,'Course Added','Added course 22CE404 - GEOTECHNICAL ENGINEERING I to Semester 183','System','2026-01-22 10:54:16',NULL),(908,15,'Course Added','Added course 22CH103 - ENGINEERING CHEMISTRY I to Semester 146','System','2026-01-22 10:54:36',NULL),(909,27,'Card Added','Added Vertical 2','System','2026-01-22 10:54:40',NULL),(910,20,'Course Added','Added course 22CE405 - CONSTRUCTION MANAGEMENT to Semester 183','System','2026-01-22 10:54:57',NULL),(911,15,'Course Added','Added course 22GE001 - FUNDAMENTALS OF COMPUTING to Semester 146','System','2026-01-22 10:55:11',NULL),(912,15,'Course Added','Added course 22HS001 - FOUNDATIONAL ENGLISH to Semester 146','System','2026-01-22 10:56:13',NULL),(913,16,'Course Added','Added course 22AI007 - VIRTUALIZATION IN CLOUD COMPUTING to Semester 175','System','2026-01-22 10:56:46',NULL),(914,16,'Course Updated','Updated course: 22HS001 - FOUNDATIONAL ENGLISH','System','2026-01-22 10:57:23','{\"cia_marks\": {\"new\": 100, \"old\": 50}, \"see_marks\": {\"new\": 60, \"old\": 50}, \"course_type\": {\"new\": \"Theory\", \"old\": \"Theory&Lab\"}}'),(915,16,'Card Added','Added New Card','System','2026-01-22 10:57:52',NULL),(916,28,'PO[8] Added','Added PO item at index 8','System','2026-01-22 11:01:23','{\"PO[8]\": {\"new\": \"Individual and Team Work: Function effectively as an individual, and as a member or leader in diverse teams, and in multidisciplinary settings.\", \"old\": \"\"}}'),(917,28,'PO[0] Added','Added PO item at index 0','System','2026-01-22 11:01:23','{\"PO[0]\": {\"new\": \"Engineering Knowledge: Apply the knowledge of mathematics, science, engineering fundamentals, and an engineering specialization to the solution of complex engineering problems.\", \"old\": \"\"}}'),(918,15,'Course Added','Added course 22GE003 - BASICS OF ELECTRICAL ENGINEERING  to Semester 146','System','2026-01-23 03:49:56',NULL),(919,15,'Course Added','Added course 22GE005 - ENGINEERING DRAWING to Semester 146','System','2026-01-23 03:51:14',NULL),(920,15,'Course Added','Added course 22HS003 - தமிழர்மரபு HERITAGE OF TAMILS#* to Semester 146','System','2026-01-23 03:52:43',NULL),(921,20,'Course Added','Added course 22HS008 - ADVANCED ENGLISH AND TECHNICAL EXPRESSION to Semester 183','System','2026-01-23 03:54:30',NULL),(922,20,'Card Added','Added Semester 5','System','2026-01-23 03:58:34',NULL),(923,20,'Course Added','Added course 22CE501 - DESIGN OF RCC ELEMENTS to Semester 191','System','2026-01-23 03:59:20',NULL),(924,20,'Course Added','Added course 22CE502 - STRUCTURAL ANALYSIS I to Semester 191','System','2026-01-23 04:00:05',NULL),(925,20,'Course Added','Added course 22CE503 - WATER SUPPLY AND WASTEWATER ENGINEERING to Semester 191','System','2026-01-23 04:00:44',NULL),(926,20,'Course Added','Added course 22CE504 - GEOTECHNICAL ENGINEERING II to Semester 191','System','2026-01-23 04:01:27',NULL),(927,20,'Course Added','Added course 22CE507 - MINI PROJECT I to Semester 191','System','2026-01-23 04:02:14',NULL),(928,20,'Card Added','Added Semester 6','System','2026-01-23 04:02:47',NULL),(929,25,'Vision Updated','Updated department vision','System','2026-01-23 04:05:33','{\"vision\": {\"new\": \"To be the leader in the field of computer technology, fostering innovative thinking, promoting technological excellence, and driving digital transformation for the benefit of society.\\n\", \"old\": \"To be the leader in the field of computer technology, fostering innovative thinking,\\npromoting technological excellence, and driving digital transformation for the benefit\\nof society.\\n\"}}'),(930,25,'PO[0] Added','Added PO item at index 0','System','2026-01-23 04:11:42','{\"PO[0]\": {\"new\": \"Engineering Knowledge: Apply knowledge of mathematics, natural science, computing, engineering fundamentals and an engineering specialization as specified in WK1 to WK4 respectively to develop to the solution of complex engineering problems.\", \"old\": \"\"}}'),(931,25,'PO[3] Added','Added PO item at index 3','System','2026-01-23 04:11:42','{\"PO[3]\": {\"new\": \"Conduct Investigations of Complex Problems: Conduct investigations of complex engineering problems using research-based knowledge including design of experiments, modelling, analysis & interpretation of data to provide valid conclusions. (WK8).\", \"old\": \"\"}}'),(932,25,'PO[10] Added','Added PO item at index 10','System','2026-01-23 04:11:42','{\"PO[10]\": {\"new\": \"Life-Long Learning: Recognize the need for, and have the preparation and ability for i) independent and life-long learning ii) adaptability to new and emerging technologies and iii) critical thinking in the broadest context of technological change. (WK8)\", \"old\": \"\"}}'),(933,25,'PO[5] Added','Added PO item at index 5','System','2026-01-23 04:11:42','{\"PO[5]\": {\"new\": \"The Engineer and The World: Analyze and evaluate societal and environmental aspects while solving complex engineering problems for its impact on sustainability with reference to economy, health, safety, legal framework, culture and environment. (WK1, WK5, and WK7).\", \"old\": \"\"}}'),(934,25,'PO[2] Added','Added PO item at index 2','System','2026-01-23 04:11:42','{\"PO[2]\": {\"new\": \"Design/Development of Solutions: Design creative solutions for complex engineering problems and design/develop systems/components/processes to meet identified needs with consideration for the public health and safety, whole-life cost, net zero carbon, culture, society and environment as required. (WK5)\", \"old\": \"\"}}'),(935,25,'PO[9] Added','Added PO item at index 9','System','2026-01-23 04:11:42','{\"PO[9]\": {\"new\": \"Project Management and Finance: Apply knowledge and understanding of engineering management principles and economic decision-making and apply these to one’s own work, as a member and leader in a team, and to manage projects and in multidisciplinary environments.\", \"old\": \"\"}}'),(936,25,'PO[8] Added','Added PO item at index 8','System','2026-01-23 04:11:42','{\"PO[8]\": {\"new\": \"Communication: Communicate effectively and inclusively within the engineering community and society at large, such as being able to comprehend and write effective reports and design documentation, make effective presentations considering cultural, language, and learning differences\", \"old\": \"\"}}'),(937,25,'PO[7] Added','Added PO item at index 7','System','2026-01-23 04:11:42','{\"PO[7]\": {\"new\": \"Individual and Collaborative Team work: Function effectively as an individual, and as a member or leader in diverse/multi-disciplinary teams.\", \"old\": \"\"}}'),(938,25,'PO[1] Added','Added PO item at index 1','System','2026-01-23 04:11:42','{\"PO[1]\": {\"new\": \"Problem Analysis: Identify, formulate, review research literature and analyze complex engineering problems reaching substantiated conclusions with consideration for sustainable development. (WK1 to WK4)\", \"old\": \"\"}}'),(939,25,'PO[6] Added','Added PO item at index 6','System','2026-01-23 04:11:42','{\"PO[6]\": {\"new\": \"Ethics: Apply ethical principles and commit to professional ethics, human values, diversity and inclusion; adhere to national & international laws. (WK9)\", \"old\": \"\"}}'),(940,25,'PO[4] Added','Added PO item at index 4','System','2026-01-23 04:11:42','{\"PO[4]\": {\"new\": \"Engineering Tool Usage: Create, select and apply appropriate techniques, resources and modern engineering & IT tools, including prediction and modelling recognizing their limitations to solve complex engineering problems. (WK2 and WK6)\", \"old\": \"\"}}'),(941,25,'PEO-PO Mapping Saved','Updated PEO-PO mappings for the curriculum','System','2026-01-23 04:13:17',NULL),(942,25,'PEO-PO Mapping Saved','Updated PEO-PO mappings for the curriculum','System','2026-01-23 04:13:19',NULL),(943,25,'PEO-PO Mapping Saved','Updated PEO-PO mappings for the curriculum','System','2026-01-23 04:13:23',NULL),(944,25,'PEO-PO Mapping Saved','Updated PEO-PO mappings for the curriculum','System','2026-01-23 04:14:42',NULL),(945,25,'Card Added','Added Semester 1','System','2026-01-23 04:15:34',NULL),(946,25,'Course Added','Added course 22MA101 - ENGINEERING MATHEMATICS I to Semester 193','System','2026-01-23 04:16:21',NULL),(947,25,'Course Added','Added course 22PH102 - ENGINEERING PHYSICS to Semester 193','System','2026-01-23 04:17:19',NULL),(948,25,'Course Added','Added course 22CH103  - ENGINEERING CHEMISTRY I to Semester 193','System','2026-01-23 04:17:51',NULL),(949,20,'Course Added','Added course 22CE601 - DESIGN OF RCC STRUCTURES to Semester 192','System','2026-01-23 04:18:00',NULL),(950,20,'Course Added','Added course 22CE602 - STRUCTURAL ANALYSIS II to Semester 192','System','2026-01-23 04:18:42',NULL),(951,20,'Course Added','Added course 22CE603 - DESIGN OF STEEL STRUCTURES to Semester 192','System','2026-01-23 04:19:20',NULL),(952,25,'Course Added','Added course 22GE001 - FUNDAMENTALS OF COMPUTING to Semester 193','System','2026-01-23 04:19:28',NULL),(953,20,'Course Added','Added course 22CE607 - MINI PROJECT II to Semester 192','System','2026-01-23 04:19:58',NULL),(954,25,'Course Added','Added course 22HS001 - FOUNDATIONAL ENGLISH to Semester 193','System','2026-01-23 04:20:05',NULL),(955,20,'Card Added','Added Semester 7','System','2026-01-23 04:20:20',NULL),(956,25,'Course Added','Added course 22GE004 - BASICS OF ELECTRONICS ENGINEERING to Semester 193','System','2026-01-23 04:20:37',NULL),(957,20,'Course Added','Added course 22CE701 - HIGHWAY AND RAILWAY ENGINEERING to Semester 194','System','2026-01-23 04:21:03',NULL),(958,25,'Course Added','Added course 22HS002 - STARTUP MANAGEMENT to Semester 193','System','2026-01-23 04:21:14',NULL),(959,20,'Course Added','Added course 22CE702 - ESTIMATION, COSTING AND QUANTITY SURVEYING to Semester 194','System','2026-01-23 04:21:45',NULL),(960,25,'Course Added','Added course 22HS003 - தமிழர்மரபு HERITAGE OF TAMILS to Semester 193','System','2026-01-23 04:21:57',NULL),(961,20,'Course Added','Added course 22CE707 - PROJECT WORK I to Semester 194','System','2026-01-23 04:22:22',NULL),(962,25,'Course Added','Added course 22CT108 - COMPREHENSIVE WORK to Semester 193','System','2026-01-23 04:22:23',NULL),(963,25,'Card Added','Added Semester 2','System','2026-01-23 04:22:31',NULL),(964,20,'Card Added','Added Semester 8','System','2026-01-23 04:22:43',NULL),(965,25,'Course Added','Added course 22MA201 - ENGINEERING MATHEMATICS II to Semester 195','System','2026-01-23 04:23:22',NULL),(966,20,'Course Added','Added course 22CE801 - PROJECT WORK II to Semester 196','System','2026-01-23 04:23:24',NULL),(967,25,'Course Added','Added course 22PH202  - ELECTROMAGNETISM AND MODERN PHYSICS to Semester 195','System','2026-01-23 04:23:53',NULL),(968,25,'Course Added','Added course 22CH203 - ENGINEERING CHEMISTRY II to Semester 195','System','2026-01-23 04:24:26',NULL),(969,25,'Course Added','Added course 22GE002 - COMPUTATIONAL PROBLEM SOLVING to Semester 195','System','2026-01-23 04:24:51',NULL),(970,25,'Course Added','Added course 22GE003  - BASICS OF ELECTRICAL ENGINEERING to Semester 195','System','2026-01-23 04:26:45',NULL),(971,25,'Course Added','Added course 22CT206 - DIGITAL COMPUTER ELECTRONICS to Semester 195','System','2026-01-23 04:27:25',NULL),(972,25,'Course Added','Added course 22HS006 - தமிழரும் தததொழில்நுட்பமும் TAMILS AND TECHNOLOGY to Semester 195','System','2026-01-23 04:28:21',NULL),(973,25,'Card Added','Added Semester 3','System','2026-01-23 04:28:34',NULL),(974,20,'Card Added','Added New Card','System','2026-01-23 04:29:40',NULL),(975,20,'Course Added','Added course 22HS201 - COMMUNICATIVE ENGLISH II to Semester 198','System','2026-01-23 04:30:30',NULL),(976,20,'Course Added','Added course 22HSH01 - HINDI  to Semester 198','System','2026-01-23 04:32:00',NULL),(977,20,'Course Added','Added course 22HSG01  - GERMAN to Semester 198','System','2026-01-23 04:32:32',NULL),(978,20,'Course Added','Added course 22HSJ01 - JAPANESE to Semester 198','System','2026-01-23 04:33:04',NULL),(979,20,'Course Added','Added course 22HSF01 - FRENCH to Semester 198','System','2026-01-23 04:33:46',NULL),(980,25,'Course Added','Added course 22CT301 - PROBABILITY, STATISTICS AND QUEUING THEORY to Semester 197','System','2026-01-23 04:52:35',NULL),(981,25,'Course Added','Added course 22CT302 - DATA STRUCTURES I  to Semester 197','System','2026-01-23 04:53:04',NULL),(982,25,'Course Added','Added course 22CT303 - COMPUTER ORGANIZATION AND ARCHITECTURE to Semester 197','System','2026-01-23 04:54:16',NULL),(983,25,'Course Added','Added course 22CT304 - PRINCIPLES OF PROGRAMMING LANGUAGES to Semester 197','System','2026-01-23 04:54:45',NULL),(984,25,'Course Added','Added course 22CT305 - SOFTWARE ENGINEERING to Semester 197','System','2026-01-23 04:55:14',NULL),(985,25,'Course Added','Added course 22HS004 - HUMAN VALUES AND ETHICS to Semester 197','System','2026-01-23 04:55:42',NULL),(986,25,'Course Added','Added course 22HS005 - SOFT SKILLS AND EFFECTIVE COMMUNICATION to Semester 197','System','2026-01-23 04:56:16',NULL),(987,25,'Card Added','Added Semester 4','System','2026-01-23 04:56:28',NULL),(988,25,'Course Added','Added course 22CT401 - DISCRETE MATHEMATICS to Semester 199','System','2026-01-23 04:57:29',NULL),(989,25,'Course Added','Added course 22CT402 - DATA STRUCTURES II to Semester 199','System','2026-01-23 04:57:56',NULL),(990,25,'Course Added','Added course 22CT403 - OPERATING SYSTEMS to Semester 199','System','2026-01-23 04:58:21',NULL),(991,25,'Course Added','Added course 22CT404  - WEB TECHNOLOGY AND FRAMEWORKS to Semester 199','System','2026-01-23 04:58:49',NULL),(992,25,'Course Added','Added course 22CT405 - DATABASE MANAGEMENT SYSTEM to Semester 199','System','2026-01-23 04:59:22',NULL),(993,25,'Course Added','Added course 22HS007 - ENVIRONMENTAL SCIENCE to Semester 199','System','2026-01-23 05:01:21',NULL),(994,25,'Course Added','Added course 22HS008 - ADVANCED ENGLISH AND TECHNICAL EXPRESSION to Semester 199','System','2026-01-23 05:01:47',NULL),(995,25,'Card Added','Added Semester 5','System','2026-01-23 05:02:07',NULL),(996,21,'PO[11] Deleted','Deleted PO item at index 11','System','2026-01-23 05:02:31','{\"PO[11]\": {\"new\": \"\", \"old\": \"Life-long Learning: Recognize the need for, and have the preparation and ability to engage in independent and life-long learning in the broadest context of technological change.\"}}'),(997,21,'PO[7] Updated','Updated PO item at index 7','System','2026-01-23 05:02:31','{\"PO[7]\": {\"new\": \"Individual and Team Work: Function effectively as an individual, and as a member or leader in diverse teams, and in multidisciplinary settings.\", \"old\": \"Ethics: Apply ethical principles and commit to professional ethics and responsibilities and norms of the engineering practice.\"}}'),(998,21,'PO[9] Updated','Updated PO item at index 9','System','2026-01-23 05:02:31','{\"PO[9]\": {\"new\": \"Project Management and Finance: Demonstrate knowledge and understanding of the engineering and management principles and apply these to one’s own work, as a member and leader in a team, to manage projects and in multidisciplinary environments.\", \"old\": \"Communication: Communicate effectively on complex engineering activities with the engineering community and with society at large, such as, being able to comprehend and write effective reports and design documentation, make effective presentations, and give and receive clear instructions.\"}}'),(999,21,'PO[5] Updated','Updated PO item at index 5','System','2026-01-23 05:02:31','{\"PO[5]\": {\"new\": \"The Engineer and Society:  The Engineer and The World: Analyze and evaluate societal and environmental aspects while solving complex engineering problems for its impact on sustainability with reference to economy, health, safety, legal framework, culture and environment.\", \"old\": \"The Engineer and Society: Apply reasoning informed by the contextual knowledge to assess societal, health, safety, legal and cultural issues and the consequent responsibilities relevant to the professional engineering practice.\"}}'),(1000,21,'PO[8] Updated','Updated PO item at index 8','System','2026-01-23 05:02:31','{\"PO[8]\": {\"new\": \"Communication: Communicate effectively on complex engineering activities with the engineering community and with society at large, such as, being able to comprehend and write effective reports and design documentation, make effective presentations, and give and receive clear instructions.\", \"old\": \"Individual and Team Work: Function effectively as an individual, and as a member or leader in diverse teams, and in multidisciplinary settings.\"}}'),(1001,21,'PO[3] Updated','Updated PO item at index 3','System','2026-01-23 05:02:31','{\"PO[3]\": {\"new\": \"Conduct Investigations of Complex Problems: Use research-based knowledge and research methods including design of experiments, analysis and interpretation of data, and synthesis of the information to provide valid conclusions.\", \"old\": \"Conduct Investigations of Complex Problems: Use research-based knowledge and research methods including design of experiments, analysis and interpretation of data, and synthesis of the information to provide valid conclusions\"}}'),(1002,21,'PO[10] Updated','Updated PO item at index 10','System','2026-01-23 05:02:31','{\"PO[10]\": {\"new\": \"Life-long Learning: Recognize the need for, and have the preparation and ability to engage in independent and life-long learning in the broadest context of technological change.\", \"old\": \"Project Management and Finance: Demonstrate knowledge and understanding of the engineering and management principles and apply these to one’s own work, as a member and leader in a team, to manage projects and in multidisciplinary environments.\"}}'),(1003,21,'PO[6] Updated','Updated PO item at index 6','System','2026-01-23 05:02:31','{\"PO[6]\": {\"new\": \"Ethics: Apply ethical principles and commit to professional ethics and responsibilities and norms of the engineering practice.\", \"old\": \"Environment and Sustainability: Understand the impact of the professional engineering solutions in societal and environmental contexts, and demonstrate the knowledge of, and need for sustainable development.\"}}'),(1004,25,'Course Added','Added course 22CT501 - PRINCIPLES OF COMPILER DESIGN to Semester 200','System','2026-01-23 05:02:34',NULL),(1005,25,'Course Added','Added course 22CT502 - COMPUTER NETWORKS to Semester 200','System','2026-01-23 05:02:55',NULL),(1006,25,'Course Added','Added course 22CT503 - EMBEDDED SYSTEMS  to Semester 200','System','2026-01-23 05:03:23',NULL),(1007,25,'Course Added','Added course 22CT504 - ARTIFICIAL INTELLIGENCE SYSTEMS to Semester 200','System','2026-01-23 05:03:53',NULL),(1008,33,'Course Updated','Updated course: 22HSJ01 - JAPANESE ','System','2026-01-23 05:04:22','{\"cia_marks\": {\"new\": 100, \"old\": 50}, \"see_marks\": {\"new\": 60, \"old\": 50}}'),(1009,25,'Course Added','Added course 22CT507 - MINI PROJECT I to Semester 200','System','2026-01-23 05:05:53',NULL),(1010,25,'Card Added','Added Semester 6','System','2026-01-23 05:06:01',NULL),(1011,21,'Course Added','Added course 22BT007 - TRANSPORT PHENOMENON IN BIOLOGICAL SYSTEMS to Semester 185','System','2026-01-23 05:07:15',NULL),(1012,21,'Card Added','Added Vertical 2','System','2026-01-23 05:08:10',NULL),(1013,21,'Course Added','Added course 22BT008 - ASTROBIOLOGY AND ASTROCHEMISTRY to Semester 202','System','2026-01-23 05:08:43',NULL),(1014,21,'Course Added','Added course 22BT009 - BIOPROSPECTING AND QUALITY ANALYSIS to Semester 202','System','2026-01-23 05:09:10',NULL),(1015,21,'Course Added','Added course 22BT010 - FOOD PROCESS AND TECHNOLOGY to Semester 202','System','2026-01-23 05:09:36',NULL),(1016,21,'Course Added','Added course 22BT011 - MARINE BIOTECHNOLOGY to Semester 202','System','2026-01-23 05:09:58',NULL),(1017,21,'Course Added','Added course 22BT012 - BIODIVERSITY AND AGROFORESTRY to Semester 202','System','2026-01-23 05:10:20',NULL),(1018,21,'Course Added','Added course 22BT013 - BIOSENSORS to Semester 202','System','2026-01-23 05:10:39',NULL),(1019,21,'Course Added','Added course 22BT014 - BIOMATERIALS to Semester 202','System','2026-01-23 05:10:59',NULL),(1020,21,'Card Added','Added Vertical 3','System','2026-01-23 05:11:18',NULL),(1021,21,'Course Added','Added course 22BT015 - PROGRAMS FOR BIOINFORMATICS to Semester 203','System','2026-01-23 05:11:45',NULL),(1022,21,'Course Added','Added course 22BT016 - FUNDAMENTALS OF ALGORITHMS FOR BIOINFORMATICS to Semester 203','System','2026-01-23 05:12:03',NULL),(1023,21,'Course Added','Added course 22BT017 - MOLECULAR MODELING to Semester 203','System','2026-01-23 05:12:23',NULL),(1024,21,'Course Added','Added course 22BT018 - COMPUTER AIDED DRUG DESIGN to Semester 203','System','2026-01-23 05:12:46',NULL),(1025,21,'Course Added','Added course 22BT019 - METABOLOMICS AND GENOMICS- BIG DATA ANALYTICS to Semester 203','System','2026-01-23 05:13:06',NULL),(1026,21,'Course Added','Added course 22BT020 - DATA MINING AND MACHINE LEARNING TECHNIQUES FOR INFORMATICS to Semester 203','System','2026-01-23 05:13:30',NULL),(1027,21,'Course Added','Added course 22BT021 - SYSTEMS AND SYNTHETIC BIOLOGY to Semester 203','System','2026-01-23 05:13:51',NULL),(1028,21,'Card Added','Added Vertical 4','System','2026-01-23 05:14:10',NULL),(1029,21,'Course Added','Added course 22BT022 - PLANT TISSUE CULTURE AND TRANSFORMATION TECHNIQUE to Semester 204','System','2026-01-23 05:14:39',NULL),(1030,17,'Course Added','Added course 22AM006 - DevOps to Semester 130','System','2026-01-23 05:15:13',NULL),(1031,21,'Course Added','Added course 22BT023 - TRANSGENIC TECHNOLOGY IN AGRICULTURE to Semester 204','System','2026-01-23 05:15:31',NULL),(1032,16,'Course Added','Added course 22AI008 - CLOUD SERVICES AND DATA MANAGEMENT to Semester 175','System','2026-01-23 05:15:47',NULL),(1033,21,'Course Added','Added course 22BT024 - BIOFERTILIZERS AND BIOPESTICIDES PRODUCTION to Semester 204','System','2026-01-23 05:15:51',NULL),(1034,17,'Course Added','Added course 22AM007 - VIRTUALIZATION IN CLOUD COMPUTING  to Semester 145','System','2026-01-23 05:16:00',NULL),(1035,21,'Course Added','Added course 22BT025 - MUSHROOM CULTIVATION AND VERMICOMPOSTING to Semester 204','System','2026-01-23 05:16:12',NULL),(1036,16,'Course Added','Added course 22AI009 - CLOUD STORAGE TECHNOLOGIES to Semester 175','System','2026-01-23 05:16:30',NULL),(1037,17,'Course Added','Added course 22AM008 - CLOUD SERVICES AND DATA MANAGEMENT to Semester 145','System','2026-01-23 05:16:30',NULL),(1038,21,'Course Added','Added course 22BT026 - FUNGAL AND ALGAL TECHNOLOGY to Semester 204','System','2026-01-23 05:16:33',NULL),(1039,21,'Course Added','Added course 22BT027 - PHYTOTHERAPEUTICS to Semester 204','System','2026-01-23 05:16:55',NULL),(1040,17,'Course Added','Added course 22AM009 - CLOUD STORAGE TECHNOLOGIES to Semester 145','System','2026-01-23 05:17:03',NULL),(1041,16,'Course Added','Added course 22AI010 - CLOUD AUTOMATION TOOLS AND APPLICATIONS to Semester 175','System','2026-01-23 05:17:09',NULL),(1042,17,'Course Added','Added course 22AM010 - CLOUD AUTOMATION TOOLS AND APPLICATIONS to Semester 145','System','2026-01-23 05:17:31',NULL),(1043,17,'Course Added','Added course 22AM011 - SOFTWARE DEFINED NETWORKS  to Semester 145','System','2026-01-23 05:18:04',NULL),(1044,16,'Course Added','Added course 22AI011 - SOFTWARE DEFINED NETWORKS to Semester 175','System','2026-01-23 05:18:07',NULL),(1045,21,'PO[6] Updated','Updated PO item at index 6','System','2026-01-23 05:18:07','{\"PO[6]\": {\"new\": \"Ethics: Apply ethical principles and commit to professional ethics and responsibilities and norms of the engineering practice.\", \"old\": \"Environment and Sustainability: Understand the impact of the professional engineering solutions in societal and environmental contexts, and demonstrate the knowledge of, and need for sustainable development.\"}}'),(1046,21,'PO[8] Updated','Updated PO item at index 8','System','2026-01-23 05:18:07','{\"PO[8]\": {\"new\": \"Communication: Communicate effectively on complex engineering activities with the engineering community and with society at large, such as, being able to comprehend and write effective reports and design documentation, make effective presentations, and give and receive clear instructions.\", \"old\": \"Individual and Team Work: Function effectively as an individual, and as a member or leader in diverse teams, and in multidisciplinary settings.\"}}'),(1047,21,'PO[10] Updated','Updated PO item at index 10','System','2026-01-23 05:18:07','{\"PO[10]\": {\"new\": \"Life-long Learning: Recognize the need for, and have the preparation and ability to engage in independent and life-long learning in the broadest context of technological change.\", \"old\": \"Project Management and Finance: Demonstrate knowledge and understanding of the engineering and management principles and apply these to one’s own work, as a member and leader in a team, to manage projects and in multidisciplinary environments.\"}}'),(1048,21,'PO[7] Updated','Updated PO item at index 7','System','2026-01-23 05:18:07','{\"PO[7]\": {\"new\": \"Individual and Team Work: Function effectively as an individual, and as a member or leader in diverse teams, and in multidisciplinary settings.\", \"old\": \"Ethics: Apply ethical principles and commit to professional ethics and responsibilities and norms of the engineering practice.\"}}'),(1049,21,'PO[9] Updated','Updated PO item at index 9','System','2026-01-23 05:18:07','{\"PO[9]\": {\"new\": \"Project Management and Finance: Demonstrate knowledge and understanding of the engineering and management principles and apply these to one’s own work, as a member and leader in a team, to manage projects and in multidisciplinary environments.\", \"old\": \"Communication: Communicate effectively on complex engineering activities with the engineering community and with society at large, such as, being able to comprehend and write effective reports and design documentation, make effective presentations, and give and receive clear instructions.\"}}'),(1050,21,'PO[11] Deleted','Deleted PO item at index 11','System','2026-01-23 05:18:07','{\"PO[11]\": {\"new\": \"\", \"old\": \"Life-long Learning: Recognize the need for, and have the preparation and ability to engage in independent and life-long learning in the broadest context of technological change.\"}}'),(1051,17,'Course Added','Added course 22AM012 - SECURITY AND PRIVACY IN CLOUD to Semester 145','System','2026-01-23 05:18:34',NULL),(1052,16,'Course Added','Added course 22AI012 - SECURITY AND PRIVACY IN CLOUD to Semester 175','System','2026-01-23 05:18:39',NULL),(1053,17,'Course Added','Added course 22AM013 - CYBER SECURITY to Semester 149','System','2026-01-23 05:19:48',NULL),(1054,16,'Course Added','Added course 22AI013 - CYBER SECURITY to Semester 176','System','2026-01-23 05:19:49',NULL),(1055,24,'PO[0] Updated','Updated PO item at index 0','System','2026-01-23 05:20:05','{\"PO[0]\": {\"new\": \"Engineering Knowledge: Apply knowledge of mathematics, natural science, computing, engineering fundamentals and an engineering specialization to develop to the solution of complex engineering problems.\", \"old\": \"Engineering Knowledge: Apply the knowledge of mathematics, science, engineering fundamentals, and an engineering specialization to the solution of complex engineering problems. \"}}'),(1056,24,'PO[2] Updated','Updated PO item at index 2','System','2026-01-23 05:20:05','{\"PO[2]\": {\"new\": \"Design/Development of Solutions: Design creative solutions for complex engineering problems and design/develop systems/components/processes to meet identified needs with consideration for the public health and safety, whole-life cost, net zero carbon, culture, society and environment as required.\", \"old\": \"Design/ Development of Solutions: Design solutions for complex engineering problems and design system components or processes that meet the specified needs with appropriate  consideration for public health and safety, and the cultural, societal, and environmental considerations. \"}}'),(1057,24,'PO[8] Updated','Updated PO item at index 8','System','2026-01-23 05:20:05','{\"PO[8]\": {\"new\": \"Communication: Communicate effectively and inclusively within the engineering community and society at large, such as being able to comprehend and write effective reports and design documentation, make effective presentations considering cultural, language, and learning differences\", \"old\": \" Individual and Team Work: Function effectively as an individual, and as a member or leader in diverse teams, and in multidisciplinary settings.\"}}'),(1058,24,'PO[4] Updated','Updated PO item at index 4','System','2026-01-23 05:20:05','{\"PO[4]\": {\"new\": \"Engineering Tool Usage: Create, select and apply appropriate techniques, resources and modern engineering & IT tools, including prediction and modelling recognizing their limitations to solve complex engineering problems. \", \"old\": \"Modern Tool Usage: Create, select, and apply appropriate techniques, resources, and modern  engineering and IT tools including prediction and modeling to complex engineering activities with an understanding of the limitations. \"}}'),(1059,24,'PO[10] Updated','Updated PO item at index 10','System','2026-01-23 05:20:05','{\"PO[10]\": {\"new\": \"Life-Long Learning: Recognize the need for, and have the preparation and ability for i) independent and life-long learning ii) adaptability to new and emerging technologies and iii) critical thinking in the broadest context of technological change.\", \"old\": \"Project Management and Finance: Demonstrate knowledge and understanding of the engineering and management principles and apply these to one’s own work, as a member  and leader in a team, to manage projects and in multidisciplinary environments.\"}}'),(1060,24,'PO[5] Updated','Updated PO item at index 5','System','2026-01-23 05:20:05','{\"PO[5]\": {\"new\": \"The Engineer and The World: Analyze and evaluate societal and environmental aspects while solving complex engineering problems for its impact on sustainability with reference to economy, health, safety, legal framework, culture and environment.\", \"old\": \" The Engineer and Society: Apply reasoning informed by the contextual knowledge to assess  societal, health, safety, legal and cultural issues and the consequent responsibilities relevant to the professional engineering practice\"}}'),(1061,24,'PO[7] Updated','Updated PO item at index 7','System','2026-01-23 05:20:05','{\"PO[7]\": {\"new\": \"Individual and Collaborative Team work: Function effectively as an individual, and as a member or leader in diverse/multi-disciplinary teams.\", \"old\": \"Ethics: Apply ethical principles and commit to professional ethics and responsibilities and norms of the engineering practice. \"}}'),(1062,24,'PO[6] Updated','Updated PO item at index 6','System','2026-01-23 05:20:05','{\"PO[6]\": {\"new\": \"Ethics: Apply ethical principles and commit to professional ethics, human values, diversity and inclusion; adhere to national & international laws.\", \"old\": \"Environment and Sustainability: Understand the impact of the professional engineering  solutions in societal and environmental contexts, and demonstrate the knowledge of, and need for sustainable development.\"}}'),(1063,24,'PO[9] Updated','Updated PO item at index 9','System','2026-01-23 05:20:05','{\"PO[9]\": {\"new\": \"Project Management and Finance: Apply knowledge and understanding of engineering management principles and economic decision-making and apply these to one’s own work, as a member and leader in a team, and to manage projects and in multidisciplinary environments.\", \"old\": \"Communication: Communicate effectively on complex engineering activities with the engineering community and with society at large, such as, being able to comprehend and  write effective reports and design documentation, make effective presentations, and give and  receive clear instructions.\"}}'),(1064,24,'PO[1] Updated','Updated PO item at index 1','System','2026-01-23 05:20:05','{\"PO[1]\": {\"new\": \"Problem Analysis: Identify, formulate, review research literature and analyze complex engineering problems reaching substantiated conclusions with consideration for sustainable development.\", \"old\": \"Problem Analysis: Identify, formulate, review research literature, and analyse complex engineering problems reaching substantiated conclusions using first principles of  mathematics, natural sciences, and engineering sciences. \"}}'),(1065,24,'PO[3] Updated','Updated PO item at index 3','System','2026-01-23 05:20:05','{\"PO[3]\": {\"new\": \"Conduct Investigations of Complex Problems: Conduct investigations of complex engineering problems using research-based knowledge including design of experiments, modelling, analysis & interpretation of data to provide valid conclusions. \", \"old\": \"Conduct Investigations of Complex Problems: Use research-based knowledge and research  methods including design of experiments, analysis and interpretation of data, and synthesis of the information to provide valid conclusions. \"}}'),(1066,24,'PO[11] Deleted','Deleted PO item at index 11','System','2026-01-23 05:20:05','{\"PO[11]\": {\"new\": \"\", \"old\": \" Life-long Learning: Recognize the need for, and have the preparation and ability to engage  in independent and life-long learning in the broadest context of technological change. \"}}'),(1067,17,'Course Added','Added course 22AM014 - MODERN CRYPTOGRAPHY to Semester 149','System','2026-01-23 05:20:12',NULL),(1068,16,'Course Added','Added course 22AI014 - MODERN CRYPTOGRAPHY to Semester 176','System','2026-01-23 05:20:26',NULL),(1069,17,'Course Added','Added course 22AM015 - CYBER FORENSICS to Semester 149','System','2026-01-23 05:20:43',NULL),(1070,17,'Course Added','Added course 22AM016 - ETHICAL HACKING to Semester 149','System','2026-01-23 05:21:14',NULL),(1071,16,'Course Added','Added course 22AI015 - CYBER FORENSICS to Semester 176','System','2026-01-23 05:21:37',NULL),(1072,17,'Course Added','Added course 22AM017 - CRYPTOCURRENCY AND BLOCKCHAIN TECHNOLOGIES to Semester 149','System','2026-01-23 05:21:51',NULL),(1073,16,'Course Added','Added course 22AI016 - ETHICAL HACKING to Semester 176','System','2026-01-23 05:22:01',NULL),(1074,17,'Course Added','Added course 22AM018 - MALWARE ANALYSIS  to Semester 149','System','2026-01-23 05:22:16',NULL),(1075,16,'Course Added','Added course 22AI017 - CRYPTOCURRENCY AND BLOCKCHAIN TECHNOLOGIES to Semester 176','System','2026-01-23 05:22:49',NULL),(1076,17,'Course Added','Added course 22AM019 - ROBOTIC PROCESS AUTOMATION to Semester 152','System','2026-01-23 05:23:08',NULL),(1077,16,'Course Added','Added course 22AI018 - MALWARE ANALYSIS to Semester 176','System','2026-01-23 05:23:20',NULL),(1078,17,'Course Added','Added course 22AM020 - TEXT AND SPEECH ANALYSIS to Semester 152','System','2026-01-23 05:23:45',NULL),(1079,21,'Card Added','Added Vertical 5','System','2026-01-23 05:23:47',NULL),(1080,24,'Course Added','Added course 22CS403  - OPERATING SYSTEMS to Semester 95','System','2026-01-23 05:23:55',NULL),(1081,17,'Course Added','Added course 22AM021 - EDGE COMPUTING to Semester 152','System','2026-01-23 05:24:18',NULL),(1082,17,'Course Added','Added course 22AM022 - INTELLIGENT ROBOTS AND DRONE TECHNOLOGY to Semester 152','System','2026-01-23 05:24:52',NULL),(1083,21,'Course Added','Added course 22BT028 - ANIMAL PHYSIOLOGY AND METABOLISM to Semester 205','System','2026-01-23 05:25:02',NULL),(1084,17,'Course Added','Added course 22AM023 - INTELLIGENT TRANSPORTATION SYSTEMS  to Semester 152','System','2026-01-23 05:25:23',NULL),(1085,17,'Course Added','Added course 22AM024 - EXPERT SYSTEMS to Semester 152','System','2026-01-23 05:25:47',NULL),(1086,16,'Course Added','Added course 22AI019 - ROBOTIC PROCESS AUTOMATION to Semester 178','System','2026-01-23 05:26:06',NULL),(1087,16,'Course Added','Added course 22AI020 - REINFORCEMENT LEARNING to Semester 178','System','2026-01-23 05:26:34',NULL),(1088,16,'Course Added','Added course 22AI021 - EDGE COMPUTING to Semester 178','System','2026-01-23 05:27:27',NULL),(1089,16,'Course Added','Added course 22AI022 - INTELLIGENT ROBOTS AND DRONE TECHNOLOGY to Semester 178','System','2026-01-23 05:28:06',NULL),(1090,16,'Course Added','Added course 22AI023 - INTELLIGENT TRANSPORTATION SYSTEMS to Semester 178','System','2026-01-23 05:28:27',NULL),(1091,21,'Course Added','Added course 22BT029 - ANIMAL HEALTH AND NUTRITION to Semester 205','System','2026-01-23 05:28:35',NULL),(1092,17,'Course Added','Added course 22AM025 - WEB FRAMEWORKS AND APPLICATIONS to Semester 158','System','2026-01-23 05:28:44',NULL),(1093,16,'Course Added','Added course 22AI024 - EXPERT SYSTEMS to Semester 178','System','2026-01-23 05:29:16',NULL),(1094,16,'Course Added','Added course 22AI025 - KNOWLEDGE ENGINEERING to Semester 179','System','2026-01-23 05:30:12',NULL),(1095,17,'Course Added','Added course 22AM026 - ECOMMERCE AND WEB DEVELOPMENT to Semester 158','System','2026-01-23 05:30:17',NULL),(1096,17,'Course Added','Added course 22AM027 - MOBILE AND WEB APPLICATION  to Semester 158','System','2026-01-23 05:30:43',NULL),(1097,16,'Course Added','Added course 22AI026 - HEALTH CARE ANALYTICS to Semester 179','System','2026-01-23 05:30:46',NULL),(1098,24,'Card Added','Added Semester 5','System','2026-01-23 05:31:00',NULL),(1099,16,'Course Added','Added course 22AI027 - OPTIMIZATION TECHNIQUES to Semester 179','System','2026-01-23 05:31:13',NULL),(1100,17,'Course Added','Added course 22AM028 - NoSQL DATABASE to Semester 158','System','2026-01-23 05:31:17',NULL),(1101,16,'Course Added','Added course 22AI028 - BIG DATA ANALYTICS to Semester 179','System','2026-01-23 05:31:39',NULL),(1102,17,'Course Added','Added course 22AM029 - SMART PRODUCT DEVELOPMENT  to Semester 158','System','2026-01-23 05:31:43',NULL),(1103,16,'Course Added','Added course 22AI029 - QUANTUM COMPUTING to Semester 179','System','2026-01-23 05:32:04',NULL),(1104,17,'Course Added','Added course 22AM030 - BIO MEDICAL IMAGE ANALYSIS  to Semester 159','System','2026-01-23 05:32:25',NULL),(1105,16,'Course Added','Added course 22AI030 - COGNITIVE SCIENCE  to Semester 179','System','2026-01-23 05:32:42',NULL),(1106,17,'Course Added','Added course 22AM031 -  DATA ANALYTICS AND DATA SCIENCE to Semester 159','System','2026-01-23 05:32:49',NULL),(1107,17,'Course Added','Added course 22AM032 - VIDEO ANALYTICS to Semester 159','System','2026-01-23 05:33:11',NULL),(1108,17,'Course Added','Added course 22AM033 - CYBER THREAT ANALYTICS  to Semester 159','System','2026-01-23 05:33:32',NULL),(1109,16,'Course Added','Added course 22AI031 - BIO MEDICAL IMAGE ANALYSIS to Semester 180','System','2026-01-23 05:33:44',NULL),(1110,17,'Course Added','Added course 22AM034 - BUSINESS INTELLIGENCE to Semester 159','System','2026-01-23 05:33:56',NULL),(1111,16,'Course Added','Added course 22AI032 - RECOMMENDER SYSTEMS  to Semester 180','System','2026-01-23 05:34:10',NULL),(1112,17,'Course Added','Added course 22AM035 - DIGITAL MARKETING AND MANAGEMENT to Semester 159','System','2026-01-23 05:34:22',NULL),(1113,16,'Course Added','Added course 22AI033 - IMAGE AND VIDEO ANALYTICS to Semester 180','System','2026-01-23 05:34:45',NULL),(1114,17,'Course Added','Added course 22AM036 - INTERNET OF THINGS AND ITS APPLICATIONS  to Semester 160','System','2026-01-23 05:34:52',NULL),(1115,17,'Course Added','Added course 22AM037 - BIOINFORMATICS to Semester 160','System','2026-01-23 05:35:11',NULL),(1116,16,'Course Added','Added course 22AI034 - CYBER THREAT ANALYTICS to Semester 180','System','2026-01-23 05:35:46',NULL),(1117,24,'Course Added','Added course 22CS404  - WEB TECHNOLOGY AND FRAMEWORKS to Semester 95','System','2026-01-23 05:36:19',NULL),(1118,25,'Course Added','Added course 22CT601 - DISTRIBUTED COMPUTING to Semester 201','System','2026-01-23 05:41:44',NULL),(1119,25,'Course Added','Added course 22CT602 - MACHINE LEARNING ESSENTIALS to Semester 201','System','2026-01-23 05:42:17',NULL),(1120,25,'Course Added','Added course 22CT603 - CLOUD COMPUTING to Semester 201','System','2026-01-23 05:43:00',NULL),(1121,25,'Course Added','Added course 22CT607 - MINI PROJECT II  to Semester 201','System','2026-01-23 05:43:37',NULL),(1122,25,'Card Added','Added Semester 7','System','2026-01-23 05:43:50',NULL),(1123,25,'Course Added','Added course 22CT701 - BLOCKCHAIN TECHNOLOGY to Semester 207','System','2026-01-23 05:44:25',NULL),(1124,25,'Course Added','Added course 22CT702 - MOBILE APPLICATION DEVELOPMENT to Semester 207','System','2026-01-23 05:45:09',NULL),(1125,25,'Course Added','Added course 22CT707 - PROJECT WORK I  to Semester 207','System','2026-01-23 05:45:40',NULL),(1126,25,'Card Added','Added Semester 8','System','2026-01-23 05:45:48',NULL),(1127,25,'Card Added','Added Vertical 1','System','2026-01-23 05:47:12',NULL),(1128,25,'Course Added','Added course 22CT001 - EXPLORATORY DATA ANALYSIS to Semester 209','System','2026-01-23 05:47:54',NULL),(1129,24,'Card Added','Added Semester 6','System','2026-01-23 05:48:56',NULL),(1130,25,'Course Added','Added course 22CT002 - RECOMMENDER SYSTEMS to Semester 209','System','2026-01-23 05:48:59',NULL),(1131,24,'Card Added','Added Semester 7','System','2026-01-23 05:49:10',NULL),(1132,24,'Card Added','Added Semester 8','System','2026-01-23 05:49:23',NULL),(1133,24,'Card Added','Added New Card','System','2026-01-23 05:50:39',NULL),(1134,24,'Card Added','Added Vertical 1','System','2026-01-23 05:51:03',NULL),(1135,24,'Card Added','Added Vertical 2','System','2026-01-23 05:51:17',NULL),(1136,24,'Card Added','Added Vertical 3','System','2026-01-23 05:51:28',NULL),(1137,24,'Card Added','Added Vertical 4','System','2026-01-23 05:51:42',NULL),(1138,24,'Card Added','Added Vertical 5','System','2026-01-23 05:51:51',NULL),(1139,24,'Card Added','Added Vertical 6','System','2026-01-23 05:52:05',NULL),(1140,24,'Card Added','Added Vertical 7','System','2026-01-23 05:52:15',NULL),(1141,24,'Card Added','Added New Card','System','2026-01-23 05:52:51',NULL),(1142,24,'Card Added','Added New Card','System','2026-01-23 05:53:02',NULL),(1143,24,'Honour Card Added','Added Honour Card: DATA SCIENCE ','System','2026-01-23 05:53:52',NULL),(1144,24,'Honour Card Added','Added Honour Card:  DATA SCIENCE ','System','2026-01-23 05:54:30',NULL),(1145,31,'Card Added','Added Semester 1','System','2026-01-23 05:56:32',NULL),(1146,31,'Card Added','Added Semester 2','System','2026-01-23 05:56:40',NULL),(1147,31,'Card Added','Added Semester 3','System','2026-01-23 05:56:50',NULL),(1148,31,'Card Added','Added Semester 4','System','2026-01-23 05:56:56',NULL),(1149,31,'Card Added','Added Semester 5','System','2026-01-23 05:57:02',NULL),(1150,31,'Card Added','Added Semester 6','System','2026-01-23 05:57:09',NULL),(1151,31,'Card Added','Added Semester 7','System','2026-01-23 05:57:20',NULL),(1152,31,'Card Added','Added Semester 8','System','2026-01-23 05:57:27',NULL),(1153,31,'Card Added','Added New Card','System','2026-01-23 05:58:19',NULL),(1154,31,'Card Added','Added Vertical 1','System','2026-01-23 05:58:42',NULL),(1155,31,'Card Added','Added Vertical 2','System','2026-01-23 05:58:51',NULL),(1156,31,'Card Added','Added Vertical 3','System','2026-01-23 05:59:02',NULL),(1157,31,'Card Added','Added Vertical 4','System','2026-01-23 05:59:11',NULL),(1158,31,'Card Added','Added Vertical 5','System','2026-01-23 05:59:19',NULL),(1159,31,'Card Added','Added Vertical 6','System','2026-01-23 05:59:32',NULL),(1160,31,'Card Added','Added Vertical 7','System','2026-01-23 05:59:46',NULL),(1161,31,'Card Added','Added New Card','System','2026-01-23 06:00:41',NULL),(1162,22,'Card Added','Added Semester 1','System','2026-01-23 06:02:43',NULL),(1163,22,'Card Added','Added Semester 2','System','2026-01-23 06:02:49',NULL),(1164,22,'Card Added','Added Semester 3','System','2026-01-23 06:02:54',NULL),(1165,22,'Card Added','Added Semester 4','System','2026-01-23 06:02:58',NULL),(1166,22,'Card Added','Added Semester 5','System','2026-01-23 06:03:04',NULL),(1167,22,'Card Added','Added Semester 6','System','2026-01-23 06:03:09',NULL),(1168,22,'Card Added','Added Semester 7','System','2026-01-23 06:03:20',NULL),(1169,22,'Card Added','Added Semester 8','System','2026-01-23 06:04:28',NULL),(1170,22,'Card Added','Added Vertical 1','System','2026-01-23 06:05:48',NULL),(1171,22,'Card Added','Added Vertical 2','System','2026-01-23 06:05:55',NULL),(1172,22,'Card Added','Added Vertical 3','System','2026-01-23 06:06:02',NULL),(1173,22,'Card Added','Added Vertical 4','System','2026-01-23 06:06:12',NULL),(1174,22,'Card Added','Added Vertical 5','System','2026-01-23 06:06:22',NULL),(1175,22,'Card Added','Added Vertical 6','System','2026-01-23 06:06:33',NULL),(1176,22,'Card Added','Added Vertical 7','System','2026-01-23 06:06:46',NULL),(1177,22,'Card Added','Added New Card','System','2026-01-23 06:07:09',NULL),(1178,22,'Card Added','Added New Card','System','2026-01-23 06:07:16',NULL),(1179,22,'Honour Card Added','Added Honour Card: DATA SCIENCE ','System','2026-01-23 06:07:55',NULL),(1180,22,'Honour Card Added','Added Honour Card: DATA SCIENCE ','System','2026-01-23 06:08:16',NULL),(1181,20,'Course Removed','Removed course COMPREHENSIVE WORK from Semester 104','System','2026-01-23 08:12:35',NULL),(1182,20,'Card Added','Added Vertical 1','System','2026-01-23 08:14:53',NULL),(1183,20,'Course Added','Added course 22CE001 - REPAIR AND REHABILITATION OF STRUCTURES  to Semester 257','System','2026-01-23 08:15:52',NULL),(1184,20,'Course Added','Added course 22CE002 - PRESTRESSED CONCRETE STRUCTURES to Semester 257','System','2026-01-23 08:16:38',NULL),(1185,20,'Course Added','Added course 22CE003 - STRUCTURAL DYNAMICS AND EARTHQUAKE ENGINEERING to Semester 257','System','2026-01-23 08:17:00',NULL),(1186,20,'Course Added','Added course 22CE004 - BRIDGE ENGINEERING to Semester 257','System','2026-01-23 08:17:30',NULL),(1187,20,'Course Added','Added course 22CE005 - TALL STRUCTURES to Semester 257','System','2026-01-23 08:17:53',NULL),(1188,20,'Course Added','Added course 22CE006 - STRUCTURAL HEALTH MONITORING to Semester 257','System','2026-01-23 08:18:18',NULL),(1189,20,'Card Added','Added Vertical 2','System','2026-01-23 08:18:36',NULL),(1190,20,'Course Added','Added course 22CE007  - DESIGN OF TIMBER AND MASONRY ELEMENTS  to Semester 258','System','2026-01-23 08:19:08',NULL),(1191,20,'Course Added','Added course 22CE008 - ADVANCED RC DESIGN to Semester 258','System','2026-01-23 08:19:35',NULL),(1192,20,'Course Added','Added course 22CE009 - ADVANCED STEEL DESIGN to Semester 258','System','2026-01-23 08:19:56',NULL),(1193,20,'Course Added','Added course 22CE010 - INDUSTRIAL STRUCTURES to Semester 258','System','2026-01-23 08:20:18',NULL),(1194,20,'Course Added','Added course 22CE011 - FINITE ELEMENT ANALYSIS to Semester 258','System','2026-01-23 08:20:38',NULL),(1195,20,'Course Added','Added course 22CE012 - STEEL CONCRETE COMPOSITE STRUCTURES  to Semester 258','System','2026-01-23 08:20:58',NULL),(1196,20,'Card Added','Added Vertical 3','System','2026-01-23 08:21:15',NULL),(1197,20,'Course Added','Added course 22CE013 - BUILDING SERVICES to Semester 259','System','2026-01-23 08:21:46',NULL),(1198,20,'Course Added','Added course 22CE014 - CONCEPTUAL PLANNING AND BYE LAWS to Semester 259','System','2026-01-23 08:22:05',NULL),(1199,20,'Course Added','Added course 22CE015 - COST EFFECTIVE CONSTRUCTION AND GREEN BUILDING to Semester 259','System','2026-01-23 08:22:25',NULL),(1200,20,'Course Added','Added course 22CE016 - PREFABRICATED STRUCTURES AND PREENGINEEREDBUILDING to Semester 259','System','2026-01-23 08:22:47',NULL),(1201,20,'Course Added','Added course 22CE017 - ENERGY EFFICIENT BUILDINGS to Semester 259','System','2026-01-23 08:23:09',NULL),(1202,20,'Course Added','Added course 22CE018 - CONSTRUCTION MANAGEMENT AND SAFETY  to Semester 259','System','2026-01-23 08:23:39',NULL),(1203,20,'Card Added','Added Vertical 4','System','2026-01-23 08:23:57',NULL),(1204,20,'Course Added','Added course 22CE019 - GROUND IMPROVEMENT TECHNIQUES to Semester 260','System','2026-01-23 08:24:23',NULL),(1205,20,'Course Added','Added course 22CE020  - GEOENVIRONMENTAL ENGINEERING to Semester 260','System','2026-01-23 08:24:49',NULL),(1206,20,'Course Added','Added course 22CE021 - INTRODUCTION TO GEOTECHNICAL EARTHQUAKE ENGINEERING to Semester 260','System','2026-01-23 08:25:24',NULL),(1207,20,'Course Added','Added course 22CE022 - REINFORCED SOIL STRUCTURES to Semester 260','System','2026-01-23 08:25:46',NULL),(1208,20,'Course Added','Added course 22CE023 - ROCK MECHANICS AND APPLICATIONS to Semester 260','System','2026-01-23 08:26:08',NULL),(1209,20,'Course Added','Added course 22CE024 - EARTH RETAINING STRUCTURES to Semester 260','System','2026-01-23 08:26:34',NULL),(1210,20,'Course Updated','Updated course: 22CE022 - REINFORCED SOIL STRUCTURES','System','2026-01-23 08:26:53','{\"credit\": {\"new\": 3, \"old\": 2}}'),(1211,20,'Course Updated','Updated course: 22CE011 - FINITE ELEMENT ANALYSIS','System','2026-01-23 08:27:21','{\"credit\": {\"new\": 3, \"old\": 2}}'),(1212,20,'Course Updated','Updated course: 22CE016 - PREFABRICATED STRUCTURES AND PREENGINEEREDBUILDING','System','2026-01-23 08:27:55','{\"credit\": {\"new\": 3, \"old\": 2}}'),(1213,20,'Course Updated','Updated course: 22CE014 - CONCEPTUAL PLANNING AND BYE LAWS','System','2026-01-23 08:27:59','{\"credit\": {\"new\": 3, \"old\": 2}}'),(1214,20,'Card Added','Added Vertical 5','System','2026-01-23 08:29:05',NULL),(1215,20,'Course Added','Added course 22CE025 - URBAN TRANSPORTATION PLANNING AND SYSTEMS to Semester 261','System','2026-01-23 08:29:30',NULL),(1216,20,'Course Added','Added course 22CE026 - MASS TRANSPORTATION SYSTEMS to Semester 261','System','2026-01-23 08:29:54',NULL),(1217,16,'Mission[0] Added','Added Mission item at index 0','System','2026-02-03 03:10:14','{\"Mission[0]\": {\"new\": \"To impart need based education to meet the requirements of the industry and society.\", \"old\": \"\"}}'),(1218,16,'Mission[2] Added','Added Mission item at index 2','System','2026-02-03 03:10:14','{\"Mission[2]\": {\"new\": \"To build technologically competent individuals for industry and entrepreneurialventures by providing infrastructure and human resources.\", \"old\": \"\"}}'),(1219,16,'Mission[1] Added','Added Mission item at index 1','System','2026-02-03 03:10:14','{\"Mission[1]\": {\"new\": \"To equip students for emerging technologies with global standards and ethics that aid insocietal sustainability.\", \"old\": \"\"}}'),(1220,16,'Course Added','Added course 22AI035 - BUSINESS ANALYTICS to Semester 180','System','2026-02-03 05:52:08',NULL),(1221,16,'Course Added','Added course 22AI036  - DIGITAL MARKETING AND MANAGEMENT to Semester 180','System','2026-02-03 05:54:01',NULL),(1222,16,'Course Added','Added course 22AI037 - TIME SERIES ANALYSIS AND FORECASTING to Semester 181','System','2026-02-03 05:55:25',NULL),(1223,16,'Course Added','Added course 22AI038  - HUMAN COMPUTER INTERACTION to Semester 181','System','2026-02-03 05:55:56',NULL),(1224,16,'Course Added','Added course 22AI039  - PATTERN RECOGNITION  to Semester 181','System','2026-02-03 05:56:19',NULL),(1225,16,'Course Added','Added course 22AI040  - ETHICS AND AI to Semester 181','System','2026-02-03 05:56:47',NULL),(1226,16,'Course Added','Added course 22AI041 - MULTIMEDIA AND ANIMATION to Semester 181','System','2026-02-03 05:57:23',NULL),(1227,16,'Course Added','Added course 22AI042  - SOFTWARE PROJECT MANAGEMENT to Semester 181','System','2026-02-03 05:57:54',NULL),(1228,16,'Course Added','Added course 22AI043  - PYTHON FOR DATA SCIENCE  to Semester 182','System','2026-02-03 05:58:36',NULL),(1229,16,'Course Added','Added course 22AI044  - EXPLORATORY DATA ANALYSIS to Semester 182','System','2026-02-03 05:59:10',NULL),(1230,16,'Course Added','Added course 22AI045 - FUNDAMENTALS OF MACHINE LEARNING to Semester 182','System','2026-02-03 05:59:33',NULL),(1231,16,'Course Added','Added course 22AI046 - DEEP LEARNING ESSENTIALS to Semester 182','System','2026-02-03 05:59:52',NULL),(1232,16,'Course Added','Added course 22AI047  - TEXT AND SPEECH ANALYSIS to Semester 182','System','2026-02-03 06:00:15',NULL),(1233,16,'Course Added','Added course 22AI048  - COMPUTER VISION AND IMAGE PROCESSING to Semester 182','System','2026-02-03 06:00:37',NULL),(1234,16,'Course Added','Added course 22AI049  - ETHICS IN DATA SCIENCE  to Semester 182','System','2026-02-03 06:00:57',NULL),(1235,16,'Course Added','Added course 22OAI01 - FUNDAMENTALS OF DATA SCIENCE to Semester 186','System','2026-02-03 06:02:30',NULL),(1236,16,'Course Removed','Removed course FUNDAMENTALS OF DATA SCIENCE from Semester 186','System','2026-02-03 06:12:14',NULL),(1237,16,'Course Added','Added course 22AI0XA - MACHINE LEARNING IN INTERNET OF ROBOTIC THINGS (IoRT) to Semester 187','System','2026-02-03 06:36:51',NULL),(1238,16,'Course Added','Added course 22AI0XB - AUGMENTED REALITY to Semester 187','System','2026-02-03 06:37:15',NULL),(1239,16,'Course Added','Added course 22AI0XC - STATISTICAL MODELLING IN R PROGRAMMING  to Semester 187','System','2026-02-03 06:37:34',NULL),(1240,16,'Course Added','Added course 22AI0XD  - NODE.JS to Semester 187','System','2026-02-03 06:37:54',NULL),(1241,16,'Course Added','Added course 22AI0XE  - MLOps ESSENTIALS to Semester 187','System','2026-02-03 06:38:12',NULL),(1242,16,'Course Added','Added course 22AI0XF - APACHE KAFKA to Semester 187','System','2026-02-03 06:38:28',NULL),(1243,16,'Course Added','Added course 22AI0XG  - FULL STACK DEVELOPMENT USING ADAPTIVE AI  to Semester 187','System','2026-02-03 06:38:46',NULL),(1244,16,'Course Added','Added course 22AI0XH - DEMYSTIFYING DIALOGUECRAFT AI AND APPLICATIONS to Semester 187','System','2026-02-03 06:39:04',NULL),(1245,16,'Course Added','Added course 22AI0XI  - AI BASED DEEPFAKE IMAGE CREATION  to Semester 187','System','2026-02-03 06:39:23',NULL),(1246,16,'Course Added','Added course NA - PROFESSIONAL ELECTIVE I  to Semester 109','System','2026-02-03 06:47:43',NULL),(1247,16,'Curriculum Updated','Updated curriculum details','System','2026-02-03 08:16:59','{\"max_credits\": {\"new\": 1, \"old\": 165}}'),(1248,16,'Curriculum Updated','Updated curriculum details','System','2026-02-03 08:17:05','{\"max_credits\": {\"new\": 165, \"old\": 1}}'),(1249,16,'Course Added','Added course NA - PROFESSIONAL ELECTIVE II to Semester 120','System','2026-02-03 09:48:55',NULL),(1250,16,'Course Added','Added course NA - OPEN ELECTIVE to Semester 120','System','2026-02-03 09:49:27',NULL),(1251,16,'Course Added','Added course NA - PROFESSIONAL ELECTIVE III to Semester 131','System','2026-02-03 09:49:57',NULL),(1252,16,'Course Added','Added course NA - PROFESSIONAL ELECTIVE IV  to Semester 131','System','2026-02-03 09:50:14',NULL),(1253,16,'Course Added','Added course NA - PROFESSIONAL ELECTIVE V to Semester 131','System','2026-02-03 09:50:34',NULL),(1254,16,'Course Added','Added course NA - PROFESSIONAL ELECTIVE VI  to Semester 135','System','2026-02-03 09:51:21',NULL),(1255,16,'Course Added','Added course NA - PROFESSIONAL ELECTIVE VII to Semester 135','System','2026-02-03 09:51:47',NULL),(1256,16,'Course Added','Added course NA - PROFESSIONAL ELECTIVE VII to Semester 135','System','2026-02-03 09:52:19',NULL),(1257,16,'Course Added','Added course NA - PROFESSIONAL ELECTIVE IX  to Semester 135','System','2026-02-03 09:52:40',NULL),(1258,16,'Course Added','Added course 22OCE01 - ENERGY CONSERVATION AND MANAGEMENT to Semester 186','System','2026-02-03 09:53:31',NULL),(1259,16,'Course Added','Added course 22OCE02 - COST MANAGEMENT OF ENGINEERING PROJECTS to Semester 186','System','2026-02-03 09:54:05',NULL),(1260,16,'Course Added','Added course 22OEC02 - MICROCONTROLLER PROGRAMMING  to Semester 186','System','2026-02-03 09:54:31',NULL),(1261,16,'Course Added','Added course 22OEC03  - PRINCIPLES OF COMMUNICATION SYSTEMS to Semester 186','System','2026-02-03 09:55:07',NULL),(1262,16,'Course Added','Added course 22OEI01 - PROGRAMMABLE LOGIC CONTROLLER to Semester 186','System','2026-02-03 09:55:27',NULL),(1263,16,'Course Added','Added course 22OEI02 - SENSOR TECHNOLOGY to Semester 186','System','2026-02-03 09:55:45',NULL),(1264,16,'Course Added','Added course 22OEI03 - FUNDAMENTALS OF VIRTUAL INSTRUMENTATION to Semester 186','System','2026-02-03 09:56:09',NULL),(1265,16,'Course Added','Added course 22OEI04 - OPTOELECTRONICS AND LASER INSTRUMENTATION to Semester 186','System','2026-02-03 09:56:29',NULL),(1266,16,'Course Added','Added course 22OME0 - DIGITAL MANUFACTURING to Semester 186','System','2026-02-03 09:57:01',NULL),(1267,16,'Course Added','Added course 22OME02 - INDUSTRIAL PROCESS ENGINEERING to Semester 186','System','2026-02-03 09:57:19',NULL),(1268,16,'Course Added','Added course 22OME03 - MAINTENANCE ENGINEERING to Semester 186','System','2026-02-03 09:57:43',NULL),(1269,16,'Course Added','Added course 22OME04  - SAFETY ENGINEERING  to Semester 186','System','2026-02-03 09:58:07',NULL),(1270,16,'Course Added','Added course 22OBT01 - BIOFUELS to Semester 186','System','2026-02-03 09:58:27',NULL),(1271,16,'Course Added','Added course 22OFD01 - TRADITIONAL FOODS to Semester 186','System','2026-02-03 09:58:47',NULL),(1272,16,'Course Added','Added course 22OFD02  - FOOD LAWS AND REGULATIONS to Semester 186','System','2026-02-03 09:59:10',NULL),(1273,16,'Course Added','Added course 22OFD03 - POST HARVEST TECHNOLOGY OF FRUITS AND VEGETABLES to Semester 186','System','2026-02-03 09:59:53',NULL),(1274,16,'Course Added','Added course 22OFD04 - CEREAL, PULSES AND OILSEED TECHNOLOGY  to Semester 186','System','2026-02-03 10:00:09',NULL),(1275,16,'Course Added','Added course 22OFT01 - FASHION CRAFTSMANSHIP to Semester 186','System','2026-02-03 10:00:29',NULL),(1276,16,'Course Added','Added course 22OFT02  - INTERIOR DESIGN IN FASHION  to Semester 186','System','2026-02-03 10:01:00',NULL),(1277,16,'Course Added','Added course 22OFT03  - SURFACE ORNAMENTATION to Semester 186','System','2026-02-03 10:01:16',NULL),(1278,16,'Course Added','Added course 22OPH02 - SEMICONDUCTOR PHYSICS AND DEVICES  to Semester 186','System','2026-02-03 10:01:33',NULL),(1279,16,'Course Added','Added course 22OPH03  - APPLIED LASER SCIENCE to Semester 186','System','2026-02-03 10:01:56',NULL),(1280,16,'Course Added','Added course 22OPH04  - BIOPHOTONICS to Semester 186','System','2026-02-03 10:02:12',NULL),(1281,16,'Course Added','Added course 22OPH05  - PHYSICS OF SOFT MATTER to Semester 186','System','2026-02-03 10:02:31',NULL),(1282,16,'Course Added','Added course 22OCH01 - CORROSION SCIENCE AND ENGINEERING to Semester 186','System','2026-02-03 10:02:48',NULL),(1283,16,'Course Added','Added course 22OCH02 - POLYMER SCIENCE  to Semester 186','System','2026-02-03 10:03:06',NULL),(1284,16,'Course Added','Added course 22OCH03  - ENERGY STORING DEVICES to Semester 186','System','2026-02-03 10:03:24',NULL),(1285,16,'Course Added','Added course 22OGE01 - PRINCIPLES OF MANAGEMENT  to Semester 186','System','2026-02-03 10:03:39',NULL),(1286,16,'Course Added','Added course 22OGE02  - ENTREPRENEURSHIP DEVELOPMENT I to Semester 186','System','2026-02-03 10:03:54',NULL),(1287,16,'Course Added','Added course 22OGE03 - ENTREPRENEURSHIP DEVELOPMENT II to Semester 186','System','2026-02-03 10:04:11',NULL),(1288,16,'Course Added','Added course 22OGE04 - NATION BUILDING, LEADERSHIP AND SOCIAL RESPONSIBILITY to Semester 186','System','2026-02-03 10:04:25',NULL),(1289,16,'Course Added','Added course 22OBM01 - OCCUPATIONAL SAFETY AND HEALTH IN PUBLIC HEALTH EMERGENCIES to Semester 186','System','2026-02-03 10:04:45',NULL),(1290,16,'Course Added','Added course 22OBM02 - AMBULANCE AND EMERGENCY MEDICAL SERVICE MANAGEMENT to Semester 186','System','2026-02-03 10:05:04',NULL),(1291,16,'Course Added','Added course 22OBM03 - HOSPITAL AUTOMATION  to Semester 186','System','2026-02-03 10:05:20',NULL),(1292,16,'Course Added','Added course 22OAG01 - RAIN WATER HARVESTING TECHNIQUES to Semester 186','System','2026-02-03 10:05:37',NULL),(1293,16,'Course Added','Added course 22OEE01  - VALUE ENGINEERING to Semester 186','System','2026-02-03 10:05:58',NULL),(1294,16,'Course Added','Added course 22OEE02  - ELECTRICAL SAFETY to Semester 186','System','2026-02-03 10:06:15',NULL),(1295,16,'Course Added','Added course 22OCB01 - INTERNATIONAL BUSINESS MANAGEMENT to Semester 186','System','2026-02-03 10:06:30',NULL),(1296,31,'PO[0] Added','Added PO item at index 0','System','2026-02-03 10:10:50','{\"PO[0]\": {\"new\": \"Engineering Knowledge: Apply knowledge of mathematics, natural science, computing, engineering fundamentals and an engineering specialization to develop to the solution of complex engineering problems.\", \"old\": \"\"}}'),(1297,31,'PO[0] Deleted','Deleted PO item at index 0','System','2026-02-03 10:11:00','{\"PO[0]\": {\"new\": \"\", \"old\": \"Engineering Knowledge: Apply knowledge of mathematics, natural science, computing, engineering fundamentals and an engineering specialization to develop to the solution of complex engineering problems.\"}}'),(1298,31,'PO[0] Added','Added PO item at index 0','System','2026-02-03 10:11:19','{\"PO[0]\": {\"new\": \"Engineering Knowledge: Apply knowledge of mathematics, natural science, computing, engineering fundamentals and an engineering specialization to develop to the solution of complex engineering problems.\", \"old\": \"\"}}'),(1299,31,'PEO-PO Mapping Saved','Updated PEO-PO mappings for the curriculum','System','2026-02-03 10:13:57',NULL),(1300,16,'PEO-PO Mapping Saved','Updated PEO-PO mappings for the curriculum','System','2026-02-03 10:14:08',NULL),(1301,16,'PEO-PO Mapping Saved','Updated PEO-PO mappings for the curriculum','System','2026-02-03 10:14:12',NULL),(1302,16,'Course Added','Added course 22OAI01  - FUNDAMENTALS OF DATA SCIENCE to Semester 190','System','2026-02-03 10:20:39',NULL),(1303,16,'Card Added','Added New Card','System','2026-02-03 10:25:24',NULL),(1304,16,'Course Updated','Updated course: NA - OPEN ELECTIVE','System','2026-02-03 10:26:34','{\"credit\": {\"new\": 3, \"old\": 0}}'),(1305,16,'Course Added','Added course 22HS201  - COMMUNICATIVE ENGLISH II to Semester 262','System','2026-02-03 10:32:41',NULL),(1306,16,'PEO-PO & PSO-PO Mapping Saved','Updated PEO-PO and PSO-PO mappings for the curriculum','System','2026-02-05 03:19:08',NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curriculum_mission`
--

LOCK TABLES `curriculum_mission` WRITE;
/*!40000 ALTER TABLE `curriculum_mission` DISABLE KEYS */;
INSERT INTO `curriculum_mission` VALUES (42,20,'To establish a unique learning environment and to enable the students to face the challenges in Artificial Intelligence and Data Science.',0,'UNIQUE',NULL,1),(43,20,'To critique the role of information and analytics for a professional career, research activities and consultancy.',1,'UNIQUE',NULL,1),(44,20,'To produce competent engineers with professional ethics and life skills.',2,'UNIQUE',NULL,1),(45,21,'To develop professionals skilled in the field of Artificial Intelligence and Machine Learning.',0,'UNIQUE',NULL,1),(46,21,'To impart quality and value based education and contribute towards the innovation of computing, expert systems, AI, ML to solve complex problems in research and society.',1,'UNIQUE',NULL,1),(47,18,'To focus on healthcare engineering that includes the study and understanding of biological systems.',0,'UNIQUE',NULL,1),(48,18,'To emphasize quantitative analysis and directly tying concepts with healthcare and diagnostics.',1,'UNIQUE',NULL,1),(49,18,'To encourage entrepreneurship in Biomedical Engineering fostering innovations in healthcare.',2,'UNIQUE',NULL,1),(50,18,'To inculcate interdisciplinary work and focus on research and development in Biomedical Engineering.',3,'UNIQUE',NULL,1),(54,20,'To educate the students to face the challenges pertaining to Civil Engineering by maintaining continuous sprit on creativity, innovation, safety and ethics.',0,'UNIQUE',NULL,1),(55,20,'To train students through periodical in-plant training and industrial visits.',1,'UNIQUE',NULL,1),(56,20,'To motivate students to pursue higher education through competitive examinations.',2,'UNIQUE',NULL,1),(57,20,'To create Centre of Excellence in the emerging areas of Civil Engineering.',3,'UNIQUE',NULL,1),(58,20,'To give a broad education to the students on recent areas of development through interactions and camps.',4,'UNIQUE',NULL,1),(59,21,'To provide a state-of-art infrastructure for a professional environment through standard academic practices, co-curricular and extra-curricular activities in-line with National and International paradigms.',0,'UNIQUE',NULL,1),(60,21,'To facilitate a platform for student and faculty members towards qualitative interdisciplinary research for developing sustainable circular bioeconomy.',1,'UNIQUE',NULL,1),(61,21,'To establish collaborations with biotech ventures and research institutes to inculcate professional and leadership qualities for students career advancements and faculty competency enhancement.',2,'UNIQUE',NULL,1),(62,22,'To excel in technology and business, fostering innovation, interdisciplinary collaboration and ethical leadership in preparation for a digital future.',0,'UNIQUE',NULL,1),(63,22,'To provide a stimulating environment that encourages creativity, critical thinking, and problem-solving, empowering students to develop solutions and drive industry advancements.',1,'UNIQUE',NULL,1),(64,22,'To cultivate a culture of innovation, risk-taking, and business acumen, enabling our students to launch successful start-ups or contribute to entrepreneurial endeavors. ',2,'UNIQUE',NULL,1),(65,23,'To adopt the latest industry trends in teaching learning process in order to make students competitive in the job market.',0,'UNIQUE',NULL,1),(66,23,'To build technologically proficient individuals in Computer Science and Design to meet industry and entrepreneurial ventures by providing infrastructure and human resources.',1,'UNIQUE',NULL,1),(67,23,'To Prepare students for full and ethical participation in a diverse society and encourage lifelong learning.',2,'UNIQUE',NULL,1),(68,24,'To impart need based education to meet the requirements of the industry and society.',0,'UNIQUE',NULL,1),(69,24,'To equip students for emerging technologies with global standards and ethics that aid in societal sustainability.',1,'UNIQUE',NULL,1),(70,24,'To build technologically competent individuals for industry and entrepreneurial ventures by providing infrastructure and human resources.',2,'UNIQUE',NULL,1),(71,25,'To build an innovative and problem-solving culture, empowering students to create cutting-edge computer technology solutions.',0,'UNIQUE',NULL,1),(72,25,'To equip students for thriving careers in the technology industry through practical, hands-on learning experiences and industry-relevant skill development.',1,'UNIQUE',NULL,1),(73,25,'To develop socially responsible students driving impactful digital transformations for the betterment of individuals, communities, and the environment.',2,'UNIQUE',NULL,1),(74,26,' To provide a unique environment with facilities to inculcate self-learning and to meet the challenges in the field of electrical, electronics, and allied engineering.',0,'UNIQUE',NULL,1),(75,26,'To enhance the knowledge and skills of students, members of facultyand supporting staff through professional training.',1,'UNIQUE',NULL,1),(76,26,'To strengthen academia and industry collaboration for improving the problem solving, interpersonal and entrepreneur skills.',2,'UNIQUE',NULL,1),(77,27,'To establish a unique learning environment and to enable the students to face the challenges in Electronics and Communication Engineering.',0,'UNIQUE',NULL,1),(78,27,'To provide a framework for professional career, higher education, and research activities. ',1,'UNIQUE',NULL,1),(79,27,'To impart ethical and value-based education by promoting activities addressing the social needs.',2,'UNIQUE',NULL,1),(80,28,'To empower the students with balanced technical education to confront multidisciplinary engineering problems.',0,'UNIQUE',NULL,1),(81,28,'To strengthen the relation between academia and industry for their mutual benefits.',1,'UNIQUE',NULL,1),(82,28,'To update the existing infrastructure along with establishing a new one to encourage research and start-up related activities.',2,'UNIQUE',NULL,1),(83,29,'To pursue impactful research, impart value based education and skill based education to meet the challenging needs of the Fashion industry as well as society.',0,'UNIQUE',NULL,1),(84,29,'To foster students for higher education in fashion designing, merchandising and research related activities.',1,'UNIQUE',NULL,1),(85,29,'To nurture and develop entrepreneurial skills among students for project management and entrepreneurial ventures by providing infra-structure, human resource and enterprise knowledge.',2,'UNIQUE',NULL,1),(86,30,'Produce technically well versed and socially responsive professionals who would take up the national and international positions in government and private Food Processing sectors.',0,'UNIQUE',NULL,1),(87,30,'Develop partnerships with industries and communities to share the knowledge and also to train the Food Technologists.',1,'UNIQUE',NULL,1),(88,30,'Produce Food Technologist who can develop novel technologies for better processing, storage and value addition of agricultural products with the ultimate aimto prevent postharvest losses which in turn helps in increasing the country\'s economy and also ensures the food security of our nation.',2,'UNIQUE',NULL,1),(89,31,'Develop human potential with sound knowledge in theory and practice of Information Science & Engineering.',0,'UNIQUE',NULL,1),(90,31,'Facilitate the development of Industry Institute collaborations and societal outreach programmes.',1,'UNIQUE',NULL,1),(91,31,'Promote research based activities in the emerging areas of technology convergence.',2,'UNIQUE',NULL,1),(92,32,'To impart technical knowledge through innovative teaching, research and consultancy.',0,'UNIQUE',NULL,1),(93,32,'To adapt to the dynamic needs of industries through curriculum update.',1,'UNIQUE',NULL,1),(94,32,'To produce competent engineers with professional ethics and life skills.',2,'UNIQUE',NULL,1),(95,33,'To achieve a dynamic and inclusive learning environment through teaching pedagogies and continuous improvement of teaching and learning process. ',0,'UNIQUE',NULL,1),(96,33,'To enhance the knowledge and skills of students and faculty through research, industry collaboration, and continuous learning. ',1,'UNIQUE',NULL,1),(97,33,'To produce competent and innovative engineers capable of meeting the evolving needs of industry, society, and entrepreneurial development. ',2,'UNIQUE',NULL,1),(98,34,'To provide pedagogical expertise to disseminate technical knowledge.',0,'UNIQUE',NULL,1),(99,34,'To foster continuous learning and research by establishing state of the art facilities.',1,'UNIQUE',NULL,1),(100,34,'To provide exposure to latest technologies through industry-institute interaction.',2,'UNIQUE',NULL,1),(101,34,'To nurture the innovation to develop interdisciplinary projects',3,'UNIQUE',NULL,1),(102,35,'To build and nurture a new generation of textile technologists with the potential to be the future leaders of the textile industry.',0,'UNIQUE',NULL,1),(103,35,'To provide quality education and empower the students and staff with the technical, managerial, entrepreneurial and life-long learning competencies required to attain the vision.',1,'UNIQUE',NULL,1),(104,35,'To impart ethical and value-based education by promoting activities addressing the social needs.',2,'UNIQUE',NULL,1),(105,36,'To impart need based education to meet the requirements of the industry and society.',0,'UNIQUE',NULL,1),(106,36,'To equip students for emerging technologies with global standards and ethics that aid in societal sustainability.',1,'UNIQUE',NULL,1),(107,36,'To build technologically competent individuals for industry and entrepreneurial ventures by providing infrastructure and human resources.',2,'UNIQUE',NULL,1),(108,37,'To continuously improving the teaching and learning process to enable students to meet the global needs. ',0,'UNIQUE',NULL,1),(109,37,'To upgrade the knowledge and skills of students, members of faculty and supporting staff through regular training. ',1,'UNIQUE',NULL,1),(110,37,'To produce the best minds of engineers capable of meeting expectations of Industry, Society and Entrepreneurship development. ',2,'UNIQUE',NULL,1),(111,16,'To impart need based education to meet the requirements of the industry and society.',0,'UNIQUE',NULL,1),(112,16,'To equip students for emerging technologies with global standards and ethics that aid insocietal sustainability.',1,'UNIQUE',NULL,1),(113,16,'To build technologically competent individuals for industry and entrepreneurialventures by providing infrastructure and human resources.',2,'UNIQUE',NULL,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curriculum_peos`
--

LOCK TABLES `curriculum_peos` WRITE;
/*!40000 ALTER TABLE `curriculum_peos` DISABLE KEYS */;
INSERT INTO `curriculum_peos` VALUES (34,15,'Excel in academic/professional career by acquiring knowledge and skill in engineering principles involved in agriculture',0,'UNIQUE',NULL,1),(35,15,'Analyze and improve agricultural operations through farm mechanization, land and water management, post-harvest handling and energy conservation to increase yield and land use efficiency',1,'UNIQUE',NULL,1),(36,15,'Develop professionalism in management, entrepreneurship, continuous learning and follow ethics to serve the society',2,'UNIQUE',NULL,1),(37,16,'Competent engineering professionals to use Artificial Intelligence and Data Science to solve engineering problems.',0,'UNIQUE',NULL,1),(38,16,'Capable of pursuing higher studies and research, with wider opportunities in teaching and innovation.',1,'UNIQUE',NULL,1),(39,16,'Improve communication skills, follow professional ethics and involve in team work in their profession.',2,'UNIQUE',NULL,1),(40,17,'To perform well in their professional career by acquiring enough knowledge in the domain of Artificial Intelligence and Machine Learning.',0,'UNIQUE',NULL,1),(41,17,'To improve communication skills, follow professional ethics and involve in team work in their profession.',1,'UNIQUE',NULL,1),(42,17,'To update with evolving technology and use it for career advancement.',2,'UNIQUE',NULL,1),(43,18,'Engage in professional development or post-graduate education for continuing self-development in biomedical engineering or other related fields.',0,'UNIQUE',NULL,1),(44,18,'Pursue a wide range of career options, including those in industry, academia, and medicine.',1,'UNIQUE',NULL,1),(45,18,'Practice professionally as biomedical engineers and/or biomedical scientists in the, field of health care sector for the wellbeing of humankind.',2,'UNIQUE',NULL,1),(46,18,'Build careers addressing human health problems within a multidisciplinary, global industry.',3,'UNIQUE',NULL,1),(50,20,'To demonstrate technical competency in their chosen career path of academics, research, public service or entrepreneurial start-up.',0,'UNIQUE',NULL,1),(51,20,'To execute planning, design and analysis of Civil Engineering systems catering to the societal and industrial needs with academic or research perspective adapting to the sustainable development goals.',1,'UNIQUE',NULL,1),(52,20,'To exhibit leadership qualities in their intellectual pursuit upholding professionalism, ethics and sustainability.',2,'UNIQUE',NULL,1),(53,21,'To maintain high standards of teaching through innovative pedagogy for enabling students to be lifelong learners and globally competent professionals.',0,'UNIQUE',NULL,1),(54,21,'To foster creativity through innovation based research activities for upliftment of self and society promoting socio-economic growth.',1,'UNIQUE',NULL,1),(55,21,'To inculcate professional ethics and skills amongst the graduates and empowering them to have career advancement through placements, higher studies, and entrepreneurship.',2,'UNIQUE',NULL,1),(56,22,' To perform well in their professional career by acquiring enough knowledge, technical competency in the domain of Computer Science and Business Systems to concord the industry engrossment. ',0,'UNIQUE',NULL,1),(57,22,'To improve communication skills, business management skills, follow professional ethics and involve in team work in their profession. ',1,'UNIQUE',NULL,1),(58,22,'To update themselves in business level innovation with societal consideration.',2,'UNIQUE',NULL,1),(59,23,'To perform well in their professional career by acquiring enough knowledge in the domain of Computer Science and Design.',0,'UNIQUE',NULL,1),(60,23,'To improve communication skills, follow professional ethics and involve in team work in their profession.',1,'UNIQUE',NULL,1),(61,23,'To update with evolving technology and use it for career advancement.',2,'UNIQUE',NULL,1),(62,24,'Graduates will apply computer science and engineering principles and practices to solve real world problems with their technical competence.',0,'UNIQUE',NULL,1),(63,24,' Graduates will have the domain knowledge to pursue higher education and apply cutting edge research to develop solutions for socially relevant problems.',1,'UNIQUE',NULL,1),(64,24,'Graduates will communicate effectively and practice their profession with ethics,integrity, leadership, teamwork, and social responsibility, and pursue lifelong learning throughout their careers.',2,'UNIQUE',NULL,1),(65,25,'Engineering professionals, innovators, or entrepreneurs engaged in technology development, technology deployment, or engineering system implementation in industry.',0,'UNIQUE',NULL,1),(66,25,'Capable of interacting with their peers in other disciplines in industry and society and contribute to the economic growth of the country.',1,'UNIQUE',NULL,1),(67,25,'Successful in pursuing higher studies in engineering or management and pursue career paths in teaching or research.',2,'UNIQUE',NULL,1),(68,26,'Apply, analyze, design and create products and provide solutions in the field of Electrical and Electronics Engineering.',0,'UNIQUE',NULL,1),(69,26,'Involve in multidisciplinary teams and apply the knowledge and skills of Electrical and Electronics Engineering to create sustainable solutions for global, environmental and communal needs in an ethical way.',1,'UNIQUE',NULL,1),(70,26,'Engage in lifelong learning to work in core domain / software / pursue higher studies /research / entrepreneur.',2,'UNIQUE',NULL,1),(71,27,'Design and develop electronic circuits and systems, based on the existing as well as emerging technologies. ',0,'UNIQUE',NULL,1),(72,27,'Pursue higher education, research, and continue to learn in their profession.',1,'UNIQUE',NULL,1),(73,27,'Become a successful professional engineer in Electronics/Communication/allied fields.',2,'UNIQUE',NULL,1),(74,28,'Perform effectively in interdisciplinary fields related to Instrumentation engineering, including associated industries, software firms, and academic institutions.',0,'UNIQUE',NULL,1),(75,28,'Pursue higher studies and research at prestigious institutions in India or abroad.',1,'UNIQUE',NULL,1),(76,28,'Exhibit social responsibility, teamwork, leadership, and entrepreneurial skills in their professional endeavors.',2,'UNIQUE',NULL,1),(77,29,'Graduates will be having successful careers in industry, academics and research in the fields of apparel technology and fashion design with a fundamental knowledge and skill in basics of science, technology, arts, mathematics, computers and apparel manufacturing processes',0,'UNIQUE',NULL,1),(78,29,'Graduates will be globally competent in fashion industry project management and entrepreneurship through effective communication, design and technology skills and also be able to appraise social and environmental issues.',1,'UNIQUE',NULL,1),(79,29,'Graduates will demonstrate spirit of ethics, leadership and engage in professional practice throughout their career.',2,'UNIQUE',NULL,1),(80,30,'Acquire theoretical and practical knowledge of food engineering and technology to become a qualified food process engineer.',0,'UNIQUE',NULL,1),(81,30,'Apply the skills of food technology in research, industry and entrepreneurship to ensure food safety and nutrition security.',1,'UNIQUE',NULL,1),(82,30,'Improve the standard of living and economy of the nation through convenience and novel food products with professional ethics.',2,'UNIQUE',NULL,1),(83,31,'Competent professional with the knowledge of Information Science and Engineering by designing innovative solutions to real life problems that are technically sound, economically viable and socially acceptable.',0,'UNIQUE',NULL,1),(84,31,'Capable of pursuing higher studies, research activities and entrepreneurial skills by adapting to new technologies and constantly upgrade their skills with an attitude towards lifelong learning.',1,'UNIQUE',NULL,1),(85,31,'Proficient team leaders, effective communicators and capable of working in multidisciplinary projects and diverse professional activities following ethical values.',2,'UNIQUE',NULL,1),(86,32,'Apply technical, analytical, and creative thinking skills to understand and meet the needs of industry, academia, and research.',0,'UNIQUE',NULL,1),(87,32,'Excel in leadership, team spirit, and entrepreneurship skills to provide effective, user-friendly, and innovative solutions to real-world problems.',1,'UNIQUE',NULL,1),(88,32,'Practice work ethics with social and environmental responsibility to address the complex engineering and societally relevant problems',2,'UNIQUE',NULL,1),(89,32,'Pursue lifelong learning for professional development, use cutting-edge technologies, and involve in applied research to design optimal solutions.',3,'UNIQUE',NULL,1),(90,33,'Apply foundational knowledge and skills to effectively solve real-world problems, showcasing advanced problem-solving abilities, strong communication, and the ability to continuously upgrade expertise in response to emerging technologies ',0,'UNIQUE',NULL,1),(91,33,'Innovate and implement engineering solutions through research and development to fulfill industrial and societal requirements ',1,'UNIQUE',NULL,1),(92,33,'Assist in developing innovative thinking, engaging in entrepreneurial ventures or pursuing higher studies, upholding ethical practices, and contributing to a sustainable and healthy society ',2,'UNIQUE',NULL,1),(93,34,'To impart adequate technical knowledge and skills in the area of mechanical, electrical and electronic systems to solve problems pertaining to mechatronics',0,'UNIQUE',NULL,1),(94,34,'To adapt multidisciplinary approach for product design, development and manufacturing using contemporary tools.',1,'UNIQUE',NULL,1),(95,34,'To exhibit research aptitude and life-long learning in the working environment with professional and ethical responsibility.',2,'UNIQUE',NULL,1),(96,35,'Analyse the properties of textile materials to enable the selection of materials for different kinds of textile and apparel manufacturing systems.',0,'UNIQUE',NULL,1),(97,35,'Compare various technological systems of manufacturing the quality textile materials and apply them for the development of new processes and products.',1,'UNIQUE',NULL,1),(98,35,'Demonstrate the management responsibilities related to issues namely social, ethical and environmental and personal aspects of textile industry.',2,'UNIQUE',NULL,1),(99,36,'Analyse, design, and develop creative products and solutions for real-world problems.',0,'UNIQUE',NULL,1),(100,36,'Critically analyse the current literature in a field of study and ethically develop innovative and research-based methodologies to fill the gaps.',1,'UNIQUE',NULL,1),(101,36,'Participate in lifelong multidisciplinary learning as skilled computer engineers, including working in teams, investigating and implementing research problems, and presenting technical reports.',2,'UNIQUE',NULL,1),(102,37,'Possess a mastery of health safety and environmental knowledge and safety management skills to reach higher levels in their profession. ',0,'UNIQUE',NULL,1),(103,37,'Competent safety engineer rendering professional expertise to the industrial and societal needs at national and global level subject to legal requirements. ',1,'UNIQUE',NULL,1),(104,37,'Effectively communicate information on health, safety, and environment, facilitating collaboration with experts across various disciplines to create and execute safe methodology in complex engineering activities. ',2,'UNIQUE',NULL,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=204 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curriculum_pos`
--

LOCK TABLES `curriculum_pos` WRITE;
/*!40000 ALTER TABLE `curriculum_pos` DISABLE KEYS */;
INSERT INTO `curriculum_pos` VALUES (45,15,'Apply the knowledge of mathematics, science, engineering fundamentals, and an engineering specialization to the solution of complex engineering problems.',0,'UNIQUE',NULL,1),(46,15,'Identify, formulate, review research literature, and analyze complex engineering problems reaching substantiated conclusions using first principles of mathematics, natural sciences, and engineering sciences.',1,'UNIQUE',NULL,1),(47,15,'Design solutions for complex engineering problems and design system components or processes that meet the specified needs with appropriate consideration for the public health and safety, and the cultural, societal, and environmental considerations.',2,'UNIQUE',NULL,1),(48,15,'Use research-based knowledge and research methods including design of experiments, analysis and interpretation of data, and synthesis of the information to provide valid conclusions.',3,'UNIQUE',NULL,1),(49,15,'Create, select, and apply appropriate techniques, resources, and modern engineering and IT tools including prediction and modeling to complex engineering activities with an understanding of the limitations.',4,'UNIQUE',NULL,1),(50,15,'Apply reasoning informed by the contextual knowledge to assess societal, health, safety, legal and cultural issues and the consequent responsibilities relevant to the professional engineering practice.',5,'UNIQUE',NULL,1),(51,15,'Understand the impact of the professional engineering solutions in societal and environmental contexts, and demonstrate the knowledge of, and need for sustainable development.',6,'UNIQUE',NULL,1),(52,15,'Apply ethical principles and commit to professional ethics and responsibilities and norms of the engineering practice.',7,'UNIQUE',NULL,1),(53,15,'Function effectively as an individual, and as a member or leader in diverse teams, and in multidisciplinary settings.',8,'UNIQUE',NULL,1),(54,15,'Communicate effectively on complex engineering activities with the engineering community and with society at large, such as, being able to comprehend and write effective reports and design documentation, make effective presentations, and give and receive clear instructions.',9,'UNIQUE',NULL,1),(55,15,'Demonstrate knowledge and understanding of the engineering and management principles and apply these to one’s own work, as a member and leader in a team, to manage projects and in multidisciplinary environments.',10,'UNIQUE',NULL,1),(56,15,'Recognize the need for, and have the preparation and ability to engage in independent and life- long learning in the broadest context of technological change.',11,'UNIQUE',NULL,1),(57,16,'Engineering Knowledge: Apply knowledge of mathematics, natural science, computing, engineering fundamentals and an engineering specialization to develop to the solution of complex engineering problems.',0,'UNIQUE',NULL,1),(58,16,'Problem Analysis: Identify, formulate, review research literature and analyze complex engineering problems reaching substantiated conclusions with consideration for sustainable development.',1,'UNIQUE',NULL,1),(59,16,'Design/Development of Solutions: Design creative solutions for complex engineering problems and design/develop systems/components/processes to meet identified needs with consideration for the public health and safety, whole-life cost, net zero carbon, culture, society and environment as required.',2,'UNIQUE',NULL,1),(60,16,'Conduct Investigations of Complex Problems: Conduct investigations of complex engineering problems using research-based knowledge including design of experiments, modelling, analysis & interpretation of data to provide valid conclusions.',3,'UNIQUE',NULL,1),(61,16,'Engineering Tool Usage: Create, select and apply appropriate techniques, resources and modern engineering & IT tools, including prediction and modelling recognizing their limitations to solve complex engineering problems.',4,'UNIQUE',NULL,1),(62,16,'The Engineer and The World: Analyze and evaluate societal and environmental aspects while solving complex engineering problems for its impact on sustainability with reference to economy, health, safety, legal framework, culture and environment.',5,'UNIQUE',NULL,1),(63,16,'Ethics: Apply ethical principles and commit to professional ethics, human values, diversity and inclusion; adhere to national & international laws',6,'UNIQUE',NULL,1),(64,16,'Individual and Collaborative Team work: Function effectively as an individual, and as a member or leader in diverse/multi-disciplinary teams.',7,'UNIQUE',NULL,1),(65,16,'Communication: Communicate effectively and inclusively within the engineering community and society at large, such as being able to comprehend and write effective reports and design documentation, make effective presentations considering cultural, language, and learning differences',8,'UNIQUE',NULL,1),(66,16,'Project Management and Finance: Apply knowledge and understanding of engineering management principles and economic decision-making and apply these to one’s own work, as a member and leader in a team, and to manage projects and in multidisciplinary environments.',9,'UNIQUE',NULL,1),(67,16,'Life-Long Learning: Recognize the need for, and have the preparation and ability for i) independent and life-long learning ii) adaptability to new and emerging technologies and iii) critical thinking in the broadest context of technological change.',10,'UNIQUE',NULL,1),(80,20,'Apply the knowledge of mathematics, science, engineering fundamentals, and an engineering specialization to the solution of complex engineering problems.',0,'UNIQUE',NULL,1),(81,20,'Identify, formulate, review research literature, and analyse complex engineering problems reaching substantiated conclusions using first principles of mathematics, natural sciences, and engineering sciences.',1,'UNIQUE',NULL,1),(82,20,'Design solutionsfor complex engineering problems and design system components or processes that meet the specified needs with appropriate consideration for the public health and safety, andthe cultural, societal, and environmental considerations.',2,'UNIQUE',NULL,1),(83,20,'Use research-based knowledge and research methods including design of experiments, analysis and interpretation of data, and synthesis of the information to provide valid conclusions.',3,'UNIQUE',NULL,1),(84,20,'Create, select, and apply appropriate techniques, resources, and modern engineering and IT tools including prediction and modelling to complex engineering activities with an understanding of the limitations.',4,'UNIQUE',NULL,1),(85,20,'Apply reasoning informed by the contextual knowledge to assess societal, health, safety, legal and cultural issues and the consequent responsibilities relevant to the professional engineering practice.',5,'UNIQUE',NULL,1),(86,20,'Understand the impact of the professional engineering solutions in societal and environmental contexts, and demonstrate the knowledge of, and need for sustainable development.',6,'UNIQUE',NULL,1),(87,20,'Apply ethical principles and commit to professional ethics and responsibilities and norms of the engineering practice.',7,'UNIQUE',NULL,1),(88,20,'Function effectively as an individual, and as a member or leader in diverse teams, and in multidisciplinary settings.',8,'UNIQUE',NULL,1),(89,20,'Communicate effectively on complex engineering activities with the engineering community and with society at large, such as, being able to comprehend and write effective reports and design documentation, make effective presentations, and give and receive clear instructions.',9,'UNIQUE',NULL,1),(90,20,' Demonstrate knowledge and understanding of the engineering and management principles and apply these to one’s own work, as a member and leader in a team, to manage projects and in multidisciplinary environments.',10,'UNIQUE',NULL,1),(91,20,'Recognize the need for, and have the preparation and ability to engage in independent and life-long learning in the broadest context of technological change.',11,'UNIQUE',NULL,1),(92,21,'Engineering Knowledge: Apply the knowledge of mathematics, science, engineering fundamentals, and an engineering specialization to the solution of complex engineering problems.',0,'UNIQUE',NULL,1),(93,21,'Problem Analysis: Identify, formulate, review research literature, and analyse complex engineering problems reaching substantiated conclusions using first principles of mathematics, natural sciences, and engineering sciences.',1,'UNIQUE',NULL,1),(94,21,'Design/ Development of Solutions: Design solutions for complex engineering problems and design system components or processes that meet the specified needs with appropriate consideration for the public health and safety, and the cultural, societal, and environmental considerations.',2,'UNIQUE',NULL,1),(95,21,'Conduct Investigations of Complex Problems: Use research-based knowledge and research methods including design of experiments, analysis and interpretation of data, and synthesis of the information to provide valid conclusions',3,'UNIQUE',NULL,1),(96,21,'Modern Tool Usage: Create, select, and apply appropriate techniques, resources, and modern engineering and IT tools including prediction and modelling to complex engineering activities with an understanding of the limitations.',4,'UNIQUE',NULL,1),(97,21,'The Engineer and Society: Apply reasoning informed by the contextual knowledge to assess societal, health, safety, legal and cultural issues and the consequent responsibilities relevant to the professional engineering practice.',5,'UNIQUE',NULL,1),(98,21,'Environment and Sustainability: Understand the impact of the professional engineering solutions in societal and environmental contexts, and demonstrate the knowledge of, and need for sustainable development.',6,'UNIQUE',NULL,1),(99,21,'Ethics: Apply ethical principles and commit to professional ethics and responsibilities and norms of the engineering practice.',7,'UNIQUE',NULL,1),(100,21,'Individual and Team Work: Function effectively as an individual, and as a member or leader in diverse teams, and in multidisciplinary settings.',8,'UNIQUE',NULL,1),(101,21,'Communication: Communicate effectively on complex engineering activities with the engineering community and with society at large, such as, being able to comprehend and write effective reports and design documentation, make effective presentations, and give and receive clear instructions.',9,'UNIQUE',NULL,1),(102,21,'Project Management and Finance: Demonstrate knowledge and understanding of the engineering and management principles and apply these to one’s own work, as a member and leader in a team, to manage projects and in multidisciplinary environments.',10,'UNIQUE',NULL,1),(103,21,'Life-long Learning: Recognize the need for, and have the preparation and ability to engage in independent and life-long learning in the broadest context of technological change.',11,'UNIQUE',NULL,1),(104,36,'An ability to independently carry out research / investigation and development work to solve practical problems.',0,'UNIQUE',NULL,1),(105,36,'An ability to write and present a substantial technical report/document.',1,'UNIQUE',NULL,1),(106,36,'Students should be able to demonstrate a degree of mastery over the area of Computer Science and Engineering.',2,'UNIQUE',NULL,1),(107,36,'Efficiently design, build and develop system application software for distributed and centralized computing environments in varying domains and platforms.',3,'UNIQUE',NULL,1),(108,36,'Understand the working of current Industry trends, the new hardware architectures, the software components and design solutions for real world problems by Communicating and effectively working with professionals in various engineering fields and pursue research orientation for a lifelong professional development in computer and automation arenas.',4,'UNIQUE',NULL,1),(109,36,'Model a computer based automation system and design algorithms that explore the understanding of the tradeoffs involved in digital transformation.',5,'UNIQUE',NULL,1),(110,37,'Apply knowledge of Engineering Specialization for Hazard identification risk assessment analysis of the cause of the incident and control of occupational health safety and environmental problems ',0,'UNIQUE',NULL,1),(111,37,'Establish, implement, and maintain continuous improvement on industrial safety management to ensure a risk-free working environment. ',1,'UNIQUE',NULL,1),(112,37,'Recognize and evaluate occupational health safety, and legal issues at the workplace to determine appropriate hazard controls following the hierarchy of controls relevant to occupational health and safety practices. ',2,'UNIQUE',NULL,1),(113,37,'Conduct investigation analyzes the root cause and can generate corrective and preventive measures to prevent recurrence of accidents in industries. ',3,'UNIQUE',NULL,1),(114,37,'Create, select, and apply modern Safety and Fire Engineering and IT tools to complex engineering activities with an understanding of the limitations. ',4,'UNIQUE',NULL,1),(115,37,'Effectively communicate the safety matters rules, and regulations to the employee’s society for safe handling of equipment and maintain the safe working environment in industries. ',5,'UNIQUE',NULL,1),(116,32,'Engineering Knowledge: Apply knowledge of mathematics, natural science, computing, engineering fundamentals and an engineering specialization as specified in WK1 to WK4 respectively to develop to the solution of complex engineering problems.',0,'UNIQUE',NULL,1),(117,32,'Problem Analysis: Identify, formulate, review research literature and analyze complex engineering problems reaching substantiated conclusions with consideration for sustainable development. (WK1 to WK4)',1,'UNIQUE',NULL,1),(118,32,'Design/Development of Solutions: Design creative solutions for complex engineering problems and design/develop systems/components/processes to meet identified needs with consideration for the public health and safety, whole-life cost, net zero carbon, culture, society and environment as required. (WK5)',2,'UNIQUE',NULL,1),(119,32,'Conduct Investigations of Complex Problems: Conduct investigations of complex engineering problems using research-based knowledge including design of experiments, modelling, analysis & interpretation of data to provide valid conclusions. (WK8).',3,'UNIQUE',NULL,1),(120,32,'Engineering Tool Usage: Create, select and apply appropriate techniques, resources and modern engineering & IT tools, including prediction and modelling recognizing their limitations to solve complex engineering problems. (WK2 and WK6)',4,'UNIQUE',NULL,1),(121,32,'The Engineer and The World: Analyze and evaluate societal and environmental aspects while solving complex engineering problems for its impact on sustainability with reference to economy, health, safety, legal framework, culture and environment. (WK1, WK5, and WK7).',5,'UNIQUE',NULL,1),(122,32,' Ethics: Apply ethical principles and commit to professional ethics, human values, diversity and inclusion; adhere to national & international laws. (WK9)',6,'UNIQUE',NULL,1),(123,32,'Individual and Collaborative Team work: Function effectively as an individual, and as a member or leader in diverse/multi-disciplinary teams.',7,'UNIQUE',NULL,1),(124,32,'Communication: Communicate effectively and inclusively within the engineering community and society at large, such as being able to comprehend and write effective reports and design documentation, make effective presentations considering cultural, language, and learning differences',8,'UNIQUE',NULL,1),(125,32,'Project Management and Finance: Apply knowledge and understanding of engineering management principles and economic decision-making and apply these to one’s own work, as a member and leader in a team, and to manage projects and in multidisciplinary environments',9,'UNIQUE',NULL,1),(126,32,'Life-Long Learning: Recognize the need for, and have the preparation and ability for i) independent and life-long learning ii) adaptability to new and emerging technologies and iii) critical thinking in the broadest context of technological change. (WK8)',10,'UNIQUE',NULL,1),(127,17,'Engineering Knowledge: Apply the knowledge of mathematics, science, engineering fundamentals, and an engineering specialization to the solution of complex engineering problems.',0,'UNIQUE',NULL,1),(128,17,'Problem Analysis: Identify, formulate, review research literature, and analyse complex engineering problems reaching substantiated conclusions using first principles of mathematics, natural sciences, and engineering sciences.',1,'UNIQUE',NULL,1),(129,17,'Design/Development of Solutions: Design solutions for complex engineering problems and design system components or processes that meet the specified needs with appropriate consideration for the public health and safety, and the cultural, societal, and environmental considerations.',2,'UNIQUE',NULL,1),(130,17,'Conduct Investigations of Complex Problems: Use research-based knowledge and research methods including design of experiments, analysis and interpretation of data, and synthesis of the information to provide valid conclusions.',3,'UNIQUE',NULL,1),(131,17,'Engineering Tool Usage: Create, select and apply appropriate techniques, resources and modern engineering & IT tools, including prediction and modelling recognizing their limitations to solve complex engineering problems.',4,'UNIQUE',NULL,1),(132,17,'The Engineer and The World: Analyze and evaluate societal and environmental aspects while solving complex engineering problems for its impact on sustainability with reference to economy, health, safety, legal framework, culture and environment.',5,'UNIQUE',NULL,1),(133,17,'Ethics: Apply ethical principles and commit to professional ethics, human values, diversity and inclusion; adhere to national & international laws.',6,'UNIQUE',NULL,1),(134,17,'Individual and Collaborative Team work: Function effectively as an individual, and as a member or leader in diverse/multi-disciplinary teams.',7,'UNIQUE',NULL,1),(135,17,'Communication: Communicate effectively and inclusively within the engineering community and society at large, such as being able to comprehend and write effective reports and design documentation, make effective presentations considering cultural, language, and learning differences.',8,'UNIQUE',NULL,1),(136,17,'Project Management and Finance: Apply knowledge and understanding of engineering management principles and economic decision-making and apply these to one’s own work, as a member and leader in a team, and to manage projects and in multidisciplinary environments.',9,'UNIQUE',NULL,1),(137,17,'Life-Long Learning: Recognize the need for, and have the preparation and ability for i) independent and life-long learning ii) adaptability to new and emerging technologies and iii) critical thinking in the broadest context of technological change.',10,'UNIQUE',NULL,1),(138,33,'Engineering Knowledge: Apply knowledge of mathematics, natural science, computing, engineering fundamentals and an engineering specialization as specified in WK1 to WK4 respectively to develop to the solution of complex engineering problems. ',0,'UNIQUE',NULL,1),(139,33,'Problem Analysis: Identify, formulate, review research literature and analyze complex engineering problems reaching substantiated conclusions with consideration for sustainable development. (WK1 to WK4)',1,'UNIQUE',NULL,1),(140,33,'Design/Development of Solutions: Design creative solutions for complex engineering problems and design/develop systems/components/processes to meet identified needs with consideration for the public health and safety, whole-life cost, net zero carbon, culture, society and environment as required. (WK5)',2,'UNIQUE',NULL,1),(141,33,'Conduct Investigations of Complex Problems: Conduct investigations of complex engineering problems using research-based knowledge including design of experiments, modelling, analysis & interpretation of data to provide valid conclusions. (WK8). ',3,'UNIQUE',NULL,1),(142,33,'Engineering Tool Usage: Create, select and apply appropriate techniques, resources and modern engineering & IT tools, including prediction and modelling recognizing their limitations to solve complex engineering problems. (WK2 and WK6) ',4,'UNIQUE',NULL,1),(143,33,'The Engineer and The World: Analyze and evaluate societal and environmental aspects while solving complex engineering problems for its impact on sustainability with reference to economy, health, safety, legal framework, culture and environment. (WK1, WK5, and WK7). ',5,'UNIQUE',NULL,1),(144,33,'Ethics: Apply ethical principles and commit to professional ethics, human values, diversity and inclusion; adhere to national & international laws. (WK9)',6,'UNIQUE',NULL,1),(145,33,'Individual and Collaborative Team work: Function effectively as an individual, and as a member or leader in diverse/multi-disciplinary teams. ',7,'UNIQUE',NULL,1),(146,33,'Communication: Communicate effectively and inclusively within the engineering community and society at large, such as being able to comprehend and write effective reports and design documentation, make effective presentations considering cultural, language, and learning differences ',8,'UNIQUE',NULL,1),(147,33,'Project Management and Finance: Apply knowledge and understanding of engineering management principles and economic decision-making and apply these to one’s own work, as a member and leader in a team, and to manage projects and in multidisciplinary environments. ',9,'UNIQUE',NULL,1),(148,33,'Life-Long Learning: Recognize the need for, and have the preparation and ability for i) independent and life-long learning ii) adaptability to new and emerging technologies and iii) critical thinking in the broadest context of technological change. (WK8) ',10,'UNIQUE',NULL,1),(149,24,'Engineering Knowledge: Apply the knowledge of mathematics, science, engineering fundamentals, and an engineering specialization to the solution of complex engineering problems. ',0,'UNIQUE',NULL,1),(150,24,'Problem Analysis: Identify, formulate, review research literature, and analyse complex engineering problems reaching substantiated conclusions using first principles of  mathematics, natural sciences, and engineering sciences. ',1,'UNIQUE',NULL,1),(151,24,'Design/ Development of Solutions: Design solutions for complex engineering problems and design system components or processes that meet the specified needs with appropriate  consideration for public health and safety, and the cultural, societal, and environmental considerations. ',2,'UNIQUE',NULL,1),(152,24,'Conduct Investigations of Complex Problems: Use research-based knowledge and research  methods including design of experiments, analysis and interpretation of data, and synthesis of the information to provide valid conclusions. ',3,'UNIQUE',NULL,1),(153,24,'Modern Tool Usage: Create, select, and apply appropriate techniques, resources, and modern  engineering and IT tools including prediction and modeling to complex engineering activities with an understanding of the limitations. ',4,'UNIQUE',NULL,1),(154,24,' The Engineer and Society: Apply reasoning informed by the contextual knowledge to assess  societal, health, safety, legal and cultural issues and the consequent responsibilities relevant to the professional engineering practice',5,'UNIQUE',NULL,1),(155,24,'Environment and Sustainability: Understand the impact of the professional engineering  solutions in societal and environmental contexts, and demonstrate the knowledge of, and need for sustainable development.',6,'UNIQUE',NULL,1),(156,24,'Ethics: Apply ethical principles and commit to professional ethics and responsibilities and norms of the engineering practice. ',7,'UNIQUE',NULL,1),(157,24,' Individual and Team Work: Function effectively as an individual, and as a member or leader in diverse teams, and in multidisciplinary settings.',8,'UNIQUE',NULL,1),(158,24,'Communication: Communicate effectively on complex engineering activities with the engineering community and with society at large, such as, being able to comprehend and  write effective reports and design documentation, make effective presentations, and give and  receive clear instructions.',9,'UNIQUE',NULL,1),(159,24,'Project Management and Finance: Demonstrate knowledge and understanding of the engineering and management principles and apply these to one’s own work, as a member  and leader in a team, to manage projects and in multidisciplinary environments.',10,'UNIQUE',NULL,1),(160,24,' Life-long Learning: Recognize the need for, and have the preparation and ability to engage  in independent and life-long learning in the broadest context of technological change. ',11,'UNIQUE',NULL,1),(162,27,'Engineering Knowledge: Apply knowledge of mathematics, natural science, computing, engineering fundamentals and an engineering specialization to develop to the solution of complex engineering problems.',0,'UNIQUE',NULL,1),(163,27,'Problem Analysis: Identify, formulate, review research literature and analyze complex engineering problems reaching substantiated conclusions with consideration for sustainable development.',1,'UNIQUE',NULL,1),(164,27,'Design/ Development of Solutions: Design creative solutions for complex engineering problems and design/develop systems/components/processes to meet identified needs with consideration for the public health and safety, wholelife cost, net zero carbon, culture, society and environment as required.',2,'UNIQUE',NULL,1),(165,27,'Conduct Investigations of Complex Problems: Conduct investigations of complex engineering problems using research-based knowledge including design of experiments, modelling, analysis & interpretation of data to provide valid conclusions.',3,'UNIQUE',NULL,1),(166,27,'Engineering Tool Usage: Create, select and apply appropriate techniques, resources and modern engineering & IT tools, including prediction and modelling recognizing their limitations to solve complex engineering problems.',4,'UNIQUE',NULL,1),(167,27,'The Engineer and The World: Analyze and evaluate societal and environmental aspects while solving complex engineering problems for its impact on sustainability with reference to economy, health, safety, legal framework, culture and environment.',5,'UNIQUE',NULL,1),(168,27,'Ethics: Apply ethical principles and commit to professional ethics, human values, diversity and inclusion; adhere to national & international laws.',6,'UNIQUE',NULL,1),(169,27,'Individual and Collaborative Team Work: Function effectively as an individual, and as a member or leader in diverse/multi-disciplinary teams.',7,'UNIQUE',NULL,1),(170,27,'Communication: Communicate effectively and inclusively within the engineering community and society at large, such as being able to comprehend and write effective reports and design documentation, make effective presentations considering cultural, language, and learning differences.',8,'UNIQUE',NULL,1),(171,27,'Project Management and Finance: Apply knowledge and understanding of engineering management principles and economic decision-making and apply these to one’s own work, as a member and leader in a team, and to manage projects and in multidisciplinary environments.',9,'UNIQUE',NULL,1),(172,27,'Life-long Learning: Recognize the need for, and have the preparation and ability for i) independent and life-long learning ii) adaptability to new and emerging technologies and iii) critical thinking in the broadest context of technological change.',10,'UNIQUE',NULL,1),(176,28,'Engineering Knowledge: Apply the knowledge of mathematics, science, engineering fundamentals, and an engineering specialization to the solution of complex engineering problems.',0,'UNIQUE',NULL,1),(177,28,'Problem Analysis: Identify, formulate, review research literature, and analyse complex engineering problems reaching substantiated conclusions using first principles of mathematics, natural sciences, and engineering sciences.',1,'UNIQUE',NULL,1),(178,28,'Design / Development of Solutions: Design solutions for complex engineering problems and design system components or processes that meet the specified needs with appropriate consideration for the public health and safety, and the cultural, societal, and environmental considerations.',2,'UNIQUE',NULL,1),(179,28,'Conduct Investigations of Complex Problems: Use research-based knowledge and research methods including design of experiments, analysis and interpretation of data, and synthesis of the information to provide valid conclusions.',3,'UNIQUE',NULL,1),(180,28,'Modern Tool Usage: Create, select, and apply appropriate techniques, resources, and modern engineering and IT tools including prediction and modelling to complex engineering activities with an understanding of the limitations.',4,'UNIQUE',NULL,1),(181,28,'The Engineer and Society: Apply reasoning informed by the contextual knowledge to assess societal, health, safety, legal and cultural issues and the consequent responsibilities relevant to the professional engineering practice.',5,'UNIQUE',NULL,1),(182,28,'Environment and Sustainability: Understand the impact of the professional engineering solutions in societal and environmental contexts, and demonstrate the knowledge of, and need for sustainable development.',6,'UNIQUE',NULL,1),(183,28,'Ethics: Apply ethical principles and commit to professional ethics and responsibilities and norms of the engineering practice.',7,'UNIQUE',NULL,1),(184,28,'Individual and Team Work: Function effectively as an individual, and as a member or leader in diverse teams, and in multidisciplinary settings.',8,'UNIQUE',NULL,1),(185,28,'Communication: Communicate effectively on complex engineering activities with the engineering community and with society at large, such as, being able to comprehend and write effective reports and design documentation, make effective presentations, and give and receive clear instructions.',9,'UNIQUE',NULL,1),(186,28,'Project Management and Finance: Demonstrate knowledge and understanding of the engineering and management principles and apply these to one’s own work, as a member and leader in a team, to manage projects and in multidisciplinary environments.',10,'UNIQUE',NULL,1),(187,28,'Life-long Learning: Recognize the need for, and have the preparation and ability to engage in independent and life-long learning in the broadest context of technological change.',11,'UNIQUE',NULL,1),(189,25,'Engineering Knowledge: Apply knowledge of mathematics, natural science, computing, engineering fundamentals and an engineering specialization as specified in WK1 to WK4 respectively to develop to the solution of complex engineering problems.',0,'UNIQUE',NULL,1),(190,25,'Problem Analysis: Identify, formulate, review research literature and analyze complex engineering problems reaching substantiated conclusions with consideration for sustainable development. (WK1 to WK4)',1,'UNIQUE',NULL,1),(191,25,'Design/Development of Solutions: Design creative solutions for complex engineering problems and design/develop systems/components/processes to meet identified needs with consideration for the public health and safety, whole-life cost, net zero carbon, culture, society and environment as required. (WK5)',2,'UNIQUE',NULL,1),(192,25,'Conduct Investigations of Complex Problems: Conduct investigations of complex engineering problems using research-based knowledge including design of experiments, modelling, analysis & interpretation of data to provide valid conclusions. (WK8).',3,'UNIQUE',NULL,1),(193,25,'Engineering Tool Usage: Create, select and apply appropriate techniques, resources and modern engineering & IT tools, including prediction and modelling recognizing their limitations to solve complex engineering problems. (WK2 and WK6)',4,'UNIQUE',NULL,1),(194,25,'The Engineer and The World: Analyze and evaluate societal and environmental aspects while solving complex engineering problems for its impact on sustainability with reference to economy, health, safety, legal framework, culture and environment. (WK1, WK5, and WK7).',5,'UNIQUE',NULL,1),(195,25,'Ethics: Apply ethical principles and commit to professional ethics, human values, diversity and inclusion; adhere to national & international laws. (WK9)',6,'UNIQUE',NULL,1),(196,25,'Individual and Collaborative Team work: Function effectively as an individual, and as a member or leader in diverse/multi-disciplinary teams.',7,'UNIQUE',NULL,1),(197,25,'Communication: Communicate effectively and inclusively within the engineering community and society at large, such as being able to comprehend and write effective reports and design documentation, make effective presentations considering cultural, language, and learning differences',8,'UNIQUE',NULL,1),(198,25,'Project Management and Finance: Apply knowledge and understanding of engineering management principles and economic decision-making and apply these to one’s own work, as a member and leader in a team, and to manage projects and in multidisciplinary environments.',9,'UNIQUE',NULL,1),(199,25,'Life-Long Learning: Recognize the need for, and have the preparation and ability for i) independent and life-long learning ii) adaptability to new and emerging technologies and iii) critical thinking in the broadest context of technological change. (WK8)',10,'UNIQUE',NULL,1),(202,31,'Engineering Knowledge: Apply knowledge of mathematics, natural science, computing, engineering fundamentals and an engineering specialization to develop to the solution of complex engineering problems.',0,'UNIQUE',NULL,0),(203,31,'Engineering Knowledge: Apply knowledge of mathematics, natural science, computing, engineering fundamentals and an engineering specialization to develop to the solution of complex engineering problems.',0,'UNIQUE',NULL,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curriculum_psos`
--

LOCK TABLES `curriculum_psos` WRITE;
/*!40000 ALTER TABLE `curriculum_psos` DISABLE KEYS */;
INSERT INTO `curriculum_psos` VALUES (20,15,'Model, design, and analyze agricultural machinery and implement it to increase productivity, improve land use, and conserve agricultural inputs.',0,'UNIQUE',NULL,1),(21,15,'Improvise technologies to minimize the crop loss from field damage during harvesting, sorting, processing, and packaging.',1,'UNIQUE',NULL,1),(22,15,'Design improved irrigation gadgets and develop technologies for effective utilization of renewable energy in the agriculture sector.',2,'UNIQUE',NULL,1),(23,16,'Ability to design and develop Artificial Intelligence algorithms, tools and techniques for solving real world problems.',0,'UNIQUE',NULL,1),(24,16,'Ability to identify and use appropriate analytical tools and techniques on massive datasets to extract information.',1,'UNIQUE',NULL,1),(25,17,' Develop models in Data Science, Machine learning, deep learning and Big data technologies, using AI and modern tools.',0,'UNIQUE',NULL,1),(26,17,'Formulate solutions for interdisciplinary AI problems through acquired programming knowledge in the respective domains fulfilling with real-time constraints.',1,'UNIQUE',NULL,1),(27,18,'Apply knowledge on foundation in Life Science, engineering, mathematics and current biomedical engineering practices with an ability to demonstrate advanced knowledge of a selected area within Biomedical Engineering.',0,'UNIQUE',NULL,1),(28,18,'Critically analyse the current healthcare systems and develop innovative solutions effectively through problem specific design and development using modern hardware and software tools.',1,'UNIQUE',NULL,1),(29,18,'Hands-on knowledge on cutting edge hardware and software tools to acquire real time data, model and simulate physiological processes and analyse limitations on real time implementations.',2,'UNIQUE',NULL,1),(33,20,'Graduates will be able to demonstrate technical skills with inter-disciplinary approach for executing infrastructural projects ensuring safety, cost-effectiveness and sustainability.',0,'UNIQUE',NULL,1),(34,20,'Graduates will be able to implement various software tools and smart technologies to solve awide range of Civil Engineering problems with innovative research attributes.',1,'UNIQUE',NULL,1),(35,21,'Use the analytical instruments and techniques to separate, purify and characterize biological compounds',0,'UNIQUE',NULL,1),(36,21,'Design and synthesis of the novel biomolecule for the agriculture and healthcare sectors',1,'UNIQUE',NULL,1),(37,21,'Conceive, Plan and Deploy societal projects for environmental protection using bioresources.',2,'UNIQUE',NULL,1),(38,22,'To demonstrate the technical knowledge in Computer Science with equal appreciation of humanities, management sciences and human values ',0,'UNIQUE',NULL,1),(39,22,'To create, select, and apply appropriate techniques, resources, modern engineering and business tools including prediction and data analytics to complex engineering activities and business solutions ',1,'UNIQUE',NULL,1),(40,23,'Apply the skill of Design and Creative thinking to provide digital solutions to modern and complex engineering problems.',0,'UNIQUE',NULL,1),(41,23,'Apply the power of computing and digital media tools to provide solutions to challenging interactive technologies.',1,'UNIQUE',NULL,1),(42,23,'Acquire knowledge in diverse areas of Computer Science and Design to promote skills essential for career, entrepreneurship and higher studies.',2,'UNIQUE',NULL,1),(43,24,'Apply suitable algorithmic thinking and data management practices to design develop, and evaluate effective solutions for real-life and research problems',0,'UNIQUE',NULL,1),(44,24,'Design and develop cost-effective solutions based on cutting-edge hardware and software tools and techniques to meet global requirements.',1,'UNIQUE',NULL,1),(45,25,'Demonstrate the knowledge and technical skills in software development.',0,'UNIQUE',NULL,1),(46,25,'Develop practical competencies in Software and Hardware Design',1,'UNIQUE',NULL,1),(47,26,'Design, analyze, and evaluate the performance of real-world problems in the field of Electrical and Electronics using contemporary tools.',0,'UNIQUE',NULL,1),(48,26,'Apply knowledge skills and attitude to conduct experiments and interpret data to solve complex engineering problems in the power systems network, power electronics, electric drives and develop control strategies by considering economic and environmental constraints.',1,'UNIQUE',NULL,1),(49,27,'Able to apply the concepts of Electronics, Communication, Signal processing and VLSI in the design and implementation of application oriented engineering systems.',0,'UNIQUE',NULL,1),(50,27,'Able to solve the complex engineering problems using state-of-the-art hardware and software tools, along with analytical and managerial skills to arrive at appropriate solutions.',1,'UNIQUE',NULL,1),(51,28,'Identify suitable sensors and design signal conditioning circuits to measure physical parameters for industrial applications.',0,'UNIQUE',NULL,1),(52,28,'Design, develop and realize advanced control schemes in different platforms such as microcontroller, PLC, SCADA, DCS and other modern controllers for next level of automation.',1,'UNIQUE',NULL,1),(53,29,'Interpret trends, decipher fashion movements, apply the knowledge of elements of design and Gestalt theory of visual perception; and incorporate sustainable decisions into their design artworks, fashion products and accessories.',0,'UNIQUE',NULL,1),(54,29,'Articulate design aesthetics, communicate product values, collaborate across disciplines as member and leader; and envision solutions in fashion systems: design, technology, production and management.',1,'UNIQUE',NULL,1),(55,30,'Students will be able to conduct innovative and high-quality research to solve emerging problems in food technology by applying scientific knowledge.',0,'UNIQUE',NULL,1),(56,30,'Practical and research training imparted to the students will pave the way for introducing novel technologies in food processing sectors for global sustenance.',1,'UNIQUE',NULL,1),(57,31,'Excel in processing the information using data management with security features.',0,'UNIQUE',NULL,1),(58,31,'Demonstrate and develop applications on data analysis',1,'UNIQUE',NULL,1),(59,32,'Design and develop cost effective, secure, reliable IT, network and web based solutions with professional expertise in the domains including banking and healthcare and communications.',0,'UNIQUE',NULL,1),(60,32,'Identify and analyze large and heterogeneous data by applying suitable machine and deep learning algorithms and analytical tools to enable information retrieval and decision making in scientific and business applications.',1,'UNIQUE',NULL,1),(61,33,'Implement new ideas on product / process development by utilizing the knowledge of design and manufacturing. ',0,'UNIQUE',NULL,1),(62,33,'Apply knowledge acquired in mechanical engineering with an analytical / computational tools to design, analyze and provide solutions for real world applications. ',1,'UNIQUE',NULL,1),(63,33,'Execute professional capabilities to competitively work in industries with global Standards by implementing latest tools and techniques. ',2,'UNIQUE',NULL,1),(64,34,'Design, analyze and develop automation solutions for complex problems in diverse sectors using modern tools',0,'UNIQUE',NULL,1),(65,34,'Perform multidisciplinary activities in the mechatronics systems to solve real world problem.',1,'UNIQUE',NULL,1),(66,35,'Demonstrate the knowledge and understanding of the processes and systems related to textile manufacturing and solve the problems related to production and quality of fibres, yarns and fabrics.',0,'UNIQUE',NULL,1),(67,35,'Develop new designs (Woven / Printed / Dyed) and products (Knitted / Woven / Nonwoven) for apparel and technical applications.',1,'UNIQUE',NULL,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curriculum_vision`
--

LOCK TABLES `curriculum_vision` WRITE;
/*!40000 ALTER TABLE `curriculum_vision` DISABLE KEYS */;
INSERT INTO `curriculum_vision` VALUES (10,15,'To develop Agricultural Engineers with wealth of knowledge in Agriculture to meet the global\ndemand and serving society to reach sustainable food and nutritional security',1),(11,16,'To build a conducive academic and research environment to produce competent Professionals to the\ndynamic needs of the emerging trends in the field of Artificial Intelligence and Data Science.\n',1),(12,17,'To achieve excellence in the field of Artificial Intelligence and Machine Learning by focusing on knowledge centric education systems, integrative partnerships, innovation and cutting-edge research to meet latest industry standards and service the greater cause of society.',1),(14,18,'Department of Biomedical Engineering envisages to propel creative engineering knowledge\nand advancements in biomedical technology to improve the healthcare conditions for the\nbenefit of mankind.\n',1),(16,20,'To educate the students to face the challenges pertaining to Civil Engineering by maintaining\ncontinuous sprit on creativity, innovation, safety and ethics.',1),(17,21,'To empower students with world-class education by providing academic and professional competence in tune with technological and societal aspirations.',1),(18,22,'To be a leading center of excellence in computer science education and business\ntechnology, empowering students to become highly skilled professionals, innovative\nproblem solvers, and ethical leaders in the rapidly evolving digital world. ',1),(19,23,'To excel in the field of Computer Science and Design through the appropriate use of\nComputing and Design approaches.\n',1),(20,24,'To excel in the field of Computer Science and Engineering, to meet the emerging needs of the\nindustry, society, and beyond.',1),(21,25,'To be the leader in the field of computer technology, fostering innovative thinking, promoting technological excellence, and driving digital transformation for the benefit of society.\n',1),(22,26,'To produce competent Electrical and Electronics Engineers to fulfill the industry\nand society needs.',1),(23,27,'To foster academic excellence in Electronics and Communication Engineering\neducation and research and turn out students into competent professionals to\nserve society.',1),(24,28,'To empower graduates with future-ready engineering skills and transform them into\nintellectually competent and responsible professionals who excel in automation and\nallied domains, contributing meaningfully to societal and industrial advancement at\nboth national and international reputes.',1),(25,29,'To provide dynamic and impactful education in the field of Fashion Design and\nTechnology, facilitate transfer of knowledge and skills, achieve academic\nexcellence in meeting the emerging needs of the nation‟s fashion industry and\nthe world.',1),(26,30,'To develop technically sound human resources who can make a difference in thefield\nof Food Technology and to cater the needs of industry as well as society.',1),(27,31,'To promote innovative centric education through excellence in scientific & technical education and research aimed towards improvement of society.',1),(28,32,'To produce competent IT professionals to the dynamic needs of the emerging trends in the field of Information Technology.',1),(29,33,'To excel in Mechanical Engineering education by imparting industry-relevant knowledge and\nskills, implementing effective teaching methodologies, nurturing innovation, and contributing to\nsocietal and entrepreneurial development. ',1),(30,34,'To prepare students to achieve academic excellence in Mechatronics education with a practically\noriented curriculum, research and innovative product development.\n',1),(31,35,'To be a leading technology and managerial resource for the global growth of the Indian\ntextile industry.',1),(32,36,'To excel in the field of Computer Science and Engineering, to meet the emerging needs of the\nindustry, society and beyond.',1),(33,37,'Seek excellence in the field of Mechanical Engineering education through knowledge and skills to carter to the requirements of the society. ',1);
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_curriculum_active`
--

LOCK TABLES `department_curriculum_active` WRITE;
/*!40000 ALTER TABLE `department_curriculum_active` DISABLE KEYS */;
INSERT INTO `department_curriculum_active` VALUES (1,14,16,'2025-2026',1,'2026-02-09 09:30:58');
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
) ENGINE=InnoDB AUTO_INCREMENT=336 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_teachers`
--

LOCK TABLES `department_teachers` WRITE;
/*!40000 ALTER TABLE `department_teachers` DISABLE KEYS */;
INSERT INTO `department_teachers` VALUES (100,'MA10071',8,NULL,1,'2026-01-30 10:45:39','2026-01-30 10:45:39'),(101,'PH11015',8,NULL,1,'2026-01-30 10:45:39','2026-01-30 10:45:39'),(111,'AG10092',8,NULL,1,'2026-01-30 10:45:42','2026-01-30 10:45:42'),(138,'PH11015',14,NULL,1,'2026-02-02 06:17:47','2026-02-02 06:17:47'),(267,'MA1702',14,NULL,1,'2026-02-03 03:38:46','2026-02-03 03:38:46'),(268,'MA10119',14,NULL,1,'2026-02-03 03:38:48','2026-02-03 03:38:48'),(269,'MA10763',14,NULL,1,'2026-02-03 03:38:49','2026-02-03 03:38:49'),(270,'MA10986',14,NULL,1,'2026-02-03 03:38:51','2026-02-03 03:38:51'),(271,'MA11181',14,NULL,1,'2026-02-03 03:38:52','2026-02-03 03:38:52'),(272,'PH1653',14,NULL,1,'2026-02-03 03:38:53','2026-02-03 03:38:53'),(273,'PH10870',14,NULL,1,'2026-02-03 03:38:54','2026-02-03 03:38:54'),(274,'PH11153',14,NULL,1,'2026-02-03 03:38:55','2026-02-03 03:38:55'),(275,'PH11152',14,NULL,1,'2026-02-03 03:38:56','2026-02-03 03:38:56'),(277,'CH1493',14,NULL,1,'2026-02-03 03:38:58','2026-02-03 03:38:58'),(278,'CH10314',14,NULL,1,'2026-02-03 03:38:59','2026-02-03 03:38:59'),(279,'CH11057',14,NULL,1,'2026-02-03 03:39:01','2026-02-03 03:39:01'),(280,'CH1557',14,NULL,1,'2026-02-03 03:39:02','2026-02-03 03:39:02'),(281,'CH11127',14,NULL,1,'2026-02-03 03:39:02','2026-02-03 03:39:02'),(282,'AD10931',14,NULL,1,'2026-02-03 03:39:03','2026-02-03 03:39:03'),(283,'AD10945',14,NULL,1,'2026-02-03 03:39:04','2026-02-03 03:39:04'),(284,'AD11069',14,NULL,1,'2026-02-03 03:39:04','2026-02-03 03:39:04'),(285,'AD11089',14,NULL,1,'2026-02-03 03:39:05','2026-02-03 03:39:05'),(286,'AD11114',14,NULL,1,'2026-02-03 03:39:06','2026-02-03 03:39:06'),(287,'EE10721',14,NULL,1,'2026-02-03 03:39:07','2026-02-03 03:39:07'),(288,'EE1747',14,NULL,1,'2026-02-03 03:39:08','2026-02-03 03:39:08'),(289,'EE10619',14,NULL,1,'2026-02-03 03:39:09','2026-02-03 03:39:09'),(290,'EE10616',14,NULL,1,'2026-02-03 03:39:11','2026-02-03 03:39:11'),(291,'EE1437',14,NULL,1,'2026-02-03 03:39:14','2026-02-03 03:39:14'),(292,'EC10827',14,NULL,1,'2026-02-03 03:39:14','2026-02-03 03:39:14'),(293,'EC10813',14,NULL,1,'2026-02-03 03:39:16','2026-02-03 03:39:16'),(294,'EC10739',14,NULL,1,'2026-02-03 03:39:19','2026-02-03 03:39:19'),(295,'EC11010',14,NULL,1,'2026-02-03 03:39:19','2026-02-03 03:39:19'),(296,'CD11061',14,NULL,1,'2026-02-03 03:39:21','2026-02-03 03:39:21'),(297,'EC10972',14,NULL,1,'2026-02-03 03:39:22','2026-02-03 03:39:22'),(298,'CB10949',14,NULL,1,'2026-02-03 03:39:24','2026-02-03 03:39:24'),(299,'HU11085',14,NULL,1,'2026-02-03 03:39:26','2026-02-03 03:39:26'),(300,'HU11115',14,NULL,1,'2026-02-03 03:39:28','2026-02-03 03:39:28'),(301,'HU11154',14,NULL,1,'2026-02-03 03:39:29','2026-02-03 03:39:29'),(302,'HU11125',14,NULL,1,'2026-02-03 03:39:30','2026-02-03 03:39:30'),(303,'HU11139',14,NULL,1,'2026-02-03 03:39:31','2026-02-03 03:39:31'),(304,'HU11141',14,NULL,1,'2026-02-03 03:39:33','2026-02-03 03:39:33'),(305,'MA1327',14,NULL,1,'2026-02-03 03:39:34','2026-02-03 03:39:34'),(306,'MA11028',14,NULL,1,'2026-02-03 03:39:36','2026-02-03 03:39:36'),(307,'MA11122',14,NULL,1,'2026-02-03 03:39:39','2026-02-03 03:39:39'),(308,'AD10953',14,NULL,1,'2026-02-03 03:39:40','2026-02-03 03:39:40'),(309,'AD10955',14,NULL,1,'2026-02-03 03:39:42','2026-02-03 03:39:42'),(310,'AD10928',14,NULL,1,'2026-02-03 03:39:43','2026-02-03 03:39:43'),(311,'AD11041',14,NULL,1,'2026-02-03 03:39:44','2026-02-03 03:39:44'),(312,'AD10628',14,NULL,1,'2026-02-03 03:39:46','2026-02-03 03:39:46'),(313,'AD10818',14,NULL,1,'2026-02-03 03:39:48','2026-02-03 03:39:48'),(314,'AD11068',14,NULL,1,'2026-02-03 03:39:49','2026-02-03 03:39:49'),(315,'AD11164',14,NULL,1,'2026-02-03 03:39:51','2026-02-03 03:39:51'),(316,'AD11019',14,NULL,1,'2026-02-03 03:39:53','2026-02-03 03:39:53'),(317,'AD11026',14,NULL,1,'2026-02-03 03:39:55','2026-02-03 03:39:55'),(318,'AD11023',14,NULL,1,'2026-02-03 03:39:57','2026-02-03 03:39:57'),(319,'AD11104',14,NULL,1,'2026-02-03 03:39:58','2026-02-03 03:39:58'),(320,'AD10838',14,NULL,1,'2026-02-03 03:40:00','2026-02-03 03:40:00'),(321,'AD11096',14,NULL,1,'2026-02-03 03:40:02','2026-02-03 03:40:02'),(322,'AD11016',14,NULL,1,'2026-02-03 03:40:05','2026-02-03 03:40:05'),(323,'AD1444',14,NULL,1,'2026-02-03 03:40:06','2026-02-03 03:40:06'),(324,'AD11111',14,NULL,1,'2026-02-03 03:40:07','2026-02-03 03:40:07'),(325,'AD1108',14,NULL,1,'2026-02-03 03:40:09','2026-02-03 03:40:09'),(326,'AD11009',14,NULL,1,'2026-02-03 03:40:10','2026-02-03 03:40:10'),(327,'CH1894',14,NULL,1,'2026-02-03 03:40:11','2026-02-03 03:40:11'),(328,'CH10957',14,NULL,1,'2026-02-03 03:40:13','2026-02-03 03:40:13'),(329,'HU11151',14,NULL,1,'2026-02-03 03:40:16','2026-02-03 03:40:16'),(330,'AD11042',14,NULL,1,'2026-02-03 03:40:17','2026-02-03 03:40:17'),(331,'AD11116',14,NULL,1,'2026-02-03 03:40:19','2026-02-03 03:40:19'),(332,'AD11112',14,NULL,1,'2026-02-03 03:40:20','2026-02-03 03:40:20'),(333,'AD10936',14,NULL,1,'2026-02-03 03:40:22','2026-02-03 03:40:22'),(334,'AD11169',14,NULL,1,'2026-02-03 03:40:24','2026-02-03 03:40:24'),(335,'AM10971',14,NULL,1,'2026-02-03 03:40:26','2026-02-03 03:40:26');
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
  `current_curriculum_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_departments_code` (`department_code`),
  KEY `fk_departments_current_curriculum` (`current_curriculum_id`),
  CONSTRAINT `fk_departments_current_curriculum` FOREIGN KEY (`current_curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (8,'AG','Agricultural Engineering',1,'2026-01-29 08:35:15','2026-02-09 09:29:49',15),(14,'AD','Artificial Intelligence and Data Science',1,'2026-02-02 06:17:41','2026-02-09 09:29:49',16);
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elective_semester_slots`
--

DROP TABLE IF EXISTS `elective_semester_slots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elective_semester_slots` (
  `id` int NOT NULL AUTO_INCREMENT,
  `semester` int NOT NULL,
  `slot_name` varchar(100) NOT NULL,
  `slot_order` int NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_semester_slot` (`semester`,`slot_name`),
  KEY `idx_semester` (`semester`),
  KEY `idx_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elective_semester_slots`
--

LOCK TABLES `elective_semester_slots` WRITE;
/*!40000 ALTER TABLE `elective_semester_slots` DISABLE KEYS */;
INSERT INTO `elective_semester_slots` VALUES (14,4,'Professional Elective 1',1,1,'2026-02-09 09:12:31','2026-02-09 09:12:31'),(15,5,'Professional Elective 2',1,1,'2026-02-09 09:12:31','2026-02-09 09:12:31'),(16,5,'Open Elective',2,1,'2026-02-09 09:12:31','2026-02-09 09:12:31'),(17,6,'Professional Elective 3',1,1,'2026-02-09 09:12:31','2026-02-09 09:12:31'),(18,6,'Professional Elective 4',2,1,'2026-02-09 09:12:31','2026-02-09 09:12:31'),(19,6,'Professional Elective 5',3,1,'2026-02-09 09:12:31','2026-02-09 09:12:31'),(20,7,'Professional Elective 6',1,1,'2026-02-09 09:12:31','2026-02-09 09:12:31'),(21,7,'Professional Elective 7',2,1,'2026-02-09 09:12:31','2026-02-09 09:12:31'),(22,7,'Professional Elective 8',3,1,'2026-02-09 09:12:31','2026-02-09 09:12:31'),(23,7,'Professional Elective 9',4,1,'2026-02-09 09:12:31','2026-02-09 09:12:31'),(24,7,'Mini Project I',5,1,'2026-02-09 09:12:31','2026-02-09 09:12:31');
/*!40000 ALTER TABLE `elective_semester_slots` ENABLE KEYS */;
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
  `slot_id` int NOT NULL,
  `slot_name` varchar(100) NOT NULL COMMENT 'Fixed slot for the semester (e.g., Professional Elective 1)',
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
  KEY `fk_hes_slot` (`slot_id`),
  CONSTRAINT `fk_hes_slot` FOREIGN KEY (`slot_id`) REFERENCES `elective_semester_slots` (`id`),
  CONSTRAINT `fk_hod_selection_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_hod_selection_curriculum` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_hod_selection_dept` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_hod_selection_user` FOREIGN KEY (`approved_by_user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hod_elective_selections`
--

LOCK TABLES `hod_elective_selections` WRITE;
/*!40000 ALTER TABLE `hod_elective_selections` DISABLE KEYS */;
INSERT INTO `hod_elective_selections` VALUES (15,14,16,5,343,15,'Professional Elective 2','2025-2026',NULL,NULL,142,'ACTIVE','2026-02-09 16:14:43','2026-02-09 16:14:43'),(16,14,16,7,349,21,'Professional Elective 7','2025-2026',NULL,NULL,142,'ACTIVE','2026-02-09 16:14:43','2026-02-09 16:14:43'),(17,14,16,5,352,15,'Professional Elective 2','2025-2026',NULL,NULL,142,'ACTIVE','2026-02-09 16:14:43','2026-02-09 16:14:43'),(18,14,16,5,355,16,'Open Elective','2025-2026',NULL,NULL,142,'ACTIVE','2026-02-09 16:14:43','2026-02-09 16:14:43'),(23,14,16,6,343,17,'Professional Elective 3','2025-2026',NULL,NULL,142,'ACTIVE','2026-02-09 21:37:33','2026-02-09 21:37:33'),(25,14,16,4,343,14,'Professional Elective 1','2025-2026',NULL,NULL,142,'ACTIVE','2026-02-09 21:38:25','2026-02-09 21:38:25');
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `honour_cards`
--

LOCK TABLES `honour_cards` WRITE;
/*!40000 ALTER TABLE `honour_cards` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `honour_vertical_courses`
--

LOCK TABLES `honour_vertical_courses` WRITE;
/*!40000 ALTER TABLE `honour_vertical_courses` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `honour_verticals`
--

LOCK TABLES `honour_verticals` WRITE;
/*!40000 ALTER TABLE `honour_verticals` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mark_category_name`
--

LOCK TABLES `mark_category_name` WRITE;
/*!40000 ALTER TABLE `mark_category_name` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mark_category_types`
--

LOCK TABLES `mark_category_types` WRITE;
/*!40000 ALTER TABLE `mark_category_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `mark_category_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mark_entry_field_permissions`
--

DROP TABLE IF EXISTS `mark_entry_field_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mark_entry_field_permissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `teacher_id` varchar(45) NOT NULL,
  `assessment_component_id` int NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_mark_entry_permission` (`course_id`,`teacher_id`,`assessment_component_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mark_entry_field_permissions`
--

LOCK TABLES `mark_entry_field_permissions` WRITE;
/*!40000 ALTER TABLE `mark_entry_field_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `mark_entry_field_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mark_entry_window_components`
--

DROP TABLE IF EXISTS `mark_entry_window_components`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mark_entry_window_components` (
  `id` int NOT NULL AUTO_INCREMENT,
  `window_id` int NOT NULL,
  `assessment_component_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_window_component` (`window_id`,`assessment_component_id`),
  KEY `assessment_component_id` (`assessment_component_id`),
  CONSTRAINT `mark_entry_window_components_ibfk_1` FOREIGN KEY (`window_id`) REFERENCES `mark_entry_windows` (`id`) ON DELETE CASCADE,
  CONSTRAINT `mark_entry_window_components_ibfk_2` FOREIGN KEY (`assessment_component_id`) REFERENCES `mark_category_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mark_entry_window_components`
--

LOCK TABLES `mark_entry_window_components` WRITE;
/*!40000 ALTER TABLE `mark_entry_window_components` DISABLE KEYS */;
/*!40000 ALTER TABLE `mark_entry_window_components` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mark_entry_windows`
--

DROP TABLE IF EXISTS `mark_entry_windows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mark_entry_windows` (
  `id` int NOT NULL AUTO_INCREMENT,
  `teacher_id` varchar(45) DEFAULT NULL,
  `department_id` int DEFAULT NULL,
  `semester` int DEFAULT NULL,
  `course_id` int DEFAULT NULL,
  `start_at` datetime NOT NULL,
  `end_at` datetime NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_window_lookup` (`teacher_id`,`department_id`,`semester`,`course_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mark_entry_windows`
--

LOCK TABLES `mark_entry_windows` WRITE;
/*!40000 ALTER TABLE `mark_entry_windows` DISABLE KEYS */;
/*!40000 ALTER TABLE `mark_entry_windows` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=263 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `normal_cards`
--

LOCK TABLES `normal_cards` WRITE;
/*!40000 ALTER TABLE `normal_cards` DISABLE KEYS */;
INSERT INTO `normal_cards` VALUES (72,32,1,'UNIQUE',NULL,'semester',1),(73,36,1,'UNIQUE',NULL,'semester',1),(74,36,NULL,'UNIQUE',NULL,'elective',1),(75,16,1,'UNIQUE',NULL,'semester',1),(76,16,2,'UNIQUE',NULL,'semester',1),(77,17,1,'UNIQUE',NULL,'semester',1),(78,17,2,'UNIQUE',NULL,'semester',1),(79,17,3,'UNIQUE',NULL,'semester',1),(80,33,1,'UNIQUE',NULL,'semester',1),(81,33,2,'UNIQUE',NULL,'semester',1),(82,33,3,'UNIQUE',NULL,'semester',1),(83,33,4,'UNIQUE',NULL,'semester',1),(84,33,5,'UNIQUE',NULL,'semester',1),(85,33,6,'UNIQUE',NULL,'semester',1),(86,33,7,'UNIQUE',NULL,'semester',1),(87,33,8,'UNIQUE',NULL,'semester',1),(88,24,1,'UNIQUE',NULL,'semester',1),(89,17,4,'UNIQUE',NULL,'semester',1),(90,24,2,'UNIQUE',NULL,'semester',1),(91,27,1,'UNIQUE',NULL,'semester',1),(92,27,2,'UNIQUE',NULL,'semester',1),(93,24,3,'UNIQUE',NULL,'semester',1),(94,21,1,'UNIQUE',NULL,'semester',1),(95,24,4,'UNIQUE',NULL,'semester',1),(96,27,3,'UNIQUE',NULL,'semester',1),(97,27,4,'UNIQUE',NULL,'semester',1),(98,27,5,'UNIQUE',NULL,'semester',1),(99,27,6,'UNIQUE',NULL,'semester',1),(100,27,7,'UNIQUE',NULL,'semester',1),(101,27,8,'UNIQUE',NULL,'semester',1),(102,32,2,'UNIQUE',NULL,'semester',1),(103,16,3,'UNIQUE',NULL,'semester',1),(104,20,1,'UNIQUE',NULL,'semester',1),(107,21,2,'UNIQUE',NULL,'semester',1),(108,17,5,'UNIQUE',NULL,'semester',1),(109,16,4,'UNIQUE',NULL,'semester',1),(110,33,NULL,'UNIQUE',NULL,'elective',1),(111,32,3,'UNIQUE',NULL,'semester',1),(112,17,6,'UNIQUE',NULL,'semester',1),(113,33,1,'UNIQUE',NULL,'vertical',1),(114,21,3,'UNIQUE',NULL,'semester',1),(115,17,7,'UNIQUE',NULL,'semester',1),(116,32,4,'UNIQUE',NULL,'semester',1),(117,33,2,'UNIQUE',NULL,'vertical',1),(118,21,4,'UNIQUE',NULL,'semester',1),(119,17,8,'UNIQUE',NULL,'semester',1),(120,16,5,'UNIQUE',NULL,'semester',1),(121,17,NULL,'UNIQUE',NULL,'elective',1),(122,33,3,'UNIQUE',NULL,'vertical',1),(123,33,4,'UNIQUE',NULL,'vertical',1),(124,33,5,'UNIQUE',NULL,'vertical',1),(125,33,6,'UNIQUE',NULL,'vertical',1),(126,33,7,'UNIQUE',NULL,'vertical',1),(127,33,8,'UNIQUE',NULL,'vertical',1),(128,33,NULL,'UNIQUE',NULL,'one_credit',1),(129,33,NULL,'UNIQUE',NULL,'open_elective',1),(130,17,1,'UNIQUE',NULL,'vertical',1),(131,16,6,'UNIQUE',NULL,'semester',1),(132,21,5,'UNIQUE',NULL,'semester',1),(133,32,5,'UNIQUE',NULL,'semester',1),(134,20,2,'UNIQUE',NULL,'semester',1),(135,16,7,'UNIQUE',NULL,'semester',1),(136,21,6,'UNIQUE',NULL,'semester',1),(137,32,6,'UNIQUE',NULL,'semester',1),(138,16,NULL,'UNIQUE',NULL,'elective',0),(139,21,7,'UNIQUE',NULL,'semester',1),(140,32,7,'UNIQUE',NULL,'semester',1),(141,16,8,'UNIQUE',NULL,'semester',1),(142,21,8,'UNIQUE',NULL,'semester',1),(143,32,8,'UNIQUE',NULL,'semester',1),(144,21,NULL,'UNIQUE',NULL,'elective',1),(145,17,2,'UNIQUE',NULL,'vertical',1),(146,15,1,'UNIQUE',NULL,'semester',1),(147,15,2,'UNIQUE',NULL,'semester',1),(148,15,3,'UNIQUE',NULL,'semester',1),(149,17,3,'UNIQUE',NULL,'vertical',1),(150,15,4,'UNIQUE',NULL,'semester',1),(151,15,5,'UNIQUE',NULL,'semester',1),(152,17,4,'UNIQUE',NULL,'vertical',1),(153,15,6,'UNIQUE',NULL,'semester',1),(154,15,7,'UNIQUE',NULL,'semester',1),(155,15,8,'UNIQUE',NULL,'semester',1),(156,15,NULL,'UNIQUE',NULL,'elective',1),(157,32,1,'UNIQUE',NULL,'vertical',1),(158,17,5,'UNIQUE',NULL,'vertical',1),(159,17,6,'UNIQUE',NULL,'vertical',1),(160,17,7,'UNIQUE',NULL,'vertical',1),(161,15,1,'UNIQUE',NULL,'vertical',1),(162,32,NULL,'UNIQUE',NULL,'elective',1),(163,15,2,'UNIQUE',NULL,'vertical',1),(164,15,3,'UNIQUE',NULL,'vertical',1),(165,15,4,'UNIQUE',NULL,'vertical',1),(166,17,8,'UNIQUE',NULL,'vertical',1),(167,15,5,'UNIQUE',NULL,'vertical',1),(168,20,3,'UNIQUE',NULL,'semester',1),(169,15,6,'UNIQUE',NULL,'vertical',1),(170,15,7,'UNIQUE',NULL,'vertical',1),(171,27,NULL,'UNIQUE',NULL,'elective',1),(172,16,1,'UNIQUE',NULL,'vertical',1),(173,32,2,'UNIQUE',NULL,'vertical',1),(174,17,NULL,'UNIQUE',NULL,'one_credit',1),(175,16,2,'UNIQUE',NULL,'vertical',1),(176,16,3,'UNIQUE',NULL,'vertical',1),(177,17,NULL,'UNIQUE',NULL,'open_elective',1),(178,16,4,'UNIQUE',NULL,'vertical',1),(179,16,5,'UNIQUE',NULL,'vertical',1),(180,16,6,'UNIQUE',NULL,'vertical',1),(181,16,7,'UNIQUE',NULL,'vertical',1),(182,16,8,'UNIQUE',NULL,'vertical',1),(183,20,4,'UNIQUE',NULL,'semester',1),(184,27,1,'UNIQUE',NULL,'vertical',1),(185,21,1,'UNIQUE',NULL,'vertical',1),(186,16,NULL,'UNIQUE',NULL,'open_elective',1),(187,16,NULL,'UNIQUE',NULL,'one_credit',1),(188,32,3,'UNIQUE',NULL,'vertical',1),(189,27,2,'UNIQUE',NULL,'vertical',1),(190,16,NULL,'UNIQUE',NULL,'open_elective',1),(191,20,5,'UNIQUE',NULL,'semester',1),(192,20,6,'UNIQUE',NULL,'semester',1),(193,25,1,'UNIQUE',NULL,'semester',1),(194,20,7,'UNIQUE',NULL,'semester',1),(195,25,2,'UNIQUE',NULL,'semester',1),(196,20,8,'UNIQUE',NULL,'semester',1),(197,25,3,'UNIQUE',NULL,'semester',1),(198,20,NULL,'UNIQUE',NULL,'elective',1),(199,25,4,'UNIQUE',NULL,'semester',1),(200,25,5,'UNIQUE',NULL,'semester',1),(201,25,6,'UNIQUE',NULL,'semester',1),(202,21,2,'UNIQUE',NULL,'vertical',1),(203,21,3,'UNIQUE',NULL,'vertical',1),(204,21,4,'UNIQUE',NULL,'vertical',1),(205,21,5,'UNIQUE',NULL,'vertical',1),(206,24,5,'UNIQUE',NULL,'semester',1),(207,25,7,'UNIQUE',NULL,'semester',1),(208,25,8,'UNIQUE',NULL,'semester',1),(209,25,1,'UNIQUE',NULL,'vertical',1),(210,24,6,'UNIQUE',NULL,'semester',1),(211,24,7,'UNIQUE',NULL,'semester',1),(212,24,8,'UNIQUE',NULL,'semester',1),(213,24,NULL,'UNIQUE',NULL,'elective',1),(214,24,1,'UNIQUE',NULL,'vertical',1),(215,24,2,'UNIQUE',NULL,'vertical',1),(216,24,3,'UNIQUE',NULL,'vertical',1),(217,24,4,'UNIQUE',NULL,'vertical',1),(218,24,5,'UNIQUE',NULL,'vertical',1),(219,24,6,'UNIQUE',NULL,'vertical',1),(220,24,7,'UNIQUE',NULL,'vertical',1),(221,24,NULL,'UNIQUE',NULL,'open_elective',1),(222,24,NULL,'UNIQUE',NULL,'one_credit',1),(223,31,1,'UNIQUE',NULL,'semester',1),(224,31,2,'UNIQUE',NULL,'semester',1),(225,31,3,'UNIQUE',NULL,'semester',1),(226,31,4,'UNIQUE',NULL,'semester',1),(227,31,5,'UNIQUE',NULL,'semester',1),(228,31,6,'UNIQUE',NULL,'semester',1),(229,31,7,'UNIQUE',NULL,'semester',1),(230,31,8,'UNIQUE',NULL,'semester',1),(231,31,NULL,'UNIQUE',NULL,'elective',1),(232,31,1,'UNIQUE',NULL,'vertical',1),(233,31,2,'UNIQUE',NULL,'vertical',1),(234,31,3,'UNIQUE',NULL,'vertical',1),(235,31,4,'UNIQUE',NULL,'vertical',1),(236,31,5,'UNIQUE',NULL,'vertical',1),(237,31,6,'UNIQUE',NULL,'vertical',1),(238,31,7,'UNIQUE',NULL,'vertical',1),(239,31,NULL,'UNIQUE',NULL,'one_credit',1),(240,22,1,'UNIQUE',NULL,'semester',1),(241,22,2,'UNIQUE',NULL,'semester',1),(242,22,3,'UNIQUE',NULL,'semester',1),(243,22,4,'UNIQUE',NULL,'semester',1),(244,22,5,'UNIQUE',NULL,'semester',1),(245,22,6,'UNIQUE',NULL,'semester',1),(246,22,7,'UNIQUE',NULL,'semester',1),(247,22,8,'UNIQUE',NULL,'semester',1),(248,22,1,'UNIQUE',NULL,'vertical',1),(249,22,2,'UNIQUE',NULL,'vertical',1),(250,22,3,'UNIQUE',NULL,'vertical',1),(251,22,4,'UNIQUE',NULL,'vertical',1),(252,22,5,'UNIQUE',NULL,'vertical',1),(253,22,6,'UNIQUE',NULL,'vertical',1),(254,22,7,'UNIQUE',NULL,'vertical',1),(255,22,NULL,'UNIQUE',NULL,'open_elective',1),(256,22,NULL,'UNIQUE',NULL,'one_credit',1),(257,20,1,'UNIQUE',NULL,'vertical',1),(258,20,2,'UNIQUE',NULL,'vertical',1),(259,20,3,'UNIQUE',NULL,'vertical',1),(260,20,4,'UNIQUE',NULL,'vertical',1),(261,20,5,'UNIQUE',NULL,'vertical',1),(262,16,NULL,'UNIQUE',NULL,'language_elective',1);
/*!40000 ALTER TABLE `normal_cards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `open_elective_department_allowed`
--

DROP TABLE IF EXISTS `open_elective_department_allowed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `open_elective_department_allowed` (
  `id` int NOT NULL AUTO_INCREMENT,
  `department_id` int NOT NULL,
  `course_id` int NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_open_elective_dept_course` (`department_id`,`course_id`),
  KEY `fk_oe_course` (`course_id`),
  CONSTRAINT `fk_oe_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_oe_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `open_elective_department_allowed`
--

LOCK TABLES `open_elective_department_allowed` WRITE;
/*!40000 ALTER TABLE `open_elective_department_allowed` DISABLE KEYS */;
/*!40000 ALTER TABLE `open_elective_department_allowed` ENABLE KEYS */;
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
-- Table structure for table `pso_po_mapping`
--

DROP TABLE IF EXISTS `pso_po_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pso_po_mapping` (
  `id` int NOT NULL AUTO_INCREMENT,
  `curriculum_id` int NOT NULL,
  `po_index` int NOT NULL,
  `pso_index` int NOT NULL,
  `mapping_value` int NOT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `fk_popso_reg` (`curriculum_id`),
  CONSTRAINT `fk_popso_reg` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pso_po_mapping`
--

LOCK TABLES `pso_po_mapping` WRITE;
/*!40000 ALTER TABLE `pso_po_mapping` DISABLE KEYS */;
/*!40000 ALTER TABLE `pso_po_mapping` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `email` varchar(100) DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=315 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teacher_course_allocation`
--

LOCK TABLES `teacher_course_allocation` WRITE;
/*!40000 ALTER TABLE `teacher_course_allocation` DISABLE KEYS */;
INSERT INTO `teacher_course_allocation` VALUES (115,135,'AG10092'),(229,136,'CH10314'),(230,136,'CH11057'),(232,136,'CH11127'),(228,136,'CH1493'),(231,136,'CH1557'),(233,137,'AD10931'),(234,137,'AD10945'),(235,137,'AD11069'),(236,137,'AD11089'),(237,137,'AD11114'),(250,140,'HU11085'),(251,140,'HU11115'),(252,140,'HU11154'),(287,141,'CH10957'),(288,141,'CH11127'),(286,141,'CH1557'),(285,141,'CH1894'),(289,142,'HU11125'),(290,142,'HU11139'),(291,142,'HU11141'),(292,142,'HU11151'),(256,143,'HU11125'),(257,143,'HU11139'),(258,143,'HU11141'),(102,144,'MA10071'),(219,144,'MA10119'),(220,144,'MA10763'),(221,144,'MA10986'),(222,144,'MA11181'),(218,144,'MA1702'),(224,145,'PH10870'),(103,145,'PH11015'),(226,145,'PH11152'),(225,145,'PH11153'),(223,145,'PH1653'),(284,147,'AD11009'),(283,147,'AD1108'),(303,148,'AD11041'),(306,149,'AD11019'),(307,149,'AM10971'),(312,150,'AD10955'),(309,151,'AD11023'),(308,151,'AD11096'),(310,152,'AD10955'),(311,153,'AD11042'),(282,154,'AD11111'),(281,154,'AD1444'),(304,155,'AD10936'),(305,155,'AD11169'),(249,156,'CB10949'),(247,156,'CD11061'),(245,156,'EC10739'),(244,156,'EC10813'),(243,156,'EC10827'),(248,156,'EC10972'),(246,156,'EC11010'),(261,157,'MA10763'),(260,157,'MA11028'),(262,157,'MA11122'),(259,157,'MA1327'),(266,158,'AD10928'),(263,158,'AD10953'),(264,158,'AD10955'),(267,158,'AD11041'),(265,158,'AD11089'),(268,158,'AD11114'),(269,159,'AD10628'),(270,159,'AD10818'),(271,159,'AD11068'),(272,159,'AD11164'),(273,160,'AD11019'),(275,160,'AD11023'),(274,160,'AD11026'),(276,160,'AD11104'),(277,161,'AD10838'),(280,161,'AD10931'),(279,161,'AD11016'),(278,161,'AD11096'),(293,162,'AD11042'),(295,162,'AD11069'),(294,162,'AD11164'),(297,163,'AD10928'),(296,163,'AD11009'),(298,163,'AD11026'),(299,163,'AD11116'),(301,164,'AD10945'),(300,164,'AD11068'),(302,164,'AD11112'),(313,165,'AD11016'),(314,166,'AD11116'),(241,167,'EE10616'),(240,167,'EE10619'),(238,167,'EE10721'),(242,167,'EE1437'),(239,167,'EE1747');
/*!40000 ALTER TABLE `teacher_course_allocation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teacher_course_limits`
--

DROP TABLE IF EXISTS `teacher_course_limits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teacher_course_limits` (
  `id` int NOT NULL AUTO_INCREMENT,
  `teacher_id` int NOT NULL,
  `course_type_id` int NOT NULL,
  `max_count` int DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `teacher_id` (`teacher_id`,`course_type_id`),
  KEY `fk_tcl_course_type` (`course_type_id`),
  CONSTRAINT `fk_tcl_course_type` FOREIGN KEY (`course_type_id`) REFERENCES `course_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teacher_course_limits`
--

LOCK TABLES `teacher_course_limits` WRITE;
/*!40000 ALTER TABLE `teacher_course_limits` DISABLE KEYS */;
INSERT INTO `teacher_course_limits` VALUES (1,11349,1,2),(2,11349,2,2),(3,11349,3,2);
/*!40000 ALTER TABLE `teacher_course_limits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teacher_course_preferences`
--

DROP TABLE IF EXISTS `teacher_course_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teacher_course_preferences` (
  `id` int NOT NULL AUTO_INCREMENT,
  `teacher_id` bigint unsigned NOT NULL,
  `course_id` varchar(50) DEFAULT NULL,
  `semester` int NOT NULL,
  `batch` varchar(10) DEFAULT NULL,
  `course_type` int NOT NULL,
  `academic_year` varchar(20) DEFAULT NULL,
  `current_semester_type` enum('odd','even') DEFAULT NULL,
  `status` enum('pending','approved','active','completed','cancelled') DEFAULT NULL,
  `priority` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_by` int DEFAULT NULL,
  `approved_by` int DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teacher_course_preferences`
--

LOCK TABLES `teacher_course_preferences` WRITE;
/*!40000 ALTER TABLE `teacher_course_preferences` DISABLE KEYS */;
INSERT INTO `teacher_course_preferences` VALUES (7,11349,'22AI007',2,'2024',1,'2025-2026','even','pending',1,NULL,NULL,NULL,NULL,NULL,NULL),(8,11349,'22AI008',2,'2024',1,'2025-2026','even','pending',2,NULL,NULL,NULL,NULL,NULL,NULL),(9,11349,'22HS008 ',4,'2024',2,'2025-2026','even','pending',3,NULL,NULL,NULL,NULL,NULL,NULL),(10,11349,'22HS010',4,'2024',2,'2025-2026','even','pending',4,NULL,NULL,NULL,NULL,NULL,NULL),(11,11349,'22AI011',2,'2024',3,'2025-2026','even','pending',5,NULL,NULL,NULL,NULL,NULL,NULL),(12,11349,'22AI206',2,'2024',3,'2025-2026','even','pending',6,NULL,NULL,NULL,NULL,NULL,NULL),(19,11349,'22AI007',2,'2026',1,'2025-2026','odd','pending',1,NULL,NULL,NULL,NULL,NULL,NULL),(20,11349,'22AI001',1,'2026',1,'2025-2026','odd','pending',2,NULL,NULL,NULL,NULL,NULL,NULL),(21,11349,'22AI108',1,'2026',2,'2025-2026','odd','pending',3,NULL,NULL,NULL,NULL,NULL,NULL),(22,11349,'22HS002',1,'2026',2,'2025-2026','odd','pending',4,NULL,NULL,NULL,NULL,NULL,NULL),(23,11349,'22AI004',1,'2026',3,'2025-2026','odd','pending',5,NULL,NULL,NULL,NULL,NULL,NULL),(24,11349,'22CH103',1,'2026',3,'2025-2026','odd','pending',6,NULL,NULL,NULL,NULL,NULL,NULL),(37,11349,'22AI001',1,'',1,'2025-2026','odd','pending',1,NULL,NULL,NULL,NULL,NULL,NULL),(38,11349,'22AI002',1,'',1,'2025-2026','odd','pending',2,NULL,NULL,NULL,NULL,NULL,NULL),(39,11349,'22AI108',1,'',2,'2025-2026','odd','pending',3,NULL,NULL,NULL,NULL,NULL,NULL),(40,11349,'22HS002',1,'',2,'2025-2026','odd','pending',4,NULL,NULL,NULL,NULL,NULL,NULL),(41,11349,'22AI004',1,'',3,'2025-2026','odd','pending',5,NULL,NULL,NULL,NULL,NULL,NULL),(42,11349,'22CH103',1,'',3,'2025-2026','odd','pending',6,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `teacher_course_preferences` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=11446 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teachers`
--

LOCK TABLES `teachers` WRITE;
/*!40000 ALTER TABLE `teachers` DISABLE KEYS */;
INSERT INTO `teachers` VALUES (11211,'MA10071','Mrs.PREETHA R','preetha@bitsathy.ac.in','234253443',NULL,'14','Professor','2026-01-30 10:45:39',1),(11212,'PH11015','Dr.GOPI G','gopi@bitsathy.ac.in','23423423343',NULL,'14','Professor','2026-01-30 10:45:39',1),(11222,'AG10092','Dr.VASUDEVAN M','vasudevan@bitsathy.ac.in','+918838879911',NULL,'14','Professor','2026-01-30 10:45:42',1),(11308,'MA1702','Dr.UMAMAGESWARI D','umamageswarid@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:27:55',1),(11309,'MA10119','Dr.SARANYA D','saranyad@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:27:58',1),(11310,'MA10763','Dr.REVATHI V M','revathivm@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:27:59',1),(11311,'MA10986','Dr.GOMATHI M','gomathim@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:01',1),(11312,'MA11181','Dr.HEMALATHA B','hemalathab@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:03',1),(11313,'PH1653','Dr.PONGALI SATHYA PRABU N','pongalispn@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:05',1),(11314,'PH10870','Dr.VANITHA K','vanithak@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:06',1),(11315,'PH11153','Dr.SANGEETHA K','sangeethak@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:08',1),(11316,'PH11152','Dr.PRIYADHARSINI A','Priyadharsinia@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:09',1),(11318,'CH1493','Dr.SUBHAPRIYA P','subhapriyap@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:14',1),(11319,'CH10314','Dr.VISWANATHAN G','viswanathan@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:15',1),(11320,'CH11057','Dr.KARUPPUSAMY S','karuppusamys@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:16',1),(11321,'CH1557','Dr.VIJAYANAND P S','vijayanandps@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:17',1),(11322,'CH11127','Dr.MANIGANDAN S','manigandan@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:21',1),(11323,'AD10931','Mr.BALASAMY K','balasamyk@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:26',1),(11324,'AD10945','Mr.SATHEESH N P','satheeshnp@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:29',1),(11325,'AD11069','Mr.PREMKUMAR C','premkumar@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:30',1),(11326,'AD11089','Mrs.RESHMI T S','reshmits@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:33',1),(11327,'AD11114','Mrs.MANJU M','manju@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:35',1),(11328,'EE10721','Mrs.GOPIKA N P','gopika@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:36',1),(11329,'EE1747','Dr.SRITHA P','srithap@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:37',1),(11330,'EE10619','Mrs.MADHUMITHA J','madhumithaj@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:39',1),(11331,'EE10616','Mrs.NITHYA G','nithyag@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:40',1),(11332,'EE1437','Dr.VEERAKUMAR S','veerakumars@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:40',1),(11333,'EC10827','Dr.MURUGAN K','murugank@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:41',1),(11334,'EC10813','Ms.SHARMILA A','sharmilaa@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:42',1),(11335,'EC10739','Dr.ARULMURUGAN L','arulmurugan@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:43',1),(11336,'EC11010','Mrs.MARIAAMUTHA R','mariaamuthar@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:44',1),(11337,'CD11061','Mrs.PREETHIMATHI L','preethimathi@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:46',1),(11338,'EC10972','Mr.VELLINGIRI A','vellingiria@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:47',1),(11339,'CB10949','Mrs.MADHUMITHA A','madhumithaa@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:50',1),(11340,'HU11085','Dr.SAGUNTHALA DEVI P','sagunthaladevi@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:52',1),(11341,'HU11115','Ms.KAMALI D','kamali@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:54',1),(11342,'HU11154','Mr.SHYAMSUNDAR S','shyamsundar@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:55',1),(11343,'HU11125','Dr.GAYATHRI G M','gayathri@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:28:59',1),(11344,'HU11139','Dr.ASLIN JERUSHA D','aslinjerusha@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:03',1),(11345,'HU11141','Dr.EZHIL G','ezhil@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:03',1),(11346,'MA1327','Dr.THULASIMANI T','thulasimanit@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:05',1),(11347,'MA11028','Mr.SURESH R','sureshr@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:06',1),(11348,'MA11122','Dr.AKALYADEVI K','akalyadevi@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:07',1),(11349,'AD10953','Mr.RAJ KUMAR V S','rajkumarvs@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:08',1),(11350,'AD10955','Ms.ESAKKI MADURA E','esakkimadurae@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:09',1),(11351,'AD10928','Mrs.NISHA DEVI K','nishadevik@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:10',1),(11352,'AD11041','Mrs.ASHFORN HERMINA J M','ashfornherminajm@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:12',1),(11353,'AD10628','Dr.ARUN KUMAR R','arunkumarr@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:13',1),(11354,'AD10818','Dr.ESWARAMOORTHY V','eswaramoorthyv@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:14',1),(11355,'AD11068','Ms.BENITA GRACIA THANGAM J','benitagraciathangam@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:14',1),(11356,'AD11164','Mr.SASSON TAFFWIN MOSES S','sassontaffwinmosess@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:15',1),(11357,'AD11019','Mrs.KIRUTHIGA R','kiruthigar@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:16',1),(11358,'AD11026','Mr.CHOZHARAJAN P','chozharajanp@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:17',1),(11359,'AD11023','Mrs.VAANATHI S','vaanathi@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:18',1),(11360,'AD11104','Mrs.KALPANA R','kalpana@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:19',1),(11361,'AD10838','Mrs.NITHYAPRIYA S','nithyapriyas@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:20',1),(11362,'AD11096','Dr.SUBBULAKSHMI M','subbulakshmi@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:21',1),(11363,'AD11016','Mr.SATHEESHKUMAR S','satheeshkumars@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:22',1),(11364,'AD1444','Dr.GOMATHI R','gomathir@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:24',1),(11365,'AD11111','Ms.SURIYA V','suriya@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:24',1),(11366,'AD1108','Dr.SUNDARA MURTHY S','sundaramurthys@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:25',1),(11367,'AD11009','Mrs.DIVYABARATHI P','divyabarathip@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:26',1),(11368,'CH1894','Dr.MALATHI MAHALINGAM','malathimahalingamm@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:27',1),(11369,'CH10957','Dr.DEEPHA V','deephav@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:28',1),(11370,'HU11151','Dr.NITHYA S','nithyas@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:30',1),(11371,'AD11042','Mrs.JEEVITHA S V','jeevithasv@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:31',1),(11372,'AD11116','Ms.PRIYADHARSHNI S','priyadharshni@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:32',1),(11373,'AD11112','Mrs.HEMA PRIYA D','hemapriyad@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:37',1),(11374,'AD10936','Mr.PRABANAND S C','prabanandsc@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:39',1),(11375,'AD11169','Mrs.MANOCHITRA A S','manochitra@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:40',1),(11376,'AM10971','Mr.NITHIN P','nithinp@bitsathy.ac.in',NULL,NULL,NULL,NULL,'2026-02-03 03:29:41',1);
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
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=143 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','admin123','admin@example.com','admin',1,'2026-01-07 00:22:45','2026-02-09 15:07:09','2026-02-09 20:37:09'),(3,'curriculum entry','curriculumentry1432','curriculum@example.com','curriculum_entry_user',1,'2026-02-03 09:34:55','2026-02-04 05:59:35','2026-02-04 05:59:35'),(140,'teacher','t','rajkumarvs@bitsathy.ac.in','teacher',1,'2026-02-09 06:09:07','2026-02-09 10:46:28','2026-02-09 16:16:28'),(141,'hr','h','hr@gmail.com','hr',1,'2026-02-09 08:52:47','2026-02-09 09:38:04','2026-02-09 15:08:05'),(142,'hod','hod','satheeshkumars@bitsathy.ac.in','hod',1,'2026-02-09 10:40:54','2026-02-10 03:16:55','2026-02-10 08:46:56');
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

-- Dump completed on 2026-02-10  9:04:05
