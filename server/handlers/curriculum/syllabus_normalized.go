package curriculum

import (
	"database/sql"
	"log"
	"server/db"
	"server/models"
	"strings"
)

// Helper functions for normalized syllabus data access
// All tables reference course_id directly (course-centric design)

// fetchObjectives retrieves all objectives for a course ordered by position
func fetchObjectives(courseID int) ([]string, error) {
	rows, err := db.DB.Query(`
		SELECT objective 
		FROM course_objectives 
		WHERE course_id = ? AND (status = 1 OR status IS NULL)
		ORDER BY position`, courseID)
	if err != nil {
		return []string{}, err
	}
	defer rows.Close()

	objectives := []string{}
	for rows.Next() {
		var text string
		if err := rows.Scan(&text); err == nil {
			objectives = append(objectives, text)
		}
	}
	return objectives, nil
}

// fetchOutcomes retrieves all outcomes for a course ordered by position
func fetchOutcomes(courseID int) ([]string, error) {
	rows, err := db.DB.Query(`
		SELECT outcome 
		FROM course_outcomes 
		WHERE course_id = ? AND (status = 1 OR status IS NULL)
		ORDER BY position`, courseID)
	if err != nil {
		return []string{}, err
	}
	defer rows.Close()

	outcomes := []string{}
	for rows.Next() {
		var text string
		if err := rows.Scan(&text); err == nil {
			outcomes = append(outcomes, text)
		}
	}
	return outcomes, nil
}

// fetchReferences retrieves all references for a course ordered by position
func fetchReferences(courseID int) ([]string, error) {
	rows, err := db.DB.Query(`
		SELECT reference_text 
		FROM course_references 
		WHERE course_id = ? AND (status = 1 OR status IS NULL)
		ORDER BY position`, courseID)
	if err != nil {
		return []string{}, err
	}
	defer rows.Close()

	references := []string{}
	for rows.Next() {
		var text string
		if err := rows.Scan(&text); err == nil {
			references = append(references, text)
		}
	}
	return references, nil
}

// fetchPrerequisites retrieves all prerequisites for a course ordered by position
func fetchPrerequisites(courseID int) ([]string, error) {
	rows, err := db.DB.Query(`
		SELECT prerequisite 
		FROM course_prerequisites 
		WHERE course_id = ? 
		ORDER BY position`, courseID)
	if err != nil {
		return []string{}, err
	}
	defer rows.Close()

	prerequisites := []string{}
	for rows.Next() {
		var text string
		if err := rows.Scan(&text); err == nil {
			prerequisites = append(prerequisites, text)
		}
	}
	return prerequisites, nil
}

// fetchTeamwork retrieves teamwork data for a course
func fetchTeamwork(courseID int) (*models.Teamwork, error) {
	// Get total_hours from course_teamwork
	var hours int
	err := db.DB.QueryRow(`
		SELECT total_hours 
		FROM course_teamwork 
		WHERE course_id = ?`, courseID).Scan(&hours)

	if err == sql.ErrNoRows {
		return nil, nil // No teamwork data
	}
	if err != nil {
		return nil, err
	}

	// Fetch activities from course_teamwork_activities
	rows, err := db.DB.Query(`
		SELECT activity 
		FROM course_teamwork_activities 
		WHERE course_id = ? 
		ORDER BY position`, courseID)
	if err != nil {
		return &models.Teamwork{Hours: hours, Activities: []string{}}, nil
	}
	defer rows.Close()

	activities := []string{}
	for rows.Next() {
		var text string
		if err := rows.Scan(&text); err == nil {
			activities = append(activities, text)
		}
	}

	return &models.Teamwork{
		Hours:      hours,
		Activities: activities,
	}, nil
}

