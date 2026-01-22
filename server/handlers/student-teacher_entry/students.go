package studentteacher

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"
	"server/db"
	"server/models"
	"strconv"

	"github.com/gorilla/mux"
)

// GetStudents retrieves all students from the database
func GetStudents(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	query := `
		SELECT 
			student_id, enrollment_no, register_no, dte_reg_no, 
			application_no, admission_no, student_name, gender, dob, age,
			father_name, mother_name, guardian_name, religion, nationality,
			community, mother_tongue, blood_group, aadhar_no, parent_occupation,
			designation, place_of_work, parent_income
		FROM students
		ORDER BY student_id DESC
	`

	rows, err := db.DB.Query(query)
	if err != nil {
		log.Printf("Error querying students: %v", err)
		http.Error(w, "Failed to fetch students", http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	var students []models.Student
	for rows.Next() {
		var student models.Student
		err := rows.Scan(
			&student.ID, &student.EnrollmentNo, &student.RegisterNo,
			&student.DTERegNo, &student.ApplicationNo, &student.AdmissionNo,
			&student.StudentName, &student.Gender, &student.DOB, &student.Age,
			&student.FatherName, &student.MotherName, &student.GuardianName,
			&student.Religion, &student.Nationality, &student.Community,
			&student.MotherTongue, &student.BloodGroup, &student.AadharNo,
			&student.ParentOccupation, &student.Designation, &student.PlaceOfWork,
			&student.ParentIncome,
		)
		if err != nil {
			log.Printf("Error scanning student row: %v", err)
			continue
		}
		students = append(students, student)
	}

	if students == nil {
		students = []models.Student{}
	}

	json.NewEncoder(w).Encode(students)
}

// GetStudent retrieves a single student by ID
func GetStudent(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	vars := mux.Vars(r)
	studentID := vars["id"]

	query := `
		SELECT 
			student_id, enrollment_no, register_no, dte_reg_no, 
			application_no, admission_no, student_name, gender, dob, age,
			father_name, mother_name, guardian_name, religion, nationality,
			community, mother_tongue, blood_group, aadhar_no, parent_occupation,
			designation, place_of_work, parent_income
		FROM students
		WHERE student_id = ?
	`

	var student models.Student
	err := db.DB.QueryRow(query, studentID).Scan(
		&student.ID, &student.EnrollmentNo, &student.RegisterNo,
		&student.DTERegNo, &student.ApplicationNo, &student.AdmissionNo,
		&student.StudentName, &student.Gender, &student.DOB, &student.Age,
		&student.FatherName, &student.MotherName, &student.GuardianName,
		&student.Religion, &student.Nationality, &student.Community,
		&student.MotherTongue, &student.BloodGroup, &student.AadharNo,
		&student.ParentOccupation, &student.Designation, &student.PlaceOfWork,
		&student.ParentIncome,
	)

	if err == sql.ErrNoRows {
		http.Error(w, "Student not found", http.StatusNotFound)
		return
	} else if err != nil {
		log.Printf("Error querying student: %v", err)
		http.Error(w, "Failed to fetch student", http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(student)
}

// CreateStudent creates a new student record
func CreateStudent(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	var req models.CreateStudentRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		log.Printf("Error decoding request body: %v", err)
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	// Convert string to float64 for parent_income
	parentIncome, err := strconv.ParseFloat(req.ParentIncome, 64)
	if err != nil {
		parentIncome = 0.0 // Default if conversion fails
	}

	query := `
		INSERT INTO students (
			enrollment_no, register_no, dte_reg_no, application_no,
			admission_no, student_name, gender, dob, age, father_name, mother_name,
			guardian_name, religion, nationality, community, mother_tongue,
			blood_group, aadhar_no, parent_occupation, designation, place_of_work,
			parent_income
		) VALUES (
			?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
		)
	`

	result, err := db.DB.Exec(
		query,
		req.EnrollmentNo, req.RegisterNo, req.DTERegNo, req.ApplicationNo,
		req.AdmissionNo, req.StudentName, req.Gender, req.DOB, req.Age,
		req.FatherName, req.MotherName, req.GuardianName, req.Religion,
		req.Nationality, req.Community, req.MotherTongue, req.BloodGroup,
		req.AadharNo, req.ParentOccupation, req.Designation, req.PlaceOfWork,
		parentIncome,
	)

	if err != nil {
		log.Printf("Error creating student: %v", err)
		http.Error(w, "Failed to create student", http.StatusInternalServerError)
		return
	}

	studentID, err := result.LastInsertId()
	if err != nil {
		log.Printf("Error getting last insert ID: %v", err)
		http.Error(w, "Failed to retrieve student ID", http.StatusInternalServerError)
		return
	}

	// Fetch and return the created student
	createdStudent := models.Student{
		ID:               int(studentID),
		EnrollmentNo:     req.EnrollmentNo,
		RegisterNo:       req.RegisterNo,
		DTERegNo:         req.DTERegNo,
		ApplicationNo:    req.ApplicationNo,
		AdmissionNo:      req.AdmissionNo,
		StudentName:      req.StudentName,
		Gender:           req.Gender,
		DOB:              req.DOB,
		Age:              req.Age,
		FatherName:       req.FatherName,
		MotherName:       req.MotherName,
		GuardianName:     req.GuardianName,
		Religion:         req.Religion,
		Nationality:      req.Nationality,
		Community:        req.Community,
		MotherTongue:     req.MotherTongue,
		BloodGroup:       req.BloodGroup,
		AadharNo:         req.AadharNo,
		ParentOccupation: req.ParentOccupation,
		Designation:      req.Designation,
		PlaceOfWork:      req.PlaceOfWork,
		ParentIncome:     parentIncome,
	}

	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(createdStudent)
}

// UpdateStudent updates an existing student record
func UpdateStudent(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	vars := mux.Vars(r)
	studentID := vars["id"]

	var req models.CreateStudentRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		log.Printf("Error decoding request body: %v", err)
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	// Convert string to float64 for parent_income
	parentIncome, err := strconv.ParseFloat(req.ParentIncome, 64)
	if err != nil {
		parentIncome = 0.0 // Default if conversion fails
	}

	query := `
		UPDATE students SET
			enrollment_no = ?, register_no = ?, dte_reg_no = ?,
			application_no = ?, admission_no = ?, student_name = ?, gender = ?,
			dob = ?, age = ?, father_name = ?, mother_name = ?,
			guardian_name = ?, religion = ?, nationality = ?, community = ?,
			mother_tongue = ?, blood_group = ?, aadhar_no = ?,
			parent_occupation = ?, designation = ?, place_of_work = ?,
			parent_income = ?
		WHERE student_id = ?
	`

	result, err := db.DB.Exec(
		query,
		req.EnrollmentNo, req.RegisterNo, req.DTERegNo, req.ApplicationNo,
		req.AdmissionNo, req.StudentName, req.Gender, req.DOB, req.Age,
		req.FatherName, req.MotherName, req.GuardianName, req.Religion,
		req.Nationality, req.Community, req.MotherTongue, req.BloodGroup,
		req.AadharNo, req.ParentOccupation, req.Designation, req.PlaceOfWork,
		parentIncome, studentID,
	)

	if err != nil {
		log.Printf("Error updating student: %v", err)
		http.Error(w, "Failed to update student", http.StatusInternalServerError)
		return
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		log.Printf("Error getting rows affected: %v", err)
		http.Error(w, "Failed to update student", http.StatusInternalServerError)
		return
	}

	if rowsAffected == 0 {
		http.Error(w, "Student not found", http.StatusNotFound)
		return
	}

	// Return updated student
	updatedStudent := models.Student{
		EnrollmentNo:     req.EnrollmentNo,
		RegisterNo:       req.RegisterNo,
		DTERegNo:         req.DTERegNo,
		ApplicationNo:    req.ApplicationNo,
		AdmissionNo:      req.AdmissionNo,
		StudentName:      req.StudentName,
		Gender:           req.Gender,
		DOB:              req.DOB,
		Age:              req.Age,
		FatherName:       req.FatherName,
		MotherName:       req.MotherName,
		GuardianName:     req.GuardianName,
		Religion:         req.Religion,
		Nationality:      req.Nationality,
		Community:        req.Community,
		MotherTongue:     req.MotherTongue,
		BloodGroup:       req.BloodGroup,
		AadharNo:         req.AadharNo,
		ParentOccupation: req.ParentOccupation,
		Designation:      req.Designation,
		PlaceOfWork:      req.PlaceOfWork,
		ParentIncome:     parentIncome,
	}

	json.NewEncoder(w).Encode(updatedStudent)
}

// DeleteStudent deletes a student record
func DeleteStudent(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	vars := mux.Vars(r)
	studentID := vars["id"]

	query := `DELETE FROM students WHERE student_id = ?`
	result, err := db.DB.Exec(query, studentID)
	if err != nil {
		log.Printf("Error deleting student: %v", err)
		http.Error(w, "Failed to delete student", http.StatusInternalServerError)
		return
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		log.Printf("Error getting rows affected: %v", err)
		http.Error(w, "Failed to delete student", http.StatusInternalServerError)
		return
	}

	if rowsAffected == 0 {
		http.Error(w, "Student not found", http.StatusNotFound)
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{
		"message": "Student deleted successfully",
	})
}
