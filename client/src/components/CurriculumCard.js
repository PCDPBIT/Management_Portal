import React, { useState } from "react"
import { useNavigate } from "react-router-dom"

function CurriculumCard({ reg, onEdit = () => { }, onViewLogs = () => { }, onDownloadPDF = () => { }, onDelete = () => { } }) {

  const navigate = useNavigate()
  const [isHovered, setIsHovered] = useState(false)

  return (
    <div
      className="card-custom p-6 cursor-pointer transition-all duration-200 border hover:border-primary rounded-lg shadow-sm hover:shadow-md relative flex flex-col h-full"
      onClick={() => navigate(`/curriculum/${reg.id}/overview`)}
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
      role="button"
      tabIndex={0}
      aria-label={`View details for ${reg.name}`}
      onKeyDown={(e) => {
        if (e.key === 'Enter' || e.key === ' ') {
          e.preventDefault()
          navigate(`/curriculum/${reg.id}/overview`)
        }
      }}
    >
      {isHovered && (
        <div className="absolute -top-3 left-1/2 transform -translate-x-1/2 bg-primary text-white px-3 py-1.5 rounded-md text-xs font-medium shadow-lg pointer-events-none z-20 whitespace-nowrap">
          Click To View Overview
        </div>
      )}

      <div className="flex items-start justify-between mb-4">
        {/* Icon */}
        <div className="w-12 h-12 bg-background rounded-xl flex items-center justify-center flex-shrink-0">
          <svg className="w-6 h-6 text-iconColor" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2}
              d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
            />
          </svg>
        </div>
        {/* Edit Button */}
        <button
          onClick={(e) => {
            e.stopPropagation()
            onEdit(reg)
          }}
          onMouseEnter={() => setIsHovered(false)}
          onMouseLeave={() => setIsHovered(true)}
          className="flex items-center justify-center mt-2 gap-1 px-3 py-2 text-xs font-medium rounded-lg hover:bg-blue-50 transition-colors relative z-10 flex-shrink-0"
          aria-label="Edit curriculum"
          title="Edit this curriculum"
        >
          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
          </svg>
          Edit
        </button>
      </div>

      {/* Content - grows to fill space */}
      <div className="flex-grow">
        <h3 className="text-lg font-bold text-gray-900 mb-3 line-clamp-2 min-h-[3.5rem]">
          {reg.name}
        </h3>

        <div className="space-y-2.5 mb-4 text-sm text-gray-600">
          <div className="flex items-center gap-2">
            <svg className="w-4 h-4 text-gray-400 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
            </svg>
            <span>{reg.academic_year || "N/A"}</span>
          </div>

          <div className="flex items-center gap-2">
            <svg className="w-4 h-4 text-gray-400 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z" />
            </svg>
            <span>{reg.max_credits || 0} Credits</span>
          </div>

          <div className="flex items-center gap-2">
            <svg className="w-4 h-4 text-gray-400 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
            </svg>
            <span
              className={`inline-flex items-center px-2 py-0.5 rounded-md text-xs font-semibold ${reg.curriculum_template === "2022"
                  ? "bg-amber-100 text-amber-700"
                  : "bg-emerald-100 text-emerald-700"
                }`}
            >
              {reg.curriculum_template || "2026"} Template
            </span>
          </div>
        </div>
      </div>

      {/* Actions - pushed to bottom */}
      <div 
        className="flex items-center gap-2 pt-4 border-t border-gray-200 relative z-10 mt-auto"
        onMouseEnter={() => setIsHovered(false)}
        onMouseLeave={() => setIsHovered(true)}
      >
        <button
          onClick={(e) => {
            e.stopPropagation()
            onViewLogs(reg.id)
          }}
          className="flex-1 flex items-center justify-center gap-1.5 px-3 py-2 text-xs font-medium bg-secondary rounded-lg hover:bg-blue-50 transition-colors"
          aria-label="View logs"
          title="View activity logs for this curriculum"
        >
          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4" />
          </svg>
          Logs
        </button>

        <button
          onClick={(e) => {
            e.stopPropagation()
            onDownloadPDF(reg.id, reg.name)
          }}
          className="flex-1 flex items-center justify-center gap-1.5 px-3 py-2 text-xs font-medium bg-secondary rounded-lg hover:bg-blue-50 transition-colors"
          aria-label="Download PDF"
          title="Download curriculum as PDF"
        >
          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
          PDF
        </button>

        <button
          onClick={(e) => {
            e.stopPropagation()
            onDelete(reg.id)
          }}
          className="flex-1 flex items-center justify-center gap-1.5 px-3 py-2 text-xs font-medium text-red-600 hover:text-white hover:bg-red-600 rounded-lg transition-colors"
          aria-label="Delete curriculum"
          title="Delete this curriculum"
        >
          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
          </svg>
          Delete
        </button>
      </div>
    </div>
  )
}

export default CurriculumCard