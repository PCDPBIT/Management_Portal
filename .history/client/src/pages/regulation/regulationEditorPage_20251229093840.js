import React, { useState, useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import MainLayout from '../../components/MainLayout'
import ClauseSidebar from './components/ClauseSidebar'
import ClauseEditor from './components/ClauseEditor'

function RegulationEditorPage() {
  const { id } = useParams()
  const navigate = useNavigate()
  
  const [regulation, setRegulation] = useState(null)
  const [structure, setStructure] = useState(null)
  const [selectedClause, setSelectedClause] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [isEditing, setIsEditing] = useState(false)

  useEffect(() => {
    fetchRegulationStructure()
  }, [id])

  const fetchRegulationStructure = async () => {
    try {
      setLoading(true)
      const response = await fetch(`http://localhost:8080/api/regulations/${id}/structure`)
      if (!response.ok) {
        throw new Error('Failed to fetch regulation structure')
      }
      const data = await response.json()
      setRegulation(data.regulation)
      setStructure(data.sections)
      setError('')
    } catch (err) {
      console.error('Error fetching regulation:', err)
      setError('Failed to load regulation. Please try again.')
    } finally {
      setLoading(false)
    }
  }

  const handleClauseSelect = (clause) => {
    if (regulation?.status === 'LOCKED') {
      setError('Cannot edit LOCKED regulation')
      return
    }
    setSelectedClause(clause)
    setIsEditing(false)
  }

  const handleClauseSave = async (updatedClause) => {
    try {
      const response = await fetch(
        `http://localhost:8080/api/regulations/clauses/${updatedClause.id}`,
        {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(updatedClause),
        }
      )

      if (!response.ok) {
        throw new Error('Failed to save clause')
      }

      // Refresh the structure
      await fetchRegulationStructure()
      setIsEditing(false)
      setError('')
    } catch (err) {
      setError('Failed to save clause. Please try again.')
    }
  }

  const handleSectionAdd = async (sectionData) => {
    try {
      const response = await fetch(
        `http://localhost:8080/api/regulations/${id}/sections`,
        {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(sectionData),
        }
      )

      if (!response.ok) {
        throw new Error('Failed to create section')
      }

      await fetchRegulationStructure()
      setError('')
    } catch (err) {
      setError('Failed to create section. Please try again.')
    }
  }

  const handleClauseAdd = async (sectionId, clauseData) => {
    try {
      const response = await fetch(
        `http://localhost:8080/api/regulations/sections/${sectionId}/clauses`,
        {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(clauseData),
        }
      )

      if (!response.ok) {
        throw new Error('Failed to create clause')
      }

      await fetchRegulationStructure()
      setError('')
    } catch (err) {
      setError('Failed to create clause. Please try again.')
    }
  }

  const handleClauseDelete = async (clauseId) => {
    if (!window.confirm('Are you sure you want to delete this clause?')) {
      return
    }

    try {
      const response = await fetch(
        `http://localhost:8080/api/regulations/clauses/${clauseId}`,
        {
          method: 'DELETE',
        }
      )

      if (!response.ok) {
        throw new Error('Failed to delete clause')
      }

      await fetchRegulationStructure()
      setSelectedClause(null)
      setError('')
    } catch (err) {
      setError('Failed to delete clause. Please try again.')
    }
  }

  if (loading) {
    return (
      <MainLayout title="Loading..." subtitle="Please wait">
        <div className="flex items-center justify-center h-64">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
        </div>
      </MainLayout>
    )
  }

  const isLocked = regulation?.status === 'LOCKED'
  const isPublished = regulation?.status === 'PUBLISHED'
  const canEdit = regulation?.status === 'DRAFT'

  return (
    <MainLayout
      title={`Edit Regulation: ${regulation?.code || ''}`}
      subtitle={regulation?.name || ''}
    >
      <div className="space-y-4">
        {/* Header Actions */}
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-4">
            <button
              onClick={() => navigate('/regulations')}
              className="px-4 py-2 text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-lg transition-colors duration-200 flex items-center space-x-2"
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 19l-7-7m0 0l7-7m-7 7h18" />
              </svg>
              <span>Back to Regulations</span>
            </button>

            <span className={`inline-flex px-3 py-1 text-sm font-semibold rounded-full ${
              regulation?.status === 'PUBLISHED' 
                ? 'bg-green-100 text-green-800' 
                : regulation?.status === 'LOCKED'
                ? 'bg-gray-100 text-gray-800'
                : 'bg-yellow-100 text-yellow-800'
            }`}>
              {regulation?.status}
            </span>
          </div>

          {isLocked && (
            <div className="flex items-center space-x-2 text-red-600">
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
              </svg>
              <span className="font-medium">Regulation is locked - Read only</span>
            </div>
          )}
        </div>

        {/* Error Message */}
        {error && (
          <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg">
            {error}
          </div>
        )}

        {/* Editor Layout */}
        <div className="grid grid-cols-12 gap-6">
          {/* Left Panel - Clause Tree */}
          <div className="col-span-3">
            <ClauseSidebar
              structure={structure}
              selectedClause={selectedClause}
              onClauseSelect={handleClauseSelect}
              onSectionAdd={handleSectionAdd}
              onClauseAdd={handleClauseAdd}
              canEdit={canEdit}
            />
          </div>

          {/* Right Panel - Clause Editor */}
          <div className="col-span-9">
            <ClauseEditor
              clause={selectedClause}
              isEditing={isEditing}
              onEdit={() => setIsEditing(true)}
              onSave={handleClauseSave}
              onCancel={() => setIsEditing(false)}
              onDelete={handleClauseDelete}
              canEdit={canEdit}
            />
          </div>
        </div>
      </div>
    </MainLayout>
  )
}

export default RegulationEditorPage
