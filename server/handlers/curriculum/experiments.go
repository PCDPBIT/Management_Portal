package curriculum

import (
	"encoding/json"
	"log"
	"net/http"
	"server/db"
	"server/models"
	"strconv"
	"strings"

	"github.com/gorilla/mux"
)

// GetCourseExperiments returns all experiments for a course (2022 template)
func GetCourseExperiments(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	vars := mux.Vars(r)
	courseID, err := strconv.Atoi(vars["courseId"])
	if err != nil {
		http.Error(w, "Invalid course ID", http.StatusBadRequest)
		return
	}

	experiments := []models.Experiment{}
	rows, err := db.DB.Query(`
		SELECT id, course_id, experiment_number, experiment_name, hours
		FROM course_experiments
		WHERE course_id = ? AND status = 1
		ORDER BY experiment_number`, courseID)
	if err != nil {
		log.Println("Error fetching experiments:", err)
		http.Error(w, "Failed to fetch experiments", http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	for rows.Next() {
		var exp models.Experiment
		if err := rows.Scan(&exp.ID, &exp.CourseID, &exp.ExperimentNumber, &exp.ExperimentName, &exp.Hours); err != nil {
			continue
		}

		// Fetch topics for this experiment
		topicRows, err := db.DB.Query(`
			SELECT topic_text
			FROM course_experiment_topics
			WHERE experiment_id = ? AND status = 1
			ORDER BY topic_order`, exp.ID)
		if err != nil {
			exp.Topics = []string{}
		} else {
			topics := []string{}
			for topicRows.Next() {
				var topic string
				if err := topicRows.Scan(&topic); err == nil {
					topics = append(topics, topic)
				}
			}
			topicRows.Close()
			exp.Topics = topics
		}

		experiments = append(experiments, exp)
	}

	json.NewEncoder(w).Encode(experiments)
}

// CreateExperiment creates a new experiment for a course
func CreateExperiment(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	vars := mux.Vars(r)
	courseID, err := strconv.Atoi(vars["courseId"])
	if err != nil {
		http.Error(w, "Invalid course ID", http.StatusBadRequest)
		return
	}

	var req struct {
		ExperimentNumber int      `json:"experiment_number"`
		ExperimentName   string   `json:"experiment_name"`
		Hours            int      `json:"hours"`
		Topics           []string `json:"topics"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		log.Println("CreateExperiment decode error:", err)
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	log.Printf("DEBUG CreateExperiment: courseID=%d, ExpNum=%d, ExpName=%s, Hours=%d, Topics=%v", courseID, req.ExperimentNumber, req.ExperimentName, req.Hours, req.Topics)

	// Verify course exists
	var courseExists int
	err = db.DB.QueryRow("SELECT COUNT(*) FROM courses WHERE course_id = ?", courseID).Scan(&courseExists)
	if err != nil {
		log.Printf("ERROR CreateExperiment: failed to check if course exists: %v", err)
		http.Error(w, "Failed to verify course", http.StatusInternalServerError)
		return
	}
	if courseExists == 0 {
		log.Printf("ERROR CreateExperiment: course %d does not exist", courseID)
		http.Error(w, "Course not found", http.StatusNotFound)
		return
	}

	// Insert experiment
	result, err := db.DB.Exec(`
		INSERT INTO course_experiments (course_id, experiment_number, experiment_name, hours)
		VALUES (?, ?, ?, ?)`, courseID, req.ExperimentNumber, req.ExperimentName, req.Hours)
	if err != nil {
		log.Printf("ERROR CreateExperiment: failed to insert experiment: %v", err)
		http.Error(w, "Failed to create experiment", http.StatusInternalServerError)
		return
	}

	expID, _ := result.LastInsertId()
	log.Printf("DEBUG CreateExperiment: successfully created experiment with ID=%d", expID)

	// Insert topics
	log.Printf("DEBUG CreateExperiment: will insert %d topics", len(req.Topics))
	for i, topic := range req.Topics {
		if topic == "" {
			log.Printf("DEBUG CreateExperiment: skipping empty topic at position %d", i)
			continue
		}
		log.Printf("DEBUG CreateExperiment: inserting topic %d: '%s'", i, topic)
		topicResult, err := db.DB.Exec(`
			INSERT INTO course_experiment_topics (experiment_id, topic_text, topic_order, status)
			VALUES (?, ?, ?, 1)`, expID, topic, i)
		if err != nil {
			log.Printf("ERROR CreateExperiment: failed to insert topic %d: %v", i, err)
		} else {
			topicID, _ := topicResult.LastInsertId()
			log.Printf("DEBUG CreateExperiment: successfully inserted topic with ID=%d", topicID)
		}
	}

	log.Printf("DEBUG CreateExperiment: completed successfully, returning experiment ID=%d", expID)
	json.NewEncoder(w).Encode(map[string]int64{"id": expID})
}

// UpdateExperiment updates an experiment and its topics
func UpdateExperiment(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	vars := mux.Vars(r)
	expID, err := strconv.Atoi(vars["expId"])
	if err != nil {
		http.Error(w, "Invalid experiment ID", http.StatusBadRequest)
		return
	}

	var req struct {
		ExperimentNumber int      `json:"experiment_number"`
		ExperimentName   string   `json:"experiment_name"`
		Hours            int      `json:"hours"`
		Topics           []string `json:"topics"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	tx, err := db.DB.Begin()
	if err != nil {
		log.Println("ERROR UpdateExperiment: Failed to begin transaction:", err)
		http.Error(w, "Failed to update experiment", http.StatusInternalServerError)
		return
	}
	defer func() {
		_ = tx.Rollback()
	}()

	result, err := tx.Exec(`
		UPDATE course_experiments
		SET experiment_number = ?, experiment_name = ?, hours = ?
		WHERE id = ? AND status = 1`, req.ExperimentNumber, req.ExperimentName, req.Hours, expID)
	if err != nil {
		log.Println("ERROR UpdateExperiment: Failed to update experiment:", err)
		http.Error(w, "Failed to update experiment", http.StatusInternalServerError)
		return
	}

	rowsAffected, _ := result.RowsAffected()
	log.Printf("DEBUG UpdateExperiment: Updated experiment ID %d, rows affected: %d", expID, rowsAffected)

	if rowsAffected == 0 {
		log.Printf("WARNING UpdateExperiment: No rows updated for experiment ID %d (might be soft-deleted or not exist)", expID)
		http.Error(w, "Experiment not found or already deleted", http.StatusNotFound)
		return
	}

	// Normalize incoming topics (keep order; skip empty)
	incomingTopics := make([]string, 0, len(req.Topics))
	for _, t := range req.Topics {
		norm := strings.TrimSpace(t)
		if norm == "" {
			continue
		}
		incomingTopics = append(incomingTopics, norm)
	}

	// Load current ACTIVE topics ordered by topic_order.
	// If the user only edits text (no add/remove), we update by index -> same DB row.
	// If the user adds/removes, we diff by text (LCS) to shift topic_order without overwriting texts.
	type existingActive struct {
		ID    int
		Text  string
		Order int
	}

	existingActiveTopics := make([]existingActive, 0)
	rows, err := tx.Query(`
		SELECT id, topic_text, topic_order
		FROM course_experiment_topics
		WHERE experiment_id = ? AND status = 1
		ORDER BY topic_order, id`, expID)
	if err != nil {
		log.Printf("ERROR UpdateExperiment: Failed to load active topics for exp_id=%d: %v", expID, err)
		http.Error(w, "Failed to update experiment topics", http.StatusInternalServerError)
		return
	}
	defer rows.Close()
	for rows.Next() {
		var t existingActive
		if err := rows.Scan(&t.ID, &t.Text, &t.Order); err != nil {
			continue
		}
		existingActiveTopics = append(existingActiveTopics, t)
	}

	// Case 1: edit-only (same count) => update same records by index.
	if len(incomingTopics) == len(existingActiveTopics) {
		log.Printf("DEBUG UpdateExperiment: Edit-only update of %d topics", len(incomingTopics))
		for i := range incomingTopics {
			id := existingActiveTopics[i].ID
			if _, err := tx.Exec(
				"UPDATE course_experiment_topics SET topic_text = ?, topic_order = ?, status = 1 WHERE id = ?",
				incomingTopics[i], i, id,
			); err != nil {
				log.Printf("ERROR UpdateExperiment: Failed to update topic id=%d exp_id=%d: %v", id, expID, err)
				return
			}
		}
	} else {
		// Case 2: add/remove => shift existing records without overwriting their texts.
		existingTexts := make([]string, 0, len(existingActiveTopics))
		for _, t := range existingActiveTopics {
			existingTexts = append(existingTexts, strings.TrimSpace(t.Text))
		}

		// LCS to find which existing rows remain (by text) and their new positions.
		n := len(existingTexts)
		m := len(incomingTopics)
		dp := make([][]int, n+1)
		for i := range dp {
			dp[i] = make([]int, m+1)
		}
		for i := 1; i <= n; i++ {
			for j := 1; j <= m; j++ {
				if existingTexts[i-1] == incomingTopics[j-1] {
					dp[i][j] = dp[i-1][j-1] + 1
				} else {
					if dp[i-1][j] >= dp[i][j-1] {
						dp[i][j] = dp[i-1][j]
					} else {
						dp[i][j] = dp[i][j-1]
					}
				}
			}
		}

		matchedExisting := make(map[int]int)
		matchedIncoming := make(map[int]bool)
		i := n
		j := m
		for i > 0 && j > 0 {
			if existingTexts[i-1] == incomingTopics[j-1] {
				matchedExisting[i-1] = j - 1
				matchedIncoming[j-1] = true
				i--
				j--
			} else if dp[i-1][j] >= dp[i][j-1] {
				i--
			} else {
				j--
			}
		}

		// Soft delete rows that were removed
		for idx, t := range existingActiveTopics {
			if _, ok := matchedExisting[idx]; !ok {
				if _, err := tx.Exec("UPDATE course_experiment_topics SET status = 0 WHERE id = ?", t.ID); err != nil {
					log.Printf("ERROR UpdateExperiment: Failed to soft delete removed topic id=%d exp_id=%d: %v", t.ID, expID, err)
					return
				}
			}
		}

		// Shift remaining rows (update topic_order only; keep text)
		for oldIdx, newIdx := range matchedExisting {
			id := existingActiveTopics[oldIdx].ID
			if _, err := tx.Exec("UPDATE course_experiment_topics SET topic_order = ?, status = 1 WHERE id = ?", newIdx, id); err != nil {
				log.Printf("ERROR UpdateExperiment: Failed to shift topic id=%d exp_id=%d: %v", id, expID, err)
				return
			}
		}

		// Insert new rows for topics that didn't exist before
		for idx, text := range incomingTopics {
			if matchedIncoming[idx] {
				continue
			}
			if _, err := tx.Exec(`
				INSERT INTO course_experiment_topics (experiment_id, topic_text, topic_order, status)
				VALUES (?, ?, ?, 1)`, expID, text, idx); err != nil {
				log.Printf("ERROR UpdateExperiment: Failed to insert new topic exp_id=%d order=%d: %v", expID, idx, err)
				return
			}
		}
	}

	if err := tx.Commit(); err != nil {
		log.Println("ERROR UpdateExperiment: Failed to commit transaction:", err)
		http.Error(w, "Failed to update experiment", http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

// DeleteExperiment deletes an experiment and its topics
func DeleteExperiment(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	vars := mux.Vars(r)
	expID, err := strconv.Atoi(vars["expId"])
	if err != nil {
		http.Error(w, "Invalid experiment ID", http.StatusBadRequest)
		return
	}

	// Soft delete experiment and its topics
	log.Printf("DEBUG DeleteExperiment: Soft deleting experiment ID=%d", expID)

	// Soft delete topics first
	_, err = db.DB.Exec("UPDATE course_experiment_topics SET status = 0 WHERE experiment_id = ?", expID)
	if err != nil {
		log.Printf("ERROR DeleteExperiment: Failed to soft delete topics: %v", err)
	}

	// Soft delete experiment
	result, err := db.DB.Exec("UPDATE course_experiments SET status = 0 WHERE id = ?", expID)
	if err != nil {
		log.Println("ERROR DeleteExperiment: Failed to soft delete experiment:", err)
		http.Error(w, "Failed to delete experiment", http.StatusInternalServerError)
		return
	}

	rowsAffected, _ := result.RowsAffected()
	log.Printf("DEBUG DeleteExperiment: Soft deleted experiment ID=%d, rows affected: %d", expID, rowsAffected)

	w.WriteHeader(http.StatusNoContent)
}
