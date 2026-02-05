package curriculum

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"strings"

	"server/db"
	"server/models"
)

// GetMarkCategoriesByType fetches all mark categories for a specific course type
func GetMarkCategoriesByType(w http.ResponseWriter, r *http.Request) {
	// Enable CORS
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
	w.Header().Set("Content-Type", "application/json")

	if r.Method == "OPTIONS" {
		w.WriteHeader(http.StatusOK)
		return
	}

	// Extract courseTypeId from URL path: /api/mark-categories-by-type/{courseTypeId}
	pathParts := strings.Split(r.URL.Path, "/")
	courseTypeIdStr := pathParts[len(pathParts)-1]
	
	courseTypeID, err := strconv.Atoi(courseTypeIdStr)
	if err != nil {
		http.Error(w, "Invalid course type ID", http.StatusBadRequest)
		return
	}

	database := db.DB
	if database == nil {
		http.Error(w, "Database connection failed", http.StatusInternalServerError)
		return
	}

	// Query mark categories filtered by course_type_id and learning_mode_id, ordered by position
	query := `
		SELECT 
			id,
			name,
			max_marks,
			conversion_marks,
			position,
			course_type_id,
			category_name_id,
			learning_mode_id,
			status
		FROM mark_category_types
		WHERE course_type_id = ? AND learning_mode_id = 2 AND status = 1
		ORDER BY position ASC
	`

	rows, err := database.Query(query, courseTypeID)
	if err != nil {
		log.Printf("Error fetching mark categories: %v", err)
		http.Error(w, "Error fetching mark categories", http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	var categories []models.MarkCategoryType
	for rows.Next() {
		var category models.MarkCategoryType
		err := rows.Scan(
			&category.ID,
			&category.Name,
			&category.MaxMarks,
			&category.ConversionMarks,
			&category.Position,
			&category.CourseTypeID,
			&category.CategoryNameID,
			&category.LearningModeID,
			&category.Status,
		)
		if err != nil {
			log.Printf("Error scanning mark category: %v", err)
			continue
		}
		categories = append(categories, category)
	}

	if err = rows.Err(); err != nil {
		log.Printf("Error iterating mark categories: %v", err)
		http.Error(w, "Error processing mark categories", http.StatusInternalServerError)
		return
	}

	// Return empty array if no categories found
	if categories == nil {
		categories = []models.MarkCategoryType{}
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(categories)
}

// SaveStudentMarks saves or updates student mark entries
func SaveStudentMarks(w http.ResponseWriter, r *http.Request) {
	// Enable CORS
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
	w.Header().Set("Content-Type", "application/json")

	if r.Method == "OPTIONS" {
		w.WriteHeader(http.StatusOK)
		return
	}

	var saveRequest models.MarkEntrySaveRequest
	err := json.NewDecoder(r.Body).Decode(&saveRequest)
	if err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	if saveRequest.CourseID == 0 || len(saveRequest.MarkEntries) == 0 {
		http.Error(w, "Course ID and mark entries are required", http.StatusBadRequest)
		return
	}

	database := db.DB
	if database == nil {
		http.Error(w, "Database connection failed", http.StatusInternalServerError)
		return
	}

	savedCount := 0
	var errors []string

	// Process each mark entry
	for _, entry := range saveRequest.MarkEntries {
		// Validate student enrollment in course
		var studentEnrolled bool
		err := database.QueryRow(`
			SELECT COUNT(*) > 0 FROM student_courses 
			WHERE student_id = ? AND course_id = ?
		`, entry.StudentID, entry.CourseID).Scan(&studentEnrolled)
		if err != nil {
			log.Printf("Error validating student enrollment: %v", err)
			errors = append(errors, fmt.Sprintf("Student %d: enrollment validation failed", entry.StudentID))
			continue
		}

		if !studentEnrolled {
			log.Printf("Student %d not enrolled in course %d", entry.StudentID, entry.CourseID)
			errors = append(errors, fmt.Sprintf("Student %d is not enrolled in this course", entry.StudentID))
			continue
		}

		// Get mark category details for conversion calculation
		var maxMarks float64
		var conversionMarks float64
		err = database.QueryRow(`
			SELECT max_marks, conversion_marks FROM mark_category_types 
			WHERE id = ?
		`, entry.AssessmentComponentID).Scan(&maxMarks, &conversionMarks)
		if err != nil {
			log.Printf("Error fetching mark category: %v", err)
			errors = append(errors, fmt.Sprintf("Mark category %d not found", entry.AssessmentComponentID))
			continue
		}

		// Validate obtained marks against max marks
		if entry.ObtainedMarks < 0 || entry.ObtainedMarks > maxMarks {
			errors = append(errors, fmt.Sprintf("Student %d: marks %.2f exceed maximum %.0f", 
				entry.StudentID, entry.ObtainedMarks, maxMarks))
			continue
		}

		// Calculate converted marks: (obtained_marks / max_marks) * conversion_marks
		var convertedMarks float64
		if maxMarks > 0 {
			convertedMarks = (entry.ObtainedMarks / maxMarks) * conversionMarks
		}

		// Upsert mark entry
		query := `
			INSERT INTO student_marks 
			(student_id, course_id, faculty_id, assessment_component_id, obtained_marks, converted_marks, status)
			VALUES (?, ?, ?, ?, ?, ?, 1)
			ON DUPLICATE KEY UPDATE 
			obtained_marks = VALUES(obtained_marks),
			converted_marks = VALUES(converted_marks),
			status = 1
		`

		_, err = database.Exec(query,
			entry.StudentID,
			entry.CourseID,
			saveRequest.FacultyID,
			entry.AssessmentComponentID,
			entry.ObtainedMarks,
			convertedMarks,
		)
		if err != nil {
			log.Printf("Error saving student mark: %v", err)
			errors = append(errors, fmt.Sprintf("Student %d: database error", entry.StudentID))
			continue
		}

		savedCount++
	}

	response := models.MarkEntrySaveResponse{
		Success:    len(errors) == 0,
		SavedCount: savedCount,
	}

	if len(errors) > 0 {
		response.Message = fmt.Sprintf("Saved %d/%d marks. Errors: %s", 
			savedCount, len(saveRequest.MarkEntries), strings.Join(errors, "; "))
	} else {
		response.Message = fmt.Sprintf("Successfully saved %d mark entries", savedCount)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

// GetStudentMarks retrieves existing marks for a course
func GetStudentMarks(w http.ResponseWriter, r *http.Request) {
	// Enable CORS
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
	w.Header().Set("Content-Type", "application/json")

	if r.Method == "OPTIONS" {
		w.WriteHeader(http.StatusOK)
		return
	}

	// Extract courseId from URL path: /api/course/{courseId}/student-marks
	pathParts := strings.Split(r.URL.Path, "/")
	courseIdStr := pathParts[len(pathParts)-2]
	
	courseID, err := strconv.Atoi(courseIdStr)
	if err != nil {
		http.Error(w, "Invalid course ID", http.StatusBadRequest)
		return
	}

	database := db.DB
	if database == nil {
		http.Error(w, "Database connection failed", http.StatusInternalServerError)
		return
	}

	// Query all marks for the course
	query := `
		SELECT 
			id, student_id, course_id, faculty_id, assessment_component_id,
			obtained_marks, converted_marks, status
		FROM student_marks
		WHERE course_id = ? AND status = 1
		ORDER BY student_id, assessment_component_id
	`

	rows, err := database.Query(query, courseID)
	if err != nil {
		log.Printf("Error fetching student marks: %v", err)
		http.Error(w, "Error fetching student marks", http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	var marks []models.StudentMark
	for rows.Next() {
		var mark models.StudentMark
		err := rows.Scan(
			&mark.ID,
			&mark.StudentID,
			&mark.CourseID,
			&mark.FacultyID,
			&mark.AssessmentComponentID,
			&mark.ObtainedMarks,
			&mark.ConvertedMarks,
			&mark.Status,
		)
		if err != nil {
			log.Printf("Error scanning student mark: %v", err)
			continue
		}
		marks = append(marks, mark)
	}

	if err = rows.Err(); err != nil {
		log.Printf("Error iterating student marks: %v", err)
		http.Error(w, "Error processing student marks", http.StatusInternalServerError)
		return
	}

	// Return empty array if no marks found
	if marks == nil {
		marks = []models.StudentMark{}
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(marks)
}
