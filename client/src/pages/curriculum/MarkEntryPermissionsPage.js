import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import MainLayout from '../../components/MainLayout'
import { API_BASE_URL } from '../../config'

// Helper function to format date for datetime-local input (preserves local timezone)
const formatDateTimeLocal = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const hours = String(date.getHours()).padStart(2, '0')
  const minutes = String(date.getMinutes()).padStart(2, '0')
  return `${year}-${month}-${day}T${hours}:${minutes}`
}

function MarkEntryPermissionsPage() {
  const navigate = useNavigate()
  const userRole = localStorage.getItem('userRole')
  
  const [teachers, setTeachers] = useState([])
  const [selectedTeacherId, setSelectedTeacherId] = useState('')
  const [courses, setCourses] = useState([])
  const [selectedCourseId, setSelectedCourseId] = useState('')
  const [message, setMessage] = useState({ type: '', text: '' })
  const [departments, setDepartments] = useState([])
  const [windowScope, setWindowScope] = useState('teacher_course')
  const [windowDepartmentId, setWindowDepartmentId] = useState('')
  const [windowSemester, setWindowSemester] = useState('')
  const [windowCourseId, setWindowCourseId] = useState('')
  const [windowCourses, setWindowCourses] = useState([])
  const [windowStartAt, setWindowStartAt] = useState('')
  const [windowEndAt, setWindowEndAt] = useState('')
  const [windowEnabled, setWindowEnabled] = useState(true)
  const [windowLoading, setWindowLoading] = useState(false)
  const [windowComponents, setWindowComponents] = useState([])
  const [selectedWindowComponents, setSelectedWindowComponents] = useState([])
  const [existingWindows, setExistingWindows] = useState([])
  const [editingWindow, setEditingWindow] = useState(null)
  const [showWindowList, setShowWindowList] = useState(false)
  const [teacherSearch, setTeacherSearch] = useState('')
  const [showTeacherDropdown, setShowTeacherDropdown] = useState(false)

  // Check if user has COE role
  useEffect(() => {
    if (userRole !== 'coe') {
      navigate('/dashboard')
    }
  }, [userRole, navigate])

  useEffect(() => {
    fetchTeachers()
    fetchDepartments()
    fetchExistingWindows()
  }, [])

  useEffect(() => {
    const handleClickOutside = (event) => {
      if (showTeacherDropdown && !event.target.closest('.teacher-search-container')) {
        setShowTeacherDropdown(false)
      }
    }
    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [showTeacherDropdown])

  useEffect(() => {
    // Load window components when course context changes
    if (windowScope === 'teacher_course' && selectedCourseId) {
      fetchMarkCategoriesForCourseType(selectedCourseId)
    } else if (windowScope === 'department_semester_course' && windowCourseId) {
      fetchMarkCategoriesForCourseType(windowCourseId)
    } else if (windowScope === 'department_semester') {
      // For dept+semester, show all categories since it applies to all courses
      fetchAllMarkCategories()
    } else {
      setWindowComponents([])
    }
  }, [windowScope, selectedCourseId, windowCourseId])

  useEffect(() => {
    if (selectedTeacherId) {
      fetchTeacherCourses(selectedTeacherId)
    } else {
      setCourses([])
      setSelectedCourseId('')
    }
  }, [selectedTeacherId])



  useEffect(() => {
    if (windowScope === 'department_semester_course' && windowDepartmentId && windowDepartmentId !== '0' && windowSemester) {
      fetchDepartmentCourses(windowDepartmentId, windowSemester)
    } else {
      setWindowCourses([])
      if (windowScope === 'department_semester_course') {
        setWindowCourseId('')
      }
    }
  }, [windowScope, windowDepartmentId, windowSemester])

  useEffect(() => {
    loadWindowRule()
  }, [windowScope, selectedTeacherId, selectedCourseId, windowDepartmentId, windowSemester, windowCourseId])

  const fetchTeachers = async () => {
    try {
      const res = await fetch(`${API_BASE_URL}/teachers`)
      const data = await res.json()
      setTeachers(Array.isArray(data) ? data : [])
    } catch (error) {
      console.error('Error fetching teachers:', error)
      setMessage({ type: 'error', text: 'Failed to load teachers.' })
    }
  }

  const fetchAllMarkCategories = async () => {
    try {
      // Fetch all mark category types (Theory=1, Lab=2, Theory+Lab=3)
      const results = await Promise.all([
        fetch(`${API_BASE_URL}/mark-categories-by-type/1`).then(r => r.json()),
        fetch(`${API_BASE_URL}/mark-categories-by-type/2`).then(r => r.json()),
        fetch(`${API_BASE_URL}/mark-categories-by-type/3`).then(r => r.json())
      ])
      
      // Combine and deduplicate
      const allCategories = []
      const seen = new Set()
      
      results.forEach(categories => {
        if (Array.isArray(categories)) {
          categories.forEach(cat => {
            if (!seen.has(cat.id)) {
              seen.add(cat.id)
              allCategories.push(cat)
            }
          })
        }
      })
      
      // Sort by position
      allCategories.sort((a, b) => (a.position || 0) - (b.position || 0))
      setWindowComponents(allCategories)
    } catch (error) {
      console.error('Error fetching mark categories:', error)
    }
  }

  const mapCourseCategoryToTypeID = (category) => {
    const categoryLower = (category || '').toLowerCase().trim()
    if (!categoryLower) return 0
    if (categoryLower.includes('theory') && categoryLower.includes('lab')) return 3
    if (categoryLower.includes('lab')) return 2
    return 1
  }

  const fetchMarkCategoriesForCourseType = async (courseId) => {
    try {
      // First fetch the course to get its category
      const courseRes = await fetch(`${API_BASE_URL}/courses/${courseId}`)
      if (!courseRes.ok) throw new Error('Failed to fetch course')
      const course = await courseRes.json()
      
      const courseTypeID = mapCourseCategoryToTypeID(course.category)
      if (courseTypeID === 0) {
        setWindowComponents([])
        return
      }
      
      // Fetch mark categories for this course type (learning_mode_id=2 is already filtered by API)
      const res = await fetch(`${API_BASE_URL}/mark-categories-by-type/${courseTypeID}`)
      if (!res.ok) throw new Error('Failed to fetch mark categories')
      const categories = await res.json()
      
      // Sort by position
      const sorted = Array.isArray(categories) ? categories : []
      sorted.sort((a, b) => (a.position || 0) - (b.position || 0))
      console.log('[DEBUG] Fetched categories:', sorted)
      sorted.forEach(cat => console.log(`[DEBUG] ID=${cat.id}, Name=${cat.name}, CourseTypeName='${cat.course_type_name}', CategoryName='${cat.category_name}'`))
      setWindowComponents(sorted)
    } catch (error) {
      console.error('Error fetching mark categories for course:', error)
      setWindowComponents([])
    }
  }

  const fetchDepartments = async () => {
    try {
      const res = await fetch(`${API_BASE_URL}/departments`)
      const data = await res.json()
      setDepartments(Array.isArray(data) ? data : [])
    } catch (error) {
      console.error('Error fetching departments:', error)
      setMessage({ type: 'error', text: 'Failed to load departments.' })
    }
  }

  const fetchTeacherCourses = async (teacherId) => {
    setMessage({ type: '', text: '' })
    try {
      const res = await fetch(`${API_BASE_URL}/teachers/${teacherId}/courses`)
      if (!res.ok) throw new Error('Failed to fetch teacher courses')
      const data = await res.json()
      setCourses(Array.isArray(data) ? data : [])
      if (data && data.length > 0) {
        setSelectedCourseId(String(data[0].course_id))
      } else {
        setSelectedCourseId('')
      }
    } catch (error) {
      console.error('Error fetching courses:', error)
      setCourses([])
      setSelectedCourseId('')
      setMessage({ type: 'error', text: 'Failed to load courses for teacher.' })
    }
  }



  const fetchDepartmentCourses = async (departmentId, semester) => {
    setWindowLoading(true)
    try {
      const res = await fetch(`${API_BASE_URL}/department/${departmentId}/semester/${semester}/courses`)
      if (!res.ok) throw new Error('Failed to fetch department courses')
      const data = await res.json()
      setWindowCourses(Array.isArray(data) ? data : [])
      if (data && data.length > 0) {
        setWindowCourseId(String(data[0].course_id))
      } else {
        setWindowCourseId('')
      }
    } catch (error) {
      console.error('Error fetching department courses:', error)
      setWindowCourses([])
      setWindowCourseId('')
      setMessage({ type: 'error', text: 'Failed to load department courses.' })
    } finally {
      setWindowLoading(false)
    }
  }

  const buildWindowQuery = () => {
    const params = new URLSearchParams()

    if (windowScope === 'teacher_course') {
      if (!selectedTeacherId || !selectedCourseId) return ''
      params.append('teacher_id', selectedTeacherId)
      params.append('course_id', selectedCourseId)
    }

    if (windowScope === 'department_semester') {
      if (windowDepartmentId === '' || !windowSemester) return ''
      if (windowDepartmentId !== '0') {
        params.append('department_id', windowDepartmentId)
      }
      params.append('semester', windowSemester)
    }

    if (windowScope === 'department_semester_course') {
      if (windowDepartmentId === '' || !windowSemester || !windowCourseId) return ''
      if (windowDepartmentId !== '0') {
        params.append('department_id', windowDepartmentId)
      }
      params.append('semester', windowSemester)
      params.append('course_id', windowCourseId)
    }

    return params.toString()
  }

  const loadWindowRule = async () => {
    const query = buildWindowQuery()
    if (!query) {
      setWindowStartAt('')
      setWindowEndAt('')
      setWindowEnabled(true)
      return
    }

    setWindowLoading(true)
    try {
      const res = await fetch(`${API_BASE_URL}/mark-entry-window?${query}`)
      if (!res.ok) throw new Error('Failed to fetch window rule')
      const data = await res.json()

      if (!data) {
        setWindowStartAt('')
        setWindowEndAt('')
        setWindowEnabled(true)
        setSelectedWindowComponents([])
        return
      }

      setWindowStartAt(formatDateTimeLocal(data.start_at))
      setWindowEndAt(formatDateTimeLocal(data.end_at))
      setWindowEnabled(data.enabled !== false)
      setSelectedWindowComponents(data.component_ids || [])
    } catch (error) {
      console.error('Error loading window rule:', error)
      setMessage({ type: 'error', text: 'Failed to load window rule.' })
    } finally {
      setWindowLoading(false)
    }
  }



  const saveWindowRule = async () => {
    if (!windowStartAt || !windowEndAt) {
      setMessage({ type: 'error', text: 'Start and end dates are required.' })
      return
    }

    // Convert datetime-local to ISO 8601 format with timezone
    const startDate = new Date(windowStartAt)
    const endDate = new Date(windowEndAt)

    const payload = {
      start_at: startDate.toISOString(),
      end_at: endDate.toISOString(),
      enabled: windowEnabled,
      component_ids: selectedWindowComponents.length > 0 ? selectedWindowComponents : null,
    }

    if (windowScope === 'teacher_course') {
      if (!selectedTeacherId || !selectedCourseId) {
        setMessage({ type: 'error', text: 'Select a teacher and course first.' })
        return
      }
      payload.teacher_id = selectedTeacherId
      payload.course_id = parseInt(selectedCourseId, 10)
    }

    if (windowScope === 'department_semester') {
      if (windowDepartmentId === '' || !windowSemester) {
        setMessage({ type: 'error', text: 'Select a department and semester.' })
        return
      }
      if (windowDepartmentId !== '0') {
        payload.department_id = parseInt(windowDepartmentId, 10)
      }
      payload.semester = parseInt(windowSemester, 10)
    }

    if (windowScope === 'department_semester_course') {
      if (windowDepartmentId === '' || !windowSemester || !windowCourseId) {
        setMessage({ type: 'error', text: 'Select department, semester, and course.' })
        return
      }
      if (windowDepartmentId !== '0') {
        payload.department_id = parseInt(windowDepartmentId, 10)
      }
      payload.semester = parseInt(windowSemester, 10)
      payload.course_id = parseInt(windowCourseId, 10)
    }

    setWindowLoading(true)
    try {
      const res = await fetch(`${API_BASE_URL}/mark-entry-window`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      })
      if (!res.ok) throw new Error('Failed to save window')
      setMessage({ type: 'success', text: 'Mark entry window saved.' })
      fetchExistingWindows() // Refresh the list
    } catch (error) {
      console.error('Error saving window:', error)
      setMessage({ type: 'error', text: 'Failed to save mark entry window.' })
    } finally {
      setWindowLoading(false)
    }
  }

  const fetchExistingWindows = async () => {
    try {
      const res = await fetch(`${API_BASE_URL}/mark-entry-windows`)
      if (!res.ok) throw new Error('Failed to fetch windows')
      const data = await res.json()
      setExistingWindows(data || [])
    } catch (error) {
      console.error('Error fetching windows:', error)
    }
  }

  const deleteWindow = async (windowId) => {
    if (!window.confirm('Are you sure you want to delete this window?')) return

    try {
      const res = await fetch(`${API_BASE_URL}/mark-entry-windows/${windowId}`, {
        method: 'DELETE',
      })
      if (!res.ok) throw new Error('Failed to delete window')
      setMessage({ type: 'success', text: 'Window deleted successfully.' })
      fetchExistingWindows()
    } catch (error) {
      console.error('Error deleting window:', error)
      setMessage({ type: 'error', text: 'Failed to delete window.' })
    }
  }

  const editWindow = (win) => {
    setEditingWindow(win)
    setWindowStartAt(formatDateTimeLocal(win.start_at))
    setWindowEndAt(formatDateTimeLocal(win.end_at))
    setWindowEnabled(win.enabled)
    setSelectedWindowComponents(win.component_ids || [])
    
    // Determine scope and set appropriate fields
    if (win.teacher_id && win.course_id) {
      setWindowScope('teacher_course')
      setSelectedTeacherId(win.teacher_id)
      setSelectedCourseId(win.course_id.toString())
    } else if (win.semester && win.course_id) {
      setWindowScope('department_semester_course')
      setWindowDepartmentId(win.department_id ? win.department_id.toString() : '0')
      setWindowSemester(win.semester.toString())
      setWindowCourseId(win.course_id.toString())
    } else if (win.semester) {
      setWindowScope('department_semester')
      setWindowDepartmentId(win.department_id ? win.department_id.toString() : '0')
      setWindowSemester(win.semester.toString())
    }

    setShowWindowList(false)
    setTimeout(() => window.scrollTo({ top: 0, behavior: 'smooth' }), 100)
  }

  const updateWindow = async () => {
    if (!editingWindow) return

    // Convert datetime-local to ISO 8601 format with timezone
    const startDate = new Date(windowStartAt)
    const endDate = new Date(windowEndAt)

    const payload = {
      start_at: startDate.toISOString(),
      end_at: endDate.toISOString(),
      enabled: windowEnabled,
      component_ids: selectedWindowComponents.length > 0 ? selectedWindowComponents : null,
    }

    setWindowLoading(true)
    try {
      const res = await fetch(`${API_BASE_URL}/mark-entry-windows/${editingWindow.id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      })
      if (!res.ok) throw new Error('Failed to update window')
      setMessage({ type: 'success', text: 'Window updated successfully.' })
      setEditingWindow(null)
      fetchExistingWindows()
    } catch (error) {
      console.error('Error updating window:', error)
      setMessage({ type: 'error', text: 'Failed to update window.' })
    } finally {
      setWindowLoading(false)
    }
  }

  const cancelEdit = () => {
    setEditingWindow(null)
    setWindowStartAt('')
    setWindowEndAt('')
    setWindowEnabled(true)
    setSelectedWindowComponents([])
  }

  const getScopeDescription = (window) => {
    if (window.teacher_id && window.course_id) {
      return `${window.teacher_name} - ${window.course_code} (Most Specific)`
    } else if (window.department_id && window.semester && window.course_id) {
      return `${window.department_name} - Sem ${window.semester} - ${window.course_code}`
    } else if (window.department_id && window.semester) {
      return `${window.department_name} - Semester ${window.semester} (Least Specific)`
    } else if (!window.department_id && window.semester && window.course_id) {
      return `All Departments - Sem ${window.semester} - ${window.course_code}`
    } else if (!window.department_id && window.semester) {
      return `All Departments - Semester ${window.semester}`
    }
    return 'Unknown scope'
  }

  const getWindowStatus = (win) => {
    const now = new Date()
    const startAt = new Date(win.start_at)
    const endAt = new Date(win.end_at)
    
    if (!win.enabled) {
      return { status: 'Disabled', color: 'bg-red-100 text-red-800' }
    } else if (now < startAt) {
      return { status: 'Scheduled', color: 'bg-blue-100 text-blue-800' }
    } else if (now > endAt) {
      return { status: 'Expired', color: 'bg-yellow-100 text-yellow-800' }
    } else {
      return { status: 'Active', color: 'bg-green-100 text-green-800' }
    }
  }

  return (
    <MainLayout title="Mark Permissions" subtitle="Manage mark entry windows and permissions">
      <div className="space-y-6">
        
        {/* Message Alert */}
        {message.text && (
          <div
            className={`rounded-lg p-4 border-l-4 ${
              message.type === 'error'
                ? 'bg-red-50 text-red-700 border-red-400'
                : message.type === 'success'
                ? 'bg-green-50 text-green-700 border-green-400'
                : 'bg-blue-50 text-blue-700 border-blue-400'
            }`}
          >
            {message.text}
          </div>
        )}

        {/* Teacher & Course Selection Card */}
        {windowScope === 'teacher_course' && (
          <div className="bg-white rounded-xl shadow-sm border border-gray-100">
            <div className="border-b border-gray-200 px-6 py-3">
              <h3 className="text-sm font-semibold text-gray-700">Teacher & Course Selection</h3>
            </div>
            <div className="p-6">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
                <div className="relative teacher-search-container">
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Teacher
                  </label>
                  <input
                    type="text"
                    value={teacherSearch}
                    onChange={(e) => {
                      setTeacherSearch(e.target.value)
                      setShowTeacherDropdown(true)
                    }}
                    onFocus={() => setShowTeacherDropdown(true)}
                    placeholder="Search by name or ID..."
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500"
                  />
                  {showTeacherDropdown && (
                    <div className="absolute z-20 w-full mt-1 bg-white border border-gray-300 rounded-lg shadow-lg max-h-60 overflow-y-auto">
                      {teachers
                        .filter(
                          (teacher) =>
                            teacher.name.toLowerCase().includes(teacherSearch.toLowerCase()) ||
                            teacher.faculty_id.toLowerCase().includes(teacherSearch.toLowerCase())
                        )
                        .slice(0, 50)
                        .map((teacher) => (
                          <div
                            key={teacher.faculty_id}
                            onClick={() => {
                              setSelectedTeacherId(teacher.faculty_id)
                              setTeacherSearch(`${teacher.name} (${teacher.faculty_id})`)
                              setShowTeacherDropdown(false)
                            }}
                            className={`px-3 py-2 cursor-pointer hover:bg-blue-50 border-b border-gray-100 last:border-0 ${
                              selectedTeacherId === teacher.faculty_id ? 'bg-blue-50' : ''
                            }`}
                          >
                            <div className="font-medium text-gray-900">{teacher.name}</div>
                            <div className="text-sm text-gray-500">{teacher.faculty_id}</div>
                          </div>
                        ))}
                      {teachers.filter(
                        (teacher) =>
                          teacher.name.toLowerCase().includes(teacherSearch.toLowerCase()) ||
                          teacher.faculty_id.toLowerCase().includes(teacherSearch.toLowerCase())
                      ).length === 0 && (
                        <div className="px-3 py-4 text-sm text-gray-500 text-center">No teachers found</div>
                      )}
                    </div>
                  )}
                  {selectedTeacherId && (
                    <button
                      onClick={() => {
                        setSelectedTeacherId('')
                        setTeacherSearch('')
                        setCourses([])
                        setSelectedCourseId('')
                      }}
                      className="absolute right-2 top-9 text-gray-400 hover:text-gray-600"
                    >
                      ✕
                    </button>
                  )}
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Course
                  </label>
                  <select
                    value={selectedCourseId}
                    onChange={(e) => setSelectedCourseId(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 disabled:bg-gray-100 disabled:cursor-not-allowed"
                    disabled={!selectedTeacherId}
                  >
                    <option value="">Select Course</option>
                    {courses.map((course) => (
                      <option key={course.course_id} value={course.course_id}>
                        {course.course_code} - {course.course_name}
                      </option>
                    ))}
                  </select>
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Window Configuration Card */}
        <div className="bg-white rounded-xl shadow-sm border border-gray-100">
          <div className="border-b border-gray-200 px-6 py-4 flex items-center justify-between">
            <div>
              <h3 className="text-sm font-semibold text-gray-700">
                {editingWindow ? 'Edit Mark Entry Window' : 'Create Mark Entry Window'}
              </h3>
              <p className="text-xs text-gray-500 mt-1">
                {editingWindow ? 'Update window configuration' : 'Define time-based access control'}
              </p>
            </div>
            <div className="flex gap-2">
              {editingWindow ? (
                <>
                  <button
                    onClick={cancelEdit}
                    className="px-4 py-2 bg-gray-500 text-white text-sm font-medium rounded-lg hover:bg-gray-600 transition-colors"
                  >
                    Cancel
                  </button>
                  <button
                    onClick={updateWindow}
                    className="px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-lg hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                    disabled={windowLoading}
                  >
                    {windowLoading ? 'Updating...' : 'Update Window'}
                  </button>
                </>
              ) : (
                <button
                  onClick={saveWindowRule}
                  className="px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-lg hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                  disabled={windowLoading}
                >
                  {windowLoading ? 'Saving...' : 'Save Window'}
                </button>
              )}
            </div>
          </div>

          <div className="p-6 space-y-5">
            {editingWindow && (
              <div className="bg-blue-50 border border-blue-200 rounded-lg p-3">
                <p className="text-sm text-blue-900">
                  <span className="font-semibold">Editing:</span> {getScopeDescription(editingWindow)}
                </p>
              </div>
            )}

            {/* Scope Selection */}
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Window Scope
              </label>
              <select
                value={windowScope}
                onChange={(e) => setWindowScope(e.target.value)}
                disabled={editingWindow !== null}
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 disabled:bg-gray-100 disabled:cursor-not-allowed"
              >
                <option value="teacher_course">Teacher + Course (Most Specific)</option>
                <option value="department_semester">Department + Semester</option>
                <option value="department_semester_course">Department + Semester + Course</option>
              </select>
              {editingWindow && (
                <p className="text-xs text-gray-500 mt-1">Scope cannot be changed for existing windows</p>
              )}
            </div>

            {/* Department/Semester Selection */}
            {(windowScope === 'department_semester' || windowScope === 'department_semester_course') && (
              <div className="bg-gray-50 rounded-lg p-4 border border-gray-200">
                <h4 className="text-sm font-semibold text-gray-700 mb-3">Department & Semester</h4>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                  <div>
                    <label className="block text-xs font-medium text-gray-600 mb-1">Department</label>
                    <select
                      value={windowDepartmentId}
                      onChange={(e) => setWindowDepartmentId(e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 text-sm"
                    >
                      <option value="">Select Department</option>
                      <option value="0">All Departments</option>
                      {departments.map((department) => (
                        <option key={department.id} value={department.id}>
                          {department.department_name}
                        </option>
                      ))}
                    </select>
                  </div>
                  <div>
                    <label className="block text-xs font-medium text-gray-600 mb-1">Semester</label>
                    <select
                      value={windowSemester}
                      onChange={(e) => setWindowSemester(e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 text-sm"
                    >
                      <option value="">Select Semester</option>
                      {[1, 2, 3, 4, 5, 6, 7, 8].map((sem) => (
                        <option key={sem} value={sem}>
                          Semester {sem}
                        </option>
                      ))}
                    </select>
                  </div>
                  {windowScope === 'department_semester_course' && (
                    <div>
                      <label className="block text-xs font-medium text-gray-600 mb-1">Course</label>
                      {windowDepartmentId === '0' ? (
                        <input
                          type="number"
                          value={windowCourseId}
                          onChange={(e) => setWindowCourseId(e.target.value)}
                          placeholder="Enter Course ID"
                          className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 text-sm"
                        />
                      ) : (
                        <select
                          value={windowCourseId}
                          onChange={(e) => setWindowCourseId(e.target.value)}
                          className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 text-sm"
                        >
                          <option value="">Select Course</option>
                          {windowCourses.map((course) => (
                            <option key={course.course_id} value={course.course_id}>
                              {course.course_code} - {course.course_name}
                            </option>
                          ))}
                        </select>
                      )}
                    </div>
                  )}
                </div>
              </div>
            )}

            {/* Time Window */}
            <div className="bg-blue-50 rounded-lg p-4 border border-blue-100">
              <h4 className="text-sm font-semibold text-gray-700 mb-3">Time Window Configuration</h4>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-2">Start Date & Time</label>
                  <input
                    type="datetime-local"
                    value={windowStartAt}
                    onChange={(e) => setWindowStartAt(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500"
                  />
                </div>
                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-2">End Date & Time</label>
                  <input
                    type="datetime-local"
                    value={windowEndAt}
                    onChange={(e) => setWindowEndAt(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500"
                  />
                </div>
              </div>
              <div className="mt-3">
                <label className="inline-flex items-center gap-2 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={windowEnabled}
                    onChange={(e) => setWindowEnabled(e.target.checked)}
                    className="h-4 w-4 accent-blue-600 cursor-pointer"
                  />
                  <span className="text-sm text-gray-700 font-medium">Enable this window</span>
                </label>
              </div>
            </div>

            {/* Component Selection */}
            {windowComponents.length > 0 && (
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Allowed Mark Components
                </label>
                <div className="space-y-3">
                  {Object.entries(
                    windowComponents.reduce((groups, component) => {
                      const courseTypeName = component.course_type_name || 'Other'
                      if (!groups[courseTypeName]) groups[courseTypeName] = []
                      groups[courseTypeName].push(component)
                      return groups
                    }, {})
                  ).map(([courseTypeName, components]) => (
                    <div key={courseTypeName} className="bg-gray-50 rounded-lg p-4 border border-gray-200">
                      <h4 className="text-xs font-semibold text-gray-600 uppercase tracking-wider mb-3">
                        {courseTypeName}
                      </h4>
                      <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3">
                        {components.map((component) => (
                          <label
                            key={component.id}
                            className="flex items-center gap-2 text-sm text-gray-700 cursor-pointer hover:text-blue-600"
                          >
                            <input
                              type="checkbox"
                              checked={selectedWindowComponents.includes(component.id)}
                              onChange={(e) => {
                                if (e.target.checked) {
                                  setSelectedWindowComponents([...selectedWindowComponents, component.id])
                                } else {
                                  setSelectedWindowComponents(
                                    selectedWindowComponents.filter((id) => id !== component.id)
                                  )
                                }
                              }}
                              className="h-4 w-4 accent-blue-600 cursor-pointer"
                            />
                            <span className="font-medium">{component.name}</span>
                          </label>
                        ))}
                      </div>
                    </div>
                  ))}
                </div>
                <p className="text-xs text-gray-500 mt-2">
                  Leave all unchecked to allow all components, or select specific ones to restrict access.
                </p>
              </div>
            )}
          </div>
        </div>

        {/* Existing Windows List */}
        <div className="bg-white rounded-xl shadow-sm border border-gray-100">
          <div className="border-b border-gray-200 px-6 py-3 flex items-center justify-between">
            <h3 className="text-sm font-semibold text-gray-700">Existing Windows</h3>
            <span className="px-3 py-1 bg-blue-100 text-blue-700 rounded-full text-xs font-semibold">
              {existingWindows.length} {existingWindows.length === 1 ? 'window' : 'windows'}
            </span>
          </div>
          <div className="p-6">
            {existingWindows.length === 0 ? (
              <div className="text-center py-12 text-gray-400">
                <p className="text-sm">No windows configured yet</p>
              </div>
            ) : (
              <div className="space-y-3">
                {existingWindows.map((win) => {
                  const { status, color } = getWindowStatus(win)
                  return (
                    <div
                      key={win.id}
                      className="bg-gray-50 rounded-lg p-4 border border-gray-200 hover:border-blue-300 hover:shadow-sm transition-all"
                    >
                      <div className="flex items-start justify-between mb-3">
                        <div className="flex-1">
                          <p className="font-semibold text-gray-800 text-sm mb-2">
                            {getScopeDescription(win)}
                          </p>
                          <span className={`px-2 py-1 rounded text-xs font-medium ${color}`}>
                            {status}
                          </span>
                        </div>
                        <div className="flex gap-2 ml-4">
                          <button
                            onClick={() => editWindow(win)}
                            className="px-3 py-1.5 text-xs text-blue-600 hover:bg-blue-50 rounded-lg font-medium transition-colors"
                          >
                            Edit
                          </button>
                          <button
                            onClick={() => deleteWindow(win.id)}
                            className="px-3 py-1.5 text-xs text-red-600 hover:bg-red-50 rounded-lg font-medium transition-colors"
                          >
                            Delete
                          </button>
                        </div>
                      </div>
                      <div className="grid grid-cols-1 md:grid-cols-3 gap-3 text-xs text-gray-600">
                        <div className="bg-white rounded p-2 border border-gray-100">
                          <div className="text-gray-500 mb-1">Start</div>
                          <div className="font-medium">{new Date(win.start_at).toLocaleString('en-US', { month: 'short', day: 'numeric', year: 'numeric', hour: '2-digit', minute: '2-digit' })}</div>
                        </div>
                        <div className="bg-white rounded p-2 border border-gray-100">
                          <div className="text-gray-500 mb-1">End</div>
                          <div className="font-medium">{new Date(win.end_at).toLocaleString('en-US', { month: 'short', day: 'numeric', year: 'numeric', hour: '2-digit', minute: '2-digit' })}</div>
                        </div>
                        <div className="bg-white rounded p-2 border border-gray-100">
                          <div className="text-gray-500 mb-1">Components</div>
                          <div className="font-medium">
                            {win.component_ids && win.component_ids.length > 0
                              ? `${win.component_ids.length} selected`
                              : 'All allowed'}
                          </div>
                        </div>
                      </div>
                    </div>
                  )
                })}
              </div>
            )}
          </div>
        </div>
      </div>
    </MainLayout>
  )
}

export default MarkEntryPermissionsPage
