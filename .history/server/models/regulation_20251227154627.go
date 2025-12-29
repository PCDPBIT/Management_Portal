package models

import "time"

// Regulation represents an academic regulation document
type Regulation struct {
	ID        int       `json:"id"`
	Code      string    `json:"code"`
	Name      string    `json:"name"`
	Status    string    `json:"status"` // DRAFT, PUBLISHED, LOCKED
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

// RegulationClause represents a single clause within a regulation
type RegulationClause struct {
	ID           int       `json:"id"`
	RegulationID int       `json:"regulation_id"`
	SectionNo    int       `json:"section_no"`
	ClauseNo     string    `json:"clause_no"`
	Title        string    `json:"title"`
	Content      string    `json:"content"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

// RegulationClauseHistory tracks changes to regulation clauses
type RegulationClauseHistory struct {
	ID           int       `json:"id"`
	ClauseID     int       `json:"clause_id"`
	OldContent   string    `json:"old_content"`
	NewContent   string    `json:"new_content"`
	ChangedBy    string    `json:"changed_by"`
	ChangedAt    time.Time `json:"changed_at"`
	ChangeReason string    `json:"change_reason"`
}

// Legacy Regulation model for curriculum compatibility
type LegacyRegulation struct {
	ID           int       `json:"id"`
	Name         string    `json:"name"`
	AcademicYear string    `json:"academic_year"`
	MaxCredits   int       `json:"max_credits"`
	CreatedAt    time.Time `json:"created_at"`
}
