package curriculum

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"
	"time"
	"server/db"
	"server/models"
)

// GetCurrentAcademicCalendar returns the current academic calendar
func GetCurrentAcademicCalendar(w http.ResponseWriter, r *http.Request) {
	log.Printf("GetCurrentAcademicCalendar handler called")
	w.Header().Set("Content-Type", "application/json")

	query := `
		SELECT id, academic_year, current_semester, semester_start_date, semester_end_date, is_current
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
		&calendar.IsCurrent,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			// No current academic calendar found, return a default
			log.Printf("No current academic calendar found, returning default")
			calendar = models.AcademicCalendar{
				AcademicYear:      "2025-2026",
				CurrentSemester:   1,
				SemesterStartDate: time.Now(),
				SemesterEndDate:   time.Now().AddDate(0, 4, 0),
				IsCurrent:         true,
			}
			w.WriteHeader(http.StatusOK)
			json.NewEncoder(w).Encode(calendar)
			return
		}
		log.Printf("Error fetching academic calendar: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{
			"error": "Failed to fetch academic calendar",
		})
		return
	}

	log.Printf("Academic calendar found: %+v", calendar)
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(calendar)
}
