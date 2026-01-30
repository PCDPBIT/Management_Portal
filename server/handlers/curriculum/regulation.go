package curriculum

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"

	"server/db"
	"server/models"
)

// GetRegulations retrieves all curriculum (legacy) from the database
func GetRegulations(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	query := "SELECT id, name, academic_year, max_credits, curriculum_template, created_at FROM curriculum WHERE status = 1 ORDER BY created_at DESC"
	rows, err := db.DB.Query(query)
	if err != nil {
		log.Println("Error querying curriculum:", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": "Failed to fetch curriculum"})
		return
	}
	defer rows.Close()

	var regulations []models.LegacyRegulation = make([]models.LegacyRegulation, 0)
	for rows.Next() {
		var reg models.LegacyRegulation
		err := rows.Scan(&reg.ID, &reg.Name, &reg.AcademicYear, &reg.MaxCredits, &reg.CurriculumTemplate, &reg.CreatedAt)
		if err != nil {
			log.Println("Error scanning curriculum:", err)
			continue
		}
		regulations = append(regulations, reg)
	}

	if err := rows.Err(); err != nil {
		log.Println("Rows iteration error:", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": "Failed to fetch curriculum"})
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(regulations)
}

// CreateRegulation creates a new curriculum (legacy) in the database
func CreateRegulation(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	if r.Method != http.MethodPost {
		w.WriteHeader(http.StatusMethodNotAllowed)
		json.NewEncoder(w).Encode(map[string]string{"error": "Method not allowed"})
		return
	}

	var reg models.LegacyRegulation
	err := json.NewDecoder(r.Body).Decode(&reg)
	if err != nil {
		log.Println("Error decoding request body:", err)
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "Invalid request body"})
		return
	}

	if reg.CurriculumTemplate == "" {
		reg.CurriculumTemplate = "2026"
	}

	query := "INSERT INTO curriculum (name, academic_year, max_credits, curriculum_template) VALUES (?, ?, ?, ?)"
	result, err := db.DB.Exec(query, reg.Name, reg.AcademicYear, reg.MaxCredits, reg.CurriculumTemplate)
	if err != nil {
		log.Println("Error inserting curriculum:", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": "Failed to create curriculum"})
		return
	}

	id, _ := result.LastInsertId()
	reg.ID = int(id)

	// Log the activity
	LogCurriculumActivity(int(id), "Curriculum Created",
		"Created new curriculum: "+reg.Name+" ("+reg.AcademicYear+")", "System")

	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(reg)
}

// DeleteRegulation deletes a curriculum (legacy) from the database
func DeleteRegulation(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	if r.Method != http.MethodDelete {
		w.WriteHeader(http.StatusMethodNotAllowed)
		json.NewEncoder(w).Encode(map[string]string{"error": "Method not allowed"})
		return
	}

	idStr := r.URL.Query().Get("id")
	if idStr == "" {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "ID parameter is required"})
		return
	}

	id, err := strconv.Atoi(idStr)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "Invalid ID"})
		return
	}

	// Start a transaction to ensure all deletions happen atomically
	tx, err := db.DB.Begin()
	if err != nil {
		log.Println("Error starting transaction:", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": "Failed to start transaction"})
		return
	}
	defer tx.Rollback()

	// Soft delete the curriculum
	query := "UPDATE curriculum SET status = 0 WHERE id = ? AND status = 1"
	result, err := tx.Exec(query, id)
	if err != nil {
		log.Println("Error deleting curriculum:", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": "Failed to delete curriculum"})
		return
	}

	rowsAffected, _ := result.RowsAffected()
	if rowsAffected == 0 {
		w.WriteHeader(http.StatusNotFound)
		json.NewEncoder(w).Encode(map[string]string{"error": "Curriculum not found"})
		return
	}

	// Cascade soft-delete to related tables
	relatedTables := []string{
		"curriculum_vision",
		"curriculum_mission",
		"curriculum_peos",
		"curriculum_pos",
		"curriculum_psos",
	}

	for _, tableName := range relatedTables {
		updateQuery := fmt.Sprintf("UPDATE %s SET status = 0 WHERE curriculum_id = ? AND (status = 1 OR status IS NULL)", tableName)
		_, err := tx.Exec(updateQuery, id)
		if err != nil {
			log.Printf("Error soft-deleting from %s: %v\n", tableName, err)
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]string{"error": fmt.Sprintf("Failed to cascade delete to %s", tableName)})
			return
		}
	}

	// Soft-delete all semesters (normal_cards) in this curriculum
	_, err = tx.Exec("UPDATE normal_cards SET status = 0 WHERE curriculum_id = ? AND status = 1", id)
	if err != nil {
		log.Println("Error soft-deleting semesters:", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": "Failed to cascade delete to semesters"})
		return
	}

	// Soft-delete all honour cards in this curriculum
	_, err = tx.Exec("UPDATE honour_cards SET status = 0 WHERE curriculum_id = ? AND status = 1", id)
	if err != nil {
		log.Println("Error soft-deleting honour cards:", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": "Failed to cascade delete to honour cards"})
		return
	}

	// Soft-delete all honour verticals in honour cards of this curriculum
	_, err = tx.Exec(`UPDATE honour_verticals SET status = 0 
		WHERE honour_card_id IN (SELECT id FROM honour_cards WHERE curriculum_id = ?) 
		AND status = 1`, id)
	if err != nil {
		log.Println("Error soft-deleting honour verticals:", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": "Failed to cascade delete to honour verticals"})
		return
	}

	// Soft-delete all honour_vertical_courses in honour verticals of this curriculum
	_, err = tx.Exec(`UPDATE honour_vertical_courses SET status = 0 
		WHERE honour_vertical_id IN (
			SELECT id FROM honour_verticals WHERE honour_card_id IN (
				SELECT id FROM honour_cards WHERE curriculum_id = ?
			)
		) AND status = 1`, id)
	if err != nil {
		log.Println("Error soft-deleting honour vertical courses:", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": "Failed to cascade delete to honour vertical courses"})
		return
	}

	// Get all course IDs linked to this curriculum (from both semesters and honour verticals)
	courseIDsMap := make(map[int]bool)

	// Get courses from curriculum_courses
	rows, err := tx.Query("SELECT DISTINCT course_id FROM curriculum_courses WHERE curriculum_id = ?", id)
	if err != nil {
		log.Println("Error fetching curriculum courses:", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": "Failed to fetch curriculum courses"})
		return
	}
	for rows.Next() {
		var courseID int
		if err := rows.Scan(&courseID); err == nil {
			courseIDsMap[courseID] = true
		}
	}
	rows.Close()

	// Get courses from honour verticals
	rows, err = tx.Query(`SELECT DISTINCT course_id FROM honour_vertical_courses 
		WHERE honour_vertical_id IN (
			SELECT id FROM honour_verticals WHERE honour_card_id IN (
				SELECT id FROM honour_cards WHERE curriculum_id = ?
			)
		)`, id)
	if err != nil {
		log.Println("Error fetching honour vertical courses:", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": "Failed to fetch honour vertical courses"})
		return
	}
	for rows.Next() {
		var courseID int
		if err := rows.Scan(&courseID); err == nil {
			courseIDsMap[courseID] = true
		}
	}
	rows.Close()

	// Soft-delete all courses and their children
	for courseID := range courseIDsMap {
		_, err = tx.Exec("UPDATE courses SET status = 0 WHERE id = ? AND status = 1", courseID)
		if err != nil {
			log.Printf("Error soft-deleting course %d: %v", courseID, err)
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]string{"error": "Failed to cascade delete to courses"})
			return
		}
		// Cascade soft-delete to all course children
		if err := cascadeSoftDeleteCourse(courseID, tx); err != nil {
			log.Printf("Error cascading course %d soft-delete: %v", courseID, err)
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]string{"error": "Failed to cascade delete to course children"})
			return
		}
	}

	// Commit the transaction
	if err := tx.Commit(); err != nil {
		log.Println("Error committing transaction:", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": "Failed to commit transaction"})
		return
	}

	// Note: Log will be automatically deleted due to CASCADE on foreign key

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"message": "Curriculum and related data deleted successfully"})
}
