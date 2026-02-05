package curriculum

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"
	"server/db"
	"server/models"
	"strconv"
	"strings"
	"time"
)

// GetHODProfile retrieves HOD's department and curriculum information
func GetHODProfile(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	if r.Method != http.MethodGet {
		w.WriteHeader(http.StatusMethodNotAllowed)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "Method not allowed",
		})
		return
	}

	// Get user email from query or session (for now using query param)
	email := r.URL.Query().Get("email")
	if email == "" {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "Email parameter required",
		})
		return
	}

	// Query to get HOD's department and curriculum
	query := `
		SELECT 
			u.id as user_id,
			u.username,
			u.email,
			u.role,
			d.id as dept_id,
			d.department_name,
			d.department_code,
			c.id as curr_id,
			c.name as curr_name,
			c.academic_year
		FROM users u
		INNER JOIN teachers t ON u.email = t.email
		INNER JOIN department_teachers dt ON t.faculty_id = dt.teacher_id
		INNER JOIN departments d ON dt.department_id = d.id
		LEFT JOIN department_curriculum_active dca ON d.id = dca.department_id AND dca.is_active = 1
		LEFT JOIN curriculum c ON dca.curriculum_id = c.id
		WHERE u.email = ? AND u.role = 'hod' AND u.is_active = 1
		LIMIT 1
	`

	var response models.HODProfileResponse
	var deptID int
	var deptName string
	var deptCode sql.NullString
	var currID sql.NullInt64
	var currName, currYear sql.NullString

	err := db.DB.QueryRow(query, email).Scan(
		&response.UserID,
		&response.FullName,
		&response.Email,
		&response.Role,
		&deptID,
		&deptName,
		&deptCode,
		&currID,
		&currName,
		&currYear,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			w.WriteHeader(http.StatusNotFound)
			json.NewEncoder(w).Encode(map[string]interface{}{
				"success": false,
				"message": "HOD profile not found. Please contact admin to link your account.",
			})
			return
		}
		log.Println("Error fetching HOD profile:", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "Internal server error",
		})
		return
	}

	// Initialize nested structs
	response.Department = &models.DepartmentInfo{
		ID:   deptID,
		Name: deptName,
	}
	if deptCode.Valid {
		response.Department.Code = deptCode.String
	}

	if currID.Valid {
		response.Curriculum = &models.CurriculumInfo{
			ID:           int(currID.Int64),
			Name:         currName.String,
			AcademicYear: currYear.String,
		}
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(response)
}

// GetAvailableElectives retrieves available elective courses for a semester
func GetAvailableElectives(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	if r.Method != http.MethodGet {
		w.WriteHeader(http.StatusMethodNotAllowed)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "Method not allowed",
		})
		return
	}

	// Get parameters
	email := r.URL.Query().Get("email")
	batch := r.URL.Query().Get("batch")
	academicYear := r.URL.Query().Get("academic_year")

	if email == "" {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "Email parameter required",
		})
		return
	}

	// Get HOD's department and curriculum
	var departmentID, curriculumID int
	deptQuery := `
		SELECT d.id, COALESCE(dca.curriculum_id, 0)
		FROM users u
		INNER JOIN teachers t ON u.email = t.email
		INNER JOIN department_teachers dt ON t.faculty_id = dt.teacher_id
		INNER JOIN departments d ON dt.department_id = d.id
		LEFT JOIN department_curriculum_active dca ON d.id = dca.department_id AND dca.is_active = 1
		WHERE u.email = ? AND u.role = 'hod'
		LIMIT 1
	`

	err := db.DB.QueryRow(deptQuery, email).Scan(&departmentID, &curriculumID)
	if err != nil {
		log.Println("Error fetching department:", err)
		w.WriteHeader(http.StatusNotFound)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "Department not found",
		})
		return
	}

	// Query vertical card courses with semester assignments
	query := `
		SELECT 
			c.id,
			c.course_code,
			c.course_name,
			c.course_type,
			COALESCE(c.category, '') as category,
			COALESCE(c.credit, 0) as credit,
			nc.id as card_id,
			nc.card_type,
			CASE WHEN hes.id IS NOT NULL THEN 1 ELSE 0 END as is_selected,
			hes.semester as assigned_semester,
			hes.slot_id as assigned_slot_id,
			ess.slot_name as assigned_slot
		FROM courses c
		INNER JOIN curriculum_courses cc ON c.id = cc.course_id
		INNER JOIN normal_cards nc ON cc.semester_id = nc.id
		LEFT JOIN hod_elective_selections hes ON (
			hes.course_id = c.id
			AND hes.department_id = ?
			AND hes.academic_year = ?
			AND (hes.batch = ? OR hes.batch IS NULL OR ? = '')
			AND hes.status = 'ACTIVE'
		)
		LEFT JOIN elective_semester_slots ess ON hes.slot_id = ess.id
		WHERE cc.curriculum_id = ?
			AND nc.card_type = 'vertical'
			AND c.status = 1
			AND nc.status = 1
		ORDER BY c.course_type, c.course_code
	`

	rows, err := db.DB.Query(query, departmentID, academicYear, batch, batch, curriculumID)
	if err != nil {
		log.Println("Error fetching electives:", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "Internal server error",
		})
		return
	}
	defer rows.Close()

	electives := []models.ElectiveCourse{}
	for rows.Next() {
		var course models.ElectiveCourse
		var isSelected int
		var assignedSemester sql.NullInt64
		var assignedSlotID sql.NullInt64
		var assignedSlot sql.NullString
		err := rows.Scan(
			&course.ID,
			&course.CourseCode,
			&course.CourseName,
			&course.CourseType,
			&course.Category,
			&course.Credit,
			&course.CardID,
			&course.CardType,
			&isSelected,
			&assignedSemester,
			&assignedSlotID,
			&assignedSlot,
		)
		if err != nil {
			log.Println("Error scanning course:", err)
			continue
		}
		course.IsSelected = isSelected == 1
		if assignedSemester.Valid {
			sem := int(assignedSemester.Int64)
			course.AssignedSemester = &sem
		}
		if assignedSlotID.Valid {
			slotID := int(assignedSlotID.Int64)
			course.AssignedSlotID = &slotID
		}
		if assignedSlot.Valid {
			slot := assignedSlot.String
			course.AssignedSlot = &slot
		}
		electives = append(electives, course)
	}

	response := models.AvailableElectivesResponse{
		Semester:           0, // Not applicable - showing all vertical courses
		Batch:              batch,
		AcademicYear:       academicYear,
		AvailableElectives: electives,
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(response)
}

