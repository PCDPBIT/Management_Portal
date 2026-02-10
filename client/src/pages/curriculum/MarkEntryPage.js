import React, { useState, useEffect } from 'react'
import MainLayout from '../../components/MainLayout'
import { API_BASE_URL } from '../../config'

function MarkEntryPage() {
  const [courses, setCourses] = useState([])
  const [selectedCourse, setSelectedCourse] = useState(null)
  const [markCategories, setMarkCategories] = useState([])
  const [students, setStudents] = useState([])
  const [studentMarks, setStudentMarks] = useState({})
  const [loading, setLoading] = useState(false)
  const [savingMarks, setSavingMarks] = useState(false)
  const [message, setMessage] = useState({ type: '', text: '' })

  const teacherId = localStorage.getItem('teacher_id') || localStorage.getItem('teacherId')

  // Fetch teacher's courses on component mount
  useEffect(() => {
    if (!teacherId) {
      setMessage({ type: 'error', text: 'Teacher ID not found. Please login again.' })
      return
    }
    fetchTeacherCourses()
  }, [teacherId])

  const fetchTeacherCourses = async () => {
    try {
      setLoading(true)
      const response = await fetch(`${API_BASE_URL}/teachers/${teacherId}/courses`)
      if (!response.ok) throw new Error('Failed to fetch courses')
      const data = await response.json()
      
      // Filter courses with enrollments
      const coursesWithStudents = data.filter((course) => course.enrollments && course.enrollments.length > 0)
      setCourses(coursesWithStudents)
      
      // Select first course if available
      if (coursesWithStudents.length > 0) {
        setSelectedCourse(coursesWithStudents[0])
      }
      setMessage({ type: '', text: '' })
    } catch (error) {
      console.error('Error fetching courses:', error)
      setMessage({ type: 'error', text: 'Failed to load courses. Please try again.' })
    } finally {
      setLoading(false)
    }
  }

  // Fetch mark categories when course is selected
  useEffect(() => {
    if (!selectedCourse) return
    fetchMarkCategories()
    loadExistingMarks()
  }, [selectedCourse])

  const fetchMarkCategories = async () => {
    try {
      if (!teacherId) {
        setMessage({ type: 'error', text: 'Teacher ID not found. Please login again.' })
        return
      }

      const response = await fetch(
        `${API_BASE_URL}/course/${selectedCourse.course_id}/mark-categories?teacher_id=${teacherId}`
      )
      if (response.status === 403) {
        setMarkCategories([])
        setMessage({ type: 'warning', text: 'Mark entry window is closed for this course.' })
        return
      }
      if (!response.ok) throw new Error('Failed to fetch mark categories')
      const data = await response.json()
      setMarkCategories(data || [])
    } catch (error) {
      console.error('Error fetching mark categories:', error)
      setMessage({ type: 'error', text: 'Failed to load mark categories.' })
    }
  }

  const loadExistingMarks = async () => {
    try {
      const response = await fetch(
        `${API_BASE_URL}/course/${selectedCourse.course_id}/student-marks?teacher_id=${teacherId}`
      )
      if (response.status === 403) {
        setStudentMarks({})
        setMessage({ type: 'warning', text: 'Mark entry window is closed for this course.' })
        return
      }
      if (!response.ok) throw new Error('Failed to fetch marks')
      const data = await response.json()
      
      // Convert array of marks to object structure
      const marksObj = {}
      if (data && Array.isArray(data)) {
        data.forEach((mark) => {
          if (!marksObj[mark.student_id]) {
            marksObj[mark.student_id] = {}
          }
          marksObj[mark.student_id][mark.assessment_component_id] = mark.obtained_marks
        })
      }
      setStudentMarks(marksObj)
    } catch (error) {
      console.error('Error loading existing marks:', error)
      // Initialize empty marks if fetch fails
      const emptyMarks = {}
      selectedCourse.enrollments.forEach((student) => {
        emptyMarks[student.student_id] = {}
      })
      setStudentMarks(emptyMarks)
    }
  }

  const enrichStudentsWithEnrollmentNumbers = async (enrollments) => {
    try {
      // Fetch all students to get enrollment numbers
      const response = await fetch(`${API_BASE_URL}/students`)
      if (!response.ok) throw new Error('Failed to fetch students')
      const allStudents = await response.json()
      
      // Create maps for student data
      const enrollmentMap = {}
      const registerMap = {}
      if (Array.isArray(allStudents)) {
        allStudents.forEach((student) => {
          enrollmentMap[student.student_id] = student.enrollment_no || ''
          registerMap[student.student_id] = student.register_no || ''
        })
      }
      
      // Enrich enrollments with enrollment and register numbers
      return enrollments.map((student) => ({
        ...student,
        enrollment_no: enrollmentMap[student.student_id] || '',
        register_no: registerMap[student.student_id] || '',
      }))
    } catch (error) {
      console.error('Error fetching enrollment numbers:', error)
      // Return original enrollments if fetch fails
      return enrollments.map((student) => ({
        ...student,
        enrollment_no: '',
      }))
    }
  }

  // Update students when course changes
  useEffect(() => {
    if (selectedCourse && selectedCourse.enrollments) {
      // Enrich students with enrollment numbers
      enrichStudentsWithEnrollmentNumbers(selectedCourse.enrollments).then((enrichedStudents) => {
        setStudents(enrichedStudents)
      })
      
      // Initialize marks for new students
      const newMarks = {}
      selectedCourse.enrollments.forEach((student) => {
        newMarks[student.student_id] = studentMarks[student.student_id] || {}
      })
      setStudentMarks(newMarks)
    }
  }, [selectedCourse])

  const handleMarkChange = (studentId, categoryId, value) => {
    const category = markCategories.find((cat) => cat.id === categoryId)
    const maxMarks = category?.max_marks || 0
    
    // Allow empty value
    if (value === '' || value === null || value === undefined) {
      setStudentMarks((prev) => ({
        ...prev,
        [studentId]: {
          ...prev[studentId],
          [categoryId]: '',
        },
      }))
      return
    }

    const numValue = parseFloat(value) || 0
    // Limit to max marks
    const finalValue = Math.min(Math.max(numValue, 0), maxMarks)

    setStudentMarks((prev) => ({
      ...prev,
      [studentId]: {
        ...prev[studentId],
        [categoryId]: finalValue,
      },
    }))
  }

  const calculateConvertedMarks = (earnedMarks, maxMarks, conversionMarks) => {
    if (maxMarks === 0 || !earnedMarks) return '0.00'
    return ((earnedMarks / maxMarks) * conversionMarks).toFixed(2)
  }

  const calculateStudentTotal = (studentId) => {
    let total = 0
    markCategories.forEach((category) => {
      const earned = studentMarks[studentId]?.[category.id]
      if (earned !== '' && earned !== null && earned !== undefined) {
        const converted = parseFloat(calculateConvertedMarks(earned, category.max_marks, category.conversion_marks))
        total += converted
      }
    })
    return total.toFixed(2)
  }

  const calculateTotalWeightage = () => {
    return markCategories.reduce((sum, cat) => sum + cat.conversion_marks, 0).toFixed(2)
  }

  const handleSaveMarks = async () => {
    if (!selectedCourse || !teacherId) {
      setMessage({ type: 'error', text: 'Invalid course or teacher information' })
      return
    }

    // Collect all mark entries
    const markEntries = []
    students.forEach((student) => {
      markCategories.forEach((category) => {
        const obtainedMarks = studentMarks[student.student_id]?.[category.id]
        if (obtainedMarks !== undefined && obtainedMarks !== null && obtainedMarks !== '') {
          markEntries.push({
            student_id: student.student_id,
            course_id: selectedCourse.course_id,
            assessment_component_id: category.id,
            obtained_marks: parseFloat(obtainedMarks),
          })
        }
      })
    })

    if (markEntries.length === 0) {
      setMessage({ type: 'warning', text: 'No marks to save. Please enter some marks first.' })
      return
    }

    try {
      setSavingMarks(true)
      const response = await fetch(`${API_BASE_URL}/student-marks/save`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          course_id: selectedCourse.course_id,
          faculty_id: teacherId,
          mark_entries: markEntries,
        }),
      })

      const result = await response.json()
      if (response.ok && result.success) {
        setMessage({ type: 'success', text: result.message })
        // Refresh marks after save
        setTimeout(() => loadExistingMarks(), 1000)
      } else {
        setMessage({ type: 'error', text: result.message || 'Failed to save marks' })
      }
    } catch (error) {
      console.error('Error saving marks:', error)
      setMessage({ type: 'error', text: 'Error saving marks. Please try again.' })
    } finally {
      setSavingMarks(false)
    }
  }

  if (loading) {
    return (
      <MainLayout title="Mark Entry" subtitle="Enter and manage student marks">
        <div className="flex justify-center items-center h-64">
          <div className="text-center">
            <div className="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div>
            <p className="mt-4 text-gray-600">Loading courses...</p>
          </div>
        </div>
      </MainLayout>
    )
  }

  return (
    <MainLayout title="Mark Entry" subtitle="Enter and manage student marks">
      <div className="space-y-6">
        {/* Message Display */}
        {message.text && (
          <div
            className={`rounded-lg p-4 border-l-4 ${
              message.type === 'error'
                ? 'bg-red-50 text-red-700 border-red-400'
                : message.type === 'success'
                ? 'bg-green-50 text-green-700 border-green-400'
                : 'bg-yellow-50 text-yellow-700 border-yellow-400'
            }`}
          >
            {message.text}
          </div>
        )}

        {/* Course Selection Card */}
        {courses.length > 0 ? (
          <div className="bg-white rounded-xl shadow-sm border border-gray-100">
            <div className="border-b border-gray-200 px-6 py-3">
              <h3 className="text-sm font-semibold text-gray-700">Course Selection</h3>
            </div>
            <div className="p-6">
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Select Course
              </label>
              <select
                value={selectedCourse?.course_id || ''}
                onChange={(e) => {
                  const course = courses.find((c) => c.course_id === parseInt(e.target.value))
                  setSelectedCourse(course)
                }}
                className="w-full max-w-md px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500"
              >
                {courses.map((course) => (
                  <option key={course.course_id} value={course.course_id}>
                    {course.course_code} - {course.course_name}
                  </option>
                ))}
              </select>
              {selectedCourse && (
                <div className="mt-4 flex flex-wrap gap-4 text-sm text-gray-600">
                  <div>
                    <span className="font-medium text-gray-700">Category:</span> {selectedCourse.category}
                  </div>
                  <div>
                    <span className="font-medium text-gray-700">Credit:</span> {selectedCourse.credit}
                  </div>
                  <div>
                    <span className="font-medium text-gray-700">Students:</span> {selectedCourse.enrollments?.length || 0}
                  </div>
                </div>
              )}
            </div>
          </div>
        ) : (
          <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4 text-yellow-800">
            No courses found for you. Please contact administrator.
          </div>
        )}

        {/* Mark Entry Table */}
        {selectedCourse && markCategories.length > 0 && (
          <div className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
            <div className="border-b border-gray-200 px-6 py-4 flex justify-between items-center">
              <div>
                <h3 className="text-sm font-semibold text-gray-700">
                  Mark Entry - {selectedCourse.course_code}
                </h3>
                <p className="text-xs text-gray-500 mt-1">Enter marks for each assessment component</p>
              </div>
              <button
                onClick={handleSaveMarks}
                disabled={savingMarks}
                className="px-6 py-2 bg-blue-600 text-white text-sm font-medium rounded-lg hover:bg-blue-700 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors"
              >
                {savingMarks ? 'Saving...' : 'Save Marks'}
              </button>
            </div>

            <div className="overflow-x-auto" style={{ maxHeight: '70vh' }}>
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50 sticky top-0 z-10">
                  <tr>
                    <th className="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider border-r border-gray-200 sticky left-0 bg-gray-50 min-w-[200px]">
                      Student
                    </th>
                    {markCategories.map((category) => (
                      <th
                        key={category.id}
                        className="px-3 py-3 text-center text-xs font-semibold text-gray-700 border-r border-gray-200 min-w-[90px]"
                      >
                        <div className="truncate">{category.name}</div>
                        <div className="text-gray-500 font-normal mt-0.5">Max: {category.max_marks}</div>
                      </th>
                    ))}
                    <th className="px-4 py-3 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider bg-blue-50 min-w-[100px] sticky right-0">
                      <div>Total</div>
                      <div className="text-gray-500 font-normal mt-0.5">/ {calculateTotalWeightage()}</div>
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {students.map((student, idx) => (
                    <tr
                      key={student.student_id}
                      className={`${
                        idx % 2 === 0 ? 'bg-white' : 'bg-gray-50'
                      } hover:bg-blue-50 transition-colors`}
                    >
                      <td
                        className={`px-4 py-3 border-r border-gray-200 sticky left-0 z-5 ${
                          idx % 2 === 0 ? 'bg-white' : 'bg-gray-50'
                        }`}
                      >
                        <div className="text-sm font-semibold text-gray-800">{student.student_name}</div>
                        <div className="text-xs text-gray-500 mt-0.5">
                          {student.enrollment_no || 'N/A'} / {student.register_no || 'N/A'}
                        </div>
                      </td>
                      {markCategories.map((category) => {
                        const earned = studentMarks[student.student_id]?.[category.id]
                        const converted = calculateConvertedMarks(earned, category.max_marks, category.conversion_marks)
                        return (
                          <td key={category.id} className="px-3 py-3 text-center border-r border-gray-200">
                            <input
                              type="number"
                              min="0"
                              max={category.max_marks}
                              step="0.01"
                              value={earned ?? ''}
                              onChange={(e) => handleMarkChange(student.student_id, category.id, e.target.value)}
                              placeholder="0"
                              className="w-16 px-2 py-1 border border-gray-300 rounded text-center text-sm font-medium text-gray-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                            />
                            <div className="text-xs text-green-600 font-semibold mt-1">{converted}</div>
                          </td>
                        )
                      })}
                      <td className="px-4 py-3 text-center text-base font-bold text-blue-700 bg-blue-50 sticky right-0 z-5">
                        {calculateStudentTotal(student.student_id)}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            {/* Legend */}
            <div className="border-t border-gray-200 px-6 py-4 bg-gray-50">
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                <div>
                  <p className="font-semibold text-gray-700 mb-1">Input Format</p>
                  <p className="text-gray-600">Enter marks (capped at maximum)</p>
                </div>
                <div>
                  <p className="font-semibold text-gray-700 mb-1">Calculation</p>
                  <p className="text-gray-600">Green value = (Earned ÷ Max) × Conversion</p>
                </div>
                <div>
                  <p className="font-semibold text-gray-700 mb-1">Total Score</p>
                  <p className="text-gray-600">Sum of all converted marks</p>
                </div>
              </div>
            </div>
          </div>
        )}

        {selectedCourse && markCategories.length === 0 && (
          <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 text-blue-800">
            No mark categories found for this course type. Please ensure mark categories are configured.
          </div>
        )}
      </div>
    </MainLayout>
  )
}

export default MarkEntryPage
