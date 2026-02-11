package allocation

import (
	"encoding/json"
	"fmt"
	"log"
	"math"
	"net/http"
	"server/db"
	"time"
)

// CourseEnrollment represents a course's enrollment data
type CourseEnrollment struct {
	CourseID        int
	CourseCode      string
	CourseName      string
	Semester        int
	Batch           string
	TotalStudents   int
	RequiredSections int
}

// TeacherPreference represents a teacher's course preference
type TeacherPreference struct {
	FacultyID        string
	TeacherName      string
	CourseInternalID int
	CourseCode       string
	CourseName       string
	Semester         int
	Batch            string
	CourseType       string
	Priority         int
	MaxCount         int
}

// AllocationResult represents the outcome of an allocation
type AllocationResult struct {
	FacultyID    string    `json:"faculty_id"`
	TeacherName  string    `json:"teacher_name"`
	CourseID     int       `json:"course_id"`
	CourseCode   string    `json:"course_code"`
	CourseName   string    `json:"course_name"`
	Section      string    `json:"section"`
	AllocatedAt  time.Time `json:"allocated_at"`
	Success      bool      `json:"success"`
	ErrorMessage string    `json:"error_message,omitempty"`
}

// calculateSections implements the 60-student rule with smart rounding
func calculateSections(studentCount int) int {
	if studentCount == 0 {
		return 0
	}

	quotient := float64(studentCount) / 60.0
	remainder := studentCount % 60

	// If remainder < 30, round down; if >= 30, round up
	if remainder < 30 {
		return int(math.Floor(quotient))
	}
	return int(math.Ceil(quotient))
}

// RunAutoAllocation - Main endpoint to trigger automatic allocation
func RunAutoAllocation(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	startTime := time.Now()

	// Get the current academic year
	var academicYear string
	err := db.DB.QueryRow(`
		SELECT academic_year
		FROM academic_calendar 
		WHERE is_current = 1
		LIMIT 1
	`).Scan(&academicYear)

	if err != nil {
		log.Printf("No calendar entry found for allocation: %v", err)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"error":   "No academic year found",
		})
		return
	}

	log.Printf("🚀 Starting allocation for Academic Year: %s", academicYear)

	// Get all distinct semesters that have preferences for this academic year
	semestersQuery := `
		SELECT DISTINCT semester 
		FROM teacher_course_preferences 
		WHERE academic_year = ?
		AND status IN ('approved', 'pending')
		ORDER BY semester
	`
	
	rows, err := db.DB.Query(semestersQuery, academicYear)
	if err != nil {
		log.Printf("Error fetching semesters: %v", err)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"error":   "Failed to fetch semesters",
		})
		return
	}
	defer rows.Close()

	var semesters []int
	for rows.Next() {
		var sem int
		if err := rows.Scan(&sem); err != nil {
			continue
		}
		semesters = append(semesters, sem)
	}

	if len(semesters) == 0 {
		log.Printf("No preferences found for academic year %s", academicYear)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"error":   "No preferences found to process",
		})
		return
	}

	log.Printf("Found preferences for %d semesters: %v", len(semesters), semesters)

	totalAllocations := 0
	allResults := []map[string]interface{}{}

	// Process each semester
	for _, semester := range semesters {
		log.Printf("📚 Processing Semester %d", semester)

		// Step 1: Calculate course enrollments and required sections
		enrollments, err := calculateCourseEnrollments(academicYear, semester)
		if err != nil {
			log.Printf("Error calculating enrollments for semester %d: %v", semester, err)
			continue
		}

		log.Printf("Found %d courses needing allocation in semester %d", len(enrollments), semester)

		// Step 2: Get approved teacher preferences
		preferences, err := getTeacherPreferences(academicYear, semester)
		if err != nil {
			log.Printf("Error fetching preferences for semester %d: %v", semester, err)
			continue
		}

		log.Printf("Found preferences for %d teachers in semester %d", len(preferences), semester)

		// Step 3: Run allocation algorithm
		allocations := performAllocation(enrollments, preferences)

		log.Printf("Allocation algorithm completed with %d results for semester %d", len(allocations), semester)

		// Step 4: Save allocations to database
		successCount, failCount := saveAllocations(allocations, academicYear, semester)

		log.Printf("✓ Semester %d: %d successful, %d failed allocations", semester, successCount, failCount)
		
		totalAllocations += successCount
		
		allResults = append(allResults, map[string]interface{}{
			"semester":           semester,
			"total_allocations":  successCount,
			"failed_allocations": failCount,
			"total_courses":      len(enrollments),
			"total_teachers":     len(preferences),
		})
	}

	executionTime := time.Since(startTime).Seconds()

	log.Printf("✓ All semesters completed: %d total allocations in %.2f seconds", totalAllocations, executionTime)

	// Return response
	json.NewEncoder(w).Encode(map[string]interface{}{
		"success":        true,
		"academic_year":  academicYear,
		"semesters":      allResults,
		"total_allocations": totalAllocations,
		"execution_time": executionTime,
	})
}

