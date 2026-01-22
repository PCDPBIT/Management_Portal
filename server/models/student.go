package models

import "time"

type Student struct {
	ID               int       `json:"id"`
	StudentID        string    `json:"student_id"`
	EnrollmentNo     string    `json:"enrollment_no"`
	RegisterNo       string    `json:"register_no"`
	DTERegNo         string    `json:"dte_reg_no"`
	ApplicationNo    string    `json:"application_no"`
	AdmissionNo      string    `json:"admission_no"`
	StudentName      string    `json:"student_name"`
	Gender           string    `json:"gender"`
	DOB              string    `json:"dob"`
	Age              int       `json:"age"`
	FatherName       string    `json:"father_name"`
	MotherName       string    `json:"mother_name"`
	GuardianName     string    `json:"guardian_name"`
	Religion         string    `json:"religion"`
	Nationality      string    `json:"nationality"`
	Community        string    `json:"community"`
	MotherTongue     string    `json:"mother_tongue"`
	BloodGroup       string    `json:"blood_group"`
	AadharNo         string    `json:"aadhar_no"`
	ParentOccupation string    `json:"parent_occupation"`
	Designation      string    `json:"designation"`
	PlaceOfWork      string    `json:"place_of_work"`
	ParentIncome     float64   `json:"parent_income"`
	CreatedAt        time.Time `json:"created_at"`
	UpdatedAt        time.Time `json:"updated_at"`
}

type CreateStudentRequest struct {
	StudentID        string `json:"student_id"`
	EnrollmentNo     string `json:"enrollment_no"`
	RegisterNo       string `json:"register_no"`
	DTERegNo         string `json:"dte_reg_no"`
	ApplicationNo    string `json:"application_no"`
	AdmissionNo      string `json:"admission_no"`
	StudentName      string `json:"student_name"`
	Gender           string `json:"gender"`
	DOB              string `json:"dob"`
	Age              int    `json:"age"`
	FatherName       string `json:"father_name"`
	MotherName       string `json:"mother_name"`
	GuardianName     string `json:"guardian_name"`
	Religion         string `json:"religion"`
	Nationality      string `json:"nationality"`
	Community        string `json:"community"`
	MotherTongue     string `json:"mother_tongue"`
	BloodGroup       string `json:"blood_group"`
	AadharNo         string `json:"aadhar_no"`
	ParentOccupation string `json:"parent_occupation"`
	Designation      string `json:"designation"`
	PlaceOfWork      string `json:"place_of_work"`
	ParentIncome     string `json:"parent_income"`
}
