package studentteacher

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"server/db"
	"server/models"
	"strconv"
)

// GetMappingFilters retrieves departments and available years for filtering
func GetMappingFilters(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	type FilterResponse struct {
		Departments []struct {
			ID   int    `json:"id"`
			Name string `json:"name"`
		} `json:"departments"`
		Years []int `json:"years"`
	}

	response := FilterResponse{
		Departments: make([]struct {
			ID   int    `json:"id"`
			Name string `json:"name"`
		}, 0),
		Years: []int{2024, 2025, 2026, 2027, 2028},
	}

	// Get departments
	deptQuery := `SELECT id, department_name FROM departments WHERE status = 1 ORDER BY department_name`
	rows, err := db.DB.Query(deptQuery)
	if err != nil {
		log.Printf("Error fetching departments: %v", err)
		http.Error(w, "Failed to fetch departments", http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	for rows.Next() {
		var dept struct {
			ID   int    `json:"id"`
			Name string `json:"name"`
		}
		if err := rows.Scan(&dept.ID, &dept.Name); err != nil {
			log.Printf("Error scanning department: %v", err)
			continue
		}
		response.Departments = append(response.Departments, dept)
	}

	json.NewEncoder(w).Encode(response)
}

// GetMappingData retrieves teachers and students for a specific department and year
func GetMappingData(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	departmentID := r.URL.Query().Get("department_id")
	year := r.URL.Query().Get("year")
	academicYear := r.URL.Query().Get("academic_year")

	if departmentID == "" || year == "" {
		http.Error(w, "department_id and year are required", http.StatusBadRequest)
		return
	}

	type MappingData struct {
		Teachers []models.TeacherWithStudentCount `json:"teachers"`
		Students []models.StudentWithMapping      `json:"students"`
	}

	data := MappingData{
		Teachers: make([]models.TeacherWithStudentCount, 0),
		Students: make([]models.StudentWithMapping, 0),
	}

	// Get teachers in this department
	teacherQuery := `
		SELECT 
			t.id, 
			t.name, 
			COALESCE(t.email, ''),
			COALESCE(t.profile_img, ''),
			COALESCE(t.desg, ''),
			COALESCE(COUNT(stm.id), 0) as student_count
		FROM teachers t
		INNER JOIN department_teachers dt ON t.id = dt.teacher_id
		LEFT JOIN student_teacher_mapping stm ON t.id = stm.teacher_id 
			AND stm.department_id = ? 
			AND stm.year = ?
			` + func() string {
		if academicYear != "" {
			return `AND stm.academic_year = ?`
		}
		return ""
	}() + `
		WHERE dt.department_id = ? AND t.status = 1 AND dt.status = 1
		GROUP BY t.id, t.name, t.email, t.profile_img, t.desg
		ORDER BY t.name
	`

	var teacherRows *sql.Rows
	var err error

	if academicYear != "" {
		teacherRows, err = db.DB.Query(teacherQuery, departmentID, year, academicYear, departmentID)
	} else {
		teacherRows, err = db.DB.Query(teacherQuery, departmentID, year, departmentID)
	}

	if err != nil {
		log.Printf("Error fetching teachers: %v", err)
		http.Error(w, "Failed to fetch teachers", http.StatusInternalServerError)
		return
	}
	defer teacherRows.Close()

	for teacherRows.Next() {
		var teacher models.TeacherWithStudentCount
		if err := teacherRows.Scan(
			&teacher.TeacherID,
			&teacher.TeacherName,
			&teacher.Email,
			&teacher.ProfileImg,
			&teacher.Designation,
			&teacher.StudentCount,
		); err != nil {
			log.Printf("Error scanning teacher: %v", err)
			continue
		}
		data.Teachers = append(data.Teachers, teacher)
	}

	// Get students in this department and year
	studentQuery := `
		SELECT 
			s.student_id,
			COALESCE(s.enrollment_no, ''),
			s.student_name,
			COALESCE(ad.department, ''),
			COALESCE(ad.year, 0),
			stm.teacher_id,
			t.name as teacher_name
		FROM students s
		INNER JOIN academic_details ad ON s.student_id = ad.student_id
		LEFT JOIN student_teacher_mapping stm ON s.student_id = stm.student_id 
			AND stm.year = ?
			` + func() string {
		if academicYear != "" {
			return `AND stm.academic_year = ?`
		}
		return ""
	}() + `
		LEFT JOIN teachers t ON stm.teacher_id = t.id
		WHERE s.department_id = ? AND ad.year = ? AND s.status = 1
		ORDER BY s.enrollment_no
	`

	var studentRows *sql.Rows

	if academicYear != "" {
		studentRows, err = db.DB.Query(studentQuery, year, academicYear, departmentID, year)
	} else {
		studentRows, err = db.DB.Query(studentQuery, year, departmentID, year)
	}

	if err != nil {
		log.Printf("Error fetching students: %v", err)
		http.Error(w, "Failed to fetch students", http.StatusInternalServerError)
		return
	}
	defer studentRows.Close()

	for studentRows.Next() {
		var student models.StudentWithMapping
		if err := studentRows.Scan(
			&student.StudentID,
			&student.EnrollmentNo,
			&student.StudentName,
			&student.Department,
			&student.Year,
			&student.TeacherID,
			&student.TeacherName,
		); err != nil {
			log.Printf("Error scanning student: %v", err)
			continue
		}
		data.Students = append(data.Students, student)
	}

	json.NewEncoder(w).Encode(data)
}

// AssignStudentsToTeachers automatically distributes students evenly among teachers
func AssignStudentsToTeachers(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req models.StudentTeacherMappingRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		log.Printf("Error decoding request: %v", err)
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	if req.DepartmentID == 0 || req.Year == 0 || req.AcademicYear == "" {
		http.Error(w, "department_id, year, and academic_year are required", http.StatusBadRequest)
		return
	}

	// Start transaction
	tx, err := db.DB.Begin()
	if err != nil {
		log.Printf("Error starting transaction: %v", err)
		http.Error(w, "Failed to start transaction", http.StatusInternalServerError)
		return
	}
	defer tx.Rollback()

	// First, clear existing mappings for this department, year, and academic year
	deleteQuery := `DELETE FROM student_teacher_mapping WHERE department_id = ? AND year = ? AND academic_year = ?`
	_, err = tx.Exec(deleteQuery, req.DepartmentID, req.Year, req.AcademicYear)
	if err != nil {
		log.Printf("Error clearing existing mappings: %v", err)
		http.Error(w, "Failed to clear existing mappings", http.StatusInternalServerError)
		return
	}

	// Get all active teachers in this department
	teacherQuery := `
		SELECT t.id 
		FROM teachers t
		INNER JOIN department_teachers dt ON t.id = dt.teacher_id
		WHERE dt.department_id = ? AND t.status = 1 AND dt.status = 1
		ORDER BY t.id
	`
	teacherRows, err := tx.Query(teacherQuery, req.DepartmentID)
	if err != nil {
		log.Printf("Error fetching teachers: %v", err)
		http.Error(w, "Failed to fetch teachers", http.StatusInternalServerError)
		return
	}
	defer teacherRows.Close()

	teachers := make([]int64, 0)
	for teacherRows.Next() {
		var teacherID int64
		if err := teacherRows.Scan(&teacherID); err != nil {
			log.Printf("Error scanning teacher ID: %v", err)
			continue
		}
		teachers = append(teachers, teacherID)
	}
	teacherRows.Close()

	if len(teachers) == 0 {
		http.Error(w, "No teachers found in this department", http.StatusBadRequest)
		return
	}

	// Get all students in this department and year
	studentQuery := `
		SELECT s.student_id
		FROM students s
		INNER JOIN academic_details ad ON s.student_id = ad.student_id
		WHERE s.department_id = ? AND ad.year = ? AND s.status = 1
		ORDER BY s.student_id
	`
	studentRows, err := tx.Query(studentQuery, req.DepartmentID, req.Year)
	if err != nil {
		log.Printf("Error fetching students: %v", err)
		http.Error(w, "Failed to fetch students", http.StatusInternalServerError)
		return
	}
	defer studentRows.Close()

	students := make([]int, 0)
	for studentRows.Next() {
		var studentID int
		if err := studentRows.Scan(&studentID); err != nil {
			log.Printf("Error scanning student ID: %v", err)
			continue
		}
		students = append(students, studentID)
	}
	studentRows.Close()

	if len(students) == 0 {
		response := models.StudentTeacherMappingResponse{
			Success:         true,
			Message:         "No students found to assign",
			TotalStudents:   0,
			TotalTeachers:   len(teachers),
			MappingsCreated: 0,
		}
		json.NewEncoder(w).Encode(response)
		tx.Commit()
		return
	}

	// Calculate distribution
	totalStudents := len(students)
	totalTeachers := len(teachers)
	baseCount := totalStudents / totalTeachers
	remainder := totalStudents % totalTeachers

	// Distribute students to teachers
	insertQuery := `INSERT INTO student_teacher_mapping (student_id, teacher_id, department_id, year, academic_year) VALUES (?, ?, ?, ?, ?)`
	
	studentIndex := 0
	mappingsCreated := 0

	for teacherIdx, teacherID := range teachers {
		// First 'remainder' teachers get one extra student
		studentsForThisTeacher := baseCount
		if teacherIdx < remainder {
			studentsForThisTeacher++
		}

		for i := 0; i < studentsForThisTeacher && studentIndex < totalStudents; i++ {
			studentID := students[studentIndex]
			_, err := tx.Exec(insertQuery, studentID, teacherID, req.DepartmentID, req.Year, req.AcademicYear)
			if err != nil {
				log.Printf("Error inserting mapping for student %d to teacher %d: %v", studentID, teacherID, err)
				http.Error(w, fmt.Sprintf("Failed to create mapping: %v", err), http.StatusInternalServerError)
				return
			}
			mappingsCreated++
			studentIndex++
		}
	}

	// Commit transaction
	if err := tx.Commit(); err != nil {
		log.Printf("Error committing transaction: %v", err)
		http.Error(w, "Failed to commit mappings", http.StatusInternalServerError)
		return
	}

	response := models.StudentTeacherMappingResponse{
		Success:         true,
		Message:         fmt.Sprintf("Successfully assigned %d students to %d teachers", totalStudents, totalTeachers),
		TotalStudents:   totalStudents,
		TotalTeachers:   totalTeachers,
		MappingsCreated: mappingsCreated,
	}

	json.NewEncoder(w).Encode(response)
}

// ClearMappings removes all mappings for a specific department, year, and academic year
func ClearMappings(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	if r.Method != http.MethodDelete {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	departmentID := r.URL.Query().Get("department_id")
	year := r.URL.Query().Get("year")
	academicYear := r.URL.Query().Get("academic_year")

	if departmentID == "" || year == "" || academicYear == "" {
		http.Error(w, "department_id, year, and academic_year are required", http.StatusBadRequest)
		return
	}

	deptID, err := strconv.Atoi(departmentID)
	if err != nil {
		http.Error(w, "Invalid department_id", http.StatusBadRequest)
		return
	}

	yearInt, err := strconv.Atoi(year)
	if err != nil {
		http.Error(w, "Invalid year", http.StatusBadRequest)
		return
	}

	deleteQuery := `DELETE FROM student_teacher_mapping WHERE department_id = ? AND year = ? AND academic_year = ?`
	result, err := db.DB.Exec(deleteQuery, deptID, yearInt, academicYear)
	if err != nil {
		log.Printf("Error clearing mappings: %v", err)
		http.Error(w, "Failed to clear mappings", http.StatusInternalServerError)
		return
	}

	rowsAffected, _ := result.RowsAffected()

	response := map[string]interface{}{
		"success":       true,
		"message":       fmt.Sprintf("Cleared %d mappings", rowsAffected),
		"rows_affected": rowsAffected,
	}

	json.NewEncoder(w).Encode(response)
}
