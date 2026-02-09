import React, { useEffect, useState } from 'react'
import MainLayout from '../../components/MainLayout'
import { API_BASE_URL } from '../../config'

function MarkEntryPermissionsPage() {
  const [teachers, setTeachers] = useState([])
  const [selectedTeacherId, setSelectedTeacherId] = useState('')
  const [courses, setCourses] = useState([])
  const [selectedCourseId, setSelectedCourseId] = useState('')
  const [categories, setCategories] = useState([])
  const [loading, setLoading] = useState(false)
  const [saving, setSaving] = useState(false)
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
      setCategories([])
    }
  }, [selectedTeacherId])

  useEffect(() => {
    if (selectedTeacherId && selectedCourseId) {
      fetchPermissions(selectedCourseId, selectedTeacherId)
    } else {
      setCategories([])
    }
  }, [selectedTeacherId, selectedCourseId])

  useEffect(() => {
    if (windowScope === 'department_semester_course' && windowDepartmentId && windowSemester) {
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
    setLoading(true)
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
    } finally {
      setLoading(false)
    }
  }

  const fetchPermissions = async (courseId, teacherId) => {
    setLoading(true)
    setMessage({ type: '', text: '' })
    try {
      const res = await fetch(
        `${API_BASE_URL}/mark-entry-permissions?course_id=${courseId}&teacher_id=${teacherId}`
      )
      if (!res.ok) throw new Error('Failed to fetch permissions')
      const data = await res.json()
      setCategories(Array.isArray(data) ? data : [])
    } catch (error) {
      console.error('Error fetching permissions:', error)
      setCategories([])
      setMessage({ type: 'error', text: 'Failed to load mark entry permissions.' })
    } finally {
      setLoading(false)
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
      if (!windowDepartmentId || !windowSemester) return ''
      params.append('department_id', windowDepartmentId)
      params.append('semester', windowSemester)
    }

    if (windowScope === 'department_semester_course') {
      if (!windowDepartmentId || !windowSemester || !windowCourseId) return ''
      params.append('department_id', windowDepartmentId)
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

      setWindowStartAt(data.start_at || '')
      setWindowEndAt(data.end_at || '')
      setWindowEnabled(data.enabled !== false)
      setSelectedWindowComponents(data.component_ids || [])
    } catch (error) {
      console.error('Error loading window rule:', error)
      setMessage({ type: 'error', text: 'Failed to load window rule.' })
    } finally {
      setWindowLoading(false)
    }
  }

  const toggleCategory = (categoryId) => {
    setCategories((prev) =>
      prev.map((category) =>
        category.id === categoryId
          ? { ...category, enabled: !category.enabled }
          : category
      )
    )
  }

  const setAllCategories = (enabled) => {
    setCategories((prev) => prev.map((category) => ({ ...category, enabled })))
  }

  const savePermissions = async () => {
    if (!selectedTeacherId || !selectedCourseId) {
      setMessage({ type: 'error', text: 'Select a teacher and course first.' })
      return
    }

    setSaving(true)
    setMessage({ type: '', text: '' })
    try {
      const payload = {
        course_id: parseInt(selectedCourseId, 10),
        teacher_id: selectedTeacherId,
        permissions: categories.map((category) => ({
          assessment_component_id: category.id,
          enabled: !!category.enabled,
        })),
      }

      const res = await fetch(`${API_BASE_URL}/mark-entry-permissions`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      })

      if (!res.ok) throw new Error('Failed to save permissions')
      setMessage({ type: 'success', text: 'Permissions updated successfully.' })
    } catch (error) {
      console.error('Error saving permissions:', error)
      setMessage({ type: 'error', text: 'Failed to save permissions.' })
    } finally {
      setSaving(false)
    }
  }

  const saveWindowRule = async () => {
    if (!windowStartAt || !windowEndAt) {
      setMessage({ type: 'error', text: 'Start and end dates are required.' })
      return
    }

    const payload = {
      start_at: windowStartAt,
      end_at: windowEndAt,
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
      if (!windowDepartmentId || !windowSemester) {
        setMessage({ type: 'error', text: 'Select a department and semester.' })
        return
      }
      payload.department_id = parseInt(windowDepartmentId, 10)
      payload.semester = parseInt(windowSemester, 10)
    }

    if (windowScope === 'department_semester_course') {
      if (!windowDepartmentId || !windowSemester || !windowCourseId) {
        setMessage({ type: 'error', text: 'Select department, semester, and course.' })
        return
      }
      payload.department_id = parseInt(windowDepartmentId, 10)
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
    setWindowStartAt(new Date(win.start_at).toISOString().slice(0, 16))
    setWindowEndAt(new Date(win.end_at).toISOString().slice(0, 16))
    setWindowEnabled(win.enabled)
    setSelectedWindowComponents(win.component_ids || [])
    
    // Determine scope and set appropriate fields
    if (win.teacher_id && win.course_id) {
      setWindowScope('teacher_course')
      setSelectedTeacherId(win.teacher_id)
      setSelectedCourseId(win.course_id.toString())
    } else if (win.department_id && win.semester && win.course_id) {
      setWindowScope('department_semester_course')
      setWindowDepartmentId(win.department_id.toString())
      setWindowSemester(win.semester.toString())
      setWindowCourseId(win.course_id.toString())
    } else if (win.department_id && win.semester) {
      setWindowScope('department_semester')
      setWindowDepartmentId(win.department_id.toString())
      setWindowSemester(win.semester.toString())
    }

    setShowWindowList(false)
    setTimeout(() => window.scrollTo({ top: 0, behavior: 'smooth' }), 100)
  }

  const updateWindow = async () => {
    if (!editingWindow) return

    const payload = {
      start_at: windowStartAt,
      end_at: windowEndAt,
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
    }
    return 'Unknown scope'
  }

  const getWindowStatus = (win) => {
    const now = new Date()
    const endAt = new Date(win.end_at)
    
    if (now > endAt) {
      return { status: 'Expired', color: 'bg-yellow-100 text-yellow-800' }
    } else if (!win.enabled) {
      return { status: 'Disabled', color: 'bg-red-100 text-red-800' }
    } else {
      return { status: 'Active', color: 'bg-green-100 text-green-800' }
    }
  }

  return (
    <MainLayout title="Mark Entry Permissions" subtitle="Enable mark entry components for teachers">
      <div className="space-y-6">
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

        {/* Toggle button for existing windows list */}
        <div className="flex justify-end">
          <button
            onClick={() => setShowWindowList(!showWindowList)}
            className="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition-colors"
          >
            {showWindowList ? 'Hide' : 'View'} Existing Windows ({existingWindows.length})
          </button>
        </div>

        {/* Existing Windows List */}
        {showWindowList && (
          <div className="bg-white rounded-lg shadow-md p-6">
            <h3 className="text-xl font-bold text-gray-800 mb-4">Existing Mark Entry Windows</h3>
            {existingWindows.length === 0 ? (
              <p className="text-gray-500">No windows configured yet.</p>
            ) : (
              <div className="overflow-x-auto">
                <table className="min-w-full divide-y divide-gray-200">
                  <thead className="bg-gray-50">
                    <tr>
                      <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Scope
                      </th>
                      <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Start
                      </th>
                      <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        End
                      </th>
                      <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Status
                      </th>
                      <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Components
                      </th>
                      <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Actions
                      </th>
                    </tr>
                  </thead>
                  <tbody className="bg-white divide-y divide-gray-200">
                    {existingWindows.map((win) => (
                      <tr key={win.id} className="hover:bg-gray-50">
                        <td className="px-4 py-3 text-sm text-gray-900">
                          {getScopeDescription(win)}
                        </td>
                        <td className="px-4 py-3 text-sm text-gray-500">
                          {new Date(win.start_at).toLocaleString()}
                        </td>
                        <td className="px-4 py-3 text-sm text-gray-500">
                          {new Date(win.end_at).toLocaleString()}
                        </td>
                        <td className="px-4 py-3 text-sm">
                          {(() => {
                            const { status, color } = getWindowStatus(win)
                            return (
                              <span className={`px-2 py-1 rounded-full text-xs font-semibold ${color}`}>
                                {status}
                              </span>
                            )
                          })()}
                        </td>
                        <td className="px-4 py-3 text-sm text-gray-500">
                          {win.component_ids && win.component_ids.length > 0
                            ? `${win.component_ids.length} selected`
                            : 'All allowed'}
                        </td>
                        <td className="px-4 py-3 text-sm space-x-2">
                          <button
                            onClick={() => editWindow(win)}
                            className="text-indigo-600 hover:text-indigo-900 font-medium"
                          >
                            Edit
                          </button>
                          <button
                            onClick={() => deleteWindow(win.id)}
                            className="text-red-600 hover:text-red-900 font-medium"
                          >
                            Delete
                          </button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        )}

        <div className="bg-white rounded-xl shadow-md p-6 border-l-4 border-indigo-500">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="relative teacher-search-container">
              <label className="block text-sm font-semibold text-gray-700 mb-2">Teacher</label>
              <input
                type="text"
                value={teacherSearch}
                onChange={(e) => {
                  setTeacherSearch(e.target.value)
                  setShowTeacherDropdown(true)
                }}
                onFocus={() => setShowTeacherDropdown(true)}
                placeholder="Search teacher by name or ID..."
                className="w-full px-4 py-2 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 transition-colors"
              />
              {showTeacherDropdown && (
                <div className="absolute z-10 w-full mt-1 bg-white border-2 border-gray-300 rounded-lg shadow-lg max-h-60 overflow-y-auto">
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
                        className={`px-4 py-2 cursor-pointer hover:bg-indigo-50 ${
                          selectedTeacherId === teacher.faculty_id ? 'bg-indigo-100' : ''
                        }`}
                      >
                        <div className="font-medium text-gray-900">{teacher.name}</div>
                        <div className="text-sm text-gray-500">ID: {teacher.faculty_id}</div>
                      </div>
                    ))}
                  {teachers.filter(
                    (teacher) =>
                      teacher.name.toLowerCase().includes(teacherSearch.toLowerCase()) ||
                      teacher.faculty_id.toLowerCase().includes(teacherSearch.toLowerCase())
                  ).length === 0 && (
                    <div className="px-4 py-3 text-sm text-gray-500">No teachers found</div>
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
              <label className="block text-sm font-semibold text-gray-700 mb-2">Course</label>
              <select
                value={selectedCourseId}
                onChange={(e) => setSelectedCourseId(e.target.value)}
                className="w-full px-4 py-2 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 transition-colors"
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

        {selectedTeacherId && selectedCourseId && (
          <div className="bg-white rounded-xl shadow-md overflow-hidden">
            <div className="p-6 border-b border-gray-200 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
              <div>
                <h3 className="text-xl font-semibold text-gray-800">Mark Components</h3>
                <p className="text-sm text-gray-600 mt-1">Toggle which components teachers can enter</p>
              </div>
              <div className="flex flex-wrap gap-3">
                <button
                  onClick={() => setAllCategories(true)}
                  className="px-4 py-2 bg-indigo-600 text-white font-semibold rounded-lg hover:bg-indigo-700 transition-colors"
                >
                  Enable All
                </button>
                <button
                  onClick={() => setAllCategories(false)}
                  className="px-4 py-2 bg-gray-600 text-white font-semibold rounded-lg hover:bg-gray-700 transition-colors"
                >
                  Disable All
                </button>
                <button
                  onClick={savePermissions}
                  disabled={saving}
                  className="px-5 py-2 bg-green-600 text-white font-semibold rounded-lg hover:bg-green-700 disabled:bg-gray-400 transition-colors"
                >
                  {saving ? 'Saving...' : 'Save Permissions'}
                </button>
              </div>
            </div>

            <div className="overflow-x-auto">
              <table className="min-w-full border-collapse">
                <thead>
                  <tr className="bg-indigo-600 text-white">
                    <th className="border border-indigo-400 px-4 py-2 text-left text-sm font-semibold">Component</th>
                    <th className="border border-indigo-400 px-4 py-2 text-center text-sm font-semibold">Max Marks</th>
                    <th className="border border-indigo-400 px-4 py-2 text-center text-sm font-semibold">Conversion</th>
                    <th className="border border-indigo-400 px-4 py-2 text-center text-sm font-semibold">Enabled</th>
                  </tr>
                </thead>
                <tbody>
                  {categories.map((category, idx) => (
                    <tr
                      key={category.id}
                      className={idx % 2 === 0 ? 'bg-white' : 'bg-gray-50'}
                    >
                      <td className="border border-gray-200 px-4 py-2 text-sm text-gray-800">
                        {category.name}
                      </td>
                      <td className="border border-gray-200 px-4 py-2 text-center text-sm text-gray-700">
                        {category.max_marks}
                      </td>
                      <td className="border border-gray-200 px-4 py-2 text-center text-sm text-gray-700">
                        {category.conversion_marks}
                      </td>
                      <td className="border border-gray-200 px-4 py-2 text-center">
                        <input
                          type="checkbox"
                          checked={!!category.enabled}
                          onChange={() => toggleCategory(category.id)}
                          className="h-4 w-4 accent-indigo-600"
                        />
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            {loading && (
              <div className="p-4 text-sm text-gray-600">Loading permissions...</div>
            )}

            {!loading && categories.length === 0 && (
              <div className="p-4 text-sm text-gray-600">No mark categories found for this course.</div>
            )}
          </div>
        )}

        <div className="bg-white rounded-xl shadow-md overflow-hidden">
          <div className="p-6 border-b border-gray-200 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
            <div>
              <h3 className="text-xl font-semibold text-gray-800">
                {editingWindow ? 'Edit Mark Entry Window' : 'Create Mark Entry Window'}
              </h3>
              <p className="text-sm text-gray-600 mt-1">
                {editingWindow ? 'Update window dates and settings' : 'Control the date range for mark entry'}
              </p>
            </div>
            <div className="flex gap-2">
              {editingWindow ? (
                <>
                  <button
                    onClick={cancelEdit}
                    className="px-5 py-2 bg-gray-500 text-white font-semibold rounded-lg hover:bg-gray-600 transition-colors"
                  >
                    Cancel
                  </button>
                  <button
                    onClick={updateWindow}
                    className="px-5 py-2 bg-blue-600 text-white font-semibold rounded-lg hover:bg-blue-700 disabled:bg-gray-400 transition-colors"
                    disabled={windowLoading}
                  >
                    {windowLoading ? 'Updating...' : 'Update Window'}
                  </button>
                </>
              ) : (
                <button
                  onClick={saveWindowRule}
                  className="px-5 py-2 bg-green-600 text-white font-semibold rounded-lg hover:bg-green-700 disabled:bg-gray-400 transition-colors"
                  disabled={windowLoading}
                >
                  {windowLoading ? 'Saving...' : 'Save Window'}
                </button>
              )}
            </div>
          </div>

          <div className="p-6 space-y-4">
            {editingWindow && (
              <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-4">
                <p className="text-sm text-blue-800">
                  <strong>Editing:</strong> {getScopeDescription(editingWindow)}
                </p>
              </div>
            )}
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">Scope</label>
              <select
                value={windowScope}
                onChange={(e) => setWindowScope(e.target.value)}
                disabled={editingWindow !== null}
                className="w-full max-w-md px-4 py-2 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 transition-colors disabled:bg-gray-100 disabled:cursor-not-allowed"
              >
                <option value="teacher_course">Teacher + Course</option>
                <option value="department_semester">Department + Semester</option>
                <option value="department_semester_course">Department + Semester + Course</option>
              </select>
              {editingWindow && (
                <p className="text-xs text-gray-500 mt-1">Scope cannot be changed for existing windows</p>
              )}
            </div>

            {windowScope === 'teacher_course' && (
              <div className="text-sm text-gray-600">
                Using the selected teacher and course above.
              </div>
            )}

            {(windowScope === 'department_semester' || windowScope === 'department_semester_course') && (
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">Department</label>
                  <select
                    value={windowDepartmentId}
                    onChange={(e) => setWindowDepartmentId(e.target.value)}
                    className="w-full px-4 py-2 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 transition-colors"
                  >
                    <option value="">Select Department</option>
                    {departments.map((department) => (
                      <option key={department.id} value={department.id}>
                        {department.department_name}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">Semester</label>
                  <select
                    value={windowSemester}
                    onChange={(e) => setWindowSemester(e.target.value)}
                    className="w-full px-4 py-2 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 transition-colors"
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
                    <label className="block text-sm font-semibold text-gray-700 mb-2">Course</label>
                    <select
                      value={windowCourseId}
                      onChange={(e) => setWindowCourseId(e.target.value)}
                      className="w-full px-4 py-2 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 transition-colors"
                    >
                      <option value="">Select Course</option>
                      {windowCourses.map((course) => (
                        <option key={course.course_id} value={course.course_id}>
                          {course.course_code} - {course.course_name}
                        </option>
                      ))}
                    </select>
                  </div>
                )}
              </div>
            )}

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Allowed Components (empty = all allowed)
              </label>
              <div className="space-y-4 p-4 bg-gray-50 rounded-lg border border-gray-200">
                {Object.entries(
                  windowComponents.reduce((groups, component) => {
                    const courseTypeName = component.course_type_name || 'Other'
                    console.log(`[DEBUG] Grouping component ${component.id} (${component.name}): course_type_name='${component.course_type_name}' -> group='${courseTypeName}'`)
                    if (!groups[courseTypeName]) groups[courseTypeName] = []
                    groups[courseTypeName].push(component)
                    return groups
                  }, {})
                ).map(([courseTypeName, components]) => (
                  <div key={courseTypeName} className="space-y-2">
                    <h4 className="text-sm font-bold text-indigo-700 uppercase tracking-wide">
                      {courseTypeName}
                    </h4>
                    <div className="grid grid-cols-2 md:grid-cols-4 gap-3 pl-2">
                      {components.map((component) => (
                        <label
                          key={component.id}
                          className="flex items-center gap-2 text-sm text-gray-700 cursor-pointer hover:text-indigo-600"
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
                            className="h-4 w-4 accent-indigo-600"
                          />
                          <span className="font-medium">{component.name}</span>
                        </label>
                      ))}
                    </div>
                  </div>
                ))}
              </div>
              <p className="text-xs text-gray-500 mt-2">
                Leave all unchecked to allow all components. Select specific ones to restrict access.
              </p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">Start Date</label>
                <input
                  type="datetime-local"
                  value={windowStartAt}
                  onChange={(e) => setWindowStartAt(e.target.value)}
                  className="w-full px-4 py-2 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 transition-colors"
                />
              </div>
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">End Date</label>
                <input
                  type="datetime-local"
                  value={windowEndAt}
                  onChange={(e) => setWindowEndAt(e.target.value)}
                  className="w-full px-4 py-2 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 transition-colors"
                />
              </div>
            </div>

            <label className="inline-flex items-center gap-2 text-sm text-gray-700">
              <input
                type="checkbox"
                checked={windowEnabled}
                onChange={(e) => setWindowEnabled(e.target.checked)}
                className="h-4 w-4 accent-indigo-600"
              />
              Enable window
            </label>
          </div>
        </div>
      </div>
    </MainLayout>
  )
}

export default MarkEntryPermissionsPage
