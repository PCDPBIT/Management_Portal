import React, { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import MainLayout from '../../components/MainLayout'
import { API_BASE_URL } from '../../config'
import StatCard from '../../components/StatCard'
import QuickActionBtn from '../../components/QuickActionBtn'

function Dashboard() {
  const navigate = useNavigate()
  const userRole = localStorage.getItem('userRole')
  const [stats, setStats] = useState({
    totalCurriculum: 0,
    activeCurriculum: 0,
    totalDepartments: 0,
    recentActivities: 0
  })
  const [markEntryStats, setMarkEntryStats] = useState({
    totalWindows: 0,
    activeWindows: 0,
    upcomingWindows: 0,
    teachersWithPermissions: 0,
    departmentWindows: 0,
    teacherWindows: 0
  })

  useEffect(() => {
    // Fetch dashboard stats based on role
    if (userRole === 'coe') {
      fetchMarkEntryStats()
    } else {
      fetchDashboardStats()
    }
  }, [userRole])

  const fetchMarkEntryStats = async () => {
    try {
      const response = await fetch(`${API_BASE_URL}/mark-entry-windows/stats`)
      if (response.ok) {
        const data = await response.json()
        setMarkEntryStats(data)
      }
    } catch (error) {
      console.error('Error fetching mark entry stats:', error)
    }
  }

  const fetchDashboardStats = async () => {
    try {
      // Fetch actual curriculum count from API
      const curriculumResponse = await fetch(`${API_BASE_URL}/curriculum`)
      const curriculumData = curriculumResponse.ok ? await curriculumResponse.json() : []
      
      // Fetch departments count from API
      const departmentsResponse = await fetch(`${API_BASE_URL}/departments`)
      const departmentsData = departmentsResponse.ok ? await departmentsResponse.json() : []
      
      setStats({
        totalCurriculum: curriculumData.length || 0,
        activeCurriculum: curriculumData.length || 0,
        totalDepartments: departmentsData.length || 0,
        recentActivities: 0 // Can be fetched from logs API
      })
    } catch (error) {
      console.error('Error fetching dashboard stats:', error)
      setStats({
        totalCurriculum: 0,
        activeCurriculum: 0,
        totalDepartments: 0,
        recentActivities: 0
      })
    }
  }

  const statCards = userRole === 'coe' ? [
    {
      title: 'Total Windows',
      value: markEntryStats.totalWindows,
      icon: (
        <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
        </svg>
      ),
    },
    {
      title: 'Active Windows',
      value: markEntryStats.activeWindows,
      icon: (
        <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
      ),
    },
    {
      title: 'Upcoming Windows',
      value: markEntryStats.upcomingWindows,
      icon: (
        <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
      ),
    },
    {
      title: 'Teachers with Permissions',
      value: markEntryStats.teachersWithPermissions,
      icon: (
        <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
        </svg>
      ),
    }
  ] : [
    {
      title: 'Total Curriculum',
      value: stats.totalCurriculum,
      icon: (
        <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
        </svg>
      ),
    },
    {
      title: 'Active Curriculum',
      value: stats.activeCurriculum,
      icon: (
        <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
        </svg>
      ),
    },
    {
      title: 'Total Departments',
      value: stats.totalDepartments,
      icon: (
        <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
        </svg>
      ),
    },
    {
      title: 'Recent Activities',
      value: stats.recentActivities,
      icon: (
        <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
      ),
    }
  ]

  const quickActions = userRole === 'coe' ? [
    {
      title: 'Manage Mark Permissions',
      description: 'Create and manage mark entry windows',
      icon: (
        <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z" />
        </svg>
      ),
      action: () => navigate('/mark-entry-permissions')
    }
  ] : [
    {
      title: 'View Curriculum',
      description: 'Browse all curriculum structures',
      icon: (
        <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
        </svg>
      ),
      action: () => navigate('/curriculum')
    },
    {
      title: 'Manage Clusters',
      description: 'Create and manage department clusters',
      icon: (
        <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
        </svg>
      ),
      action: () => navigate('/clusters')
    },
    {
      title: 'Manage Sharing',
      description: 'Control content sharing between cluster departments',
      icon: (
        <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
        </svg>
      ),
      action: () => navigate('/sharing')
    }
  ]

  // Add Users Management action for admin users only
  if (userRole === 'admin') {
    quickActions.push({
      title: 'User Management',
      description: 'Manage system users and permissions',
      icon: (
        <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
        </svg>
      ),
      action: () => navigate('/users')
    })
  }

  return (
    <MainLayout 
      title="Dashboard" 
      subtitle={userRole === 'coe' ? "Mark Entry Management Overview" : "Welcome back! Here's what's happening with your curriculum"}
    >
      <div className="space-y-4">

        {/* Stats Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-x-4">
          {statCards.map((stat, index) => (
            <StatCard key={index} stat={stat} />
          ))}
        </div>

        {/* Quick Actions */}
        <div className="bg-white rounded-lg shadow-sm border border-primary-200 overflow-hidden ">
          <div className="px-6 py-4 border-b border-gray-200">
            <h2 className="text-xl font-bold text-gray-900">Quick Actions</h2>
            <p className="text-sm text-gray-600 mt-1">
              Access frequently used features
            </p>
          </div>
          <div className="p-6 grid grid-cols-1 lg:grid-cols-2 gap-6">
            {quickActions.map((action, index) => (
              <QuickActionBtn key={index} action={action}/>
            ))}
          </div>
        </div>
      </div>
    </MainLayout>
  )
}

export default Dashboard