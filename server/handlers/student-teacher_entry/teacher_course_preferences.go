package studentteacher

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/gorilla/mux"
	"server/db"
)

// TeacherCoursePreference represents a faculty course selection
type TeacherCoursePreference struct {
	ID                  int            `json:"id"`
	TeacherID           int            `json:"teacher_id"`
	CourseID            string         `json:"course_id"`
	CourseName          string         `json:"course_name"` // Added for display
	Semester            int            `json:"semester"`
	Batch               string         `json:"batch"`
	CourseType          string         `json:"course_type"` // theory or theory_with_lab
	AcademicYear        string         `json:"academic_year"`
	CurrentSemesterType string         `json:"current_semester_type"` // odd or even
	Status              string         `json:"status"`
	Priority            int            `json:"priority"`
	CreatedAt           sql.NullTime   `json:"created_at"` // Changed to sql.NullTime
	UpdatedAt           sql.NullTime   `json:"updated_at"` // Changed to sql.NullTime
	CreatedBy           sql.NullInt64  `json:"created_by"`
	ApprovedBy          sql.NullInt64  `json:"approved_by"`
	ApprovedAt          sql.NullTime   `json:"approved_at"`
	Notes               sql.NullString `json:"notes"`
}

// TeacherAllocationSummary shows teacher's allocation vs actual selections
type TeacherAllocationSummary struct {
	TeacherID           int                 `json:"teacher_id"`
	TeacherName         string              `json:"teacher_name"`
	FacultyID           string              `json:"faculty_id"`
	Batch               string              `json:"batch"`
	AcademicYear        string              `json:"academic_year"`
	CurrentSemesterType string              `json:"current_semester_type"`
	TypeSummaries       []CourseTypeSummary `json:"type_summaries"`
	AllocationStatus    string              `json:"allocation_status"` // Complete, Incomplete, Over-allocated
}

type CourseTypeSummary struct {
	CourseTypeID int    `json:"course_type_id"`
	TypeName     string `json:"type_name"`
	Allocated    int    `json:"allocated"`
	Selected     int    `json:"selected"`
	Remaining    int    `json:"remaining"`
}

