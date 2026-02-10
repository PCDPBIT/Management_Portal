import React, { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import MainLayout from '../../components/MainLayout'
import { API_BASE_URL } from '../../config'

function TeacherDashboardPage() {
  const navigate = useNavigate()
  const teacherID = localStorage.getItem('teacherId')
  const teacherName = localStorage.getItem('userName')
  const [coursesByCategory, setCoursesByCategory] = useState({})
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    if (teacherID) {
      fetchTeacherCourses()
    } else {
      setError('Teacher ID not found. Please login again.')
      setLoading(false)
    }
  }, [teacherID])

  const fetchTeacherCourses = async () => {
    setLoading(true)
    setError('')

    try {
      const url = `${API_BASE_URL}/teachers/${teacherID}/courses`
      console.log('[TEACHER DASHBOARD] Fetching from:', url)
      const response = await fetch(url)

      if (!response.ok) {
        throw new Error('Failed to fetch your courses')
      }

      const data = await response.json()
      console.log('[TEACHER DASHBOARD] Data received:', data)

      if (!data || data.length === 0) {
        setError('No courses assigned to you')
        setLoading(false)
        return
      }

      // Group courses by category
      const grouped = {}
      data.forEach((course) => {
        const category = course.category || 'General'
        if (!grouped[category]) {
          grouped[category] = []
        }
        grouped[category].push(course)
      })

      // Sort categories
      const sorted = Object.keys(grouped)
        .sort()
        .reduce((obj, key) => {
          obj[key] = grouped[key].sort((a, b) =>
            a.course_code.localeCompare(b.course_code)
          )
          return obj
        }, {})

      setCoursesByCategory(sorted)
    } catch (err) {
      console.error('[TEACHER DASHBOARD] Error:', err)
      setError(err.message || 'Failed to fetch your courses')
    } finally {
      setLoading(false)
    }
  }

  const getCategoryColor = (category) => {
    const colors = {
      'Core': '#3b82f6',
      'Language Elective': '#8b5cf6',
      'Open': '#ec4899',
      'Foundation': '#10b981',
      'Lab': '#f59e0b',
      'Project': '#ef4444',
      'Seminar': '#06b6d4',
      'General': '#6b7280'
    }
    return colors[category] || '#6b7280'
  }

  const getTotalCredits = () => {
    let total = 0
    Object.values(coursesByCategory).forEach((courses) => {
      courses.forEach((course) => {
        total += course.credit || 0
      })
    })
    return total
  }

  const getTotalCourses = () => {
    let total = 0
    Object.values(coursesByCategory).forEach((courses) => {
      total += courses.length
    })
    return total
  }

  const getTotalStudents = () => {
    let total = 0
    Object.values(coursesByCategory).forEach((courses) => {
      courses.forEach((course) => {
        total += course.enrollments?.length || 0
      })
    })
    return total
  }

  const handleCourseClick = (course) => {
    navigate(`/teacher-course/${course.id}/students`, { state: { course } })
  }

  return (
    <MainLayout title={`Welcome, ${teacherName || 'Teacher'}`} subtitle="Your Teaching Dashboard">
      <div className="space-y-6">
        {/* Loading State */}
        {loading && (
          <div className="flex items-center justify-center py-12">
            <div className="flex flex-col items-center space-y-4">
              <svg className="animate-spin h-12 w-12 text-blue-600" fill="none" viewBox="0 0 24 24">
                <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              <p className="text-gray-600 font-medium">Loading your dashboard...</p>
            </div>
          </div>
        )}

        {/* Error Message */}
        {error && !loading && (
          <div className="bg-red-50 border-l-4 border-red-500 p-4 rounded-lg">
            <div className="flex items-center">
              <svg className="w-5 h-5 text-red-500 mr-3" fill="currentColor" viewBox="0 0 20 20">
                <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clipRule="evenodd" />
              </svg>
              <p className="text-red-700 font-medium">{error}</p>
            </div>
          </div>
        )}

        {/* Dashboard Content */}
        {!loading && !error && Object.keys(coursesByCategory).length > 0 && (
          <>
            {/* Summary Stats */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              {/* Total Courses Card */}
              <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-gray-600 text-sm font-medium mb-1">My Courses</p>
                    <p className="text-3xl font-bold text-blue-600">
                      {getTotalCourses()}
                    </p>
                  </div>
                  <div className="w-12 h-12 rounded-full bg-blue-50 flex items-center justify-center">
                    <svg className="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                    </svg>
                  </div>
                </div>
              </div>

              {/* Total Students Card */}
              <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-gray-600 text-sm font-medium mb-1">Total Students</p>
                    <p className="text-3xl font-bold text-green-600">{getTotalStudents()}</p>
                  </div>
                  <div className="w-12 h-12 rounded-full bg-green-50 flex items-center justify-center">
                    <svg className="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                    </svg>
                  </div>
                </div>
              </div>

              {/* Total Credits Card */}
              <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-gray-600 text-sm font-medium mb-1">Total Credits</p>
                    <p className="text-3xl font-bold text-purple-600">{getTotalCredits()}</p>
                  </div>
                  <div className="w-12 h-12 rounded-full bg-purple-50 flex items-center justify-center">
                    <svg className="w-6 h-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z" />
                    </svg>
                  </div>
                </div>
              </div>
            </div>

            {/* Courses by Category */}
            <div className="space-y-4">
              {Object.entries(coursesByCategory).map(([category, courses]) => (
                <div key={category} className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
                  <div className="border-b border-gray-200 px-6 py-3 flex items-center justify-between">
                    <h3 className="text-sm font-semibold text-gray-700">{category}</h3>
                    <span className="px-3 py-1 bg-gray-100 text-gray-700 rounded-full text-xs font-medium">
                      {courses.length} {courses.length === 1 ? 'course' : 'courses'}
                    </span>
                  </div>

                  <div className="overflow-x-auto">
                    <table className="w-full">
                      <thead className="bg-gray-50 border-b border-gray-200">
                        <tr>
                          <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Code</th>
                          <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Course Name</th>
                          <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Type</th>
                          <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Credit</th>
                          <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Students</th>
                          <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"></th>
                        </tr>
                      </thead>
                      <tbody className="bg-white divide-y divide-gray-200">
                        {courses.map((course, idx) => (
                          <tr
                            key={`${course.id}-${idx}`}
                            className="hover:bg-blue-50 transition-colors cursor-pointer"
                            onClick={() => handleCourseClick(course)}
                          >
                            <td className="px-6 py-4 whitespace-nowrap">
                              <span className="font-semibold text-blue-600">{course.course_code}</span>
                            </td>
                            <td className="px-6 py-4">
                              <p className="text-gray-900 font-medium">{course.course_name}</p>
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap">
                              <span className="px-2 py-1 bg-blue-50 text-blue-700 rounded text-xs font-medium">
                                {course.course_type}
                              </span>
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap">
                              <span className="font-medium text-gray-700">{course.credit}</span>
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap">
                              <span className="px-2 py-1 bg-green-50 text-green-700 rounded text-xs font-medium">
                                {course.enrollments?.length || 0} students
                              </span>
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap text-right">
                              <span className="text-blue-500 hover:text-blue-700">
                                →
                              </span>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              ))}
            </div>
          </>
        )}

        {/* Empty State */}
        {!loading && !error && Object.keys(coursesByCategory).length === 0 && (
          <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-12 text-center">
            <div className="w-16 h-16 rounded-full bg-blue-50 mx-auto mb-4 flex items-center justify-center">
              <svg className="w-8 h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
              </svg>
            </div>
            <h3 className="text-lg font-semibold text-gray-800 mb-2">No Courses Assigned</h3>
            <p className="text-gray-600">You don't have any courses assigned to you at the moment.</p>
          </div>
        )}
      </div>
    </MainLayout>
  )
}

export default TeacherDashboardPage