// fetchSelfLearning retrieves self-learning data for a course
func fetchSelfLearning(courseID int) (*models.SelfLearning, error) {
	var hours int
	err := db.DB.QueryRow(`
		SELECT total_hours 
		FROM course_selflearning 
		WHERE course_id = ?`, courseID).Scan(&hours)

	if err == sql.ErrNoRows {
		return nil, nil // No self-learning data
	}
	if err != nil {
		return nil, err
	}

	// Fetch main topics
	rows, err := db.DB.Query(`
		SELECT id, main_text 
		FROM course_selflearning_topics 
		WHERE course_id = ? 
		ORDER BY position`, courseID)
	if err != nil {
		return &models.SelfLearning{Hours: hours, MainInputs: []models.SelfLearningInternal{}}, nil
	}
	defer rows.Close()

	mainInputs := []models.SelfLearningInternal{}
	for rows.Next() {
		var mainID int
		var mainText string
		if err := rows.Scan(&mainID, &mainText); err == nil {
			// Fetch internal resources for this main topic
			internalRows, err := db.DB.Query(`
				SELECT internal_text 
				FROM course_selflearning_resources 
				WHERE main_id = ? 
				ORDER BY position`, mainID)

			internal := []string{}
			if err == nil {
				defer internalRows.Close()
				for internalRows.Next() {
					var text string
					if err := internalRows.Scan(&text); err == nil {
						internal = append(internal, text)
					}
				}
			}

			mainInputs = append(mainInputs, models.SelfLearningInternal{
				Main:     mainText,
				Internal: internal,
			})
		}
	}

	return &models.SelfLearning{
		Hours:      hours,
		MainInputs: mainInputs,
	}, nil
}

