package studentteacher

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"server/db"
	"strings"
)

// ElectiveOption represents an available elective course
type ElectiveOption struct {
	CourseID   int    `json:"course_id"`
	CourseCode string `json:"course_code"`
	CourseName string `json:"course_name"`
	Credits    int    `json:"credits"`
	Category   string `json:"category"`
	SlotID     int    `json:"slot_id"`
	SlotName   string `json:"slot_name"`
}

// ElectiveSlot represents a group of electives for a specific slot
type ElectiveSlot struct {
	SlotID      int               `json:"slot_id"`
	SlotName    string            `json:"slot_name"`
	SlotType    string            `json:"slot_type"` // "PROFESSIONAL", "OPEN", or "MIXED"
	Courses     []ElectiveOption  `json:"courses"`
	IsActive    bool              `json:"is_active"`
}

// ElectivesBySlot represents electives organized by slots
type ElectivesBySlot struct {
	StudentID        int                `json:"student_id"`
	DepartmentID     int                `json:"department_id"`
	CurrentSemester  int                `json:"current_semester"`
	NextSemester     int                `json:"next_semester"`
	Batch            string             `json:"batch"`
	Slots            []ElectiveSlot     `json:"slots"`
	ExistingSelections map[string]int   `json:"existing_selections"` // slot_name -> course_id
}

// ElectiveSelection represents a student's elective choice
type ElectiveSelection struct {
	StudentID  int    `json:"student_id"`
	SemNo      int    `json:"sem_no"`
	CardType   string `json:"card_type"`
	CourseID   int    `json:"course_id"`
	CardID     int    `json:"card_id"`
}