// SaveHODSelections saves HOD's elective course selections
func SaveHODSelections(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

	if r.Method == http.MethodOptions {
		w.WriteHeader(http.StatusOK)
		return
	}

	if r.Method != http.MethodPost {
		w.WriteHeader(http.StatusMethodNotAllowed)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "Method not allowed",
		})
		return
	}

	// Get email from query (in production, get from JWT token)
	email := r.URL.Query().Get("email")
	if email == "" {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "Email parameter required",
		})
		return
	}

	var req models.SaveElectivesRequest
	err := json.NewDecoder(r.Body).Decode(&req)
	if err != nil {
		log.Println("Error decoding request:", err)
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "Invalid request body",
		})
		return
	}

	// Validate semester assignments
	if len(req.CourseAssignments) == 0 {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "No course assignments provided",
		})
		return
	}

	for _, assignment := range req.CourseAssignments {
		if assignment.Semester < 4 || assignment.Semester > 8 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{
				"success": false,
				"message": "Invalid semester (must be 4-8)",
			})
			return
		}
		if assignment.SlotID == 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{
				"success": false,
				"message": "Slot ID is required for each assignment",
			})
			return
		}
	}

	// Get HOD's user ID, department, and curriculum
	var userID, departmentID, curriculumID int
	deptQuery := `
		SELECT u.id, d.id, COALESCE(dca.curriculum_id, 0)
		FROM users u
		INNER JOIN teachers t ON u.email = t.email
		INNER JOIN department_teachers dt ON t.faculty_id = dt.teacher_id
		INNER JOIN departments d ON dt.department_id = d.id
		LEFT JOIN department_curriculum_active dca ON d.id = dca.department_id AND dca.is_active = 1
		WHERE u.email = ? AND u.role = 'hod'
		LIMIT 1
	`

	err = db.DB.QueryRow(deptQuery, email).Scan(&userID, &departmentID, &curriculumID)
	if err != nil {
		log.Println("Error fetching HOD info:", err)
		w.WriteHeader(http.StatusNotFound)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "HOD profile not found",
		})
		return
	}

	if curriculumID == 0 {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "No active curriculum configured for your department",
		})
		return
	}

	// Start transaction
	tx, err := db.DB.Begin()
	if err != nil {
		log.Println("Error starting transaction:", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "Internal server error",
		})
		return
	}
	defer tx.Rollback()

	// Delete existing selections for this department/batch/year
	deleteQuery := `
		DELETE FROM hod_elective_selections 
		WHERE department_id = ? 
		AND academic_year = ?
		AND (batch = ? OR (batch IS NULL AND ? = ''))
	`
	_, err = tx.Exec(deleteQuery, departmentID, req.AcademicYear, req.Batch, req.Batch)
	if err != nil {
		log.Println("Error deleting old selections:", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "Error clearing previous selections",
		})
		return
	}

	// Insert new selections with semester assignments
	if len(req.CourseAssignments) > 0 {
		insertQuery := `
			INSERT INTO hod_elective_selections 
			(department_id, curriculum_id, semester, course_id, slot_id, academic_year, batch, approved_by_user_id, status, created_at, updated_at)
			VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
		`

		now := time.Now()
		status := req.Status
		if status == "" {
			status = "ACTIVE"
		}

		for _, assignment := range req.CourseAssignments {
			var batchVal interface{}
			if req.Batch != "" {
				batchVal = req.Batch
			} else {
				batchVal = nil
			}

			_, err = tx.Exec(insertQuery,
				departmentID,
				curriculumID,
				assignment.Semester,
				assignment.CourseID,
				assignment.SlotID,
				req.AcademicYear,
				batchVal,
				userID,
				status,
				now,
				now,
			)
			if err != nil {
				log.Println("Error inserting selection:", err)
				w.WriteHeader(http.StatusInternalServerError)
				json.NewEncoder(w).Encode(map[string]interface{}{
					"success": false,
					"message": "Error saving selections",
				})
				return
			}
		}
	}

	// Commit transaction
	err = tx.Commit()
	if err != nil {
		log.Println("Error committing transaction:", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "Error saving selections",
		})
		return
	}

	message := "Elective selections saved successfully"
	if len(req.CourseAssignments) > 0 {
		message = strconv.Itoa(len(req.CourseAssignments)) + " elective courses assigned to semesters"
	} else {
		message = "All elective selections cleared"
	}

	response := models.SaveElectivesResponse{
		Success: true,
		Message: message,
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(response)
}

