import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import MainLayout from "../../components/MainLayout";
import { API_BASE_URL } from "../../config";

function RegulationPage() {
  const navigate = useNavigate();
  const [regulations, setRegulations] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [showForm, setShowForm] = useState(false);
  const [formData, setFormData] = useState({
    code: "",
    name: "",
    status: "DRAFT",
  });

  // Fetch regulations from backend
  useEffect(() => {
    fetchRegulations();
  }, []);

  const fetchRegulations = async () => {
    try {
      setLoading(true);
      const response = await fetch("${API_BASE_URL}/regulations");
      if (!response.ok) {
        throw new Error("Failed to fetch regulations");
      }
      const data = await response.json();
      setRegulations(data || []);
      setError("");
    } catch (err) {
      console.error("Error fetching regulations:", err);
      setError("Failed to load regulations. Make sure the backend is running.");
      setRegulations([]);
    } finally {
      setLoading(false);
    }
  };

  const handleDownloadPDF = async (e, regulationId, regulationName) => {
    e.stopPropagation();
    try {
      const response = await fetch(
        `${API_BASE_URL}/regulation/${regulationId}/pdf`
      );
      if (!response.ok) {
        const errorText = await response.text();

        // Check if the error is about Chrome not being installed
        if (errorText.includes("Chrome") || errorText.includes("Chromium")) {
          const useHTML = window.confirm(
            "Chrome is required for PDF generation but is not installed.\n\n" +
              "Would you like to view the HTML preview instead?\n\n" +
              "(You can print it to PDF using your browser's print function)"
          );

          if (useHTML) {
            // Open HTML preview in new tab
            window.open(
              `${API_BASE_URL}/regulation/${regulationId}/pdf?preview=html`,
              "_blank"
            );
            return;
          }
        }

        throw new Error("Failed to generate PDF");
      }
      const blob = await response.blob();
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement("a");
      a.href = url;
      a.download = `${regulationName.replace(/\s+/g, "_")}.pdf`;
      document.body.appendChild(a);
      a.click();
      window.URL.revokeObjectURL(url);
      document.body.removeChild(a);
    } catch (err) {
      console.error("Error downloading PDF:", err);
      alert(
        "Failed to generate PDF. Please install Chrome: brew install --cask google-chrome"
      );
    }
  };

  const handleAddRegulation = async (e) => {
    e.preventDefault();

    if (!formData.code.trim() || !formData.name.trim()) {
      setError("Please fill in all required fields");
      return;
    }

    try {
      const response = await fetch("${API_BASE_URL}/regulations", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(formData),
      });

      if (!response.ok) {
        throw new Error("Failed to create regulation");
      }

      // Reset form and refresh list
      setFormData({ code: "", name: "", status: "DRAFT" });
      setShowForm(false);
      setError("");
      fetchRegulations();
    } catch (err) {
      console.error("Error creating regulation:", err);
      setError("Failed to create regulation");
    }
  };

  const handleDeleteRegulation = async (id) => {
    if (
      !window.confirm(
        "Are you sure you want to delete this regulation? This action cannot be undone."
      )
    ) {
      return;
    }

    try {
      const response = await fetch(
        `${API_BASE_URL}/regulations/${id}`,
        {
          method: "DELETE",
        }
      );

      if (!response.ok) {
        throw new Error("Failed to delete regulation");
      }

      setError("");
      fetchRegulations();
    } catch (err) {
      console.error("Error deleting regulation:", err);
      setError("Failed to delete regulation");
    }
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }));
  };

  return (
    <MainLayout
      title="Regulation Management"
      subtitle="Create and manage academic regulations and clauses"
    >
      <div className="space-y-6">
        {/* Action Bar */}
        <div className="flex justify-between items-center">
          <div className="flex items-center space-x-4">
            <button
              onClick={() => navigate("/dashboard")}
              className="px-4 py-2 text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-lg transition-colors duration-200 flex items-center space-x-2"
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
                  d="M10 19l-7-7m0 0l7-7m-7 7h18"
                />
              </svg>
              <span>Back to Dashboard</span>
            </button>
          </div>
          <button
            onClick={() => setShowForm(!showForm)}
            className="px-6 py-2.5 bg-blue-600 text-white font-medium rounded-lg shadow-sm hover:bg-blue-700 hover:shadow-md transition-all duration-200 flex items-center space-x-2"
          >
            {showForm ? (
              <>
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
                    d="M6 18L18 6M6 6l12 12"
                  />
                </svg>
                <span>Cancel</span>
              </>
            ) : (
              <>
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
                <span>New Regulation</span>
              </>
            )}
          </button>
        </div>

        {/* Error Message */}
        {error && (
          <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg flex items-start space-x-3">
            <svg
              className="w-5 h-5 text-red-500 mt-0.5"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
              />
            </svg>
            <span>{error}</span>
          </div>
        )}

        {/* Form */}
        {showForm && (
          <div className="card-custom p-6">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">
              Create New Regulation
            </h3>
            <form onSubmit={handleAddRegulation} className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Regulation Code <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="code"
                    value={formData.code}
                    onChange={handleInputChange}
                    placeholder="e.g., R2022"
                    required
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Regulation Name <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="name"
                    value={formData.name}
                    onChange={handleInputChange}
                    placeholder="e.g., Academic Regulations 2022"
                    required
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  />
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Status
                </label>
                <select
                  name="status"
                  value={formData.status}
                  onChange={handleInputChange}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                >
                  <option value="DRAFT">Draft</option>
                  <option value="PUBLISHED">Published</option>
                  <option value="LOCKED">Locked</option>
                </select>
              </div>

              <div className="flex justify-end space-x-3 pt-2">
                <button
                  type="button"
                  onClick={() => {
                    setShowForm(false);
                    setFormData({ code: "", name: "", status: "DRAFT" });
                  }}
                  className="px-5 py-2 text-gray-700 bg-gray-100 rounded-lg hover:bg-gray-200 transition-colors duration-200"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-5 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors duration-200"
                >
                  Create Regulation
                </button>
              </div>
            </form>
          </div>
        )}

        {/* Loading State */}
        {loading ? (
          <div className="card-custom p-12">
            <div className="flex flex-col items-center justify-center space-y-4">
              <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
              <p className="text-gray-600">Loading regulations...</p>
            </div>
          </div>
        ) : regulations.length === 0 ? (
          <div className="card-custom p-12">
            <div className="text-center">
              <svg
                className="mx-auto h-12 w-12 text-gray-400"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                />
              </svg>
              <h3 className="mt-4 text-lg font-medium text-gray-900">
                No regulations found
              </h3>
              <p className="mt-2 text-sm text-gray-500">
                Get started by creating a new regulation.
              </p>
              <button
                onClick={() => setShowForm(true)}
                className="mt-6 px-6 py-2.5 bg-blue-600 text-white font-medium rounded-lg hover:bg-blue-700 transition-colors duration-200"
              >
                Create Your First Regulation
              </button>
            </div>
          </div>
        ) : (
          /* Regulations Table */
          <div className="card-custom overflow-hidden">
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th
                      scope="col"
                      className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                    >
                      Code
                    </th>
                    <th
                      scope="col"
                      className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                    >
                      Regulation Name
                    </th>
                    <th
                      scope="col"
                      className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                    >
                      Status
                    </th>
                    <th
                      scope="col"
                      className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                    >
                      Created
                    </th>
                    <th
                      scope="col"
                      className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider"
                    >
                      Actions
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {regulations.map((reg) => (
                    <tr
                      key={reg.id}
                      className="hover:bg-gray-50 transition-colors duration-150"
                    >
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="text-sm font-medium text-gray-900">
                          {reg.code}
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <div className="text-sm text-gray-900">{reg.name}</div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span
                          className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                            reg.status === "PUBLISHED"
                              ? "bg-green-100 text-green-800"
                              : reg.status === "LOCKED"
                              ? "bg-gray-100 text-gray-800"
                              : "bg-yellow-100 text-yellow-800"
                          }`}
                        >
                          {reg.status}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {reg.created_at
                          ? new Date(reg.created_at).toLocaleDateString()
                          : "-"}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                        <div className="flex items-center justify-end space-x-3">
                          <button
                            onClick={() =>
                              navigate(`/regulation/${reg.id}/editor`)
                            }
                            className="text-blue-600 hover:text-blue-900 transition-colors duration-200"
                            title="Edit regulation"
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
                                d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
                              />
                            </svg>
                          </button>
                          <button
                            onClick={(e) =>
                              handleDownloadPDF(e, reg.id, reg.name)
                            }
                            className="text-green-600 hover:text-green-900 transition-colors duration-200"
                            title="Download PDF"
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
                                d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                              />
                            </svg>
                          </button>
                          <button
                            onClick={() => handleDeleteRegulation(reg.id)}
                            className="text-red-600 hover:text-red-900 transition-colors duration-200"
                            title="Delete regulation"
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
                                d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
                              />
                            </svg>
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}
      </div>
    </MainLayout>
  );
}

export default RegulationPage;