// GetTeacherAllocationSummary returns the allocation summary for a teacher
func GetTeacherAllocationSummary(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	teacherID := vars["teacher_id"]
	
	// Optional query params
	batch := r.URL.Query().Get("batch")
	academicYear := r.URL.Query().Get("academic_year")

	// Get basic teacher info
	var summary TeacherAllocationSummary
	query := `SELECT id, name, faculty_id FROM teachers WHERE id = ?`
	err := db.DB.QueryRow(query, teacherID).Scan(&summary.TeacherID, &summary.TeacherName, &summary.FacultyID)
	if err != nil {
		log.Printf("Error fetching teacher info: %v", err)
		http.Error(w, "Teacher not found", http.StatusNotFound)
		return
	}

	summary.Batch = batch
	summary.AcademicYear = academicYear
	summary.CurrentSemesterType = "odd" // Default or fetch from somewhere

	// Fetch all course types and their limits/selections for this teacher
	typeQuery := `
		SELECT 
			ct.id, 
			ct.course_type, 
			COALESCE(tcl.max_count, 0) as allocated,
			(SELECT COUNT(*) FROM teacher_course_preferences tcp 
			 WHERE tcp.teacher_id = ? AND tcp.course_type = ct.id
			 AND tcp.status != 'rejected') as selected
		FROM course_type ct
		LEFT JOIN teacher_course_limits tcl ON ct.id = tcl.course_type_id AND tcl.teacher_id = ?
		ORDER BY ct.id
	`
	rows, err := db.DB.Query(typeQuery, teacherID, teacherID)
	if err != nil {
		log.Printf("Error fetching type summaries: %v", err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	allComplete := true
	anyOver := false

	for rows.Next() {
		var ts CourseTypeSummary
		if err := rows.Scan(&ts.CourseTypeID, &ts.TypeName, &ts.Allocated, &ts.Selected); err != nil {
			continue
		}
		ts.Remaining = ts.Allocated - ts.Selected
		summary.TypeSummaries = append(summary.TypeSummaries, ts)

		if ts.Selected < ts.Allocated {
			allComplete = false
		}
		if ts.Selected > ts.Allocated {
			anyOver = true
		}
	}

	if anyOver {
		summary.AllocationStatus = "Over-allocated"
	} else if allComplete {
		summary.AllocationStatus = "Complete"
	} else {
		summary.AllocationStatus = "Incomplete"
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"summary": summary,
	})
}

// GetTeacherCoursePreferences returns all course preferences for a teacher
func GetTeacherCoursePreferences(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	teacherID := vars["teacher_id"]

	academicYear := r.URL.Query().Get("academic_year")
	currentSemesterType := r.URL.Query().Get("current_semester_type")
	nextSemester := r.URL.Query().Get("next_semester")
	batch := r.URL.Query().Get("batch")
	status := r.URL.Query().Get("status")
	
	log.Printf("GetTeacherCoursePreferences - teacherID: %s, academicYear: %s, currentSemesterType: %s, nextSemester: %s, batch: %s", 
		teacherID, academicYear, currentSemesterType, nextSemester, batch)

	query := `
		SELECT tcp.id, tcp.teacher_id, tcp.course_id, tcp.semester, COALESCE(tcp.batch, ''), COALESCE(ct.course_type, 'theory') as course_type, 
			   tcp.academic_year, COALESCE(tcp.current_semester_type, ''), COALESCE(tcp.status, 'approved'), COALESCE(tcp.priority, 0),
			   COALESCE(c.course_name, '') as course_name
		FROM teacher_course_preferences tcp
		LEFT JOIN courses c ON tcp.course_id = c.course_code
		LEFT JOIN course_type ct ON tcp.course_type = ct.id
		WHERE tcp.teacher_id = ?
	`

	args := []interface{}{teacherID}

	// Check for next semester + batch combination (new lock mechanism)
	if nextSemester != "" && batch != "" {
		query += " AND tcp.semester = ? AND tcp.batch = ?"
		args = append(args, nextSemester, batch)
	} else {
		// Old logic for academic year and semester type
		if academicYear != "" {
			query += " AND tcp.academic_year = ?"
			args = append(args, academicYear)
		}

		if currentSemesterType != "" {
			query += " AND tcp.current_semester_type = ?"
			args = append(args, currentSemesterType)
		}
	}

	if status != "" {
		query += " AND tcp.status = ?"
		args = append(args, status)
	} else {
		query += " AND tcp.status IN ('pending', 'approved', 'active')"
	}

	query += " ORDER BY tcp.semester, tcp.priority"
	
	log.Printf("Executing query with %d args: %v", len(args), args)

	rows, err := db.DB.Query(query, args...)
	if err != nil {
		log.Printf("Error fetching teacher course preferences: %v", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	preferences := []TeacherCoursePreference{}
	for rows.Next() {
		var pref TeacherCoursePreference
		err := rows.Scan(
			&pref.ID,
			&pref.TeacherID,
			&pref.CourseID,
			&pref.Semester,
			&pref.Batch,
			&pref.CourseType,
			&pref.AcademicYear,
			&pref.CurrentSemesterType,
			&pref.Status,
			&pref.Priority,
			&pref.CourseName, // Added course_name from JOIN
		)
		if err != nil {
			log.Printf("Error scanning preference: %v", err)
			continue
		}
		preferences = append(preferences, pref)
	}

	log.Printf("Returning %d preferences for teacher %s", len(preferences), teacherID)

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"success":     true,
		"preferences": preferences,
	})
}

// SaveTeacherCoursePreferences saves/updates teacher course selections
func SaveTeacherCoursePreferences(w http.ResponseWriter, r *http.Request) {
	var requestData struct {
		TeacherID           int      `json:"teacher_id"`
		AcademicYear        string   `json:"academic_year"`
		CurrentSemesterType string   `json:"current_semester_type"`
		Preferences         []struct {
			CourseID   string `json:"course_id"`
			Semester   int    `json:"semester"`
			Batch      string `json:"batch"` // Each course has its own batch based on semester
			CourseType int    `json:"course_type"` // INT - maps to course_type.id
			Priority   int    `json:"priority"`
		} `json:"preferences"`
	}

	if err := json.NewDecoder(r.Body).Decode(&requestData); err != nil {
		log.Printf("Error decoding request: %v", err)
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	log.Printf("=== SaveTeacherCoursePreferences Request ===")
	log.Printf("TeacherID: %d", requestData.TeacherID)
	log.Printf("AcademicYear: %s", requestData.AcademicYear)
	log.Printf("CurrentSemesterType: %s", requestData.CurrentSemesterType)
	log.Printf("Number of preferences: %d", len(requestData.Preferences))
	for i, pref := range requestData.Preferences {
		log.Printf("  Pref %d: CourseID=%s, Semester=%d, Batch=%s, CourseType=%d, Priority=%d", 
			i+1, pref.CourseID, pref.Semester, pref.Batch, pref.CourseType, pref.Priority)
	}
	log.Printf("==========================================")

	// Check if selection window is open from teacher_course_tracking table
	var windowStart, windowEnd sql.NullTime
	err := db.DB.QueryRow(`
		SELECT window_start, window_end
		FROM teacher_course_tracking
		WHERE academic_year = ?
		LIMIT 1
	`, requestData.AcademicYear).Scan(&windowStart, &windowEnd)

	if err != nil {
		log.Printf("Error checking selection window: %v", err)
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusForbidden)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"error":   "Selection window not configured for this academic year",
		})
		return
	}

	// Validate window is active
	now := time.Now()
	if !windowStart.Valid || !windowEnd.Valid {
		log.Printf("Selection window dates not set")
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusForbidden)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"error":   "Teacher course selection window is not configured",
		})
		return
	}

	if now.Before(windowStart.Time) {
		log.Printf("Selection window not yet open. Opens on: %v", windowStart.Time)
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusForbidden)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success":    false,
			"error":      "Teacher course selection window has not opened yet",
			"opens_at":   windowStart.Time.Format("2006-01-02 15:04:05"),
		})
		return
	}

	if now.After(windowEnd.Time) {
		log.Printf("Selection window closed. Closed on: %v", windowEnd.Time)
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusForbidden)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success":   false,
			"error":     "Teacher course selection window has closed",
			"closed_at": windowEnd.Time.Format("2006-01-02 15:04:05"),
		})
		return
	}

	log.Printf("✓ Selection window is open: %v to %v", windowStart.Time, windowEnd.Time)

	// Validate teacher allocation dynamically - now using course_type ID
	rows, err := db.DB.Query(`
		SELECT ct.id, ct.course_type, COALESCE(tcl.max_count, 0)
		FROM course_type ct
		LEFT JOIN teacher_course_limits tcl ON ct.id = tcl.course_type_id AND tcl.teacher_id = ?
	`, requestData.TeacherID)

	if err != nil {
		log.Printf("Error fetching teacher allocation: %v", err)
		http.Error(w, "Error validating allocation", http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	limitMap := make(map[int]int) // Changed to map[int]int for course_type_id
	typeNameMap := make(map[int]string) // To get type names for error messages
	for rows.Next() {
		var typeID int
		var name string
		var max int
		if err := rows.Scan(&typeID, &name, &max); err == nil {
			limitMap[typeID] = max
			typeNameMap[typeID] = name
		}
	}

	// Count selections by type ID
	selectionCounts := make(map[int]int)
	for _, pref := range requestData.Preferences {
		selectionCounts[pref.CourseType]++
	}

	// Validate counts
	for typeID, count := range selectionCounts {
		maxAllowed, exists := limitMap[typeID]
		typeName := typeNameMap[typeID]
		if !exists {
			w.Header().Set("Content-Type", "application/json")
			json.NewEncoder(w).Encode(map[string]string{
				"error": fmt.Sprintf("Invalid course type ID: %d", typeID),
			})
			return
		}
		if count > maxAllowed {
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]string{
				"error": fmt.Sprintf("%s subject count (%d) exceeds allocation (%d)", typeName, count, maxAllowed),
			})
			return
		}
	}

	// Begin transaction
	tx, err := db.DB.Begin()
	if err != nil {
		log.Printf("Error starting transaction: %v", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer tx.Rollback()

	// Delete existing preferences for this academic year and semester type
	deleteResult, err := tx.Exec(`
		DELETE FROM teacher_course_preferences 
		WHERE teacher_id = ? AND academic_year = ? AND current_semester_type = ?
	`, requestData.TeacherID, requestData.AcademicYear, requestData.CurrentSemesterType)

	if err != nil {
		log.Printf("Error deleting old preferences: %v", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	
	rowsDeleted, _ := deleteResult.RowsAffected()
	log.Printf("Deleted %d old preferences for teacher %d, year %s, semester %s", 
		rowsDeleted, requestData.TeacherID, requestData.AcademicYear, requestData.CurrentSemesterType)

	// Insert new preferences
	stmt, err := tx.Prepare(`
		INSERT INTO teacher_course_preferences 
		(teacher_id, course_id, semester, batch, course_type, academic_year, current_semester_type, status, priority, created_at, updated_at)
		VALUES (?, ?, ?, ?, ?, ?, ?, 'approved', ?, NOW(), NOW())
	`)
	if err != nil {
		log.Printf("Error preparing statement: %v", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer stmt.Close()

	log.Printf("Inserting %d preferences for teacher %d", len(requestData.Preferences), requestData.TeacherID)
	
	// First, validate that all course_type IDs exist
	for i, pref := range requestData.Preferences {
		var exists bool
		err := db.DB.QueryRow("SELECT EXISTS(SELECT 1 FROM course_type WHERE id = ?)", pref.CourseType).Scan(&exists)
		if err != nil || !exists {
			log.Printf("Invalid course_type ID %d for course %s (preference %d)", pref.CourseType, pref.CourseID, i+1)
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]string{
				"error": fmt.Sprintf("Invalid course type ID %d. Please refresh the page and try again.", pref.CourseType),
			})
			return
		}
	}
	
	for i, pref := range requestData.Preferences {
		log.Printf("Inserting preference %d: CourseID=%s, Semester=%d, Batch=%s, CourseType=%d, Priority=%d", 
			i+1, pref.CourseID, pref.Semester, pref.Batch, pref.CourseType, pref.Priority)
			
		result, err := stmt.Exec(
			requestData.TeacherID,
			pref.CourseID,
			pref.Semester,
			pref.Batch,
			pref.CourseType,
			requestData.AcademicYear,
			requestData.CurrentSemesterType,
			pref.Priority,
		)
		if err != nil {
			log.Printf("Error inserting preference: %v", err)
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		
		insertID, _ := result.LastInsertId()
		log.Printf("Successfully inserted preference with ID: %d", insertID)
	}

	if err = tx.Commit(); err != nil {
		log.Printf("Error committing transaction: %v", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	log.Printf("✓ Transaction committed successfully - %d preferences saved", len(requestData.Preferences))

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"message": "Course preferences saved successfully",
	})
}
