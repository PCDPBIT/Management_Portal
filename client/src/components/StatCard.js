import React from 'react'

function StatCard({ stat }) {
  return (
    <div className="card-custom bg-white rounded-lg shadow-sm hover:border-primary p-6">
      <div className="flex items-center justify-between mb-4">
        <div className="flex-1">
          <p className="text-sm font-medium text-gray-600 mb-2">
            {stat.title}
          </p>
          <p className="text-3xl font-bold text-gray-900">
            {stat.value}
          </p>
        </div>
        {stat.icon && (
          <div className="flex-shrink-0 w-14 h-14 rounded-lg bg-secondary flex items-center justify-center text-iconColor">
            {stat.icon}
          </div>
        )}
      </div>
      
      <div className="w-full h-1 bg-primary rounded-full"></div>
    </div>
  )
}

export default StatCard