import React, { useState, useEffect } from 'react'
import MainLayout from '../../components/MainLayout'

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

  // Map course category string to course_type_id
  const mapCategoryToTypeId = (category) => {
    if (!category) return null
    const categoryLower = category.toLowerCase()
    if (categoryLower.includes('theory') && categoryLower.includes('lab')) {
      return 3 // Theory with Lab
    } else if (categoryLower.includes('lab')) {
      return 2 // Lab
    } else {
      return 1 // Theory
    }
  }

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
      const response = await fetch(`http://localhost:5000/api/teachers/${teacherId}/courses`)
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
      const courseTypeId = mapCategoryToTypeId(selectedCourse.category)
      if (!courseTypeId) {
        setMessage({ type: 'warning', text: 'Could not determine course type' })
        return
      }

      const response = await fetch(`http://localhost:5000/api/mark-categories-by-type/${courseTypeId}`)
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
      const response = await fetch(`http://localhost:5000/api/course/${selectedCourse.course_id}/student-marks`)
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
      const response = await fetch('http://localhost:5000/api/students')
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
    if (maxMarks === 0) return 0
    return ((earnedMarks / maxMarks) * conversionMarks).toFixed(2)
  }

  const calculateStudentTotal = (studentId) => {
    let total = 0
    markCategories.forEach((category) => {
      const earned = studentMarks[studentId]?.[category.id] || 0
      const converted = calculateConvertedMarks(earned, category.max_marks, category.conversion_marks)
      total += parseFloat(converted)
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
      const response = await fetch('http://localhost:5000/api/student-marks/save', {
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
            className={`rounded-lg p-4 ${
              message.type === 'error'
                ? 'bg-red-100 text-red-800 border border-red-400'
                : message.type === 'success'
                ? 'bg-green-100 text-green-800 border border-green-400'
                : 'bg-yellow-100 text-yellow-800 border border-yellow-400'
            }`}
          >
            {message.text}
          </div>
        )}

        {/* Course Selection Card */}
        {courses.length > 0 ? (
          <div className="bg-white rounded-xl shadow-md p-6 border-l-4 border-blue-500">
            <label className="block text-sm font-semibold text-gray-800 mb-3">
              📚 Select Course
            </label>
            <select
              value={selectedCourse?.course_id || ''}
              onChange={(e) => {
                const course = courses.find((c) => c.course_id === parseInt(e.target.value))
                setSelectedCourse(course)
              }}
              className="w-full max-w-md px-4 py-2 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition-colors"
            >
              {courses.map((course) => (
                <option key={course.course_id} value={course.course_id}>
                  {course.course_name} ({course.course_code})
                </option>
              ))}
            </select>
            {selectedCourse && (
              <p className="text-sm text-gray-600 mt-3">
                <strong>Category:</strong> {selectedCourse.category} | <strong>Credit:</strong> {selectedCourse.credit} |{' '}
                <strong>Students:</strong> {selectedCourse.enrollments?.length || 0}
              </p>
            )}
          </div>
        ) : (
          <div className="bg-yellow-50 border border-yellow-300 rounded-lg p-4 text-yellow-800">
            No courses found for you. Please contact administrator.
          </div>
        )}

        {/* Mark Entry Table */}
        {selectedCourse && markCategories.length > 0 && (
          <div className="bg-white rounded-xl shadow-md overflow-hidden">
            <div className="p-6 border-b border-gray-200 flex justify-between items-center">
              <div>
                <h3 className="text-xl font-semibold text-gray-800">
                  ✏️ Marks for {selectedCourse.course_name}
                </h3>
                <p className="text-sm text-gray-600 mt-1">Click on any cell to enter marks</p>
              </div>
              <button
                onClick={handleSaveMarks}
                disabled={savingMarks}
                className="px-6 py-2 bg-green-600 text-white font-semibold rounded-lg hover:bg-green-700 disabled:bg-gray-400 transition-colors"
              >
                {savingMarks ? 'Saving...' : '💾 Save Marks'}
              </button>
            </div>

            <div className="overflow-x-auto" style={{ maxHeight: '70vh' }}>
              <table className="border-collapse" style={{ minWidth: '100%' }}>
                <thead>
                  <tr className="bg-gradient-to-r from-blue-600 to-blue-700 text-white sticky top-0 z-10">
                    <th className="border border-blue-400 px-3 py-2 text-left text-sm font-semibold min-w-[200px] sticky left-0 bg-gradient-to-r from-blue-600 to-blue-700">
                      Student Name
                    </th>
                    {markCategories.map((category) => (
                      <th
                        key={category.id}
                        className="border border-blue-400 px-0.5 py-2 text-center text-xs font-semibold min-w-[60px]"
                      >
                        <div className="text-blue-100 text-xs truncate px-0.5 leading-tight">{category.name}</div>
                        <div className="text-blue-200 text-xs leading-tight">({category.max_marks})</div>
                      </th>
                    ))}
                    <th className="border border-blue-400 px-2 py-2 text-center text-sm font-semibold bg-blue-900 min-w-[80px] sticky right-0 z-10">
                      <div>Total</div>
                      <div className="text-blue-300 text-xs mt-0.5">Cap: {calculateTotalWeightage()}</div>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  {students.map((student, idx) => (
                    <tr
                      key={student.student_id}
                      className={`border-b transition-colors ${
                        idx % 2 === 0 ? 'bg-white hover:bg-blue-50' : 'bg-gray-50 hover:bg-blue-100'
                      }`}
                    >
                      <td
                        className="border border-gray-300 px-3 py-2 font-semibold text-gray-800 sticky left-0 z-5"
                        style={{
                          backgroundColor: idx % 2 === 0 ? 'white' : '#f9fafb',
                        }}
                      >
                        <div className="text-sm font-bold">{student.student_name}</div>
                        <div className="text-xs text-gray-600">
                          {student.enrollment_no || '-'} / {student.register_no || '-'}
                        </div>
                      </td>
                      {markCategories.map((category) => {
                        const earned = studentMarks[student.student_id]?.[category.id] || 0
                        const converted = calculateConvertedMarks(earned, category.max_marks, category.conversion_marks)
                        return (
                          <td key={category.id} className="border border-gray-300 px-0.5 py-1 text-center text-xs">
                            <input
                              type="number"
                              min="0"
                              max={category.max_marks}
                              value={earned}
                              onChange={(e) => handleMarkChange(student.student_id, category.id, e.target.value)}
                              className="w-12 px-0.5 py-0.5 border border-blue-300 rounded text-center font-bold text-xs text-blue-700 bg-blue-50 focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-400 transition-colors"
                            />
                            <div className="text-green-600 font-semibold text-xs mt-0.5">{converted}</div>
                          </td>
                        )
                      })}
                      <td className="border border-gray-300 px-2 py-2 text-center font-bold text-base text-white bg-gradient-to-r from-blue-600 to-blue-700 sticky right-0 z-5">
                        {calculateStudentTotal(student.student_id)}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            {/* Legend */}
            <div className="p-6 border-t border-gray-200 bg-gradient-to-r from-blue-50 to-indigo-50">
              <div className="flex flex-wrap gap-6">
                <div>
                  <p className="text-sm font-semibold text-gray-800">📝 Input Format</p>
                  <p className="text-sm text-gray-600 mt-1">Enter marks in blue cells (capped at max marks)</p>
                </div>
                <div>
                  <p className="text-sm font-semibold text-gray-800">📊 Calculation</p>
                  <p className="text-sm text-gray-600 mt-1">Green value = (Earned ÷ Max) × Conversion</p>
                </div>
                <div>
                  <p className="text-sm font-semibold text-gray-800">🎯 Total Score</p>
                  <p className="text-sm text-gray-600 mt-1">Sum of all converted marks</p>
                </div>
              </div>
            </div>
          </div>
        )}

        {selectedCourse && markCategories.length === 0 && (
          <div className="bg-blue-50 border border-blue-300 rounded-lg p-4 text-blue-800">
            No mark categories found for this course type. Please ensure mark categories are configured.
          </div>
        )}
      </div>
    </MainLayout>
  )
}

export default MarkEntryPage