// GetAvailableElectives returns electives available for a student based on HOD selections
func GetAvailableElectives(w http.ResponseWriter, r *http.Request) {
	// Get email from query parameter (from logged in user)
	email := r.URL.Query().Get("email")
	if email == "" {
		http.Error(w, "email parameter is required", http.StatusBadRequest)
		return
	}

	log.Printf("Fetching electives for email: %s", email)

	// Step 1: Get student_id from contact_details using student_email (email from users table)
	var studentID int
	err := db.DB.QueryRow(`
		SELECT student_id 
		FROM contact_details 
		WHERE student_email = ?
	`, email).Scan(&studentID)
	
	if err != nil {
		if err == sql.ErrNoRows {
			http.Error(w, "Student not found with this email", http.StatusNotFound)
		} else {
			log.Printf("Error fetching student from contact_details: %v", err)
			http.Error(w, "Database error", http.StatusInternalServerError)
		}
		return
	}

	log.Printf("Found student_id: %d", studentID)

	// Step 2: Get student's department_id from students table
	var departmentID int
	err = db.DB.QueryRow(`
		SELECT s.department_id 
		FROM students s
		WHERE s.id = ?
	`, studentID).Scan(&departmentID)
	
	if err != nil {
		if err == sql.ErrNoRows {
			log.Printf("Student not found in students table with id: %d", studentID)
			http.Error(w, fmt.Sprintf("Student not found in students table with id: %d", studentID), http.StatusNotFound)
		} else {
			log.Printf("Error fetching student department: %v", err)
			http.Error(w, "Database error", http.StatusInternalServerError)
		}
		return
	}

	log.Printf("Found department_id: %d", departmentID)

	// Step 3: Get semester and batch from academic_details
	var currentSemester int
	var batch string
	err = db.DB.QueryRow(`
		SELECT semester, batch 
		FROM academic_details 
		WHERE student_id = ?
	`, studentID).Scan(&currentSemester, &batch)
	
	if err != nil {
		if err == sql.ErrNoRows {
			log.Printf("Academic details not found for student_id: %d", studentID)
			http.Error(w, fmt.Sprintf("Academic details not found for student_id: %d", studentID), http.StatusNotFound)
		} else {
			log.Printf("Error fetching current semester and batch: %v", err)
			http.Error(w, "Database error", http.StatusInternalServerError)
		}
		return
	}

	nextSemester := currentSemester + 1
	log.Printf("Student department_id: %d, current semester: %d, next semester: %d, batch: %s", departmentID, currentSemester, nextSemester, batch)

	// Step 4: Get ALL elective slots for this semester, with their courses (if any)
	// FIXED QUERY: Only return courses explicitly assigned by HOD in hod_elective_selections
	// Show all slot headers even if empty, but only show courses that are assigned
	query := `
		SELECT 
			COALESCE(c.id, 0) as course_id,
			COALESCE(c.course_code, '') as course_code,
			COALESCE(c.course_name, '') as course_name,
			COALESCE(c.credit, 0) as credits,
			COALESCE(c.category, '') as category,
			ess.id as slot_id,
			ess.slot_name,
			ess.is_active,
			ess.slot_order
		FROM elective_semester_slots ess
		LEFT JOIN hod_elective_selections hes ON ess.id = hes.slot_id 
			AND hes.semester = ?
			AND hes.department_id = ?
			AND (hes.batch = ? OR hes.batch IS NULL)
			AND hes.status = 'ACTIVE'
		LEFT JOIN courses c ON hes.course_id = c.id
		LEFT JOIN student_courses sc ON sc.course_id = c.id AND sc.student_id = ?
		WHERE ess.semester = ?
		AND ess.is_active = 1
		AND (hes.course_id IS NULL OR sc.id IS NULL)
		ORDER BY ess.slot_order, ess.slot_name, c.category, c.course_code
	`

	// Log query parameters for debugging
	log.Printf("Executing electives query with params: semester=%d, dept=%d, batch=%s, studentID=%d", 
		nextSemester, departmentID, batch, studentID)
	log.Printf("FULL QUERY:\n%s", query)
	
	rows, err := db.DB.Query(query, nextSemester, departmentID, batch, studentID, nextSemester)
	if err != nil {
		log.Printf("Error fetching available electives: %v", err)
		http.Error(w, "Database error", http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	// Map to group courses by slot
	slotMap := make(map[int]*ElectiveSlot)
	var slotOrderList []int // To maintain order
	courseCount := 0
	rowCount := 0

	for rows.Next() {
		rowCount++
		var elective ElectiveOption
		var isActive bool
		var slotOrder int
		err := rows.Scan(
			&elective.CourseID,
			&elective.CourseCode,
			&elective.CourseName,
			&elective.Credits,
			&elective.Category,
			&elective.SlotID,
			&elective.SlotName,
			&isActive,
			&slotOrder,
		)
		if err != nil {
			log.Printf("Error scanning elective: %v", err)
			continue
		}

		// Log each row for debugging
		log.Printf("Row %d: slot_id=%d (%s), course_id=%d (%s)", 
			rowCount, elective.SlotID, elective.SlotName, elective.CourseID, elective.CourseCode)

		// Create slot if it doesn't exist
		if _, exists := slotMap[elective.SlotID]; !exists {
			slotType := determineSlotType(elective.SlotName, elective.Category)
			slotMap[elective.SlotID] = &ElectiveSlot{
				SlotID:   elective.SlotID,
				SlotName: elective.SlotName,
				SlotType: slotType,
				Courses:  []ElectiveOption{},
				IsActive: isActive,
			}
			slotOrderList = append(slotOrderList, elective.SlotID)
			log.Printf("  -> Created slot: %s (slot_id: %d, slot_type: %s)", elective.SlotName, elective.SlotID, slotType)
		}

		// Only add course if it exists (course_id > 0)
		if elective.CourseID > 0 {
			courseCount++
			log.Printf("  -> Adding course #%d: %s - %s to slot %d", 
				courseCount, elective.CourseCode, elective.CourseName, elective.SlotID)
			// Add course to the slot
			slotMap[elective.SlotID].Courses = append(slotMap[elective.SlotID].Courses, elective)
		} else {
			log.Printf("  -> Empty slot (no courses assigned)")
		}
	}

	// Convert map to ordered slice
	var slots []ElectiveSlot
	for _, slotID := range slotOrderList {
		slots = append(slots, *slotMap[slotID])
	}

	// Handle mixed slots (last professional elective can include open electives)
	slots = handleMixedSlots(slots, nextSemester)

	// Fetch existing selections for this student and semester
	existingSelections := make(map[string]int)
	selectionRows, err := db.DB.Query(`
		SELECT ess.slot_name, hes.course_id
		FROM student_elective_choices sec
		INNER JOIN hod_elective_selections hes ON sec.hod_selection_id = hes.id
		INNER JOIN elective_semester_slots ess ON hes.slot_id = ess.id
		WHERE sec.student_id = ? AND sec.semester = ?
	`, studentID, nextSemester)
	
	if err != nil {
		log.Printf("Warning: Could not fetch existing selections: %v", err)
	} else {
		defer selectionRows.Close()
		for selectionRows.Next() {
			var slotName string
			var courseID int
			if err := selectionRows.Scan(&slotName, &courseID); err != nil {
				log.Printf("Error scanning selection: %v", err)
				continue
			}
			existingSelections[slotName] = courseID
		}
		log.Printf("Found %d existing selections for student", len(existingSelections))
	}

	log.Printf("Processed %d rows from query, found %d courses in %d elective slots for next semester %d, batch %s", rowCount, courseCount, len(slots), nextSemester, batch)
	for i, slot := range slots {
		log.Printf("Slot %d: %s (%s) with %d courses", i+1, slot.SlotName, slot.SlotType, len(slot.Courses))
	}

	response := ElectivesBySlot{
		StudentID:          studentID,
		DepartmentID:       departmentID,
		CurrentSemester:    currentSemester,
		NextSemester:       nextSemester,
		Batch:              batch,
		Slots:              slots,
		ExistingSelections: existingSelections,
	}

	w.Header().Set("Content-Type", "application/json")
	if err := json.NewEncoder(w).Encode(response); err != nil {
		log.Printf("Error encoding response: %v", err)
		http.Error(w, "Error encoding response", http.StatusInternalServerError)
		return
	}
	log.Printf("Successfully sent response with %d slots", len(slots))
}

// SaveElectiveSelections saves a student's elective choices
func SaveElectiveSelections(w http.ResponseWriter, r *http.Request) {
	// Get email from query parameter
	email := r.URL.Query().Get("email")
	if email == "" {
		http.Error(w, "email parameter is required", http.StatusBadRequest)
		return
	}

	log.Printf("Saving elective selections for email: %s", email)

	// Get student_id from contact_details using student_email
	var studentID int
	err := db.DB.QueryRow(`
		SELECT student_id 
		FROM contact_details 
		WHERE student_email = ?
	`, email).Scan(&studentID)
	
	if err != nil {
		if err == sql.ErrNoRows {
			http.Error(w, "Student not found with this email", http.StatusNotFound)
		} else {
			log.Printf("Error fetching student: %v", err)
			http.Error(w, "Database error", http.StatusInternalServerError)
		}
		return
	}

	var requestBody struct {
		Selections map[string]int `json:"selections"` // electiveKey -> courseID
		Semester   int             `json:"semester"`
	}

	if err := json.NewDecoder(r.Body).Decode(&requestBody); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	// Validate selections
	if len(requestBody.Selections) == 0 {
		http.Error(w, "No selections provided", http.StatusBadRequest)
		return
	}

	// Get student's department_id and batch for finding hod_selection_id
	var departmentID int
	var batch string
	err = db.DB.QueryRow(`
		SELECT s.department_id, ad.batch
		FROM students s
		INNER JOIN academic_details ad ON s.id = ad.student_id
		WHERE s.id = ?
	`, studentID).Scan(&departmentID, &batch)
	
	if err != nil {
		log.Printf("Error fetching student department and batch: %v", err)
		http.Error(w, "Database error", http.StatusInternalServerError)
		return
	}

	// Get current academic year (basic calculation, can be enhanced)
	var academicYear string
	err = db.DB.QueryRow(`
		SELECT academic_year 
		FROM academic_details 
		WHERE student_id = ?
	`, studentID).Scan(&academicYear)
	
	if err != nil {
		log.Printf("Warning: Could not fetch academic year, using default: %v", err)
		academicYear = "2024-2025" // Default fallback
	}

	// Start transaction
	tx, err := db.DB.Begin()
	if err != nil {
		log.Printf("Error starting transaction: %v", err)
		http.Error(w, "Database error", http.StatusInternalServerError)
		return
	}
	defer tx.Rollback()

	// Delete existing selections for this student and semester (allow updates)
	_, err = tx.Exec(`
		DELETE FROM student_elective_choices 
		WHERE student_id = ? AND semester = ?
	`, studentID, requestBody.Semester)
	if err != nil {
		log.Printf("Error deleting existing selections: %v", err)
		http.Error(w, "Database error", http.StatusInternalServerError)
		return
	}

	// Insert new selections
	// ONLY insert if course is in hod_elective_selections for this department, semester, and batch (or NULL batch)
	// Also validate that the slot is active
	stmt, err := tx.Prepare(`
		INSERT INTO student_elective_choices 
		(student_id, hod_selection_id, semester, academic_year, status) 
		SELECT ?, hes.id, ?, ?, 'PENDING'
		FROM hod_elective_selections hes
		LEFT JOIN elective_semester_slots ess ON hes.slot_id = ess.id
		WHERE hes.department_id = ? 
		AND hes.course_id = ?
		AND hes.semester = ?
		AND (hes.batch = ? OR hes.batch IS NULL)
		AND hes.status = 'ACTIVE'
		AND (hes.slot_id IS NULL OR ess.is_active = 1)
		LIMIT 1
	`)
	if err != nil {
		log.Printf("Error preparing statement: %v", err)
		http.Error(w, "Database error", http.StatusInternalServerError)
		return
	}
	defer stmt.Close()

	// Prepare statement for inserting into student_courses table
	courseStmt, err := tx.Prepare(`
		INSERT IGNORE INTO student_courses (student_id, course_id)
		VALUES (?, ?)
	`)
	if err != nil {
		log.Printf("Error preparing student_courses statement: %v", err)
		http.Error(w, "Database error", http.StatusInternalServerError)
		return
	}
	defer courseStmt.Close()

	successCount := 0
	for _, courseID := range requestBody.Selections {
		result, err := stmt.Exec(studentID, requestBody.Semester, academicYear, departmentID, courseID, requestBody.Semester, batch)
		if err != nil {
			log.Printf("Error inserting selection for course_id %d: %v", courseID, err)
			http.Error(w, fmt.Sprintf("Failed to save selection: %v", err), http.StatusInternalServerError)
			return
		}
		
		rowsAffected, _ := result.RowsAffected()
		if rowsAffected == 0 {
			log.Printf("Warning: No valid hod_selection found for course_id %d in department %d, batch %s (slot may be inactive)", courseID, departmentID, batch)
		} else {
			// If the elective choice was successfully inserted, also add to student_courses table
			_, err = courseStmt.Exec(studentID, courseID)
			if err != nil {
				log.Printf("Error inserting into student_courses for course_id %d: %v", courseID, err)
				http.Error(w, fmt.Sprintf("Failed to add course to student record: %v", err), http.StatusInternalServerError)
				return
			}
			successCount++
			log.Printf("Successfully added course_id %d to student_courses for student_id %d", courseID, studentID)
		}
	}

	// Commit transaction
	if err = tx.Commit(); err != nil {
		log.Printf("Error committing transaction: %v", err)
		http.Error(w, "Database error", http.StatusInternalServerError)
		return
	}

	log.Printf("Successfully saved %d elective selections for student_id %d", successCount, studentID)

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"message":       "Selections saved successfully",
		"courses_saved": successCount,
	})
}

