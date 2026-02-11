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

// GetMarkEntryPermissions returns all mark categories with enabled status for a course and teacher.
func GetMarkEntryPermissions(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
	w.Header().Set("Content-Type", "application/json")

	if r.Method == "OPTIONS" {
		w.WriteHeader(http.StatusOK)
		return
	}

	courseIDStr := r.URL.Query().Get("course_id")
	teacherIDStr := r.URL.Query().Get("teacher_id")

	courseID, err := strconv.Atoi(courseIDStr)
	if err != nil || courseID == 0 {
		http.Error(w, "Invalid course ID", http.StatusBadRequest)
		return
	}

	if teacherIDStr == "" {
		http.Error(w, "Invalid teacher ID", http.StatusBadRequest)
		return
	}

	database := db.DB
	if database == nil {
		http.Error(w, "Database connection failed", http.StatusInternalServerError)
		return
	}

	var courseCategory string
	err = database.QueryRow(`SELECT COALESCE(category, '') FROM courses WHERE id = ?`, courseID).Scan(&courseCategory)
	if err != nil {
		log.Printf("Error fetching course category: %v", err)
		http.Error(w, "Failed to resolve course category", http.StatusInternalServerError)
		return
	}

	courseTypeID := mapCourseCategoryToTypeID(courseCategory)
	if courseTypeID == 0 {
		http.Error(w, "Could not determine course type", http.StatusBadRequest)
		return
	}

	// Get learning modes from query parameter (comma-separated)
	learningModesStr := r.URL.Query().Get("learning_modes")
	var learningModes []int
	if learningModesStr != "" {
		modeStrs := strings.Split(learningModesStr, ",")
		for _, modeStr := range modeStrs {
			mode, err := strconv.Atoi(strings.TrimSpace(modeStr))
			if err == nil && (mode == 1 || mode == 2) {
				learningModes = append(learningModes, mode)
			}
		}
	}

	// Default to both UAL and PBL if no modes specified (backward compatibility)
	if len(learningModes) == 0 {
		learningModes = []int{1, 2}
	}

	// Build WHERE clause for learning modes
	learningModePlaceholders := make([]string, len(learningModes))
	learningModeArgs := make([]interface{}, 0)
	learningModeArgs = append(learningModeArgs, courseID, teacherIDStr, courseTypeID)
	for i, mode := range learningModes {
		learningModePlaceholders[i] = "?"
		learningModeArgs = append(learningModeArgs, mode)
	}
	learningModeClause := strings.Join(learningModePlaceholders, ",")

	query := fmt.Sprintf(`
		SELECT 
			mct.id,
			mct.name,
			mct.max_marks,
			mct.conversion_marks,
			mct.position,
			mct.course_type_id,
			mct.category_name_id,
			mct.learning_mode_id,
			mct.status,
			COALESCE(p.enabled, 1) AS enabled
		FROM mark_category_types mct
		LEFT JOIN mark_entry_field_permissions p
			ON p.course_id = ? AND p.teacher_id = ? AND p.assessment_component_id = mct.id
		WHERE mct.course_type_id = ? AND mct.learning_mode_id IN (%s) AND mct.status = 1
		ORDER BY mct.position ASC
	`, learningModeClause)

	rows, err := database.Query(query, learningModeArgs...)
	if err != nil {
		log.Printf("Error fetching mark entry permissions: %v", err)
		http.Error(w, "Error fetching mark entry permissions", http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	var categories []models.MarkEntryPermissionCategory
	for rows.Next() {
		var category models.MarkEntryPermissionCategory
		var enabledInt int
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
			&enabledInt,
		)
		if err != nil {
			log.Printf("Error scanning mark entry permission row: %v", err)
			continue
		}
		category.Enabled = enabledInt == 1
		categories = append(categories, category)
	}

	if err = rows.Err(); err != nil {
		log.Printf("Error iterating mark entry permissions: %v", err)
		http.Error(w, "Error processing mark entry permissions", http.StatusInternalServerError)
		return
	}

	if categories == nil {
		categories = []models.MarkEntryPermissionCategory{}
	}

	json.NewEncoder(w).Encode(categories)
}

// SaveMarkEntryPermissions updates the enabled state of mark categories for a course and teacher.
func SaveMarkEntryPermissions(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
	w.Header().Set("Content-Type", "application/json")

	if r.Method == "OPTIONS" {
		w.WriteHeader(http.StatusOK)
		return
	}

	var req models.MarkEntryPermissionUpdateRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	if req.CourseID == 0 || req.TeacherID == "" || len(req.Permissions) == 0 {
		http.Error(w, "Course ID, teacher ID, and permissions are required", http.StatusBadRequest)
		return
	}

	database := db.DB
	if database == nil {
		http.Error(w, "Database connection failed", http.StatusInternalServerError)
		return
	}

	tx, err := database.Begin()
	if err != nil {
		log.Printf("Error starting transaction: %v", err)
		http.Error(w, "Failed to update permissions", http.StatusInternalServerError)
		return
	}

	for _, permission := range req.Permissions {
		enabledValue := 0
		if permission.Enabled {
			enabledValue = 1
		}

		_, err := tx.Exec(`
			INSERT INTO mark_entry_field_permissions
			(course_id, teacher_id, assessment_component_id, enabled)
			VALUES (?, ?, ?, ?)
			ON DUPLICATE KEY UPDATE enabled = VALUES(enabled)
		`, req.CourseID, req.TeacherID, permission.AssessmentComponentID, enabledValue)
		if err != nil {
			_ = tx.Rollback()
			log.Printf("Error saving mark entry permission: %v", err)
			http.Error(w, "Failed to update permissions", http.StatusInternalServerError)
			return
		}
	}

	if err := tx.Commit(); err != nil {
		log.Printf("Error committing permissions update: %v", err)
		http.Error(w, "Failed to update permissions", http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(map[string]string{"message": "Permissions updated successfully"})
}
