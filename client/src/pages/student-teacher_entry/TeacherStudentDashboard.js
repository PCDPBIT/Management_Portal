import React from 'react'
import { useNavigate } from 'react-router-dom'
import MainLayout from '../../components/MainLayout'

function TeacherStudentDashboard() {
  const navigate = useNavigate()

  const actions = [
    {
      title: 'Teacher Details',
      description: 'Manage teacher profiles and information',
      icon: (
        <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 20H5a2 2 0 01-2-2V6a2 2 0 012-2h10a2 2 0 012 2v1m2 13a2 2 0 01-2-2V7m2 13a2 2 0 002-2V9a2 2 0 00-2-2h-2m-4-3H9M7 16h6M7 8h6v4H7V8z" />
        </svg>
      ),
      action: () => navigate('/teacher-details')
    },
    {
      title: 'Student Details',
      description: 'View and manage student records',
      icon: (
        <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
        </svg>
      ),
      action: () => navigate('/Student_details')
    },
    {
      title: 'Teacher Student Mapping',
      description: 'Assign students to teachers and manage relationships',
      icon: (
        <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
        </svg>
      ),
      action: () => navigate('/teacher-student-mapping')
    }
  ]

  return (
    <MainLayout 
      title="Student & Teacher Management" 
      subtitle="Manage teachers, students, and their mappings"
    >
      <div className="space-y-8">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {actions.map((action, index) => (
            <button
              key={index}
              onClick={action.action}
              className="flex flex-col items-center text-center p-8 bg-white rounded-xl shadow-sm hover:shadow-md transition-all duration-200 hover:scale-105 border border-gray-100 group"
            >
              <div 
                className="w-16 h-16 rounded-full flex items-center justify-center mb-4 transition-colors duration-200"
                style={{
                    backgroundColor: 'rgba(67, 113, 229, 0.1)',
                    color: 'rgb(67, 113, 229)'
                }}
              >
                {action.icon}
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-2">{action.title}</h3>
              <p className="text-gray-500">{action.description}</p>
            </button>
          ))}
        </div>
      </div>
    </MainLayout>
  )
}

export default TeacherStudentDashboard
