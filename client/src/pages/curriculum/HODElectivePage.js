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

  // Available elective courses (vertical courses from API)
  const [availableElectives, setAvailableElectives] = useState([]);
  // Course assignments: { courseId: semester }
  const [courseAssignments, setCourseAssignments] = useState({});

  // Fetch HOD profile on component mount
  useEffect(() => {
    fetchHODProfile();
    fetchAcademicCalendar();
    fetchBatches();
  }, []);

  // Fetch electives when batch or academic year changes
  useEffect(() => {
    if (selectedBatch && academicYear) {
      fetchElectives();
    }
  }, [selectedBatch, academicYear]);

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
      // Fetch all vertical courses (no semester filter)
      const response = await fetch(
        `${API_BASE_URL}/hod/electives/available?email=${encodeURIComponent(userEmail)}&batch=${encodeURIComponent(selectedBatch)}&academic_year=${encodeURIComponent(academicYear)}`,
      );
      const data = await response.json();

      if (data.available_electives) {
        setAvailableElectives(data.available_electives);

        // Populate course assignments from assigned_semester
        const assignments = {};
        data.available_electives.forEach((course) => {
          if (course.assigned_semester) {
            assignments[course.id] = course.assigned_semester;
          }
        });
        setCourseAssignments(assignments);
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
      // Convert courseAssignments object to array format
      const course_assignments = Object.entries(courseAssignments).map(
        ([courseId, semester]) => ({
          course_id: parseInt(courseId),
          semester: semester,
        }),
      );

      if (course_assignments.length === 0) {
        setSaveMessage("⚠️ Please assign at least one course to a semester");
        setSaving(false);
        return;
      }

      const response = await fetch(
        `${API_BASE_URL}/hod/electives/save?email=${encodeURIComponent(userEmail)}`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            batch: selectedBatch,
            academic_year: academicYear,
            course_assignments: course_assignments,
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

  // Handle semester assignment for a course
  const handleSemesterAssignment = (courseId, semester) => {
    if (semester === "" || semester === null) {
      // Remove assignment
      const newAssignments = { ...courseAssignments };
      delete newAssignments[courseId];
      setCourseAssignments(newAssignments);
    } else {
      setCourseAssignments({
        ...courseAssignments,
        [courseId]: parseInt(semester),
      });
    }
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
        {/* Header with Batch Selector */}
        <div className="bg-white rounded-xl shadow-md p-6 mb-6">
          <div className="flex justify-between items-start mb-4">
            <div>
              <h2 className="text-xl font-bold text-gray-900 mb-2">
                Vertical Course Assignment
              </h2>
              <p className="text-gray-600">
                Assign vertical courses to semesters (4-8)
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
                    : `Save Assignments (${Object.keys(courseAssignments).length})`}
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
        </div>

        {/* Loading State */}
        {loading && (
          <div className="text-center py-12">
            <div className="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
            <p className="mt-4 text-gray-600">Loading vertical courses...</p>
          </div>
        )}

        {/* Course List with Semester Assignment */}
        {!loading && (
          <div className="bg-white rounded-xl shadow-md overflow-hidden">
            <div className="bg-gradient-to-r from-blue-600 to-blue-700 px-6 py-4 text-white">
              <h3 className="text-xl font-bold">Vertical Elective Courses</h3>
              <p className="text-sm opacity-90 mt-1">
                {availableElectives.length} course
                {availableElectives.length !== 1 ? "s" : ""} available
              </p>
            </div>

            {availableElectives.length === 0 ? (
              <div className="p-8 text-center">
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
                  No vertical courses found
                </p>
                <p className="text-gray-400 text-sm mt-2">
                  Please check if vertical cards exist in the curriculum
                </p>
              </div>
            ) : (
              <div className="p-6">
                <div className="overflow-x-auto">
                  <table className="w-full">
                    <thead>
                      <tr className="border-b-2 border-gray-200">
                        <th className="text-left py-3 px-4 text-gray-700 font-semibold">
                          Course Code
                        </th>
                        <th className="text-left py-3 px-4 text-gray-700 font-semibold">
                          Course Name
                        </th>
                        <th className="text-left py-3 px-4 text-gray-700 font-semibold">
                          Type
                        </th>
                        <th className="text-center py-3 px-4 text-gray-700 font-semibold">
                          Credits
                        </th>
                        <th className="text-left py-3 px-4 text-gray-700 font-semibold">
                          Assign to Semester
                        </th>
                      </tr>
                    </thead>
                    <tbody>
                      {availableElectives.map((course) => {
                        const category = getCategoryFromCourseType(
                          course.course_type,
                        );
                        const colors = getCategoryColor(category);
                        const assignedSem = courseAssignments[course.id] || "";

                        return (
                          <tr
                            key={course.id}
                            className="border-b border-gray-100 hover:bg-gray-50"
                          >
                            <td className="py-4 px-4">
                              <span className={`font-bold ${colors.text}`}>
                                {course.course_code}
                              </span>
                            </td>
                            <td className="py-4 px-4">
                              <span className="text-gray-700 font-medium">
                                {course.course_name}
                              </span>
                            </td>
                            <td className="py-4 px-4">
                              <span
                                className={`text-xs px-3 py-1 rounded-full ${colors.badge} text-white`}
                              >
                                {getCategoryDisplayName(category)}
                              </span>
                            </td>
                            <td className="py-4 px-4 text-center">
                              <span className="text-gray-700">
                                {course.credit}
                              </span>
                            </td>
                            <td className="py-4 px-4">
                              <select
                                value={assignedSem}
                                onChange={(e) =>
                                  handleSemesterAssignment(
                                    course.id,
                                    e.target.value,
                                  )
                                }
                                className={`px-4 py-2 border-2 rounded-lg focus:ring-2 focus:ring-blue-500 ${
                                  assignedSem
                                    ? "border-green-500 bg-green-50"
                                    : "border-gray-300"
                                }`}
                              >
                                <option value="">Not Assigned</option>
                                <option value="4">Semester 4</option>
                                <option value="5">Semester 5</option>
                                <option value="6">Semester 6</option>
                                <option value="7">Semester 7</option>
                                <option value="8">Semester 8</option>
                              </select>
                            </td>
                          </tr>
                        );
                      })}
                    </tbody>
                  </table>
                </div>
              </div>
            )}
          </div>
        )}
      </div>
    </MainLayout>
  );
};

export default HODElectivePage;
