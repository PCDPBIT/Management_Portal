import React from 'react'

function SearchFilterBar({
  searchQuery,
  onSearchChange,
  searchPlaceholder = "Search...",
  filters = [],
  resultCount,
  resultLabel = "items",
  onClearAll,
  searchWidth = "w-full sm:w-96"
}) {
  // Check if any filters are active
  const hasActiveFilters = () => {
    if (searchQuery) return true
    return filters.some(filter => filter.value !== filter.defaultValue)
  }

  return (
    <div className=" p-4 sm:p-6 space-y-4">
      {/* Search and Filters Row */}
      <div className="flex flex-col sm:flex-row gap-3 sm:gap-4">
        {/* Search Bar */}
        <div className={`relative ${searchWidth}`}>
          <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
            <svg className="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
          </div>
          <input
            type="text"
            placeholder={searchPlaceholder}
            value={searchQuery}
            onChange={(e) => onSearchChange(e.target.value)}
            className="w-full pl-12 pr-10 py-2.5 border-2 border-gray-200 outline-none focus:border-primary bg-background rounded-lg transition-all duration-200 text-sm"
          />
          {searchQuery && (
            <button
              onClick={() => onSearchChange('')}
              className="absolute inset-y-0 right-0 pr-3 flex items-center text-gray-400 hover:text-gray-600 transition-colors"
              aria-label="Clear search"
            >
              <svg className="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          )}
        </div>

        {/* Filter Dropdowns */}
        {filters.map((filter, index) => (
          <div key={index} className="relative">
            <select
              value={filter.value}
              onChange={(e) => filter.onChange(e.target.value)}
              className="input-custom min-w-[150px] appearance-none pr-10"
            >
              {filter.options.map((option, optIndex) => (
                <option key={optIndex} value={option.value}>
                  {option.label}
                </option>
              ))}
            </select>
            <div className="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none">
              <svg className="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
              </svg>
            </div>
          </div>
        ))}
      </div>

      {/* Results Count and Clear Filters */}
      {hasActiveFilters() && resultCount !== undefined && (
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2 pt-2 border-t border-gray-200">
          <p className="text-sm text-gray-600">
            Showing <span className="font-semibold text-gray-900">{resultCount}</span> {resultCount === 1 ? resultLabel.replace(/s$/, '') : resultLabel}
          </p>
        </div>
      )}
    </div>
  )
}

export default SearchFilterBar