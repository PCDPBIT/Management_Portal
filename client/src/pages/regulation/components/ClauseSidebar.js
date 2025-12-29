import React, { useState } from "react";

function ClauseSidebar({
  structure,
  selectedClause,
  onClauseSelect,
  onSectionAdd,
  onClauseAdd,
  canEdit,
}) {
  const [showSectionForm, setShowSectionForm] = useState(false);
  const [showClauseForm, setShowClauseForm] = useState(null); // sectionId when showing form
  const [newSection, setNewSection] = useState({ section_no: "", title: "" });
  const [newClause, setNewClause] = useState({
    clause_no: "",
    title: "",
    content: "",
  });
  const [expandedSections, setExpandedSections] = useState(new Set());

  const toggleSection = (sectionId) => {
    const newExpanded = new Set(expandedSections);
    if (newExpanded.has(sectionId)) {
      newExpanded.delete(sectionId);
    } else {
      newExpanded.add(sectionId);
    }
    setExpandedSections(newExpanded);
  };

  const handleSectionSubmit = (e) => {
    e.preventDefault();
    onSectionAdd(newSection);
    setNewSection({ section_no: "", title: "" });
    setShowSectionForm(false);
  };

  const handleClauseSubmit = (e, sectionId) => {
    e.preventDefault();
    onClauseAdd(sectionId, newClause);
    setNewClause({
      clause_no: "",
      title: "",
      content: "<p>Clause content...</p>",
    });
    setShowClauseForm(null);
  };

  return (
    <div className="card-custom p-4 h-[calc(100vh-250px)] overflow-y-auto">
      <div className="flex items-center justify-between mb-4">
        <h3 className="text-sm font-semibold text-gray-900 uppercase tracking-wide">
          Structure
        </h3>
        {canEdit && (
          <button
            onClick={() => setShowSectionForm(!showSectionForm)}
            className="p-1 text-blue-600 hover:bg-blue-50 rounded transition-colors"
            title="Add Section"
          >
            <svg
              className="w-5 h-5"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M12 4v16m8-8H4"
              />
            </svg>
          </button>
        )}
      </div>

      {/* Add Section Form */}
      {showSectionForm && (
        <form
          onSubmit={handleSectionSubmit}
          className="mb-4 p-3 bg-blue-50 rounded-lg space-y-2"
        >
          <input
            type="number"
            placeholder="Section No. (e.g., 1)"
            value={newSection.section_no}
            onChange={(e) =>
              setNewSection({
                ...newSection,
                section_no: parseInt(e.target.value),
              })
            }
            required
            className="w-full px-2 py-1 text-sm border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <input
            type="text"
            placeholder="Section Title"
            value={newSection.title}
            onChange={(e) =>
              setNewSection({ ...newSection, title: e.target.value })
            }
            required
            className="w-full px-2 py-1 text-sm border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <div className="flex space-x-2">
            <button
              type="submit"
              className="flex-1 px-2 py-1 text-xs bg-blue-600 text-white rounded hover:bg-blue-700"
            >
              Add
            </button>
            <button
              type="button"
              onClick={() => setShowSectionForm(false)}
              className="flex-1 px-2 py-1 text-xs bg-gray-200 text-gray-700 rounded hover:bg-gray-300"
            >
              Cancel
            </button>
          </div>
        </form>
      )}

      {/* Sections and Clauses Tree */}
      <div className="space-y-2">
        {structure && structure.length > 0 ? (
          structure.map((section) => (
            <div
              key={section.id}
              className="border border-gray-200 rounded-lg overflow-hidden"
            >
              {/* Section Header */}
              <div
                className="flex items-center justify-between bg-gray-50 px-3 py-2 cursor-pointer hover:bg-gray-100"
                onClick={() => toggleSection(section.id)}
              >
                <div className="flex items-center space-x-2 flex-1">
                  <svg
                    className={`w-4 h-4 text-gray-500 transition-transform ${
                      expandedSections.has(section.id)
                        ? "transform rotate-90"
                        : ""
                    }`}
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M9 5l7 7-7 7"
                    />
                  </svg>
                  <span className="text-sm font-semibold text-gray-700">
                    Section {section.section_no}
                  </span>
                </div>
                {canEdit && (
                  <button
                    onClick={(e) => {
                      e.stopPropagation();
                      setShowClauseForm(
                        showClauseForm === section.id ? null : section.id
                      );
                    }}
                    className="p-1 text-green-600 hover:bg-green-50 rounded"
                    title="Add Clause"
                  >
                    <svg
                      className="w-4 h-4"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth={2}
                        d="M12 4v16m8-8H4"
                      />
                    </svg>
                  </button>
                )}
              </div>

              {/* Section Title */}
              {expandedSections.has(section.id) && (
                <div className="px-3 py-1 text-xs text-gray-600 bg-gray-50 border-t border-gray-200">
                  {section.title}
                </div>
              )}

              {/* Add Clause Form */}
              {showClauseForm === section.id && (
                <form
                  onSubmit={(e) => handleClauseSubmit(e, section.id)}
                  className="p-3 bg-green-50 border-t border-gray-200 space-y-2"
                  onClick={(e) => e.stopPropagation()}
                >
                  <input
                    type="text"
                    placeholder="Clause No. (e.g., 1.1)"
                    value={newClause.clause_no}
                    onChange={(e) =>
                      setNewClause({ ...newClause, clause_no: e.target.value })
                    }
                    required
                    className="w-full px-2 py-1 text-sm border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-green-500"
                  />
                  <input
                    type="text"
                    placeholder="Clause Title"
                    value={newClause.title}
                    onChange={(e) =>
                      setNewClause({ ...newClause, title: e.target.value })
                    }
                    required
                    className="w-full px-2 py-1 text-sm border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-green-500"
                  />
                  <div className="flex space-x-2">
                    <button
                      type="submit"
                      className="flex-1 px-2 py-1 text-xs bg-green-600 text-white rounded hover:bg-green-700"
                    >
                      Add Clause
                    </button>
                    <button
                      type="button"
                      onClick={() => setShowClauseForm(null)}
                      className="flex-1 px-2 py-1 text-xs bg-gray-200 text-gray-700 rounded hover:bg-gray-300"
                    >
                      Cancel
                    </button>
                  </div>
                </form>
              )}

              {/* Clauses List */}
              {expandedSections.has(section.id) &&
                section.clauses &&
                section.clauses.length > 0 && (
                  <div className="bg-white">
                    {section.clauses.map((clause) => (
                      <div
                        key={clause.id}
                        onClick={() => onClauseSelect(clause)}
                        className={`px-4 py-2 cursor-pointer border-t border-gray-200 hover:bg-blue-50 transition-colors ${
                          selectedClause?.id === clause.id
                            ? "bg-blue-100 border-l-4 border-l-blue-600"
                            : ""
                        }`}
                      >
                        <div className="flex items-start space-x-2">
                          <span className="text-xs font-mono text-gray-500 mt-0.5">
                            {clause.clause_no}
                          </span>
                          <span className="text-sm text-gray-700 flex-1 line-clamp-2">
                            {clause.title}
                          </span>
                        </div>
                      </div>
                    ))}
                  </div>
                )}

              {/* Empty State */}
              {expandedSections.has(section.id) &&
                (!section.clauses || section.clauses.length === 0) && (
                  <div className="px-4 py-3 text-xs text-gray-500 text-center bg-white border-t border-gray-200">
                    No clauses yet. Click + to add one.
                  </div>
                )}
            </div>
          ))
        ) : (
          <div className="text-center py-8 text-gray-500 text-sm">
            <p>No sections yet.</p>
            {canEdit && (
              <p className="text-xs mt-1">Click + to add a section.</p>
            )}
          </div>
        )}
      </div>
    </div>
  );
}

export default ClauseSidebar;
