import React, { useState, useEffect } from "react";
import MainLayout from "../../components/MainLayout";
import { API_BASE_URL } from "../../config";

const HODElectivePage = () => {
  const [batches, setBatches] = useState([]);
  const [selectedBatch, setSelectedBatch] = useState("ALL");
  const [academicYear, setAcademicYear] = useState("2025-2026");
  const [currentSemester, setCurrentSemester] = useState(null);
  const [targetSemester, setTargetSemester] = useState(null);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [hodProfile, setHodProfile] = useState(null);
  const [saveMessage, setSaveMessage] = useState("");

  // Get user email from localStorage (set during login)
  const userEmail = localStorage.getItem("userEmail");

  // Available elective courses (vertical courses from API)
  const [availableElectives, setAvailableElectives] = useState([]);
  // Course assignments for target semester: { courseId: { slot_id } }
  const [courseAssignments, setCourseAssignments] = useState({});
  // Elective slots per semester
  const [semesterSlots, setSemesterSlots] = useState([]);

  // Fetch HOD profile on component mount
  useEffect(() => {
    fetchHODProfile();
    fetchAcademicCalendar();
    fetchBatches();
    fetchElectiveSlots();
  }, []);

  // Fetch electives when batch, academic year, or target semester changes
  useEffect(() => {
    if (academicYear && targetSemester) {
      fetchElectives();
    }
  }, [selectedBatch, academicYear, targetSemester]);

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
      if (data.current_semester) {
        const nextSemester = Math.min(
          parseInt(data.current_semester, 10) + 1,
          8,
        );
        setCurrentSemester(parseInt(data.current_semester, 10));
        setTargetSemester(nextSemester);
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
        setBatches(["ALL", ...data.batches]);
      } else {
        setBatches(["ALL"]);
      }
      setSelectedBatch("ALL");
    } catch (error) {
      console.error("Error fetching batches:", error);
    }
  };

  const fetchElectives = async () => {
    setLoading(true);
    try {
      const batchParam = selectedBatch === "ALL" ? "" : selectedBatch;
      const response = await fetch(
        `${API_BASE_URL}/hod/electives/available?email=${encodeURIComponent(userEmail)}&batch=${encodeURIComponent(batchParam)}&academic_year=${encodeURIComponent(academicYear)}`,
      );
      const data = await response.json();

      if (data.available_electives) {
        setAvailableElectives(data.available_electives);

        const assignments = {};
        data.available_electives.forEach((course) => {
          if (course.assigned_semester === targetSemester) {
            assignments[course.id] = {
              slot_id: course.assigned_slot_id || 0,
            };
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

  const fetchElectiveSlots = async () => {
    try {
      const response = await fetch(`${API_BASE_URL}/hod/elective-slots`);
      const data = await response.json();
      if (data.success && data.slots) {
        setSemesterSlots(data.slots);
      }
    } catch (error) {
      console.error("Error fetching elective slots:", error);
    }
  };

  const handleSave = async () => {
    setSaving(true);
    setSaveMessage("");

    try {
      const course_assignments = Object.entries(courseAssignments).map(
        ([courseId, assignment]) => ({
          course_id: parseInt(courseId, 10),
          semester: targetSemester,
          slot_id: assignment.slot_id,
        }),
      );

      const missingSlots = course_assignments.some(
        (assignment) => !assignment.slot_id,
      );
      if (missingSlots) {
        setSaveMessage(
          "⚠️ Please select a category slot for each assigned course",
        );
        setSaving(false);
        return;
      }

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
            batch: selectedBatch === "ALL" ? "" : selectedBatch,
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

  const handleAddCourseToSlot = (courseId, slotId) => {
    setCourseAssignments({
      ...courseAssignments,
      [courseId]: {
        slot_id: parseInt(slotId, 10) || 0,
      },
    });
  };

  const handleRemoveCourse = (courseId) => {
    const next = { ...courseAssignments };
    delete next[courseId];
    setCourseAssignments(next);
  };

  const getSlotsForSemester = (semester) => {
    if (!semester) return [];
    return semesterSlots.filter((slot) => slot.semester === semester);
  };

  const targetSlots = targetSemester
    ? semesterSlots.filter((slot) => slot.semester === targetSemester)
    : [];
  const selectedCourseIds = new Set(
    Object.keys(courseAssignments).map((id) => parseInt(id, 10)),
  );
  const unselectedCourses = availableElectives.filter(
    (course) => !selectedCourseIds.has(course.id),
  );

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
                Assign vertical courses for Semester {targetSemester || "-"}
              </p>
              {academicYear && (
                <p className="text-sm text-blue-600 mt-1">
                  Academic Year: {academicYear}
                </p>
              )}
              {currentSemester && (
                <p className="text-sm text-gray-600 mt-1">
                  Current Semester: {currentSemester} → Assigning for Semester{" "}
                  {targetSemester}
                </p>
              )}
              {hodProfile?.curriculum && (
                <p className="text-sm text-gray-600 mt-1">
                  Curriculum: {hodProfile.curriculum.name} (
                  {hodProfile.curriculum.academic_year})
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

        {/* Split Selection Panels */}
        {!loading && (
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <div className="bg-white rounded-xl shadow-md overflow-hidden">
              <div className="bg-gradient-to-r from-blue-600 to-blue-700 px-6 py-4 text-white">
                <h3 className="text-xl font-bold">
                  Semester {targetSemester} Elective Slots
                </h3>
                <p className="text-sm opacity-90 mt-1">
                  Click a course to add to the slot
                </p>
              </div>

              <div className="p-6 space-y-6">
                {targetSlots.length === 0 ? (
                  <div className="text-center text-gray-500">
                    No slots configured for Semester {targetSemester}
                  </div>
                ) : (
                  targetSlots.map((slot) => (
                    <div key={slot.id} className="border rounded-lg p-4">
                      <div className="flex items-center justify-between mb-3">
                        <h4 className="font-semibold text-gray-900">
                          {slot.slot_name}
                        </h4>
                        <span className="text-xs text-gray-500">
                          {unselectedCourses.length} available
                        </span>
                      </div>
                      {unselectedCourses.length === 0 ? (
                        <p className="text-sm text-gray-500">
                          No available courses to add.
                        </p>
                      ) : (
                        <div className="space-y-2 max-h-72 overflow-y-auto">
                          {unselectedCourses.map((course) => (
                            <button
                              key={`${slot.id}-${course.id}`}
                              type="button"
                              onClick={() =>
                                handleAddCourseToSlot(course.id, slot.id)
                              }
                              className="w-full text-left px-3 py-2 rounded-lg border hover:border-blue-500 hover:bg-blue-50 transition"
                            >
                              <div className="flex items-center justify-between">
                                <div>
                                  <div className="font-medium text-gray-900">
                                    {course.course_code} - {course.course_name}
                                  </div>
                                  <div className="text-xs text-gray-500">
                                    {course.credit} credits
                                  </div>
                                </div>
                                <span className="text-blue-600 text-sm font-semibold">
                                  Add
                                </span>
                              </div>
                            </button>
                          ))}
                        </div>
                      )}
                    </div>
                  ))
                )}
              </div>
            </div>

            <div className="bg-white rounded-xl shadow-md overflow-hidden">
              <div className="bg-gradient-to-r from-green-600 to-green-700 px-6 py-4 text-white">
                <h3 className="text-xl font-bold">Selected Courses</h3>
                <p className="text-sm opacity-90 mt-1">
                  {Object.keys(courseAssignments).length} selected
                </p>
              </div>
              <div className="p-6 space-y-6">
                {Object.keys(courseAssignments).length === 0 ? (
                  <div className="text-center text-gray-500">
                    No courses selected yet.
                  </div>
                ) : (
                  targetSlots.map((slot) => {
                    const selectedForSlot = availableElectives.filter(
                      (course) =>
                        courseAssignments[course.id]?.slot_id === slot.id,
                    );
                    if (selectedForSlot.length === 0) {
                      return null;
                    }
                    return (
                      <div
                        key={`selected-${slot.id}`}
                        className="border rounded-lg p-4"
                      >
                        <h4 className="font-semibold text-gray-900 mb-3">
                          {slot.slot_name}
                        </h4>
                        <div className="space-y-2">
                          {selectedForSlot.map((course) => (
                            <div
                              key={course.id}
                              className="flex items-center justify-between px-3 py-2 rounded-lg border"
                            >
                              <div>
                                <div className="font-medium text-gray-900">
                                  {course.course_code} - {course.course_name}
                                </div>
                                <div className="text-xs text-gray-500">
                                  {course.credit} credits
                                </div>
                              </div>
                              <button
                                type="button"
                                onClick={() => handleRemoveCourse(course.id)}
                                className="text-red-600 text-sm font-semibold hover:underline"
                              >
                                Remove
                              </button>
                            </div>
                          ))}
                        </div>
                      </div>
                    );
                  })
                )}
              </div>
            </div>
          </div>
        )}
      </div>
    </MainLayout>
  );
};

export default HODElectivePage;
