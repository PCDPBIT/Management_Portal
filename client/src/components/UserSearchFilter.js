import React from 'react'

function UserSearchFilter({ 
  searchQuery, 
  onSearchChange, 
  roleFilter, 
  onRoleFilterChange,
  userCount
}) {

  return (
    <div className="p-4 sm:p-6 space-y-6">
      <div className="relative">
        <div className="absolute inset-y-0 left-0 pl-4 flex items-center">
          <svg className="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
          </svg>
        </div>
        <input
          type="text"
          placeholder="Search..."
          value={searchQuery}
          onChange={(e) => onSearchChange(e.target.value)}
          className="w-1/4 pl-12 pr-4 py-3 border-2 focus:outline-none focus:border-primary bg-background rounded-lg transition-all duration-200 text-sm"
        />
        {searchQuery && (
          <button
            onClick={() => onSearchChange('')}
            className="absolute inset-y-0 right-0 pr-4 flex items-center text-gray-400 hover:text-gray-600 transition-colors"
          >
            <svg className="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        )}
      </div>

      {/* Results Count */}
      {(searchQuery || roleFilter !== 'all') && (
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2 pt-2 border-t border-gray-200">
          <p className="text-sm text-gray-600">
            Showing <span className="font-semibold text-gray-900">{userCount}</span> {userCount === 1 ? 'user' : 'users'}
          </p>
          {(searchQuery || roleFilter !== 'all') && (
            <button
              onClick={() => {
                onSearchChange('')
                onRoleFilterChange('all')
              }}
              className="text-sm text-blue-600 hover:text-blue-800 font-medium transition-colors text-left sm:text-right"
            >
              Clear filters
            </button>
          )}
        </div>
      )}
    </div>
  )
}

export default UserSearchFilter