// saveObjectives saves objectives for a course, replacing existing ones
func saveObjectives(courseID int, objectives []string) error {
	log.Printf("DEBUG saveObjectives: courseID=%d, count=%d", courseID, len(objectives))

	// Normalize input (keep order; skip empty)
	incoming := make([]string, 0, len(objectives))
	for _, o := range objectives {
		norm := strings.TrimSpace(o)
		if norm == "" {
			continue
		}
		incoming = append(incoming, norm)
	}

	tx, err := db.DB.Begin()
	if err != nil {
		log.Printf("ERROR saveObjectives begin tx: %v", err)
		return err
	}
	defer func() { _ = tx.Rollback() }()

	type existingObjective struct {
		ID       int
		Text     string
		Position int
	}

	existing := make([]existingObjective, 0)
	rows, err := tx.Query(`
		SELECT id, objective, position
		FROM course_objectives
		WHERE course_id = ? AND (status = 1 OR status IS NULL)
		ORDER BY position, id`, courseID)
	if err != nil {
		log.Printf("ERROR saveObjectives load existing: %v", err)
		return err
	}
	defer rows.Close()
	for rows.Next() {
		var o existingObjective
		if err := rows.Scan(&o.ID, &o.Text, &o.Position); err == nil {
			existing = append(existing, o)
		}
	}

	// Case 1: edit-only (same count) => update same records by index
	if len(incoming) == len(existing) {
		for i := range incoming {
			if _, err := tx.Exec(
				"UPDATE course_objectives SET objective = ?, position = ?, status = 1 WHERE id = ?",
				incoming[i], i, existing[i].ID,
			); err != nil {
				log.Printf("ERROR saveObjectives update id=%d: %v", existing[i].ID, err)
				return err
			}
		}
		if err := tx.Commit(); err != nil {
			log.Printf("ERROR saveObjectives commit: %v", err)
			return err
		}
		log.Printf("DEBUG saveObjectives: updated %d objectives (edit-only)", len(incoming))
		return nil
	}

	// Case 2: add/remove => diff by text, shift positions without overwriting texts
	existingTexts := make([]string, 0, len(existing))
	for _, o := range existing {
		existingTexts = append(existingTexts, strings.TrimSpace(o.Text))
	}
	n := len(existingTexts)
	m := len(incoming)
	dp := make([][]int, n+1)
	for i := range dp {
		dp[i] = make([]int, m+1)
	}
	for i := 1; i <= n; i++ {
		for j := 1; j <= m; j++ {
			if existingTexts[i-1] == incoming[j-1] {
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
		if existingTexts[i-1] == incoming[j-1] {
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

	// Soft delete removed
	for idx, o := range existing {
		if _, ok := matchedExisting[idx]; !ok {
			if _, err := tx.Exec("UPDATE course_objectives SET status = 0 WHERE id = ?", o.ID); err != nil {
				log.Printf("ERROR saveObjectives soft delete id=%d: %v", o.ID, err)
				return err
			}
		}
	}

	// Avoid unique(course_id,position) collisions while shifting positions
	if _, err := tx.Exec(
		"UPDATE course_objectives SET position = position + 10000 WHERE course_id = ? AND (status = 1 OR status IS NULL)",
		courseID,
	); err != nil {
		log.Printf("ERROR saveObjectives temp bump: %v", err)
		return err
	}

	// Shift kept objectives (position only)
	for oldIdx, newIdx := range matchedExisting {
		id := existing[oldIdx].ID
		if _, err := tx.Exec("UPDATE course_objectives SET position = ?, status = 1 WHERE id = ?", newIdx, id); err != nil {
			log.Printf("ERROR saveObjectives shift id=%d: %v", id, err)
			return err
		}
	}

	// Insert new objectives
	for idx, text := range incoming {
		if matchedIncoming[idx] {
			continue
		}
		if _, err := tx.Exec(
			"INSERT INTO course_objectives (course_id, objective, position, status) VALUES (?, ?, ?, 1)",
			courseID, text, idx,
		); err != nil {
			log.Printf("ERROR saveObjectives insert position=%d: %v", idx, err)
			return err
		}
	}

	if err := tx.Commit(); err != nil {
		log.Printf("ERROR saveObjectives commit: %v", err)
		return err
	}
	log.Printf("DEBUG saveObjectives: successfully saved %d objectives", len(incoming))
	return nil
}

// saveOutcomes saves outcomes for a course, replacing existing ones
func saveOutcomes(courseID int, outcomes []string) error {
	log.Printf("DEBUG saveOutcomes: courseID=%d, count=%d", courseID, len(outcomes))

	// Normalize input (keep order; skip empty)
	incoming := make([]string, 0, len(outcomes))
	for _, o := range outcomes {
		norm := strings.TrimSpace(o)
		if norm == "" {
			continue
		}
		incoming = append(incoming, norm)
	}

	tx, err := db.DB.Begin()
	if err != nil {
		log.Printf("ERROR saveOutcomes begin tx: %v", err)
		return err
	}
	defer func() { _ = tx.Rollback() }()

	type existingOutcome struct {
		ID       int
		Text     string
		Position int
	}

	existing := make([]existingOutcome, 0)
	rows, err := tx.Query(`
		SELECT id, outcome, position
		FROM course_outcomes
		WHERE course_id = ? AND (status = 1 OR status IS NULL)
		ORDER BY position, id`, courseID)
	if err != nil {
		log.Printf("ERROR saveOutcomes load existing: %v", err)
		return err
	}
	defer rows.Close()
	for rows.Next() {
		var o existingOutcome
		if err := rows.Scan(&o.ID, &o.Text, &o.Position); err == nil {
			existing = append(existing, o)
		}
	}

	// Case 1: edit-only (same count) => update same records by index
	if len(incoming) == len(existing) {
		for i := range incoming {
			if _, err := tx.Exec(
				"UPDATE course_outcomes SET outcome = ?, position = ?, status = 1 WHERE id = ?",
				incoming[i], i, existing[i].ID,
			); err != nil {
				log.Printf("ERROR saveOutcomes update id=%d: %v", existing[i].ID, err)
				return err
			}
		}
		if err := tx.Commit(); err != nil {
			log.Printf("ERROR saveOutcomes commit: %v", err)
			return err
		}
		log.Printf("DEBUG saveOutcomes: updated %d outcomes (edit-only)", len(incoming))
		return nil
	}

	// Case 2: add/remove => diff by text, shift positions without overwriting texts
	existingTexts := make([]string, 0, len(existing))
	for _, o := range existing {
		existingTexts = append(existingTexts, strings.TrimSpace(o.Text))
	}
	n := len(existingTexts)
	m := len(incoming)
	dp := make([][]int, n+1)
	for i := range dp {
		dp[i] = make([]int, m+1)
	}
	for i := 1; i <= n; i++ {
		for j := 1; j <= m; j++ {
			if existingTexts[i-1] == incoming[j-1] {
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
		if existingTexts[i-1] == incoming[j-1] {
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

	// Soft delete removed
	for idx, o := range existing {
		if _, ok := matchedExisting[idx]; !ok {
			if _, err := tx.Exec("UPDATE course_outcomes SET status = 0 WHERE id = ?", o.ID); err != nil {
				log.Printf("ERROR saveOutcomes soft delete id=%d: %v", o.ID, err)
				return err
			}
		}
	}

	// Avoid unique(course_id,position) collisions while shifting positions
	if _, err := tx.Exec(
		"UPDATE course_outcomes SET position = position + 10000 WHERE course_id = ? AND (status = 1 OR status IS NULL)",
		courseID,
	); err != nil {
		log.Printf("ERROR saveOutcomes temp bump: %v", err)
		return err
	}

	// Shift kept outcomes (position only)
	for oldIdx, newIdx := range matchedExisting {
		id := existing[oldIdx].ID
		if _, err := tx.Exec("UPDATE course_outcomes SET position = ?, status = 1 WHERE id = ?", newIdx, id); err != nil {
			log.Printf("ERROR saveOutcomes shift id=%d: %v", id, err)
			return err
		}
	}

	// Insert new outcomes
	for idx, text := range incoming {
		if matchedIncoming[idx] {
			continue
		}
		if _, err := tx.Exec(
			"INSERT INTO course_outcomes (course_id, outcome, position, status) VALUES (?, ?, ?, 1)",
			courseID, text, idx,
		); err != nil {
			log.Printf("ERROR saveOutcomes insert position=%d: %v", idx, err)
			return err
		}
	}

	if err := tx.Commit(); err != nil {
		log.Printf("ERROR saveOutcomes commit: %v", err)
		return err
	}
	log.Printf("DEBUG saveOutcomes: successfully saved %d outcomes", len(incoming))
	return nil
}

// saveReferences saves references for a course, replacing existing ones
func saveReferences(courseID int, references []string) error {
	log.Printf("DEBUG saveReferences: courseID=%d, count=%d", courseID, len(references))

	// Normalize input (keep order; skip empty)
	incoming := make([]string, 0, len(references))
	for _, r := range references {
		norm := strings.TrimSpace(r)
		if norm == "" {
			continue
		}
		incoming = append(incoming, norm)
	}

	tx, err := db.DB.Begin()
	if err != nil {
		log.Printf("ERROR saveReferences begin tx: %v", err)
		return err
	}
	defer func() { _ = tx.Rollback() }()

	type existingRef struct {
		ID       int
		Text     string
		Position int
	}

	existing := make([]existingRef, 0)
	rows, err := tx.Query(`
		SELECT id, reference_text, position
		FROM course_references
		WHERE course_id = ? AND (status = 1 OR status IS NULL)
		ORDER BY position, id`, courseID)
	if err != nil {
		log.Printf("ERROR saveReferences load existing: %v", err)
		return err
	}
	defer rows.Close()
	for rows.Next() {
		var r existingRef
		if err := rows.Scan(&r.ID, &r.Text, &r.Position); err == nil {
			existing = append(existing, r)
		}
	}

	// Case 1: edit-only (same count) => update same records by index
	if len(incoming) == len(existing) {
		for i := range incoming {
			if _, err := tx.Exec(
				"UPDATE course_references SET reference_text = ?, position = ?, status = 1 WHERE id = ?",
				incoming[i], i, existing[i].ID,
			); err != nil {
				log.Printf("ERROR saveReferences update id=%d: %v", existing[i].ID, err)
				return err
			}
		}
		if err := tx.Commit(); err != nil {
			log.Printf("ERROR saveReferences commit: %v", err)
			return err
		}
		log.Printf("DEBUG saveReferences: updated %d references (edit-only)", len(incoming))
		return nil
	}

	// Case 2: add/remove => diff by text, shift positions without overwriting texts
	existingTexts := make([]string, 0, len(existing))
	for _, r := range existing {
		existingTexts = append(existingTexts, strings.TrimSpace(r.Text))
	}
	n := len(existingTexts)
	m := len(incoming)
	dp := make([][]int, n+1)
	for i := range dp {
		dp[i] = make([]int, m+1)
	}
	for i := 1; i <= n; i++ {
		for j := 1; j <= m; j++ {
			if existingTexts[i-1] == incoming[j-1] {
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
		if existingTexts[i-1] == incoming[j-1] {
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

	// Soft delete removed
	for idx, r := range existing {
		if _, ok := matchedExisting[idx]; !ok {
			if _, err := tx.Exec("UPDATE course_references SET status = 0 WHERE id = ?", r.ID); err != nil {
				log.Printf("ERROR saveReferences soft delete id=%d: %v", r.ID, err)
				return err
			}
		}
	}

	// Avoid unique(course_id,position) collisions while shifting positions
	if _, err := tx.Exec(
		"UPDATE course_references SET position = position + 10000 WHERE course_id = ? AND (status = 1 OR status IS NULL)",
		courseID,
	); err != nil {
		log.Printf("ERROR saveReferences temp bump: %v", err)
		return err
	}

	// Shift kept refs (position only)
	for oldIdx, newIdx := range matchedExisting {
		id := existing[oldIdx].ID
		if _, err := tx.Exec("UPDATE course_references SET position = ?, status = 1 WHERE id = ?", newIdx, id); err != nil {
			log.Printf("ERROR saveReferences shift id=%d: %v", id, err)
			return err
		}
	}

	// Insert new refs
	for idx, text := range incoming {
		if matchedIncoming[idx] {
			continue
		}
		if _, err := tx.Exec(
			"INSERT INTO course_references (course_id, reference_text, position, status) VALUES (?, ?, ?, 1)",
			courseID, text, idx,
		); err != nil {
			log.Printf("ERROR saveReferences insert position=%d: %v", idx, err)
			return err
		}
	}

	if err := tx.Commit(); err != nil {
		log.Printf("ERROR saveReferences commit: %v", err)
		return err
	}
	log.Printf("DEBUG saveReferences: successfully saved %d references", len(incoming))
	return nil
}

// savePrerequisites saves prerequisites for a course, replacing existing ones
func savePrerequisites(courseID int, prerequisites []string) error {
	// Delete existing
	_, err := db.DB.Exec("DELETE FROM course_prerequisites WHERE course_id = ?", courseID)
	if err != nil {
		return err
	}

	// Insert new ones with position
	for i, text := range prerequisites {
		if text == "" {
			continue
		}
		_, err := db.DB.Exec(`
			INSERT INTO course_prerequisites (course_id, prerequisite, position) 
			VALUES (?, ?, ?)`, courseID, text, i)
		if err != nil {
			return err
		}
	}
	return nil
}

// saveTeamwork saves teamwork data for a course
func saveTeamwork(courseID int, teamwork *models.Teamwork) error {
	if teamwork == nil {
		log.Printf("DEBUG: saveTeamwork called with nil teamwork for courseID %d", courseID)
		// Delete if nil
		db.DB.Exec("DELETE FROM course_teamwork_activities WHERE course_id = ?", courseID)
		db.DB.Exec("DELETE FROM course_teamwork WHERE course_id = ?", courseID)
		return nil
	}

	log.Printf("DEBUG: saveTeamwork called for courseID %d with hours=%d, activities=%v", courseID, teamwork.Hours, teamwork.Activities)

	// Upsert total_hours in course_teamwork
	result, err := db.DB.Exec(`
		INSERT INTO course_teamwork (course_id, total_hours) 
		VALUES (?, ?) 
		ON DUPLICATE KEY UPDATE total_hours = ?`,
		courseID, teamwork.Hours, teamwork.Hours)
	if err != nil {
		log.Printf("ERROR: Failed to upsert course_teamwork: %v", err)
		return err
	}
	rowsAffected, _ := result.RowsAffected()
	log.Printf("DEBUG: course_teamwork upsert affected %d rows", rowsAffected)

	// Delete existing activities
	_, err = db.DB.Exec("DELETE FROM course_teamwork_activities WHERE course_id = ?", courseID)
	if err != nil {
		log.Printf("ERROR: Failed to delete existing teamwork activities: %v", err)
		return err
	}

	// Insert new activities
	log.Printf("DEBUG: Inserting %d teamwork activities", len(teamwork.Activities))
	for i, text := range teamwork.Activities {
		if text == "" {
			log.Printf("DEBUG: Skipping empty activity at position %d", i)
			continue
		}
		result, err := db.DB.Exec(`
			INSERT INTO course_teamwork_activities (course_id, activity, position) 
			VALUES (?, ?, ?)`, courseID, text, i)
		if err != nil {
			log.Printf("ERROR: Failed to insert teamwork activity at position %d: %v", i, err)
			return err
		}
		rowsAffected, _ := result.RowsAffected()
		log.Printf("DEBUG: Inserted teamwork activity at position %d, affected %d rows", i, rowsAffected)
	}
	log.Printf("DEBUG: Successfully saved teamwork data for courseID %d", courseID)
	return nil
}

// saveSelfLearning saves self-learning data for a course
func saveSelfLearning(courseID int, selflearning *models.SelfLearning) error {
	if selflearning == nil {
		// Delete if nil
		db.DB.Exec("DELETE FROM course_selflearning_resources WHERE main_id IN (SELECT id FROM course_selflearning_topics WHERE course_id = ?)", courseID)
		db.DB.Exec("DELETE FROM course_selflearning_topics WHERE course_id = ?", courseID)
		db.DB.Exec("DELETE FROM course_selflearning WHERE course_id = ?", courseID)
		return nil
	}

	// Upsert self-learning total_hours
	_, err := db.DB.Exec(`
		INSERT INTO course_selflearning (course_id, total_hours) 
		VALUES (?, ?) 
		ON DUPLICATE KEY UPDATE total_hours = ?`,
		courseID, selflearning.Hours, selflearning.Hours)
	if err != nil {
		return err
	}

	// Delete existing main topics and their internals
	db.DB.Exec("DELETE FROM course_selflearning_resources WHERE main_id IN (SELECT id FROM course_selflearning_topics WHERE course_id = ?)", courseID)
	db.DB.Exec("DELETE FROM course_selflearning_topics WHERE course_id = ?", courseID)

	// Insert new main topics
	for i, mainInput := range selflearning.MainInputs {
		if mainInput.Main == "" {
			continue
		}

		result, err := db.DB.Exec(`
			INSERT INTO course_selflearning_topics (course_id, main_text, position) 
			VALUES (?, ?, ?)`, courseID, mainInput.Main, i)
		if err != nil {
			return err
		}

		mainID, _ := result.LastInsertId()

		// Insert internal resources for this main topic
		for j, text := range mainInput.Internal {
			if text == "" {
				continue
			}
			_, err := db.DB.Exec(`
				INSERT INTO course_selflearning_resources (main_id, internal_text, position) 
				VALUES (?, ?, ?)`, mainID, text, j)
			if err != nil {
				return err
			}
		}
	}
	return nil
}