// calculateCourseEnrollments gets course info from teacher preferences (not student enrollments)
// For now, assume each course needs 1 section (can be enhanced later with actual student counts)
func calculateCourseEnrollments(academicYear string, semester int) (map[string]*CourseEnrollment, error) {
	// Get unique courses from teacher preferences for this semester
	query := `
		SELECT DISTINCT
			c.id,
			tcp.course_id as course_code,
			c.course_name,
			tcp.semester,
			tcp.batch,
			60 as total_students
		FROM teacher_course_preferences tcp
		JOIN courses c ON tcp.course_id = c.course_code
		WHERE tcp.academic_year = ?
		AND tcp.semester = ?
		AND tcp.status IN ('approved', 'pending')
		GROUP BY c.id, tcp.course_id, c.course_name, tcp.semester, tcp.batch
	`

	rows, err := db.DB.Query(query, academicYear, semester)
	if err != nil {
		return nil, fmt.Errorf("query error: %v", err)
	}
	defer rows.Close()

	enrollments := make(map[string]*CourseEnrollment)

	for rows.Next() {
		var enrollment CourseEnrollment
		err := rows.Scan(
			&enrollment.CourseID,
			&enrollment.CourseCode,
			&enrollment.CourseName,
			&enrollment.Semester,
			&enrollment.Batch,
			&enrollment.TotalStudents,
		)
		if err != nil {
			log.Printf("Error scanning enrollment: %v", err)
			continue
		}

		// Calculate required sections using the 60-student rule
		enrollment.RequiredSections = calculateSections(enrollment.TotalStudents)

		enrollments[enrollment.CourseCode] = &enrollment
	}

	return enrollments, nil
}

// getTeacherPreferences fetches approved teacher preferences with faculty_id
func getTeacherPreferences(academicYear string, semester int) (map[string][]TeacherPreference, error) {
	query := `
		SELECT 
			t.faculty_id,
			t.name as teacher_name,
			c.id as course_internal_id,
			c.course_code,
			c.course_name,
			tcp.semester,
			tcp.batch,
			ct.course_type,
			tcp.priority,
			COALESCE(tcl.max_count, 2) as max_count
		FROM teacher_course_preferences tcp
		JOIN teachers t ON tcp.teacher_id = t.id
		JOIN courses c ON tcp.course_id = c.course_code
		JOIN course_type ct ON tcp.course_type = ct.id
		LEFT JOIN teacher_course_limits tcl 
			ON t.id = tcl.teacher_id 
			AND tcp.course_type = tcl.course_type_id
		WHERE tcp.academic_year = ? 
		AND tcp.semester = ?
		AND tcp.status IN ('approved', 'pending')
		ORDER BY t.faculty_id, tcp.priority
	`

	rows, err := db.DB.Query(query, academicYear, semester)
	if err != nil {
		return nil, fmt.Errorf("query error: %v", err)
	}
	defer rows.Close()

	preferences := make(map[string][]TeacherPreference)

	for rows.Next() {
		var pref TeacherPreference
		err := rows.Scan(
			&pref.FacultyID,
			&pref.TeacherName,
			&pref.CourseInternalID,
			&pref.CourseCode,
			&pref.CourseName,
			&pref.Semester,
			&pref.Batch,
			&pref.CourseType,
			&pref.Priority,
			&pref.MaxCount,
		)
		if err != nil {
			log.Printf("Error scanning preference: %v", err)
			continue
		}

		preferences[pref.FacultyID] = append(preferences[pref.FacultyID], pref)
	}

	return preferences, nil
}

