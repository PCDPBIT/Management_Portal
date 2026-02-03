package models

import "time"

// AcademicCalendar represents the current academic calendar
type AcademicCalendar struct {
	ID                      int       `json:"id"`
	AcademicYear            string    `json:"academic_year"`
	CurrentSemester         int       `json:"current_semester"`
	SemesterStartDate       time.Time `json:"semester_start_date"`
	SemesterEndDate         time.Time `json:"semester_end_date"`
	ElectiveSelectionStart  *time.Time `json:"elective_selection_start,omitempty"`
	ElectiveSelectionEnd    *time.Time `json:"elective_selection_end,omitempty"`
	IsCurrent               bool      `json:"is_current"`
	CreatedAt               time.Time `json:"created_at"`
	UpdatedAt               time.Time `json:"updated_at"`
}

// HODElectiveSelection represents HOD's elective course selections
type HODElectiveSelection struct {
	ID                int       `json:"id"`
	DepartmentID      int       `json:"department_id"`
	CurriculumID      int       `json:"curriculum_id"`
	Semester          int       `json:"semester"`
	CourseID          int       `json:"course_id"`
	AcademicYear      string    `json:"academic_year"`
	Batch             *string   `json:"batch,omitempty"`
	MaxStudents       *int      `json:"max_students,omitempty"`
	ApprovedByUserID  int       `json:"approved_by_user_id"`
	Status            string    `json:"status"` // ACTIVE, INACTIVE, DRAFT
	CreatedAt         time.Time `json:"created_at"`
	UpdatedAt         time.Time `json:"updated_at"`
}

// StudentElectiveChoice represents student's elective selections
type StudentElectiveChoice struct {
	ID               int        `json:"id"`
	StudentID        int        `json:"student_id"`
	HODSelectionID   int        `json:"hod_selection_id"`
	Semester         int        `json:"semester"`
	AcademicYear     string     `json:"academic_year"`
	ChoiceOrder      int        `json:"choice_order"`
	Status           string     `json:"status"` // PENDING, CONFIRMED, REJECTED, WAITLISTED
	SelectedAt       time.Time  `json:"selected_at"`
	ConfirmedAt      *time.Time `json:"confirmed_at,omitempty"`
}

// DepartmentCurriculumActive maps departments to active curricula
type DepartmentCurriculumActive struct {
	ID           int       `json:"id"`
	DepartmentID int       `json:"department_id"`
	CurriculumID int       `json:"curriculum_id"`
	AcademicYear string    `json:"academic_year"`
	IsActive     bool      `json:"is_active"`
	CreatedAt    time.Time `json:"created_at"`
}

// ==================== DTOs for API Responses ====================

// HODProfileResponse - Response for HOD profile API
type HODProfileResponse struct {
	UserID     int                 `json:"user_id"`
	FullName   string              `json:"full_name"`
	Email      string              `json:"email"`
	Role       string              `json:"role"`
	Department *DepartmentInfo     `json:"department"`
	Curriculum *CurriculumInfo     `json:"curriculum"`
}

type DepartmentInfo struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
	Code string `json:"code,omitempty"`
}

type CurriculumInfo struct {
	ID           int    `json:"id"`
	Name         string `json:"name"`
	AcademicYear string `json:"academic_year"`
}

// ElectiveCourse - Course with selection status for HOD
type ElectiveCourse struct {
	ID              int    `json:"id"`
	CourseCode      string `json:"course_code"`
	CourseName      string `json:"course_name"`
	CourseType      string `json:"course_type"`
	Category        string `json:"category"`
	Credit          int    `json:"credit"`
	CardID          int    `json:"card_id"`
	CardType        string `json:"card_type"`
	IsSelected      bool   `json:"is_selected"`
	AssignedSemester *int  `json:"assigned_semester,omitempty"`
}

// AvailableElectivesResponse - Response for available electives API
type AvailableElectivesResponse struct {
	Semester           int              `json:"semester"`
	Batch              string           `json:"batch,omitempty"`
	AcademicYear       string           `json:"academic_year"`
	AvailableElectives []ElectiveCourse `json:"available_electives"`
}

// SaveElectivesRequest - Request to save HOD selections
type SaveElectivesRequest struct {
	Semester            int                       `json:"semester"`
	Batch               string                    `json:"batch,omitempty"`
	AcademicYear        string                    `json:"academic_year"`
	SelectedCourses     []int                     `json:"selected_courses"`
	CourseAssignments   []CourseAssignment        `json:"course_assignments"`
	Status              string                    `json:"status"` // ACTIVE or DRAFT
}

// CourseAssignment - Maps course to semester
type CourseAssignment struct {
	CourseID int `json:"course_id"`
	Semester int `json:"semester"`
}

// SaveElectivesResponse - Response after saving HOD selections
type SaveElectivesResponse struct {
	Success    bool                   `json:"success"`
	Message    string                 `json:"message"`
	Selections []HODElectiveSelection `json:"selections,omitempty"`
}

// BatchInfo - Batch information
type BatchInfo struct {
	Batch        string `json:"batch"`
	StudentCount int    `json:"student_count"`
}

// BatchesResponse - Response for batches API
type BatchesResponse struct {
	Batches []string `json:"batches"`
}

// SelectedElectivesResponse - Response for getting HOD's selected electives
type SelectedElectivesResponse struct {
	Semester        int                    `json:"semester"`
	Batch           string                 `json:"batch,omitempty"`
	AcademicYear    string                 `json:"academic_year"`
	SelectedCourses []ElectiveCourse       `json:"selected_courses"`
}

// StudentElectiveCourse - Course for student view
type StudentElectiveCourse struct {
	SelectionID        int    `json:"selection_id"`
	CourseCode         string `json:"course_code"`
	CourseName         string `json:"course_name"`
	CourseType         string `json:"course_type"`
	Category           string `json:"category"`
	Credit             int    `json:"credit"`
	MaxStudents        *int   `json:"max_students,omitempty"`
	CurrentEnrollments int    `json:"current_enrollments"`
	IsChosen           bool   `json:"is_chosen"`
}

// StudentAvailableElectivesResponse - Response for student available electives
type StudentAvailableElectivesResponse struct {
	Semester   int                     `json:"semester"`
	Electives  []StudentElectiveCourse `json:"electives"`
}

// StudentElectiveSelectionRequest - Request for student to choose electives
type StudentElectiveSelectionRequest struct {
	Semester   int                       `json:"semester"`
	Selections []StudentElectiveSelection `json:"selections"`
}

type StudentElectiveSelection struct {
	HODSelectionID int `json:"hod_selection_id"`
	ChoiceOrder    int `json:"choice_order"`
}
