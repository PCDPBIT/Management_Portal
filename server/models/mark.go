package models

// MarkCategoryType represents a mark assessment component/category for courses
type MarkCategoryType struct {
	ID              int     `json:"id"`
	Name            string  `json:"name"`
	MaxMarks        int     `json:"max_marks"`
	ConversionMarks float64 `json:"conversion_marks"`
	Position        int     `json:"position"`
	CourseTypeID    int     `json:"course_type_id"`
	CategoryNameID  int     `json:"category_name_id"`
	LearningModeID  int     `json:"learning_mode_id"`
	Status          int     `json:"status"`
}

// MarkCategoryName represents the name/label of a mark category
type MarkCategoryName struct {
	ID           int    `json:"id"`
	CategoryName string `json:"category_name"`
	Status       int    `json:"status"`
}

// StudentMark represents a student's mark entry for an assessment component
type StudentMark struct {
	ID                    int     `json:"id"`
	StudentID             int     `json:"student_id"`
	CourseID              int     `json:"course_id"`
	FacultyID             string  `json:"faculty_id"`
	AssessmentComponentID int     `json:"assessment_component_id"`
	ObtainedMarks         float64 `json:"obtained_marks"`
	ConvertedMarks        float64 `json:"converted_marks"`
	Status                int     `json:"status"`
}

// StudentMarkEntry is used for bulk save requests
type StudentMarkEntry struct {
	StudentID             int     `json:"student_id"`
	CourseID              int     `json:"course_id"`
	AssessmentComponentID int     `json:"assessment_component_id"`
	ObtainedMarks         float64 `json:"obtained_marks"`
}

// MarkEntrySaveRequest contains batch mark entries to save
type MarkEntrySaveRequest struct {
	CourseID      int                 `json:"course_id"`
	FacultyID     string              `json:"faculty_id"`
	MarkEntries   []StudentMarkEntry  `json:"mark_entries"`
}

// MarkEntrySaveResponse is returned after saving marks
type MarkEntrySaveResponse struct {
	Success    bool   `json:"success"`
	Message    string `json:"message"`
	SavedCount int    `json:"saved_count"`
}