// performAllocation runs the two-pass allocation algorithm
func performAllocation(enrollments map[string]*CourseEnrollment, preferences map[string][]TeacherPreference) []AllocationResult {
	var results []AllocationResult

	// Debug: Show what we're working with
	log.Printf("DEBUG: Enrollments map has %d courses:", len(enrollments))
	for code := range enrollments {
		log.Printf("  - Course code in enrollments: '%s'", code)
	}
	
	log.Printf("DEBUG: Preferences for %d teachers:", len(preferences))
	for facultyID, prefs := range preferences {
		log.Printf("  - Teacher %s has %d preferences", facultyID, len(prefs))
		for _, p := range prefs {
			log.Printf("    * Course code in pref: '%s' (priority %d)", p.CourseCode, p.Priority)
		}
	}

	// Track how many sections still needed per course
	courseNeedMap := make(map[string]int)
	for code, enrollment := range enrollments {
		courseNeedMap[code] = enrollment.RequiredSections
	}

	// Track allocations per teacher per course type
	teacherAllocationCount := make(map[string]map[string]int) // faculty_id -> course_type -> count
	for facultyID := range preferences {
		teacherAllocationCount[facultyID] = make(map[string]int)
	}

	// Track which teachers have gotten at least 1 course
	teacherHasAllocation := make(map[string]bool)

	// FIRST PASS: Guarantee each teacher gets at least 1 course from their preferences
	log.Println("🔄 Phase 1: Guaranteeing minimum allocation per teacher")
	for facultyID, prefs := range preferences {
		if teacherHasAllocation[facultyID] {
			continue // Already got one
		}

		for _, pref := range prefs {
			log.Printf("    Checking: %s wants %s (need=%d, allocated=%d, max=%d)", 
				facultyID, pref.CourseCode, courseNeedMap[pref.CourseCode], 
				teacherAllocationCount[facultyID][pref.CourseType], pref.MaxCount)
			
			// Check if course still needs teachers
			if courseNeedMap[pref.CourseCode] <= 0 {
				log.Printf("      ❌ Course %s needs no more teachers (need=%d)", pref.CourseCode, courseNeedMap[pref.CourseCode])
				continue
			}

			// Check if teacher hasn't exceeded their limit for this course type
			if teacherAllocationCount[facultyID][pref.CourseType] >= pref.MaxCount {
				log.Printf("      ❌ Teacher %s exceeded limit for type %s (%d >= %d)", 
					facultyID, pref.CourseType, teacherAllocationCount[facultyID][pref.CourseType], pref.MaxCount)
				continue
			}

			// Allocate!
			section := getSectionLetter(enrollments[pref.CourseCode].RequiredSections - courseNeedMap[pref.CourseCode])
			results = append(results, AllocationResult{
				FacultyID:   facultyID,
				TeacherName: pref.TeacherName,
				CourseID:    pref.CourseInternalID,
				CourseCode:  pref.CourseCode,
				CourseName:  pref.CourseName,
				Section:     section,
				AllocatedAt: time.Now(),
				Success:     true,
			})

			courseNeedMap[pref.CourseCode]--
			teacherAllocationCount[facultyID][pref.CourseType]++
			teacherHasAllocation[facultyID] = true

			log.Printf("  ✓ Guaranteed: %s (%s) → %s (Section %s, Priority %d)",
				facultyID, pref.TeacherName, pref.CourseCode, section, pref.Priority)
			break // Only one course per teacher in first pass
		}
	}

	// SECOND PASS: Fill remaining allocations up to teacher limits
	log.Println("🔄 Phase 2: Filling remaining allocations")
	for facultyID, prefs := range preferences {
		for _, pref := range prefs {
			// Check if course still needs teachers
			if courseNeedMap[pref.CourseCode] <= 0 {
				continue
			}

			// Check if teacher hasn't exceeded their limit for this course type
			if teacherAllocationCount[facultyID][pref.CourseType] >= pref.MaxCount {
				continue
			}

			// Check if this teacher already has this exact course assigned
			alreadyAssigned := false
			for _, result := range results {
				if result.FacultyID == facultyID && result.CourseCode == pref.CourseCode {
					alreadyAssigned = true
					break
				}
			}

			if alreadyAssigned {
				continue
			}

			// Allocate additional section
			section := getSectionLetter(enrollments[pref.CourseCode].RequiredSections - courseNeedMap[pref.CourseCode])
			results = append(results, AllocationResult{
				FacultyID:   facultyID,
				TeacherName: pref.TeacherName,
				CourseID:    pref.CourseInternalID,
				CourseCode:  pref.CourseCode,
				CourseName:  pref.CourseName,
				Section:     section,
				AllocatedAt: time.Now(),
				Success:     true,
			})

			courseNeedMap[pref.CourseCode]--
			teacherAllocationCount[facultyID][pref.CourseType]++

			log.Printf("  ✓ Additional: %s (%s) → %s (Section %s)",
				facultyID, pref.TeacherName, pref.CourseCode, section)
		}
	}

	return results
}

// getSectionLetter converts section number to letter (0=A, 1=B, etc.)
func getSectionLetter(sectionNum int) string {
	if sectionNum < 0 {
		return "A"
	}
	return string(rune('A' + sectionNum))
}

// saveAllocations inserts allocations into teacher_course_allocation table
func saveAllocations(allocations []AllocationResult, academicYear string, semester int) (int, int) {
	successCount := 0
	failCount := 0

	// First, clear existing allocations for this semester (optional, comment out if you want to keep old data)
	// db.DB.Exec("DELETE FROM teacher_course_allocation")

	for i := range allocations {
		// Insert into teacher_course_allocation
		// Note: teacher_id field stores faculty_id (e.g., 'AD10953')
		_, err := db.DB.Exec(`
			INSERT INTO teacher_course_allocation (course_id, teacher_id)
			VALUES (?, ?)
		`, allocations[i].CourseID, allocations[i].FacultyID)

		if err != nil {
			log.Printf("❌ Failed to save allocation for %s → %s: %v",
				allocations[i].FacultyID, allocations[i].CourseCode, err)
			allocations[i].Success = false
			allocations[i].ErrorMessage = err.Error()
			failCount++
		} else {
			successCount++
		}
	}

	return successCount, failCount
}
