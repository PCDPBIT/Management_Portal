import React, { useState } from 'react'
import MainLayout from '../../components/MainLayout'
import { API_BASE_URL } from '../../config'
import './TeacherCoursesPage.css'

function TeacherCoursesPage() {
  const [teacherID, setTeacherID] = useState('')
  const [teacherName, setTeacherName] = useState('')
  const [academicYear, setAcademicYear] = useState('')
  const [semester, setSemester] = useState('')
  const [coursesByCategory, setCoursesByCategory] = useState({})
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [searched, setSearched] = useState(false)

  const fetchTeacherCourses = async (e) => {
    e.preventDefault()
    if (!teacherID.trim()) {
      setError('Please enter a Teacher ID')
      return
    }

    setLoading(true)
    setError('')
    setCoursesByCategory({})
    setTeacherName('')

    try {
      let url = `${API_BASE_URL}/teachers/${teacherID}/courses`
      const params = new URLSearchParams()
      if (academicYear) params.append('academic_year', academicYear)
      if (semester) params.append('semester', semester)

      if (params.toString()) {
        url += '?' + params.toString()
      }

      console.log('[TEACHER COURSES] Fetching from:', url)
      const response = await fetch(url)

      if (!response.ok) {
        throw new Error(`Teacher not found or no courses assigned`)
      }

      const data = await response.json()
      console.log('[TEACHER COURSES] Data received:', data)

      if (!data || data.length === 0) {
        setError('No courses found for this teacher')
        setSearched(true)
        setLoading(false)
        return
      }

      // Get teacher name from first course entry
      if (data.length > 0) {
        setTeacherName(`Teacher ID: ${teacherID}`)
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
      setSearched(true)
    } catch (err) {
      console.error('[TEACHER COURSES] Error:', err)
      setError(err.message || 'Failed to fetch courses')
      setSearched(true)
    } finally {
      setLoading(false)
    }
  }

  const getCategoryColor = (category) => {
    const colors = {
      'Core': '#3b82f6',
      'Elective': '#8b5cf6',
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

  const getRoleColor = (role) => {
    return role === 'Primary' ? '#10b981' : '#f59e0b'
  }

  return (
    <MainLayout title="Teacher Course Allocation" subtitle="View all courses allocated to a teacher">
      <div className="teacher-courses-page">
        {/* Search Form */}
        <div className="search-form-card">
          <form onSubmit={fetchTeacherCourses} className="search-form">
            <div className="form-grid">
              <div className="form-group">
                <label htmlFor="teacherID">Teacher ID *</label>
                <input
                  id="teacherID"
                  type="text"
                  placeholder="Enter Teacher ID (e.g., 101)"
                  value={teacherID}
                  onChange={(e) => setTeacherID(e.target.value)}
                  className="form-input"
                />
              </div>

              <div className="form-group">
                <label htmlFor="academicYear">Academic Year (Optional)</label>
                <input
                  id="academicYear"
                  type="text"
                  placeholder="e.g., 2024-2025"
                  value={academicYear}
                  onChange={(e) => setAcademicYear(e.target.value)}
                  className="form-input"
                />
              </div>

              <div className="form-group">
                <label htmlFor="semester">Semester (Optional)</label>
                <select
                  id="semester"
                  value={semester}
                  onChange={(e) => setSemester(e.target.value)}
                  className="form-input"
                >
                  <option value="">All Semesters</option>
                  {[1, 2, 3, 4, 5, 6, 7, 8].map((sem) => (
                    <option key={sem} value={sem}>
                      Semester {sem}
                    </option>
                  ))}
                </select>
              </div>

              <div className="form-group">
                <label>&nbsp;</label>
                <button type="submit" className="btn-primary" disabled={loading}>
                  {loading ? 'Searching...' : 'Search'}
                </button>
              </div>
            </div>
          </form>
        </div>

        {/* Error Message */}
        {error && (
          <div className="error-message">
            <span>{error}</span>
          </div>
        )}

        {/* Results */}
        {searched && !error && Object.keys(coursesByCategory).length > 0 && (
          <div className="results-container">
            {/* Summary Stats */}
            <div className="summary-stats">
              <div className="stat-card">
                <div className="stat-number">{getTotalCourses()}</div>
                <div className="stat-label">Total Courses</div>
              </div>
              <div className="stat-card">
                <div className="stat-number">{getTotalCredits()}</div>
                <div className="stat-label">Total Credits</div>
              </div>
              <div className="stat-card">
                <div className="stat-number">{Object.keys(coursesByCategory).length}</div>
                <div className="stat-label">Categories</div>
              </div>
            </div>

            {/* Courses by Category */}
            <div className="categories-container">
              {Object.entries(coursesByCategory).map(([category, courses]) => (
                <div key={category} className="category-section">
                  <div
                    className="category-header"
                    style={{ borderLeftColor: getCategoryColor(category) }}
                  >
                    <span className="category-title">{category}</span>
                    <span className="category-count">{courses.length} courses</span>
                  </div>

                  <div className="courses-table">
                    <table>
                      <thead>
                        <tr>
                          <th>Code</th>
                          <th>Course Name</th>
                          <th>Type</th>
                          <th>Credit</th>
                          <th>Semester</th>
                          <th>Section</th>
                          <th>Role</th>
                          <th>Academic Year</th>
                        </tr>
                      </thead>
                      <tbody>
                        {courses.map((course, idx) => (
                          <tr key={`${course.id}-${idx}`} className="course-row">
                            <td className="code-cell">
                              <strong>{course.course_code}</strong>
                            </td>
                            <td className="name-cell">{course.course_name}</td>
                            <td className="type-cell">
                              <span className="type-badge">{course.course_type}</span>
                            </td>
                            <td className="credit-cell">
                              <strong>{course.credit}</strong>
                            </td>
                            <td className="semester-cell">
                              <span className="semester-badge">Sem {course.semester}</span>
                            </td>
                            <td className="section-cell">{course.section}</td>
                            <td className="role-cell">
                              <span
                                className="role-badge"
                                style={{ backgroundColor: getRoleColor(course.role) }}
                              >
                                {course.role}
                              </span>
                            </td>
                            <td className="year-cell">{course.academic_year}</td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Empty State */}
        {searched && !error && Object.keys(coursesByCategory).length === 0 && (
          <div className="empty-state">
            <div className="empty-icon">📚</div>
            <p>No courses found for the selected filters</p>
          </div>
        )}

        {/* Initial State */}
        {!searched && (
          <div className="initial-state">
            <div className="initial-icon">🔍</div>
            <p>Enter a Teacher ID to view their allocated courses</p>
          </div>
        )}
      </div>
    </MainLayout>
  )
}

export default TeacherCoursesPage
