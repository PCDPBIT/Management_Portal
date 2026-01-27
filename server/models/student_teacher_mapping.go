package models

import "time"

// StudentTeacherMapping represents the assignment of students to teachers
type StudentTeacherMapping struct {
	ID           int       `json:"id"`
	StudentID    int       `json:"student_id"`
	TeacherID    int64     `json:"teacher_id"`
	DepartmentID int       `json:"department_id"`
	Year         int       `json:"year"`
	AcademicYear string    `json:"academic_year"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

// StudentWithMapping represents a student with their assigned teacher information
type StudentWithMapping struct {
	StudentID    int     `json:"student_id"`
	EnrollmentNo string  `json:"enrollment_no"`
	StudentName  string  `json:"student_name"`
	Department   string  `json:"department"`
	Year         int     `json:"year"`
	TeacherID    *int64  `json:"teacher_id,omitempty"`
	TeacherName  *string `json:"teacher_name,omitempty"`
}

// TeacherWithStudentCount represents a teacher with their student count
type TeacherWithStudentCount struct {
	TeacherID    int64  `json:"teacher_id"`
	TeacherName  string `json:"teacher_name"`
	Email        string `json:"email"`
	ProfileImg   string `json:"profile_img"`
	Designation  string `json:"designation"`
	StudentCount int    `json:"student_count"`
}

// StudentTeacherMappingRequest represents a request to assign students to teachers
type StudentTeacherMappingRequest struct {
	DepartmentID int    `json:"department_id"`
	Year         int    `json:"year"`
	AcademicYear string `json:"academic_year"`
}

// StudentTeacherMappingResponse represents the response after assignment
type StudentTeacherMappingResponse struct {
	Success         bool   `json:"success"`
	Message         string `json:"message"`
	TotalStudents   int    `json:"total_students"`
	TotalTeachers   int    `json:"total_teachers"`
	MappingsCreated int    `json:"mappings_created"`
}
