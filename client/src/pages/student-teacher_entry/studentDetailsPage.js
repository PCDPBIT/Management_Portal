import React, { useState } from 'react'
import MainLayout from '../../components/MainLayout'
import { API_BASE_URL } from '../../config'

function StudentDetailsPage() {
  const [formData, setFormData] = useState({
    student_id: '',
    enrollment_no: '',
    register_no: '',
    dte_reg_no: '',
    application_no: '',
    admission_no: '',
    student_name: '',
    gender: '',
    dob: '',
    age: '',
    father_name: '',
    mother_name: '',
    guardian_name: '',
    religion: '',
    nationality: 'Indian',
    community: '',
    mother_tongue: '',
    blood_group: '',
    aadhar_no: '',
    parent_occupation: '',
    designation: '',
    place_of_work: '',
    parent_income: ''
  })

  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')
  const [loading, setLoading] = useState(false)

  // Auto-calculate age from DOB
  const calculateAge = (dob) => {
    if (!dob) return ''
    const today = new Date()
    const birthDate = new Date(dob)
    let age = today.getFullYear() - birthDate.getFullYear()
    const monthDiff = today.getMonth() - birthDate.getMonth()
    if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
      age--
    }
    return age
  }

  const handleInputChange = (e) => {
    const { name, value } = e.target
    
    // Auto-calculate age when DOB changes
    if (name === 'dob') {
      const calculatedAge = calculateAge(value)
      setFormData(prev => ({
        ...prev,
        [name]: value,
        age: calculatedAge
      }))
    } else {
      setFormData(prev => ({
        ...prev,
        [name]: value
      }))
    }
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setSuccess('')
    setLoading(true)

    try {
      const response = await fetch(`${API_BASE_URL}/students`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData)
      })

      if (!response.ok) {
        throw new Error('Failed to add student')
      }

      setSuccess('Student added successfully!')
      // Reset form
      setFormData({
        student_id: '',
        enrollment_no: '',
        register_no: '',
        dte_reg_no: '',
        application_no: '',
        admission_no: '',
        student_name: '',
        gender: '',
        dob: '',
        age: '',
        father_name: '',
        mother_name: '',
        guardian_name: '',
        religion: '',
        nationality: 'Indian',
        community: '',
        mother_tongue: '',
        blood_group: '',
        aadhar_no: '',
        parent_occupation: '',
        designation: '',
        place_of_work: '',
        parent_income: ''
      })
    } catch (err) {
      setError(err.message || 'Failed to add student')
    } finally {
      setLoading(false)
    }
  }

  return (
    <MainLayout
      title="Student Details"
      subtitle="Add and manage student information"
    >
      <div className="max-w-6xl mx-auto">
        {/* Messages */}
        {error && (
          <div className="mb-6 flex items-start space-x-3 p-4 bg-red-50 border border-red-200 rounded-lg">
            <svg className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
              <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clipRule="evenodd" />
            </svg>
            <p className="text-sm font-medium text-red-600">{error}</p>
          </div>
        )}

        {success && (
          <div className="mb-6 flex items-start space-x-3 p-4 bg-green-50 border border-green-200 rounded-lg">
            <svg className="w-5 h-5 text-green-600 flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
              <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
            </svg>
            <p className="text-sm font-medium text-green-600">{success}</p>
          </div>
        )}

        {/* Student Entry Form */}
        <div className="card-custom p-8">
          <h2 className="text-2xl font-bold text-gray-900 mb-6">Add New Student</h2>
          
          <form onSubmit={handleSubmit} className="space-y-8">
            {/* Identification Details */}
            <div>
              <h3 className="text-lg font-semibold text-gray-900 mb-4 pb-2 border-b border-gray-200">
                Identification Details
              </h3>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Student ID <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="student_id"
                    value={formData.student_id}
                    onChange={handleInputChange}
                    required
                    className="input-custom"
                    placeholder="e.g., STU001"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Enrollment No <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="enrollment_no"
                    value={formData.enrollment_no}
                    onChange={handleInputChange}
                    required
                    className="input-custom"
                    placeholder="College enrollment number"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Register No <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="register_no"
                    value={formData.register_no}
                    onChange={handleInputChange}
                    required
                    className="input-custom"
                    placeholder="Registration number"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    DTE Reg No <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="dte_reg_no"
                    value={formData.dte_reg_no}
                    onChange={handleInputChange}
                    required
                    className="input-custom"
                    placeholder="DTE registration number"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Application No <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="application_no"
                    value={formData.application_no}
                    onChange={handleInputChange}
                    required
                    className="input-custom"
                    placeholder="Application number"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Admission No <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="admission_no"
                    value={formData.admission_no}
                    onChange={handleInputChange}
                    required
                    className="input-custom"
                    placeholder="Admission number"
                  />
                </div>
              </div>
            </div>

            {/* Personal Details */}
            <div>
              <h3 className="text-lg font-semibold text-gray-900 mb-4 pb-2 border-b border-gray-200">
                Personal Details
              </h3>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div className="md:col-span-2">
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Student Name <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="student_name"
                    value={formData.student_name}
                    onChange={handleInputChange}
                    required
                    className="input-custom"
                    placeholder="Full name of student"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Gender <span className="text-red-500">*</span>
                  </label>
                  <select
                    name="gender"
                    value={formData.gender}
                    onChange={handleInputChange}
                    required
                    className="input-custom"
                  >
                    <option value="">Select Gender</option>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                    <option value="Other">Other</option>
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Date of Birth <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="date"
                    name="dob"
                    value={formData.dob}
                    onChange={handleInputChange}
                    required
                    className="input-custom"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Age
                  </label>
                  <input
                    type="number"
                    name="age"
                    value={formData.age}
                    onChange={handleInputChange}
                    readOnly
                    className="input-custom bg-gray-50"
                    placeholder="Auto-calculated"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Blood Group <span className="text-red-500">*</span>
                  </label>
                  <select
                    name="blood_group"
                    value={formData.blood_group}
                    onChange={handleInputChange}
                    required
                    className="input-custom"
                  >
                    <option value="">Select Blood Group</option>
                    <option value="A+">A+</option>
                    <option value="A-">A-</option>
                    <option value="B+">B+</option>
                    <option value="B-">B-</option>
                    <option value="AB+">AB+</option>
                    <option value="AB-">AB-</option>
                    <option value="O+">O+</option>
                    <option value="O-">O-</option>
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Aadhar No <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="aadhar_no"
                    value={formData.aadhar_no}
                    onChange={handleInputChange}
                    required
                    maxLength="12"
                    pattern="[0-9]{12}"
                    className="input-custom"
                    placeholder="12-digit Aadhar number"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Religion <span className="text-red-500">*</span>
                  </label>
                  <select
                    name="religion"
                    value={formData.religion}
                    onChange={handleInputChange}
                    required
                    className="input-custom"
                  >
                    <option value="">Select Religion</option>
                    <option value="Hindu">Hindu</option>
                    <option value="Muslim">Muslim</option>
                    <option value="Christian">Christian</option>
                    <option value="Sikh">Sikh</option>
                    <option value="Buddhist">Buddhist</option>
                    <option value="Jain">Jain</option>
                    <option value="Other">Other</option>
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Nationality <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="nationality"
                    value={formData.nationality}
                    onChange={handleInputChange}
                    required
                    className="input-custom"
                    placeholder="e.g., Indian"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Community <span className="text-red-500">*</span>
                  </label>
                  <select
                    name="community"
                    value={formData.community}
                    onChange={handleInputChange}
                    required
                    className="input-custom"
                  >
                    <option value="">Select Community</option>
                    <option value="OC">OC (Open Category)</option>
                    <option value="BC">BC (Backward Class)</option>
                    <option value="MBC">MBC (Most Backward Class)</option>
                    <option value="SC">SC (Scheduled Caste)</option>
                    <option value="ST">ST (Scheduled Tribe)</option>
                    <option value="SCC">SCC (Scheduled Caste Convert)</option>
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Mother Tongue <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="mother_tongue"
                    value={formData.mother_tongue}
                    onChange={handleInputChange}
                    required
                    className="input-custom"
                    placeholder="Native language"
                  />
                </div>
              </div>
            </div>

            {/* Family Details */}
            <div>
              <h3 className="text-lg font-semibold text-gray-900 mb-4 pb-2 border-b border-gray-200">
                Family Details
              </h3>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Father's Name <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="father_name"
                    value={formData.father_name}
                    onChange={handleInputChange}
                    required
                    className="input-custom"
                    placeholder="Father's full name"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Mother's Name <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="mother_name"
                    value={formData.mother_name}
                    onChange={handleInputChange}
                    required
                    className="input-custom"
                    placeholder="Mother's full name"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Guardian's Name
                  </label>
                  <input
                    type="text"
                    name="guardian_name"
                    value={formData.guardian_name}
                    onChange={handleInputChange}
                    className="input-custom"
                    placeholder="Guardian's name (if applicable)"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Parent Occupation <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="parent_occupation"
                    value={formData.parent_occupation}
                    onChange={handleInputChange}
                    required
                    className="input-custom"
                    placeholder="Parent's occupation"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Designation <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="designation"
                    value={formData.designation}
                    onChange={handleInputChange}
                    required
                    className="input-custom"
                    placeholder="Parent's job designation"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Place of Work <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="place_of_work"
                    value={formData.place_of_work}
                    onChange={handleInputChange}
                    required
                    className="input-custom"
                    placeholder="Parent's workplace"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Annual Family Income <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="number"
                    name="parent_income"
                    value={formData.parent_income}
                    onChange={handleInputChange}
                    required
                    className="input-custom"
                    placeholder="Annual income in ₹"
                  />
                </div>
              </div>
            </div>

            {/* Submit Button */}
            <div className="flex justify-end space-x-4 pt-4">
              <button
                type="button"
                onClick={() => setFormData({
                  student_id: '',
                  enrollment_no: '',
                  register_no: '',
                  dte_reg_no: '',
                  application_no: '',
                  admission_no: '',
                  student_name: '',
                  gender: '',
                  dob: '',
                  age: '',
                  father_name: '',
                  mother_name: '',
                  guardian_name: '',
                  religion: '',
                  nationality: 'Indian',
                  community: '',
                  mother_tongue: '',
                  blood_group: '',
                  aadhar_no: '',
                  parent_occupation: '',
                  designation: '',
                  place_of_work: '',
                  parent_income: ''
                })}
                className="px-6 py-2.5 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 font-medium transition-colors"
              >
                Reset
              </button>
              <button
                type="submit"
                disabled={loading}
                className="btn-primary-custom disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {loading ? 'Adding Student...' : 'Add Student'}
              </button>
            </div>
          </form>
        </div>
      </div>
    </MainLayout>
  )
}

export default StudentDetailsPage
