package curriculum

import (
	"encoding/json"
	"log"
	"net/http"
	"server/db"
	"strconv"

	"github.com/gorilla/mux"
)

// Department represents a department entity
type Department struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

// GetDepartments retrieves all active departments
func GetDepartments(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	query := `
		SELECT id, department_name
		FROM departments
		WHERE status = 1
		ORDER BY department_name
	`

	rows, err := db.DB.Query(query)
	if err != nil {
		log.Printf("Error querying departments: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "Failed to fetch departments",
		})
		return
	}
	defer rows.Close()

	departments := []Department{}
	for rows.Next() {
		var id int
		var departmentName string
		if err := rows.Scan(&id, &departmentName); err != nil {
			log.Printf("Error scanning department row: %v", err)
			continue
		}
		departments = append(departments, Department{
			ID:   id,
			Name: departmentName,
		})
	}

	if err := rows.Err(); err != nil {
		log.Printf("Error iterating departments: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"message": "Failed to process departments",
		})
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]interface{}{
		"success":     true,
		"departments": departments,
	})
}

// GetDepartmentCurriculumCourses retrieves courses from a department's current curriculum for a specific semester
func GetDepartmentCurriculumCourses(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

	if r.Method == "OPTIONS" {
		w.WriteHeader(http.StatusOK)
		return
	}

	vars := mux.Vars(r)
	deptID := vars["departmentId"]
	semesterNum := vars["semester"]

	semesterNumber, err := strconv.Atoi(semesterNum)
	if err != nil {
		http.Error(w, "Invalid semester number", http.StatusBadRequest)
		return
	}

	query := `
		SELECT DISTINCT c.id, c.course_code, c.course_name
		FROM departments d
		INNER JOIN curriculum_courses cc ON d.current_curriculum_id = cc.curriculum_id
		INNER JOIN normal_cards nc ON cc.semester_id = nc.id
		INNER JOIN courses c ON cc.course_id = c.id
		WHERE d.id = ? 
			AND nc.semester_number = ?
			AND d.status = 1
		ORDER BY c.course_code
	`

	rows, err := db.DB.Query(query, deptID, semesterNumber)
	if err != nil {
		log.Printf("Error fetching department curriculum courses: %v", err)
		http.Error(w, "Failed to fetch courses", http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	type Course struct {
		CourseID   int    `json:"course_id"`
		CourseCode string `json:"course_code"`
		CourseName string `json:"course_name"`
	}

	courses := []Course{}
	for rows.Next() {
		var course Course
		if err := rows.Scan(&course.CourseID, &course.CourseCode, &course.CourseName); err != nil {
			log.Printf("Error scanning course row: %v", err)
			continue
		}
		courses = append(courses, course)
	}

	if err := rows.Err(); err != nil {
		log.Printf("Error iterating courses: %v", err)
		http.Error(w, "Failed to process courses", http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(courses)
}

// GetAllDepartmentsCourses retrieves courses from all departments' current curriculums for a specific semester
func GetAllDepartmentsCourses(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

	if r.Method == "OPTIONS" {
		w.WriteHeader(http.StatusOK)
		return
	}

	vars := mux.Vars(r)
	semesterNum := vars["semester"]

	semesterNumber, err := strconv.Atoi(semesterNum)
	if err != nil {
		http.Error(w, "Invalid semester number", http.StatusBadRequest)
		return
	}

	query := `
		SELECT DISTINCT c.id, c.course_code, c.course_name
		FROM departments d
		INNER JOIN curriculum_courses cc ON d.current_curriculum_id = cc.curriculum_id
		INNER JOIN normal_cards nc ON cc.semester_id = nc.id
		INNER JOIN courses c ON cc.course_id = c.id
		WHERE nc.semester_number = ?
			AND d.status = 1
		ORDER BY c.course_code
	`

	rows, err := db.DB.Query(query, semesterNumber)
	if err != nil {
		log.Printf("Error fetching all departments courses: %v", err)
		http.Error(w, "Failed to fetch courses", http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	type Course struct {
		CourseID   int    `json:"course_id"`
		CourseCode string `json:"course_code"`
		CourseName string `json:"course_name"`
	}

	courses := []Course{}
	for rows.Next() {
		var course Course
		if err := rows.Scan(&course.CourseID, &course.CourseCode, &course.CourseName); err != nil {
			log.Printf("Error scanning course row: %v", err)
			continue
		}
		courses = append(courses, course)
	}

	if err := rows.Err(); err != nil {
		log.Printf("Error iterating courses: %v", err)
		http.Error(w, "Failed to process courses", http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(courses)
}
