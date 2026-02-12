package curriculum

import (
	"encoding/json"
	"log"
	"net/http"
	"server/db"
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
