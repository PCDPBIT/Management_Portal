package studentteacher

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"time"

	"server/db"
)

// CreateCourseAppeal creates a new appeal for teacher workload
func CreateCourseAppeal(w http.ResponseWriter, r *http.Request) {
	var requestData struct {
		FacultyID     int    `json:"faculty_id"`
		AppealMessage string `json:"appeal_message"`
	}

	if err := json.NewDecoder(r.Body).Decode(&requestData); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	// Validate required fields
	if requestData.FacultyID == 0 || requestData.AppealMessage == "" {
		http.Error(w, "faculty_id and appeal_message are required", http.StatusBadRequest)
		return
	}

	// Check if teacher already has a pending appeal
	var existingCount int
	checkQuery := `SELECT COUNT(*) FROM teacher_course_appeal WHERE faculty_id = ? AND appeal_status = 0`
	err := db.DB.QueryRow(checkQuery, requestData.FacultyID).Scan(&existingCount)
	if err != nil {
		log.Printf("Error checking existing appeals: %v", err)
		http.Error(w, "Database error", http.StatusInternalServerError)
		return
	}

	if existingCount > 0 {
		http.Error(w, "You already have a pending appeal. Please wait for HR to resolve it.", http.StatusConflict)
		return
	}

	// Insert new appeal
	insertQuery := `
		INSERT INTO teacher_course_appeal (faculty_id, appeal_message, appeal_status, created_at, updated_at)
		VALUES (?, ?, 0, NOW(), NOW())
	`
	result, err := db.DB.Exec(insertQuery, requestData.FacultyID, requestData.AppealMessage)
	if err != nil {
		log.Printf("Error creating appeal: %v", err)
		http.Error(w, "Failed to create appeal", http.StatusInternalServerError)
		return
	}

	// Get the created appeal ID
	appealID, err := result.LastInsertId()
	if err != nil {
		log.Printf("Error getting appeal ID: %v", err)
		http.Error(w, "Failed to get appeal ID", http.StatusInternalServerError)
		return
	}

	// Fetch and return the created appeal
	var appeal struct {
		ID             int       `json:"id"`
		FacultyID      int       `json:"faculty_id"`
		TeacherMessage string    `json:"teacher_message"`
		AppealStatus   int       `json:"appeal_status"`
		HRMessage      *string   `json:"hr_message"`
		CreatedAt      time.Time `json:"created_at"`
		UpdatedAt      time.Time `json:"updated_at"`
	}

	selectQuery := `
		SELECT id, faculty_id, appeal_message, appeal_status, hr_message, created_at, updated_at
		FROM teacher_course_appeal
		WHERE id = ?
	`
	var hrMessage sql.NullString
	err = db.DB.QueryRow(selectQuery, appealID).Scan(
		&appeal.ID,
		&appeal.FacultyID,
		&appeal.TeacherMessage,
		&appeal.AppealStatus,
		&hrMessage,
		&appeal.CreatedAt,
		&appeal.UpdatedAt,
	)
	if err != nil {
		log.Printf("Error fetching created appeal: %v", err)
		// Still return success since it was created
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusCreated)
		json.NewEncoder(w).Encode(map[string]string{"message": "Appeal submitted successfully"})
		return
	}

	if hrMessage.Valid {
		appeal.HRMessage = &hrMessage.String
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(appeal)
}