// GetStudentElectiveSelections retrieves a student's saved elective choices
func GetStudentElectiveSelections(w http.ResponseWriter, r *http.Request) {
	// Get email from query parameter
	email := r.URL.Query().Get("email")
	if email == "" {
		http.Error(w, "email parameter is required", http.StatusBadRequest)
		return
	}

	log.Printf("Fetching saved selections for email: %s", email)

	// Get student_id from contact_details using student_email
	var studentID int
	err := db.DB.QueryRow(`
		SELECT student_id 
		FROM contact_details 
		WHERE student_email = ?
	`, email).Scan(&studentID)
	
	if err != nil {
		if err == sql.ErrNoRows {
			http.Error(w, "Student not found with this email", http.StatusNotFound)
		} else {
			log.Printf("Error fetching student: %v", err)
			http.Error(w, "Database error", http.StatusInternalServerError)
		}
		return
	}

	query := `
		SELECT 
			sec.choice_id,
			sec.course_id,
			sec.semester,
			c.course_code,
			c.course_name,
			c.credits,
			c.category,
			sec.selected_at
		FROM student_elective_choices sec
		INNER JOIN courses c ON sec.course_id = c.course_id
		WHERE sec.student_id = ?
		ORDER BY sec.semester, c.course_code
	`

	rows, err := db.DB.Query(query, studentID)
	if err != nil {
		log.Printf("Error fetching student selections: %v", err)
		http.Error(w, "Database error", http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	var selections []map[string]interface{}
	for rows.Next() {
		var (
			choiceID   int
			courseID   int
			semester   int
			courseCode string
			courseName string
			credits    int
			category   string
			selectedAt string
		)

		err := rows.Scan(
			&choiceID, &courseID, &semester, &courseCode, 
			&courseName, &credits, &category, &selectedAt,
		)
		if err != nil {
			log.Printf("Error scanning selection: %v", err)
			continue
		}

		selections = append(selections, map[string]interface{}{
			"choice_id":   choiceID,
			"course_id":   courseID,
			"semester":    semester,
			"course_code": courseCode,
			"course_name": courseName,
			"credits":     credits,
			"category":    category,
			"selected_at": selectedAt,
		})
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(selections)
}

// Helper function to determine slot type based on slot name and category
func determineSlotType(slotName, category string) string {
	slotNameLower := strings.ToLower(strings.TrimSpace(slotName))
	
	log.Printf("Determining slot type for: '%s' (lowercase: '%s')", slotName, slotNameLower)
	
	// Determine slot type ONLY by slot name from elective_semester_slots table
	// NOT by course category - this ensures correct typing even with mixed courses
	
	// Check for honour/minor/addon first (most specific)
	// Check if the slot name starts with these keywords
	if strings.HasPrefix(slotNameLower, "honour") || 
	   strings.HasPrefix(slotNameLower, "honor") ||
	   strings.Contains(slotNameLower, "honour slot") ||
	   strings.Contains(slotNameLower, "honor slot") {
		log.Printf("  -> Detected as HONOR")
		return "HONOR"
	}
	
	if strings.HasPrefix(slotNameLower, "minor") || strings.Contains(slotNameLower, "minor slot") {
		log.Printf("  -> Detected as MINOR")
		return "MINOR"
	}
	
	if strings.HasPrefix(slotNameLower, "addon") || 
	   strings.HasPrefix(slotNameLower, "add-on") ||
	   strings.Contains(slotNameLower, "addon slot") ||
	   strings.Contains(slotNameLower, "add-on slot") {
		log.Printf("  -> Detected as ADDON")
		return "ADDON"
	}
	
	// Then check for open electives
	if strings.Contains(slotNameLower, "open") {
		log.Printf("  -> Detected as OPEN")
		return "OPEN"
	}
	
	// Then check for professional electives
	if strings.Contains(slotNameLower, "professional") {
		log.Printf("  -> Detected as PROFESSIONAL")
		return "PROFESSIONAL"
	}
	
	// Default to professional if it contains "elective" but not "open"
	if strings.Contains(slotNameLower, "elective") {
		log.Printf("  -> Detected as PROFESSIONAL (contains 'elective')")
		return "PROFESSIONAL"
	}
	
	// Default to professional if unclear
	log.Printf("  -> Defaulting to PROFESSIONAL")
	return "PROFESSIONAL"
}

// Helper function to handle mixed slots
// If there are multiple professional electives in a semester and open electives exist,
// the last professional elective slot can include both professional and open electives
func handleMixedSlots(slots []ElectiveSlot, semester int) []ElectiveSlot {
	if len(slots) == 0 {
		return slots
	}

	// Count professional slots and check for dedicated "Open Elective" slot
	var professionalSlots []*ElectiveSlot
	var dedicatedOpenExists bool

	for i := range slots {
		if slots[i].SlotType == "PROFESSIONAL" {
			professionalSlots = append(professionalSlots, &slots[i])
		} else if slots[i].SlotType == "OPEN" {
			// This is a dedicated "Open Elective" slot from database
			dedicatedOpenExists = true
		}
	}

	// Check if we need to merge: multiple PEs, no dedicated open slot
	if len(professionalSlots) > 1 && !dedicatedOpenExists {
		lastProfSlot := professionalSlots[len(professionalSlots)-1]
		
		// Check if the last PE slot contains any open elective courses
		hasOpenElectives := false
		for _, course := range lastProfSlot.Courses {
			if strings.Contains(strings.ToLower(course.Category), "open") {
				hasOpenElectives = true
				break
			}
		}
		
		// If last PE slot has open electives, mark it as MIXED (don't change slot name)
		if hasOpenElectives {
			lastProfSlot.SlotType = "MIXED"
			log.Printf("Marked last professional slot as MIXED (%s) for semester %d", lastProfSlot.SlotName, semester)
		} else {
			log.Printf("Last PE slot has no open electives, keeping separate for semester %d", semester)
		}
	} else if dedicatedOpenExists {
		log.Printf("Keeping dedicated Open Elective slot separate for semester %d", semester)
	} else {
		log.Printf("Only 1 PE slot, keeping all %d slots separate for semester %d", len(slots), semester)
	}
	
	return slots
}
