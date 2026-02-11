import React, { useState, useEffect } from 'react'
import { useParams, useNavigate, useLocation } from 'react-router-dom'
import MainLayout from '../../components/MainLayout'
import { API_BASE_URL } from '../../config'

function TeacherCourseStudentsPage() {
  const { courseId } = useParams()
  const navigate = useNavigate()
  const location = useLocation()
  const [course, setCourse] = useState(location.state?.course || null)
  const [students, setStudents] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    if (courseId) {
      fetchCourseStudents()
    }
  }, [courseId])

  const fetchCourseStudents = async () => {
    setLoading(true)
    setError('')

    try {
      const teacherID = localStorage.getItem('teacherId')
      const url = `${API_BASE_URL}/teachers/${teacherID}/courses`
      const response = await fetch(url)

      if (!response.ok) {
        throw new Error('Failed to fetch course details')
      }

      const data = await response.json()
      const foundCourse = data.find(c => c.id === parseInt(courseId))

      if (foundCourse) {
        setCourse(foundCourse)
        setStudents(foundCourse.enrollments || [])
      } else {
        setError('Course not found')
      }
    } catch (err) {
      console.error('Error fetching course students:', err)
      setError(err.message || 'Failed to fetch students')
    } finally {
      setLoading(false)
    }
  }

  if (loading) {
    return (
      <MainLayout title="Course Students" subtitle="Loading...">
        <div className="flex justify-center items-center py-20">
          <div className="text-center">
            <svg className="animate-spin h-12 w-12 text-blue-600 mx-auto mb-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
              <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            <p className="text-gray-600">Loading students...</p>
          </div>
        </div>
      </MainLayout>
    )
  }

  if (error) {
    return (
      <MainLayout title="Course Students" subtitle="Error">
        <div className="bg-red-50 border border-red-200 rounded-lg p-6 text-center">
          <p className="text-red-600">{error}</p>
          <button
            onClick={() => navigate('/teacher-dashboard')}
            className="mt-4 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
          >
            Back to Dashboard
          </button>
        </div>
      </MainLayout>
    )
  }

  return (
    <MainLayout
      title={course?.course_name || 'Course Students'}
      subtitle={`${course?.course_code || ''} • ${students.length} student${students.length !== 1 ? 's' : ''}`}
      actions={
        <button
          onClick={() => navigate('/teacher-dashboard')}
          className="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors flex items-center space-x-2"
        >
          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 19l-7-7m0 0l7-7m-7 7h18" />
          </svg>
          <span>Back to Dashboard</span>
        </button>
      }
    >
      <div className="space-y-6">
        {/* Course Info Card */}
        <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div>
              <p className="text-sm text-gray-600 mb-1">Course Code</p>
              <p className="text-lg font-semibold text-blue-600">{course?.course_code}</p>
            </div>
            <div>
              <p className="text-sm text-gray-600 mb-1">Course Type</p>
              <span className="inline-block px-3 py-1 bg-blue-100 text-blue-700 rounded-full text-sm font-medium">
                {course?.course_type}
              </span>
            </div>
            <div>
              <p className="text-sm text-gray-600 mb-1">Credits</p>
              <p className="text-lg font-semibold text-gray-900">{course?.credit}</p>
            </div>
            <div>
              <p className="text-sm text-gray-600 mb-1">Category</p>
              <p className="text-lg font-semibold text-gray-900">{course?.category}</p>
            </div>
          </div>
        </div>

        {/* Students List */}
        <div className="bg-white rounded-lg shadow-sm border border-gray-200">
          <div className="px-6 py-4 border-b border-gray-200">
            <h3 className="text-lg font-semibold text-gray-900">
              Allocated Students ({students.length})
            </h3>
          </div>

          {students.length > 0 ? (
            <div className="p-6">
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                {students.map((student) => (
                  <div
                    key={student.student_id}
                    className="flex items-center space-x-4 p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors border border-gray-200"
                  >
                    <div 
                      className="w-12 h-12 rounded-full flex items-center justify-center text-white font-semibold text-lg flex-shrink-0" 
                      style={{ background: 'linear-gradient(to bottom right, rgb(67, 113, 229), rgb(47, 93, 209))' }}
                    >
                      {student.student_name.charAt(0).toUpperCase()}
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="text-sm font-semibold text-gray-900 truncate">
                        {student.student_name}
                      </p>
                      <p className="text-xs text-gray-600 mt-1">
                        ID: {student.student_id}
                      </p>
                      {student.enrollment_no && (
                        <p className="text-xs text-gray-500 mt-1">
                          Enrollment: {student.enrollment_no}
                        </p>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          ) : (
            <div className="p-12 text-center">
              <svg className="w-16 h-16 text-gray-400 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
              </svg>
              <p className="text-gray-500 text-lg font-medium">No students allocated yet</p>
              <p className="text-gray-400 text-sm mt-2">Students will appear here once they are allocated to this course</p>
            </div>
          )}
        </div>
      </div>
    </MainLayout>
  )
}

export default TeacherCourseStudentsPage