// GetHODBatches retrieves all batches for the HOD's department
func GetHODBatches(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	if r.Method != http.MethodGet {
		w.WriteHeader(http.StatusMethodNotAllowed)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "Method not allowed",
		})
		return
	}

	email := r.URL.Query().Get("email")
	if email == "" {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "Email parameter required",
		})
		return
	}

	// Get batches from academic_details table
	query := `
		SELECT DISTINCT ad.batch
		FROM academic_details ad
		INNER JOIN departments d ON ad.department = d.department_name
		INNER JOIN department_teachers dt ON d.id = dt.department_id
		INNER JOIN teachers t ON dt.teacher_id = t.faculty_id
		INNER JOIN users u ON t.email = u.email
		WHERE u.email = ? AND u.role = 'hod' AND ad.batch IS NOT NULL AND ad.batch != ''
		ORDER BY ad.batch DESC
	`

	rows, err := db.DB.Query(query, email)
	if err != nil {
		log.Println("Error fetching batches:", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "Internal server error",
		})
		return
	}
	defer rows.Close()

	var batches []string
	for rows.Next() {
		var batch string
		err := rows.Scan(&batch)
		if err != nil {
			log.Println("Error scanning batch:", err)
			continue
		}
		// Clean batch string
		batch = strings.TrimSpace(batch)
		if batch != "" {
			batches = append(batches, batch)
		}
	}

	// If no batches found, provide a default
	if len(batches) == 0 {
		batches = []string{"2024-2028", "2025-2029"}
	}

	response := models.BatchesResponse{
		Batches: batches,
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(response)
}

// GetElectiveSemesterSlots returns available elective slots by semester
func GetElectiveSemesterSlots(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	if r.Method != http.MethodGet {
		w.WriteHeader(http.StatusMethodNotAllowed)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "Method not allowed",
		})
		return
	}

	semesterParam := r.URL.Query().Get("semester")
	query := `
		SELECT id, semester, slot_name, slot_order
		FROM elective_semester_slots
		WHERE is_active = 1
	`
	args := []interface{}{}
	if semesterParam != "" {
		semester, err := strconv.Atoi(semesterParam)
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{
				"success": false,
				"message": "Invalid semester",
			})
			return
		}
		query += " AND semester = ?"
		args = append(args, semester)
	}
	query += " ORDER BY semester, slot_order"

	rows, err := db.DB.Query(query, args...)
	if err != nil {
		log.Println("Error fetching elective slots:", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "Internal server error",
		})
		return
	}
	defer rows.Close()

	slots := []models.ElectiveSemesterSlot{}
	for rows.Next() {
		var slot models.ElectiveSemesterSlot
		if err := rows.Scan(&slot.ID, &slot.Semester, &slot.SlotName, &slot.SlotOrder); err != nil {
			log.Println("Error scanning elective slot:", err)
			continue
		}
		slots = append(slots, slot)
	}

	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"slots":   slots,
	})
}

// GetCurrentAcademicCalendar retrieves the current academic calendar
func GetCurrentAcademicCalendar(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	if r.Method != http.MethodGet {
		w.WriteHeader(http.StatusMethodNotAllowed)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "Method not allowed",
		})
		return
	}

	query := `
		SELECT id, academic_year, current_semester, semester_start_date, semester_end_date,
		       elective_selection_start, elective_selection_end, is_current, created_at, updated_at
		FROM academic_calendar
		WHERE is_current = 1
		LIMIT 1
	`

	var calendar models.AcademicCalendar
	err := db.DB.QueryRow(query).Scan(
		&calendar.ID,
		&calendar.AcademicYear,
		&calendar.CurrentSemester,
		&calendar.SemesterStartDate,
		&calendar.SemesterEndDate,
		&calendar.ElectiveSelectionStart,
		&calendar.ElectiveSelectionEnd,
		&calendar.IsCurrent,
		&calendar.CreatedAt,
		&calendar.UpdatedAt,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			// Return default if no calendar found
			w.WriteHeader(http.StatusOK)
			json.NewEncoder(w).Encode(map[string]interface{}{
				"academic_year":    "2025-2026",
				"current_semester": 4,
			})
			return
		}
		log.Println("Error fetching academic calendar:", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "Internal server error",
		})
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(calendar)
}
