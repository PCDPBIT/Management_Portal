import React, { useState, useEffect } from "react";
import MainLayout from "../../components/MainLayout";
import { API_BASE_URL } from "../../config";

const HODElectivePage = () => {
  const [selectedSemesterForView, setSelectedSemesterForView] = useState(4);
  const [batches, setBatches] = useState([]);
  const [selectedBatch, setSelectedBatch] = useState("");
  const [academicYear, setAcademicYear] = useState("2025-2026");
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [hodProfile, setHodProfile] = useState(null);
  const [saveMessage, setSaveMessage] = useState("");

  const semesters = [4, 5, 6, 7, 8]; // Only semesters with electives

  // Get user email from localStorage (set during login)
  const userEmail = localStorage.getItem("userEmail");

  // Available elective courses (left panel - course pool) - now from API
  const [availableElectives, setAvailableElectives] = useState([]);
  // Selected elective courses for students (right panel)
  const [selectedElectives, setSelectedElectives] = useState([]);

  // Fetch HOD profile on component mount
  useEffect(() => {
    fetchHODProfile();
    fetchAcademicCalendar();
    fetchBatches();
  }, []);

  // Fetch electives when semester or batch changes
  useEffect(() => {
    if (selectedBatch && academicYear) {
      fetchElectives();
    }
  }, [selectedSemesterForView, selectedBatch, academicYear]);

  const fetchHODProfile = async () => {
    try {
      const response = await fetch(
        `${API_BASE_URL}/hod/profile?email=${encodeURIComponent(userEmail)}`,
      );
      const data = await response.json();
      if (data.department) {
        setHodProfile(data);
      }
    } catch (error) {
      console.error("Error fetching HOD profile:", error);
    }
  };

  const fetchAcademicCalendar = async () => {
    try {
      const response = await fetch(`${API_BASE_URL}/academic-calendar/current`);
      const data = await response.json();
      if (data.academic_year) {
        setAcademicYear(data.academic_year);
      }
    } catch (error) {
      console.error("Error fetching academic calendar:", error);
    }
  };

  const fetchBatches = async () => {
    try {
      const response = await fetch(
        `${API_BASE_URL}/hod/batches?email=${encodeURIComponent(userEmail)}`,
      );
      const data = await response.json();
      if (data.batches && data.batches.length > 0) {
        setBatches(data.batches);
        setSelectedBatch(data.batches[0]); // Default to first batch
      }
    } catch (error) {
      console.error("Error fetching batches:", error);
    }
  };

  const fetchElectives = async () => {
    setLoading(true);
    try {
      const response = await fetch(
        `${API_BASE_URL}/hod/electives/available?email=${encodeURIComponent(userEmail)}&semester=${selectedSemesterForView}&batch=${encodeURIComponent(selectedBatch)}&academic_year=${encodeURIComponent(academicYear)}`,
      );
      const data = await response.json();

      if (data.available_electives) {
        // Group by category
        const grouped = data.available_electives.reduce((acc, course) => {
          const category = getCategoryFromCourseType(course.course_type);
          if (!acc[category]) acc[category] = [];
          acc[category].push(course);
          return acc;
        }, {});

        setAvailableElectives(grouped);

        // Set selected courses
        const selected = data.available_electives.filter((c) => c.is_selected);
        setSelectedElectives(selected);
      }
    } catch (error) {
      console.error("Error fetching electives:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleSave = async () => {
    setSaving(true);
    setSaveMessage("");

    try {
      const selectedCourseIds = selectedElectives.map((c) => c.id);

      const response = await fetch(
        `${API_BASE_URL}/hod/electives/save?email=${encodeURIComponent(userEmail)}`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            semester: selectedSemesterForView,
            batch: selectedBatch,
            academic_year: academicYear,
            selected_courses: selectedCourseIds,
            status: "ACTIVE",
          }),
        },
      );

      const data = await response.json();

      if (data.success) {
        setSaveMessage("✅ " + data.message);
        setTimeout(() => setSaveMessage(""), 3000);
      } else {
        setSaveMessage("❌ Error: " + data.message);
      }
    } catch (error) {
      console.error("Error saving selections:", error);
      setSaveMessage("❌ Error saving selections");
    } finally {
      setSaving(false);
    }
  };

  const getCategoryFromCourseType = (courseType) => {
    const type = courseType.toUpperCase();
    if (type.includes("OPEN") || type.includes("OE")) return "openElective";
    if (type.includes("PROFESSIONAL") || type.includes("PE"))
      return "professionalElective";
    if (type.includes("HONOR") || type.includes("HONOUR")) return "honor";
    if (type.includes("MINOR")) return "minor";
    return "professionalElective"; // Default
  };

  // Handle moving course from left to right
  const handleSelectCourse = (course) => {
    // Check if already selected
    const isAlreadySelected = selectedElectives.some((c) => c.id === course.id);

    if (!isAlreadySelected) {
      setSelectedElectives([...selectedElectives, course]);
    }
  };

  // Handle removing course from right panel
  const handleRemoveCourse = (courseId) => {
    setSelectedElectives(selectedElectives.filter((c) => c.id !== courseId));
  };

  // Check if a course is already selected
  const isCourseSelected = (courseId) => {
    return selectedElectives.some((c) => c.id === courseId);
  };

  // Get category color
  const getCategoryColor = (category) => {
    switch (category) {
      case "openElective":
        return {
          bg: "bg-blue-50",
          border: "border-blue-500",
          text: "text-blue-700",
          badge: "bg-blue-500",
        };
      case "professionalElective":
        return {
          bg: "bg-purple-50",
          border: "border-purple-500",
          text: "text-purple-700",
          badge: "bg-purple-500",
        };
      case "honor":
        return {
          bg: "bg-amber-50",
          border: "border-amber-500",
          text: "text-amber-700",
          badge: "bg-amber-500",
        };
      case "minor":
        return {
          bg: "bg-emerald-50",
          border: "border-emerald-500",
          text: "text-emerald-700",
          badge: "bg-emerald-500",
        };
      default:
        return {
          bg: "bg-gray-50",
          border: "border-gray-500",
          text: "text-gray-700",
          badge: "bg-gray-500",
        };
    }
  };

  // Get category display name
  const getCategoryDisplayName = (category) => {
    switch (category) {
      case "openElective":
        return "Open Elective";
      case "professionalElective":
        return "Professional Elective";
      case "honor":
        return "Honor";
      case "minor":
        return "Minor";
      default:
        return category;
    }
  };

  const handleAddCourse = () => {
    // Placeholder for future functionality
    console.log("Add course functionality");
  };

  return (
    <MainLayout
      title="Elective Course Selection"
      subtitle={
        hodProfile
          ? `${hodProfile.department.name} - Select electives for students`
          : "Select electives for students"
      }
    >
      {/* Split View - Elective Management */}
      <div>
        {/* Header with Semester Tabs and Batch Selector */}
        <div className="bg-white rounded-xl shadow-md p-6 mb-6">
          <div className="flex justify-between items-start mb-4">
            <div>
              <h2 className="text-xl font-bold text-gray-900 mb-2">
                Elective Course Management
              </h2>
              <p className="text-gray-600">
                Click on courses from the left panel to add them to student
                selections
              </p>
              {academicYear && (
                <p className="text-sm text-blue-600 mt-1">
                  Academic Year: {academicYear}
                </p>
              )}
            </div>

            {/* Batch Selector */}
            <div className="flex items-center gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Student Batch
                </label>
                <select
                  value={selectedBatch}
                  onChange={(e) => setSelectedBatch(e.target.value)}
                  className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                >
                  {batches.map((batch) => (
                    <option key={batch} value={batch}>
                      {batch}
                    </option>
                  ))}
                </select>
              </div>

              {/* Save Button */}
              <div className="pt-6">
                <button
                  onClick={handleSave}
                  disabled={saving || !selectedBatch}
                  className={`px-6 py-2 rounded-lg font-semibold transition-all ${
                    saving || !selectedBatch
                      ? "bg-gray-300 text-gray-500 cursor-not-allowed"
                      : "bg-green-600 hover:bg-green-700 text-white shadow-md hover:shadow-lg"
                  }`}
                >
                  {saving
                    ? "Saving..."
                    : `Save Selections (${selectedElectives.length})`}
                </button>
              </div>
            </div>
          </div>

          {/* Save Message */}
          {saveMessage && (
            <div
              className={`mt-3 p-3 rounded-lg ${saveMessage.includes("✅") ? "bg-green-50 text-green-700" : "bg-red-50 text-red-700"}`}
            >
              {saveMessage}
            </div>
          )}

          {/* Semester Tabs */}
          <div className="flex space-x-2 overflow-x-auto pb-2 mt-4">
            {semesters.map((sem) => (
              <button
                key={sem}
                onClick={() => setSelectedSemesterForView(sem)}
                className={`px-6 py-3 rounded-lg font-semibold whitespace-nowrap transition-all ${
                  selectedSemesterForView === sem
                    ? "bg-gradient-to-r from-blue-600 to-blue-700 text-white shadow-md"
                    : "bg-gray-100 text-gray-700 hover:bg-gray-200"
                }`}
              >
                Semester {sem}
              </button>
            ))}
          </div>
        </div>

        {/* Loading State */}
        {loading && (
          <div className="text-center py-12">
            <div className="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
            <p className="mt-4 text-gray-600">Loading electives...</p>
          </div>
        )}

        {/* Split View Container */}
        {!loading && (
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {/* LEFT PANEL - Available Electives */}
            <div className="space-y-6">
              <div className="bg-gradient-to-r from-blue-600 to-blue-700 rounded-xl shadow-md p-4">
                <h3 className="text-xl font-bold text-white flex items-center">
                  <svg
                    className="w-6 h-6 mr-2"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"
                    />
                  </svg>
                  Available Elective Courses
                </h3>
                <p className="text-blue-100 text-sm mt-1">
                  Click to add to student selections →
                </p>
              </div>

              {Object.entries(availableElectives).map(
                ([category, courses]) =>
                  courses.length > 0 && (
                    <div
                      key={category}
                      className="bg-white rounded-xl shadow-md overflow-hidden"
                    >
                      <div
                        className={`${getCategoryColor(category).badge} px-4 py-3 text-white`}
                      >
                        <h4 className="font-bold text-lg">
                          {getCategoryDisplayName(category)}
                        </h4>
                        <p className="text-sm opacity-90">
                          {courses.length} course
                          {courses.length !== 1 ? "s" : ""} available
                        </p>
                      </div>
                      <div className="p-4 space-y-3">
                        {courses.map((course) => {
                          const isSelected = isCourseSelected(course.id);
                          const colors = getCategoryColor(category);

                          return (
                            <div
                              key={course.id}
                              onClick={() =>
                                !isSelected && handleSelectCourse(course)
                              }
                              className={`${colors.bg} border-2 ${colors.border} rounded-lg p-4 transition-all ${
                                isSelected
                                  ? "opacity-50 cursor-not-allowed"
                                  : "cursor-pointer hover:shadow-lg hover:scale-[1.02]"
                              }`}
                            >
                              <div className="flex items-center justify-between">
                                <div className="flex-1">
                                  <div className="flex items-center space-x-2 mb-1">
                                    <span
                                      className={`font-bold ${colors.text}`}
                                    >
                                      {course.course_code}
                                    </span>
                                    <span
                                      className={`text-xs px-2 py-1 rounded-full ${colors.badge} text-white`}
                                    >
                                      {course.credit} Credits
                                    </span>
                                  </div>
                                  <p className="text-gray-700 font-medium">
                                    {course.course_name}
                                  </p>
                                </div>
                                {isSelected ? (
                                  <svg
                                    className="w-6 h-6 text-green-600 flex-shrink-0"
                                    fill="currentColor"
                                    viewBox="0 0 20 20"
                                  >
                                    <path
                                      fillRule="evenodd"
                                      d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                                      clipRule="evenodd"
                                    />
                                  </svg>
                                ) : (
                                  <svg
                                    className={`w-6 h-6 ${colors.text} flex-shrink-0`}
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
                                )}
                              </div>
                            </div>
                          );
                        })}
                      </div>
                    </div>
                  ),
              )}
            </div>

            {/* RIGHT PANEL - Selected Electives */}
            <div className="space-y-6">
              <div className="bg-gradient-to-r from-green-600 to-green-700 rounded-xl shadow-md p-4">
                <h3 className="text-xl font-bold text-white flex items-center">
                  <svg
                    className="w-6 h-6 mr-2"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                    />
                  </svg>
                  Selected for Students
                </h3>
                <p className="text-green-100 text-sm mt-1">
                  {selectedElectives.length} course
                  {selectedElectives.length !== 1 ? "s" : ""} selected
                </p>
              </div>

              {selectedElectives.length === 0 ? (
                <div className="bg-white rounded-xl shadow-md p-8 text-center">
                  <svg
                    className="w-16 h-16 mx-auto text-gray-300 mb-4"
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
                  <p className="text-gray-500 text-lg">
                    No courses selected yet
                  </p>
                  <p className="text-gray-400 text-sm mt-2">
                    Click on courses from the left panel to add them
                  </p>
                </div>
              ) : (
                <div className="space-y-3">
                  {selectedElectives.map((course) => {
                    const category = getCategoryFromCourseType(
                      course.course_type,
                    );
                    const colors = getCategoryColor(category);

                    return (
                      <div
                        key={course.id}
                        className={`bg-white border-2 ${colors.border} rounded-lg p-4`}
                      >
                        <div className="flex items-center justify-between">
                          <div className="flex-1">
                            <div className="flex items-center space-x-2 mb-1">
                              <span className={`font-bold ${colors.text}`}>
                                {course.course_code}
                              </span>
                              <span
                                className={`text-xs px-2 py-1 rounded-full ${colors.badge} text-white`}
                              >
                                {course.credit} Credits
                              </span>
                              <span className="text-xs px-2 py-1 rounded-full bg-gray-200 text-gray-700">
                                {getCategoryDisplayName(category)}
                              </span>
                            </div>
                            <p className="text-gray-700 font-medium">
                              {course.course_name}
                            </p>
                          </div>
                          <button
                            onClick={() => handleRemoveCourse(course.id)}
                            className="ml-4 p-2 text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                            title="Remove"
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
                                d="M6 18L18 6M6 6l12 12"
                              />
                            </svg>
                          </button>
                        </div>
                      </div>
                    );
                  })}
                </div>
              )}
            </div>
          </div>
        )}
      </div>
    </MainLayout>
  );
};

export default HODElectivePage;
