import React from 'react'

function QuickActionBtn({action}) {
    return (
        <button
            onClick={action.action}
            className="card-custom flex items-start space-x-4 p-5 rounded-xl border group hover:from-primary hover:border-primary  transition-all duration-200"
        >
            <div className="flex-shrink-0 w-12 h-12 bg-white rounded-lg flex items-center justify-center text-iconColor shadow-sm group-hover:bg-primary group-hover:text-white transition-all duration-200">
                {action.icon}
            </div>
            <div className="flex-1 text-left">
                <h3 className="text-base font-semibold text-gray-900 mb-1">{action.title}</h3>
                <p className="text-sm text-gray-600">{action.description}</p>
            </div>
            <svg className="w-5 h-5 text-gray-400 group-hover:text-primary transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
            </svg>
        </button>
    )
}

export default QuickActionBtn