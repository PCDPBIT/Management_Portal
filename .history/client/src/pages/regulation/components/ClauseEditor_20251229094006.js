import React, { useState, useEffect } from 'react'
import { CKEditor } from '@ckeditor/ckeditor5-react'
import ClassicEditor from '@ckeditor/ckeditor5-build-classic'

function ClauseEditor({ clause, isEditing, onEdit, onSave, onCancel, onDelete, canEdit }) {
  const [editedClause, setEditedClause] = useState(null)

  useEffect(() => {
    if (clause) {
      setEditedClause({ ...clause })
    }
  }, [clause])

  if (!clause) {
    return (
      <div className="card-custom p-12 h-[calc(100vh-250px)] flex items-center justify-center">
        <div className="text-center text-gray-500">
          <svg className="mx-auto h-16 w-16 text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
          <p className="text-lg font-medium">No Clause Selected</p>
          <p className="text-sm mt-2">Select a clause from the left panel to view or edit</p>
        </div>
      </div>
    )
  }

  const handleSave = () => {
    onSave(editedClause)
  }

  const handleCancel = () => {
    setEditedClause({ ...clause })
    onCancel()
  }

  const editorConfiguration = {
    toolbar: [
      'heading',
      '|',
      'bold',
      'italic',
      'underline',
      '|',
      'bulletedList',
      'numberedList',
      '|',
      'insertTable',
      '|',
      'undo',
      'redo'
    ],
    heading: {
      options: [
        { model: 'paragraph', title: 'Paragraph', class: 'ck-heading_paragraph' },
        { model: 'heading4', view: 'h4', title: 'Heading 4', class: 'ck-heading_heading4' },
        { model: 'heading5', view: 'h5', title: 'Heading 5', class: 'ck-heading_heading5' }
      ]
    },
    table: {
      contentToolbar: ['tableColumn', 'tableRow', 'mergeTableCells']
    },
    // Disable features we don't want
    removePlugins: ['ImageUpload', 'MediaEmbed'],
  }

  return (
    <div className="card-custom h-[calc(100vh-250px)] flex flex-col">
      {/* Clause Header */}
      <div className="flex items-center justify-between p-4 border-b border-gray-200">
        <div>
          <div className="flex items-center space-x-3">
            <span className="px-3 py-1 bg-gray-100 text-gray-700 rounded font-mono text-sm">
              {clause.clause_no}
            </span>
            <h2 className="text-lg font-semibold text-gray-900">{clause.title}</h2>
          </div>
          <p className="text-xs text-gray-500 mt-1">
            Section {clause.section_no} • Last updated: {new Date(clause.updated_at).toLocaleDateString()}
          </p>
        </div>

        {canEdit && (
          <div className="flex items-center space-x-2">
            {!isEditing ? (
              <>
                <button
                  onClick={onEdit}
                  className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors flex items-center space-x-2"
                >
                  <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                  </svg>
                  <span>Edit</span>
                </button>
                <button
                  onClick={() => onDelete(clause.id)}
                  className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors flex items-center space-x-2"
                >
                  <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                  </svg>
                  <span>Delete</span>
                </button>
              </>
            ) : (
              <>
                <button
                  onClick={handleSave}
                  className="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors flex items-center space-x-2"
                >
                  <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                  </svg>
                  <span>Save</span>
                </button>
                <button
                  onClick={handleCancel}
                  className="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors flex items-center space-x-2"
                >
                  <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                  </svg>
                  <span>Cancel</span>
                </button>
              </>
            )}
          </div>
        )}
      </div>

      {/* Clause Content */}
      <div className="flex-1 overflow-y-auto p-6">
        {isEditing && editedClause ? (
          <div className="space-y-4">
            {/* Title Edit */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Clause Title
              </label>
              <input
                type="text"
                value={editedClause.title}
                onChange={(e) => setEditedClause({ ...editedClause, title: e.target.value })}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>

            {/* Content Edit with CKEditor */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Clause Content
              </label>
              <div className="border border-gray-300 rounded-lg overflow-hidden">
                <CKEditor
                  editor={ClassicEditor}
                  data={editedClause.content}
                  config={editorConfiguration}
                  onChange={(event, editor) => {
                    const data = editor.getData()
                    setEditedClause({ ...editedClause, content: data })
                  }}
                />
              </div>
              <p className="text-xs text-gray-500 mt-2">
                Use the toolbar to format text. Only approved formatting options are available.
              </p>
            </div>
          </div>
        ) : (
          /* View Mode */
          <div className="prose max-w-none">
            <div 
              className="text-gray-700 leading-relaxed"
              dangerouslySetInnerHTML={{ __html: clause.content }}
            />
          </div>
        )}
      </div>

      {/* Footer Info */}
      <div className="p-4 border-t border-gray-200 bg-gray-50">
        <div className="flex items-center justify-between text-xs text-gray-600">
          <span>Clause ID: {clause.id}</span>
          <button className="text-blue-600 hover:text-blue-800 flex items-center space-x-1">
            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <span>View History</span>
          </button>
        </div>
      </div>
    </div>
  )
}

export default ClauseEditor
