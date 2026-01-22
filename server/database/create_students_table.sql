-- Create students table
CREATE TABLE IF NOT EXISTS students (
    id SERIAL PRIMARY KEY,
    student_id VARCHAR(50) UNIQUE NOT NULL,
    enrollment_no VARCHAR(50) UNIQUE NOT NULL,
    register_no VARCHAR(50) UNIQUE NOT NULL,
    dte_reg_no VARCHAR(50) NOT NULL,
    application_no VARCHAR(50) NOT NULL,
    admission_no VARCHAR(50) NOT NULL,
    student_name VARCHAR(255) NOT NULL,
    gender VARCHAR(20) NOT NULL,
    dob DATE NOT NULL,
    age INTEGER,
    father_name VARCHAR(255) NOT NULL,
    mother_name VARCHAR(255) NOT NULL,
    guardian_name VARCHAR(255),
    religion VARCHAR(50) NOT NULL,
    nationality VARCHAR(50) NOT NULL DEFAULT 'Indian',
    community VARCHAR(50) NOT NULL,
    mother_tongue VARCHAR(50) NOT NULL,
    blood_group VARCHAR(10) NOT NULL,
    aadhar_no VARCHAR(12) UNIQUE NOT NULL,
    parent_occupation VARCHAR(100) NOT NULL,
    designation VARCHAR(100) NOT NULL,
    place_of_work VARCHAR(255) NOT NULL,
    parent_income DECIMAL(12, 2) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create index on student_id for faster lookups
CREATE INDEX idx_students_student_id ON students(student_id);

-- Create index on enrollment_no for faster lookups
CREATE INDEX idx_students_enrollment_no ON students(enrollment_no);

-- Create index on register_no for faster lookups
CREATE INDEX idx_students_register_no ON students(register_no);