// GetTeacherPendingAppeal checks if teacher has a pending appeal and returns details
func GetTeacherPendingAppeal(w http.ResponseWriter, r *http.Request) {
	facultyIDStr := r.URL.Query().Get("faculty_id")
	if facultyIDStr == "" {
		http.Error(w, "faculty_id is required", http.StatusBadRequest)
		return
	}

	facultyID, err := strconv.Atoi(facultyIDStr)
	if err != nil {
		http.Error(w, "Invalid faculty_id", http.StatusBadRequest)
		return
	}

	// Query for pending appeal details
	query := `
		SELECT id, faculty_id, appeal_message, appeal_status, hr_message, created_at, updated_at
		FROM teacher_course_appeal 
		WHERE faculty_id = ? AND appeal_status = 0
		ORDER BY created_at DESC
		LIMIT 1
	`
	
	var appeal struct {
		ID             int       `json:"id"`
		FacultyID      int       `json:"faculty_id"`
		TeacherMessage string    `json:"teacher_message"`
		AppealStatus   int       `json:"appeal_status"`
		HRMessage      *string   `json:"hr_message"`
		CreatedAt      time.Time `json:"created_at"`
		UpdatedAt      time.Time `json:"updated_at"`
	}

	var hrMessage sql.NullString
	err = db.DB.QueryRow(query, facultyID).Scan(
		&appeal.ID,
		&appeal.FacultyID,
		&appeal.TeacherMessage,
		&appeal.AppealStatus,
		&hrMessage,
		&appeal.CreatedAt,
		&appeal.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		// No pending appeal found
		response := map[string]interface{}{
			"has_pending_appeal": false,
			"appeal":             nil,
		}
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(response)
		return
	} else if err != nil {
		log.Printf("Error checking pending appeal: %v", err)
		http.Error(w, "Database error", http.StatusInternalServerError)
		return
	}

	// Set HR message if valid
	if hrMessage.Valid {
		appeal.HRMessage = &hrMessage.String
	}

	response := map[string]interface{}{
		"has_pending_appeal": true,
		"appeal":             appeal,
	}
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

// GetAllAppeals retrieves all appeals with optional status filter for HR
func GetAllAppeals(w http.ResponseWriter, r *http.Request) {
	statusFilter := r.URL.Query().Get("status")

	baseQuery := `
		SELECT 
			a.id, 
			a.faculty_id, 
			a.appeal_message, 
			a.appeal_status, 
			a.hr_action, 
			a.hr_message, 
			a.created_at, 
			a.updated_at,
			a.resolved_at,
			t.name AS teacher_name,
			t.email AS teacher_email
		FROM teacher_course_appeal a
		LEFT JOIN teachers t ON a.faculty_id = t.id
	`

	var rows *sql.Rows
	var err error

	if statusFilter == "pending" {
		rows, err = db.DB.Query(baseQuery + " WHERE a.appeal_status = 0 ORDER BY a.created_at DESC")
	} else if statusFilter == "resolved" {
		rows, err = db.DB.Query(baseQuery + " WHERE a.appeal_status = 1 ORDER BY a.updated_at DESC")
	} else {
		rows, err = db.DB.Query(baseQuery + " ORDER BY a.appeal_status ASC, a.created_at DESC")
	}

	if err != nil {
		log.Printf("Error fetching appeals: %v", err)
		http.Error(w, "Failed to fetch appeals", http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	type Appeal struct {
		ID            int            `json:"id"`
		FacultyID     int            `json:"faculty_id"`
		AppealMessage string         `json:"appeal_message"`
		AppealStatus  int            `json:"appeal_status"`
		HRAction      sql.NullString `json:"hr_action"`
		HRMessage     sql.NullString `json:"hr_message"`
		CreatedAt     time.Time      `json:"created_at"`
		UpdatedAt     time.Time      `json:"updated_at"`
		ResolvedAt    sql.NullTime   `json:"resolved_at"`
		TeacherName   string         `json:"teacher_name"`
		TeacherEmail  string         `json:"teacher_email"`
	}

	var appeals []Appeal
	for rows.Next() {
		var appeal Appeal
		err := rows.Scan(
			&appeal.ID,
			&appeal.FacultyID,
			&appeal.AppealMessage,
			&appeal.AppealStatus,
			&appeal.HRAction,
			&appeal.HRMessage,
			&appeal.CreatedAt,
			&appeal.UpdatedAt,
			&appeal.ResolvedAt,
			&appeal.TeacherName,
			&appeal.TeacherEmail,
		)
		if err != nil {
			log.Printf("Error scanning appeal row: %v", err)
			continue
		}
		appeals = append(appeals, appeal)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(appeals)
}

// UpdateAppealStatus updates appeal with HR decision
func UpdateAppealStatus(w http.ResponseWriter, r *http.Request) {
	appealIDStr := r.URL.Query().Get("appeal_id")
	if appealIDStr == "" {
		http.Error(w, "appeal_id is required", http.StatusBadRequest)
		return
	}

	appealID, err := strconv.Atoi(appealIDStr)
	if err != nil {
		http.Error(w, "Invalid appeal_id", http.StatusBadRequest)
		return
	}

	var requestData struct {
		HRAction  string `json:"hr_action"`
		HRMessage string `json:"hr_message"`
	}

	if err := json.NewDecoder(r.Body).Decode(&requestData); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	// Validate hr_action
	validActions := map[string]bool{"APPROVED": true, "REJECTED": true}
	if !validActions[requestData.HRAction] {
		http.Error(w, "hr_action must be APPROVED or REJECTED", http.StatusBadRequest)
		return
	}

	// Get faculty_id from appeal to verify it exists
	var facultyID int
	getQuery := `SELECT faculty_id FROM teacher_course_appeal WHERE id = ?`
	err = db.DB.QueryRow(getQuery, appealID).Scan(&facultyID)
	if err != nil {
		log.Printf("Error fetching appeal details: %v", err)
		http.Error(w, "Appeal not found", http.StatusNotFound)
		return
	}

	// Update appeal status
	updateQuery := `
		UPDATE teacher_course_appeal 
		SET appeal_status = 1, hr_action = ?, hr_message = ?, resolved_at = NOW(), updated_at = NOW()
		WHERE id = ?
	`
	_, err = db.DB.Exec(updateQuery, requestData.HRAction, requestData.HRMessage, appealID)
	if err != nil {
		log.Printf("Error updating appeal: %v", err)
		http.Error(w, "Failed to update appeal", http.StatusInternalServerError)
		return
	}

	log.Printf("Appeal %d resolved with action: %s for faculty %d", appealID, requestData.HRAction, facultyID)

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]string{
		"message":    "Appeal decision saved successfully",
		"hr_action":  requestData.HRAction,
		"faculty_id": fmt.Sprintf("%d", facultyID),
	})
}

// GetAppealByID retrieves a specific appeal with teacher details
func GetAppealByID(w http.ResponseWriter, r *http.Request) {
	appealIDStr := r.URL.Query().Get("appeal_id")
	if appealIDStr == "" {
		http.Error(w, "appeal_id is required", http.StatusBadRequest)
		return
	}

	appealID, err := strconv.Atoi(appealIDStr)
	if err != nil {
		http.Error(w, "Invalid appeal_id", http.StatusBadRequest)
		return
	}

	query := `
		SELECT 
			a.id, 
			a.faculty_id, 
			a.appeal_message, 
			a.appeal_status, 
			a.hr_action, 
			a.hr_message, 
			a.created_at, 
			a.updated_at,
			a.resolved_at,
			t.name AS teacher_name,
			t.email AS teacher_email
		FROM teacher_course_appeal a
		LEFT JOIN teachers t ON a.faculty_id = t.id
		WHERE a.id = ?
	`

	type AppealDetail struct {
		ID            int            `json:"id"`
		FacultyID     int            `json:"faculty_id"`
		AppealMessage string         `json:"appeal_message"`
		AppealStatus  int            `json:"appeal_status"`
		HRAction      sql.NullString `json:"hr_action"`
		HRMessage     sql.NullString `json:"hr_message"`
		CreatedAt     time.Time      `json:"created_at"`
		UpdatedAt     time.Time      `json:"updated_at"`
		ResolvedAt    sql.NullTime   `json:"resolved_at"`
		TeacherName   string         `json:"teacher_name"`
		TeacherEmail  string         `json:"teacher_email"`
	}

	var appeal AppealDetail
	err = db.DB.QueryRow(query, appealID).Scan(
		&appeal.ID,
		&appeal.FacultyID,
		&appeal.AppealMessage,
		&appeal.AppealStatus,
		&appeal.HRAction,
		&appeal.HRMessage,
		&appeal.CreatedAt,
		&appeal.UpdatedAt,
		&appeal.ResolvedAt,
		&appeal.TeacherName,
		&appeal.TeacherEmail,
	)

	if err == sql.ErrNoRows {
		http.Error(w, "Appeal not found", http.StatusNotFound)
		return
	} else if err != nil {
		log.Printf("Error fetching appeal: %v", err)
		http.Error(w, "Database error", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(appeal)
}

// GetTeacherAppealHistory retrieves all appeals (pending + resolved) for a specific teacher
func GetTeacherAppealHistory(w http.ResponseWriter, r *http.Request) {
	facultyIDStr := r.URL.Query().Get("faculty_id")
	if facultyIDStr == "" {
		http.Error(w, "faculty_id is required", http.StatusBadRequest)
		return
	}

	facultyID, err := strconv.Atoi(facultyIDStr)
	if err != nil {
		http.Error(w, "Invalid faculty_id", http.StatusBadRequest)
		return
	}

	query := `
		SELECT 
			id, 
			appeal_message, 
			appeal_status, 
			hr_action, 
			hr_message, 
			created_at, 
			updated_at,
			resolved_at
		FROM teacher_course_appeal
		WHERE faculty_id = ?
		ORDER BY created_at DESC
	`

	rows, err := db.DB.Query(query, facultyID)
	if err != nil {
		log.Printf("Error fetching teacher appeal history: %v", err)
		http.Error(w, "Database error", http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	type AppealHistory struct {
		ID            int            `json:"id"`
		AppealMessage string         `json:"appeal_message"`
		AppealStatus  int            `json:"appeal_status"`
		HRAction      sql.NullString `json:"hr_action"`
		HRMessage     sql.NullString `json:"hr_message"`
		CreatedAt     time.Time      `json:"created_at"`
		UpdatedAt     time.Time      `json:"updated_at"`
		ResolvedAt    sql.NullTime   `json:"resolved_at"`
	}

	var appeals []AppealHistory
	for rows.Next() {
		var appeal AppealHistory
		err := rows.Scan(
			&appeal.ID,
			&appeal.AppealMessage,
			&appeal.AppealStatus,
			&appeal.HRAction,
			&appeal.HRMessage,
			&appeal.CreatedAt,
			&appeal.UpdatedAt,
			&appeal.ResolvedAt,
		)
		if err != nil {
			log.Printf("Error scanning appeal history: %v", err)
			continue
		}
		appeals = append(appeals, appeal)
	}

	if appeals == nil {
		appeals = []AppealHistory{} // Return empty array instead of null
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(appeals)
}
