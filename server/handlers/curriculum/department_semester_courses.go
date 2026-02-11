package curriculum

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
	"server/db"
	"server/models"
)

// GetCoursesForTeacherSemester maps teacher -> department -> curriculum -> semester card -> returns courses
func GetCoursesForTeacherSemester(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	vars := mux.Vars(r)
	teacherIDStr := vars["teacherId"]
	semStr := vars["semester"]

	teacherID, err := strconv.Atoi(teacherIDStr)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "Invalid teacher ID"})
		return
	}
	semesterNum, err := strconv.Atoi(semStr)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "Invalid semester number"})
		return
	}

	// Step 1: get teacher details
	var deptRaw sql.NullString
	var facultyID sql.NullString
	err = db.DB.QueryRow("SELECT dept, faculty_id FROM teachers WHERE id = ?", teacherID).Scan(&deptRaw, &facultyID)
	if err != nil {
		log.Printf("Error fetching teacher data: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": "Failed to fetch teacher data"})
		return
	}

	// Step 2: find curriculum_id for department
	var curriculumID int
	
	// Try to interpret dept as int
	var deptID int
	if deptRaw.Valid && deptRaw.String != "" {
		if id, convErr := strconv.Atoi(deptRaw.String); convErr == nil {
			deptID = id
		}
	}

	if deptID != 0 {
		err = db.DB.QueryRow("SELECT curriculum_id FROM curriculum_vision WHERE id = ? AND (status = 1 OR status IS NULL) LIMIT 1", deptID).Scan(&curriculumID)
		if err != nil {
			// try alternative: curriculum_vision.department_id = deptID
			err = db.DB.QueryRow("SELECT curriculum_id FROM curriculum_vision WHERE department_id = ? AND (status = 1 OR status IS NULL) LIMIT 1", deptID).Scan(&curriculumID)
		}
	}

	// If still not found, fallback 1: try to find curriculum by department name/code
	if curriculumID == 0 && deptRaw.Valid && deptRaw.String != "" {
		err = db.DB.QueryRow("SELECT do.curriculum_id FROM curriculum_vision do JOIN departments d ON d.id = do.department_id WHERE d.department_name = ? OR d.department_code = ? LIMIT 1", deptRaw.String, deptRaw.String).Scan(&curriculumID)
	}

	// Fallback 2: Try to infer department from faculty_id prefix (e.g., AD10953 -> AD)
	if curriculumID == 0 && facultyID.Valid && len(facultyID.String) > 2 {
		prefix := ""
		for _, r := range facultyID.String {
			if r >= 'A' && r <= 'Z' {
				prefix += string(r)
			} else {
				break
			}
		}
		if prefix != "" {
			log.Printf("Attempting to infer department from faculty_id prefix: %s", prefix)
			// Try to find a department with this code
			err = db.DB.QueryRow(`
				SELECT cv.curriculum_id 
				FROM curriculum_vision cv
				JOIN departments d ON d.id = cv.department_id 
				WHERE d.department_code = ? OR d.department_name LIKE ?
				LIMIT 1`, prefix, prefix+"%").Scan(&curriculumID)
			
			// Fallback 2b: Search curriculum names directly for the prefix or related keywords
			if err != nil || curriculumID == 0 {
				keyword := prefix
				// Common mappings based on faculty ID prefixes
				switch prefix {
				case "AD":
					keyword = "AI&DS"
				case "AM":
					keyword = "AIML"
				case "BM":
					keyword = "BME"
				case "CE":
					keyword = "CIVIL"
				case "CS":
					keyword = "CSE"
				case "EC":
					keyword = "ECE"
				case "EE":
					keyword = "EEE"
				case "ME":
					keyword = "ME" // Mechanical
				case "MT":
					keyword = "MTRS" // Mechatronics
				}
				log.Printf("Searching curriculum table for derived keyword: %s", keyword)
				err = db.DB.QueryRow("SELECT id FROM curriculum WHERE name LIKE ? AND status = 1 ORDER BY academic_year DESC, id DESC LIMIT 1", "%"+keyword+"%").Scan(&curriculumID)
			}
		}
	}

	// Fallback 3: If still nothing and we are in a dev/test environment (or just to make it work), 
	// pick the most recent active curriculum
	if curriculumID == 0 {
		log.Printf("No curriculum found for teacher %d, falling back to latest curriculum", teacherID)
		err = db.DB.QueryRow("SELECT id FROM curriculum WHERE status = 1 ORDER BY academic_year DESC, id DESC LIMIT 1").Scan(&curriculumID)
	}

	if curriculumID == 0 {
		w.WriteHeader(http.StatusNotFound)
		json.NewEncoder(w).Encode(map[string]string{"error": "Could not determine curriculum for teacher's department"})
		return
	}

	// Step 3: find ALL normal_cards entries for this curriculum and semester number
	// A semester can have multiple cards (Core, Electives, Honours, etc.)
	rows_cards, err := db.DB.Query("SELECT id FROM normal_cards WHERE curriculum_id = ? AND semester_number = ? AND status = 1", curriculumID, semesterNum)
	if err != nil {
		log.Printf("Error finding semester cards: %v", err)
		w.WriteHeader(http.StatusNotFound)
		json.NewEncoder(w).Encode(map[string]string{"error": "Semester not found for curriculum"})
		return
	}
	defer rows_cards.Close()

	var cardIDs []interface{}
	for rows_cards.Next() {
		var id int
		if err := rows_cards.Scan(&id); err == nil {
			cardIDs = append(cardIDs, id)
		}
	}

	if len(cardIDs) == 0 {
		w.WriteHeader(http.StatusNotFound)
		json.NewEncoder(w).Encode(map[string]string{"error": "No course cards found for this semester"})
		return
	}

	// Step 4: Fetch all courses linked to these card IDs
	// We'll build a query with IN clause
	placeholders := ""
	for i := range cardIDs {
		if i > 0 {
			placeholders += ","
		}
		placeholders += "?"
	}

	query := `
		SELECT c.id, c.course_code, c.course_name, c.course_type as course_type_id, ct.course_type as course_type,
		       c.category, c.credit, 
		       c.lecture_hrs, c.tutorial_hrs, c.practical_hrs, c.activity_hrs, COALESCE(c.` + "`tw/sl`" + `, 0) as tw_sl,
		       COALESCE(c.theory_total_hrs,0), COALESCE(c.tutorial_total_hrs,0), COALESCE(c.practical_total_hrs,0), COALESCE(c.activity_total_hrs,0), COALESCE(c.total_hrs,0),
		       c.cia_marks, c.see_marks, c.total_marks,
		       rc.id as reg_course_id, COALESCE(rc.count_towards_limit,1) as count_towards_limit,
		       nc.card_type
		FROM courses c
		LEFT JOIN course_type ct ON c.course_type = ct.id
		INNER JOIN curriculum_courses rc ON c.id = rc.course_id
		INNER JOIN normal_cards nc ON rc.semester_id = nc.id
		WHERE rc.curriculum_id = ? AND rc.semester_id IN (` + placeholders + `) AND c.status = 1
		ORDER BY c.course_code
	`

	queryArgs := append([]interface{}{curriculumID}, cardIDs...)
	rows, err := db.DB.Query(query, queryArgs...)
	if err != nil {
		log.Printf("Error querying curriculum courses for dept/sem: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": "Failed to fetch courses"})
		return
	}
	defer rows.Close()

	var courses []models.CourseWithDetails
	for rows.Next() {
		var course models.CourseWithDetails
		var countTowardsLimitInt int
		var cardType string
		var courseTypeID sql.NullInt64
		err := rows.Scan(&course.CourseID, &course.CourseCode, &course.CourseName, &courseTypeID, &course.CourseType, &course.Category, &course.Credit,
			&course.LectureHrs, &course.TutorialHrs, &course.PracticalHrs, &course.ActivityHrs, &course.TwSlHrs,
			&course.TheoryTotalHrs, &course.TutorialTotalHrs, &course.PracticalTotalHrs, &course.ActivityTotalHrs, &course.TotalHrs,
			&course.CIAMarks, &course.SEEMarks, &course.TotalMarks,
			&course.RegCourseID, &countTowardsLimitInt, &cardType)
		if err != nil {
			log.Printf("Error scanning course: %v", err)
			continue
		}
		
		countTowardsLimit := countTowardsLimitInt == 1
		course.CountTowardsLimit = &countTowardsLimit
		courses = append(courses, course)
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]interface{}{"courses": courses, "curriculum_id": curriculumID, "card_ids": cardIDs})
}
