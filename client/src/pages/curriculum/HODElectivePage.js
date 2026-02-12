import React, { useEffect, useMemo, useRef, useState } from "react";
import MainLayout from "../../components/MainLayout";
import { API_BASE_URL } from "../../config";

const HODElectivePage = () => {
  const [batches, setBatches] = useState([]);
  const [selectedBatch, setSelectedBatch] = useState("ALL");
  const [academicYear, setAcademicYear] = useState("2025-2026");
  const [currentSemester, setCurrentSemester] = useState(null);
  const [currentSemesters, setCurrentSemesters] = useState([]);
  const [targetSemester, setTargetSemester] = useState(null);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [hodProfile, setHodProfile] = useState(null);
  const [saveMessage, setSaveMessage] = useState("");
  const [courseSearch, setCourseSearch] = useState("");

  // Get user email from localStorage (set during login)
  const userEmail = localStorage.getItem("userEmail");

  // Available elective courses (vertical courses from API)
  const [availableElectives, setAvailableElectives] = useState([]);
  // Course assignments per semester: { [semester]: { [courseId]: { slot_ids: [] } } }
  const [courseAssignmentsBySemester, setCourseAssignmentsBySemester] = useState({});
  // Elective slots per semester
  const [semesterSlots, setSemesterSlots] = useState([]);
  const electivesRequestIdRef = useRef(0);



  // Minor program state
  const [minorVerticals, setMinorVerticals] = useState([]);
  const [selectedMinorVertical, setSelectedMinorVertical] = useState(null);
  const [minorCourses, setMinorCourses] = useState([]);
  const [minorAssignments, setMinorAssignments] = useState({
    5: [null, null],
    6: [null, null],
    7: [null, null],
  });
  const [allowedDepartments, setAllowedDepartments] = useState([]);
  const [departments, setDepartments] = useState([]);
  const [minorSaveMessage, setMinorSaveMessage] = useState("");

  // Fetch HOD profile on component mount
  useEffect(() => {
    fetchHODProfile();
    fetchAcademicCalendar();
    fetchBatches();
    fetchElectiveSlots();
    fetchMinorVerticals();
    fetchDepartments();
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

      let semesters = [];
      if (Array.isArray(data.current_semesters)) {
        semesters = data.current_semesters;
      } else if (Array.isArray(data.calendars)) {
        semesters = data.calendars.map((item) => item.current_semester);
      } else if (data.current_semester) {
        semesters = [data.current_semester];
      }

      const normalized = semesters
        .map((semester) => parseInt(semester, 10))
        .filter((semester) => !Number.isNaN(semester));

      setCurrentSemesters(normalized);
      setCurrentSemester(normalized[0] || null);

      const nextSemesters = Array.from(
        new Set(
          normalized
            .map((semester) => (semester < 8 ? semester + 1 : null))
            .filter((semester) => semester && semester >= 4 && semester <= 8),
        ),
      );
      setTargetSemester(nextSemesters[0] || null);
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
    electivesRequestIdRef.current += 1;
    const requestId = electivesRequestIdRef.current;
    setLoading(true);
    setAvailableElectives([]);
    try {
      const batchParam = selectedBatch === "ALL" ? "" : selectedBatch;
      const response = await fetch(
        `${API_BASE_URL}/hod/electives/available?email=${encodeURIComponent(userEmail)}&batch=${encodeURIComponent(batchParam)}&academic_year=${encodeURIComponent(academicYear)}`,
      );
      const data = await response.json();

      if (requestId !== electivesRequestIdRef.current) {
        return;
      }

      if (data.available_electives) {
        const courseMap = new Map();
        const assignments = {};

        data.available_electives.forEach((course) => {
          // Filter out open elective courses
          if (course.card_type === "open_elective") {
            return;
          }
          if (!courseMap.has(course.id)) {
            courseMap.set(course.id, course);
          }

          if (course.assigned_semester === targetSemester) {
            const slotId = course.assigned_slot_id || 0;
            if (slotId) {
              const existing = assignments[course.id]?.slot_ids || [];
              if (!existing.includes(slotId)) {
                assignments[course.id] = {
                  slot_ids: [...existing, slotId],
                };
              }
            }
          }
        });

        setAvailableElectives(Array.from(courseMap.values()));

        if (targetSemester) {
          setCourseAssignmentsBySemester((prev) => ({
            ...prev,
            [targetSemester]: assignments,
          }));
        }
      }
    } catch (error) {
      console.error("Error fetching electives:", error);
    } finally {
      if (requestId === electivesRequestIdRef.current) {
        setLoading(false);
      }
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

  const fetchMinorVerticals = async () => {
    try {
      const response = await fetch(
        `${API_BASE_URL}/hod/minor-verticals?email=${encodeURIComponent(userEmail)}`
      );
      const data = await response.json();
      if (data.success && data.verticals) {
        setMinorVerticals(data.verticals);
      }
    } catch (error) {
      console.error("Error fetching minor verticals:", error);
    }
  };

  const fetchDepartments = async () => {
    try {
      const response = await fetch(`${API_BASE_URL}/departments`);
      const data = await response.json();
      if (data.success && data.departments) {
        setDepartments(data.departments);
      }
    } catch (error) {
      console.error("Error fetching departments:", error);
    }
  };

  const fetchVerticalCourses = async (verticalId) => {
    try {
      const response = await fetch(
        `${API_BASE_URL}/hod/vertical-courses?vertical_id=${verticalId}`
      );
      const data = await response.json();
      if (data.success && data.courses) {
        setMinorCourses(data.courses);
        // Auto-assign first 6 courses (2 per semester) to semesters 5, 6, 7
        if (data.courses.length >= 6) {
          setMinorAssignments({
            5: [data.courses[0]?.id || null, data.courses[1]?.id || null],
            6: [data.courses[2]?.id || null, data.courses[3]?.id || null],
            7: [data.courses[4]?.id || null, data.courses[5]?.id || null],
          });
        }
      }
    } catch (error) {
      console.error("Error fetching vertical courses:", error);
    }
  };

  const handleSaveMinor = async () => {
    setMinorSaveMessage("");

    if (!selectedMinorVertical) {
      setMinorSaveMessage("⚠️ Please select a vertical for minor program");
      return;
    }

    if (allowedDepartments.length === 0) {
      setMinorSaveMessage("⚠️ Please select at least one department");
      return;
    }

    // Validate all semesters have 2 courses
    for (let sem = 5; sem <= 7; sem++) {
      const courses = minorAssignments[sem] || [];
      if (courses.filter(Boolean).length !== 2) {
        setMinorSaveMessage(`⚠️ Semester ${sem} must have exactly 2 courses`);
        return;
      }
    }

    try {
      const semesterAssignments = [];
      for (let sem = 5; sem <= 7; sem++) {
        const courses = minorAssignments[sem] || [];
        courses.forEach((courseId) => {
          if (courseId) {
            semesterAssignments.push({
              semester: sem,
              course_id: courseId,
            });
          }
        });
      }

      const response = await fetch(
        `${API_BASE_URL}/hod/minor-selections?email=${encodeURIComponent(userEmail)}`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            vertical_id: selectedMinorVertical,
            allowed_dept_ids: allowedDepartments,
            academic_year: academicYear,
            batch: selectedBatch === "ALL" ? "" : selectedBatch,
            semester_assignments: semesterAssignments,
            status: "ACTIVE",
          }),
        }
      );

      const result = await response.json();
      if (result.success) {
        setMinorSaveMessage(`✓ ${result.message}`);
      } else {
        setMinorSaveMessage(`⚠️ ${result.message || "Failed to save minor program"}`);
      }
    } catch (error) {
      console.error("Error saving minor:", error);
      setMinorSaveMessage("⚠️ Error saving minor program");
    }
  };

  const nextSemesters = useMemo(() => {
    return Array.from(
      new Set(
        currentSemesters
          .map((semester) => (semester < 8 ? semester + 1 : null))
          .filter((semester) => semester && semester >= 4 && semester <= 8),
      ),
    );
  }, [currentSemesters]);

  const availableSemesters = useMemo(() => {
    return nextSemesters.sort((a, b) => a - b);
  }, [nextSemesters]);

  useEffect(() => {
    if (availableSemesters.length === 0) {
      if (targetSemester !== null) {
        setTargetSemester(null);
      }
      return;
    }
    if (!targetSemester || !availableSemesters.includes(targetSemester)) {
      setTargetSemester(availableSemesters[0]);
    }
  }, [availableSemesters, targetSemester]);

  const handleSave = async () => {
    setSaving(true);
    setSaveMessage("");

    try {
      const course_assignments = availableSemesters.flatMap((semester) => {
        const assignments = courseAssignmentsBySemester[semester] || {};
        return Object.entries(assignments).flatMap(([courseId, assignment]) =>
          (assignment.slot_ids || []).map((slotId) => ({
            course_id: parseInt(courseId, 10),
            semester: semester,
            slot_id: slotId,
          })),
        );
      });



      const missingSlots = availableSemesters.some((semester) => {
        const assignments = courseAssignmentsBySemester[semester] || {};
        return Object.values(assignments).some(
          (assignment) => !assignment.slot_ids || assignment.slot_ids.length === 0,
        );
      });
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
        // Refetch electives to update UI with saved state
        setTimeout(() => {
          fetchElectives();
          setSaveMessage("");
        }, 1000);
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
    const normalizedSlotId = parseInt(slotId, 10) || 0;
    if (!normalizedSlotId) {
      return;
    }
    if (!targetSemester) {
      return;
    }

    // Get the slot details
    const selectedSlot = semesterSlots.find((s) => s.id === normalizedSlotId);
    if (!selectedSlot) {
      return;
    }

    // Prevent adding courses to Open Elective slots - these are auto-populated
    if (selectedSlot.slot_name.toLowerCase().includes("open elective")) {
      setSaveMessage(
        "⚠️ Open Elective slots are automatically populated. You cannot manually assign courses to them.",
      );
      setTimeout(() => setSaveMessage(""), 4000);
      return;
    }

    const isHonourSlot = selectedSlot.slot_name.toLowerCase().includes("honour slot");

    // Check 1: If it's a specific honour slot (Honour Slot 1 or 2), allow max 1 course
    if (isHonourSlot) {
      const semesterAssignments = courseAssignmentsBySemester[targetSemester] || {};
      const currentCourseCount = Object.entries(semesterAssignments).filter(
        ([, assignment]) =>
          assignment.slot_ids &&
          assignment.slot_ids.some((sid) => {
            const slot = semesterSlots.find((s) => s.id === sid);
            return (
              slot &&
              slot.slot_name.toLowerCase().includes("honour slot") &&
              slot.id === normalizedSlotId
            );
          }),
      ).length;

      if (currentCourseCount >= 1) {
        setSaveMessage(
          `⚠️ ${selectedSlot.slot_name} can have only 1 course. Currently has 1 course.`,
        );
        setTimeout(() => setSaveMessage(""), 4000);
        return;
      }

      // Check if this course is already in professional electives
      const courseInProfessionalElective = Object.entries(semesterAssignments).some(
        ([cid, assignment]) =>
          parseInt(cid, 10) === courseId &&
          assignment.slot_ids &&
          assignment.slot_ids.some((sid) => {
            const slot = semesterSlots.find((s) => s.id === sid);
            return slot && slot.slot_name.toLowerCase().includes("professional elective");
          }),
      );

      if (courseInProfessionalElective) {
        setSaveMessage(
          "⚠️ This course is already assigned to a professional elective slot. Honour courses cannot be professional electives.",
        );
        setTimeout(() => setSaveMessage(""), 4000);
        return;
      }

      // Check 2: Max 2 honour courses per semester
      const totalHonourCoursesInSem = Object.entries(semesterAssignments).filter(
        ([, assignment]) =>
          assignment.slot_ids &&
          assignment.slot_ids.some((sid) => {
            const slot = semesterSlots.find((s) => s.id === sid);
            return slot && slot.slot_name.toLowerCase().includes("honour slot");
          }),
      ).length;

      if (totalHonourCoursesInSem >= 2) {
        setSaveMessage(
          `⚠️ Maximum 2 honour courses per semester. Semester ${targetSemester} already has 2.`,
        );
        setTimeout(() => setSaveMessage(""), 4000);
        return;
      }
    }

    setCourseAssignmentsBySemester((prev) => {
      const semesterAssignments = prev[targetSemester] || {};
      const existing = semesterAssignments[courseId]?.slot_ids || [];
      if (existing.includes(normalizedSlotId)) {
        return prev;
      }
      return {
        ...prev,
        [targetSemester]: {
          ...semesterAssignments,
          [courseId]: {
            slot_ids: [...existing, normalizedSlotId],
          },
        },
      };
    });
  };

  const handleRemoveCourseFromSlot = (courseId, slotId) => {
    const normalizedSlotId = parseInt(slotId, 10) || 0;
    if (!targetSemester) {
      return;
    }
    setCourseAssignmentsBySemester((prev) => {
      const semesterAssignments = prev[targetSemester] || {};
      const existing = semesterAssignments[courseId]?.slot_ids || [];
      const nextSlots = existing.filter((id) => id !== normalizedSlotId);
      if (nextSlots.length === 0) {
        const nextSemesterAssignments = { ...semesterAssignments };
        delete nextSemesterAssignments[courseId];
        return {
          ...prev,
          [targetSemester]: nextSemesterAssignments,
        };
      }
      return {
        ...prev,
        [targetSemester]: {
          ...semesterAssignments,
          [courseId]: {
            slot_ids: nextSlots,
          },
        },
      };
    });
  };

  const targetSlots = targetSemester
    ? semesterSlots.filter((slot) => slot.semester === targetSemester)
    : [];
  const slotById = new Map(semesterSlots.map((slot) => [slot.id, slot]));
  const semestersWithSlots = useMemo(() => {
    return new Set(semesterSlots.map((slot) => slot.semester));
  }, [semesterSlots]);
  const hasSlotsForTarget = targetSemester
    ? semestersWithSlots.has(targetSemester)
    : false;
  const currentAssignments = targetSemester
    ? courseAssignmentsBySemester[targetSemester] || {}
    : {};
  const totalAssignedCourses = availableSemesters.reduce((count, semester) => {
    const assignments = courseAssignmentsBySemester[semester] || {};
    return count + Object.keys(assignments).length;
  }, 0);

  const handleDragStart = (event, courseId) => {
    event.dataTransfer.setData("text/plain", String(courseId));
    event.dataTransfer.effectAllowed = "move";
  };

  const handleDragOver = (event) => {
    event.preventDefault();
  };

  const handleDropOnSlot = (event, slotId) => {
    event.preventDefault();
    const courseId = parseInt(event.dataTransfer.getData("text/plain"), 10);
    if (!courseId) {
      return;
    }
    handleAddCourseToSlot(courseId, slotId);
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
        {/* Auto-Allocation Info Banner */}
        <div className="bg-blue-50 border-l-4 border-blue-500 rounded-lg p-4 mb-6">
          <div className="flex items-start">
            <svg
              className="w-5 h-5 text-blue-500 mt-0.5 mr-3 flex-shrink-0"
              fill="currentColor"
              viewBox="0 0 20 20"
            >
              <path
                fillRule="evenodd"
                d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z"
                clipRule="evenodd"
              />
            </svg>
            <div className="flex-1">
              <h4 className="text-sm font-semibold text-blue-800 mb-1">
                Open Electives Auto-Allocation
              </h4>
              <p className="text-sm text-blue-700">
                Open elective courses are automatically assigned when you save. They will be placed in the "Open Elective" slot if available, otherwise in the last "Professional Elective" slot for each semester. Semesters with only one professional elective slot will not receive open electives.
              </p>
            </div>
          </div>
        </div>

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
                  Current Semesters: {currentSemesters.join(", ")}
                </p>
              )}
              {nextSemesters.length > 0 && (
                <p className="text-sm text-gray-600 mt-1">
                  Next Semesters: {nextSemesters.join(", ")}
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

              {/* Semester Selector */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Target Semester
                </label>
                <select
                  value={targetSemester || ""}
                  onChange={(e) =>
                    setTargetSemester(parseInt(e.target.value, 10))
                  }
                  className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                  disabled={availableSemesters.length === 0}
                >
                  <option value="" disabled>
                    {availableSemesters.length === 0
                      ? "No slots available"
                      : "Select semester"}
                  </option>
                  {availableSemesters.map((semester) => (
                    <option key={semester} value={semester}>
                      Semester {semester}
                      {semestersWithSlots.has(semester) ? "" : " (no slots)"}
                    </option>
                  ))}
                </select>
                {!hasSlotsForTarget && targetSemester && (
                  <p className="text-xs text-amber-600 mt-1">
                    No elective slots configured for Semester {targetSemester}
                  </p>
                )}
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
                    : `Save Assignments (${totalAssignedCourses})`}
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
                <h3 className="text-xl font-bold">Available Courses</h3>
                <p className="text-sm opacity-90 mt-1">
                  Drag a course card into a semester slot
                </p>
              </div>

              <div className="p-6 space-y-3 max-h-[680px] overflow-y-auto">
                {/* Search Input */}
                <div className="mb-4">
                  <input
                    type="text"
                    placeholder="Search by course code or name..."
                    value={courseSearch}
                    onChange={(e) => setCourseSearch(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  />
                </div>
                {availableElectives.length === 0 ? (
                  <div className="text-center text-gray-500">
                    No available elective courses found.
                  </div>
                ) : (
                  availableElectives
                    .filter(
                      (course) =>
                        courseSearch === "" ||
                        course.course_code
                          .toLowerCase()
                          .includes(courseSearch.toLowerCase()) ||
                        course.course_name
                          .toLowerCase()
                          .includes(courseSearch.toLowerCase())
                    )
                    .map((course) => {
                    const assignedSlotIds =
                      currentAssignments[course.id]?.slot_ids || [];
                    const assignedSlots = assignedSlotIds
                      .map((slotId) => slotById.get(slotId))
                      .filter(Boolean);
                    const assignedSlotLabel = assignedSlots
                      .map((slot) => slot.slot_name)
                      .join(", ");

                    return (
                      <div
                        key={course.id}
                        draggable
                        onDragStart={(event) =>
                          handleDragStart(event, course.id)
                        }
                        className="border rounded-lg p-4 bg-white shadow-sm hover:shadow-md transition cursor-move"
                      >
                        <div className="flex items-center justify-between">
                          <div>
                            <div className="font-semibold text-gray-900">
                              {course.course_code} - {course.course_name}
                            </div>
                            <div className="text-xs text-gray-500">
                              {course.credit} credits
                            </div>
                          </div>
                          {assignedSlots.length > 0 ? (
                            <span className="text-xs font-semibold px-2 py-1 rounded-full bg-green-100 text-green-700">
                              Assigned ({assignedSlots.length}): {assignedSlotLabel}
                            </span>
                          ) : (
                            <span className="text-xs font-semibold px-2 py-1 rounded-full bg-gray-100 text-gray-600">
                              Unassigned
                            </span>
                          )}
                        </div>
                      </div>
                    );
                  })
                )}
              </div>
            </div>

            <div className="bg-white rounded-xl shadow-md overflow-hidden">
              <div className="bg-gradient-to-r from-green-600 to-green-700 px-6 py-4 text-white">
                <h3 className="text-xl font-bold">
                  Semester {targetSemester} Slots
                </h3>
                <p className="text-sm opacity-90 mt-1">
                  Drop courses into a slot to assign
                </p>
              </div>
              <div className="p-6 space-y-6">
                {targetSlots.length === 0 ? (
                  <div className="text-center text-gray-500">
                    No slots configured for Semester {targetSemester}
                  </div>
                ) : (
                  targetSlots.map((slot) => {
                    const selectedForSlot = availableElectives.filter(
                      (course) =>
                        currentAssignments[course.id]?.slot_ids?.includes(slot.id),
                    );

                    return (
                      <div
                        key={`selected-${slot.id}`}
                        className="border rounded-lg p-4"
                        onDragOver={handleDragOver}
                        onDrop={(event) => handleDropOnSlot(event, slot.id)}
                      >
                        <div className="flex items-center justify-between mb-3">
                          <h4 className="font-semibold text-gray-900">
                            {slot.slot_name}
                          </h4>
                          <span className="text-xs text-gray-500">
                            {selectedForSlot.length} assigned
                          </span>
                        </div>
                        {selectedForSlot.length === 0 ? (
                          <div className="border border-dashed border-gray-300 rounded-lg px-4 py-6 text-center text-gray-500 text-sm">
                            Drop a course here
                          </div>
                        ) : (
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
                                  onClick={() =>
                                    handleRemoveCourseFromSlot(course.id, slot.id)
                                  }
                                  className="text-red-600 text-sm font-semibold hover:underline"
                                >
                                  Remove
                                </button>
                              </div>
                            ))}
                          </div>
                        )}
                      </div>
                    );
                  })
                )}
              </div>
            </div>
          </div>
        )}
      </div>



      {/* Minor Program Section */}
      <div className="mt-8">
        <div className="bg-white rounded-xl shadow-md p-6">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">
            Minor Program Management
          </h2>
          <div className="bg-purple-50 border-l-4 border-purple-500 p-4 mb-6">
            <p className="text-sm text-purple-800">
              <strong>Minor programs</strong> allow other departments to study courses from your verticals.
              Select a vertical, distribute 6 courses across semesters 5, 6, 7 (2 each), and choose which departments can access them.
            </p>
          </div>

          {/* Vertical Selection */}
          <div className="mb-6">
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Select Vertical for Minor
            </label>
            <select
              value={selectedMinorVertical || ""}
              onChange={(e) => {
                const verticalId = e.target.value
                  ? parseInt(e.target.value, 10)
                  : null;
                setSelectedMinorVertical(verticalId);
                if (verticalId) {
                  fetchVerticalCourses(verticalId);
                } else {
                  setMinorCourses([]);
                }
              }}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500"
            >
              <option value="">-- Select Vertical --</option>
              {minorVerticals.map((vertical) => (
                <option key={vertical.id} value={vertical.id}>
                  {vertical.name} ({vertical.course_count} courses)
                </option>
              ))}
            </select>
          </div>

          {selectedMinorVertical && minorCourses.length > 0 && (
            <>
              {/* Course Distribution Table */}
              <div className="mb-6">
                <h3 className="text-lg font-semibold text-gray-800 mb-3">
                  Course Distribution Across Semesters
                </h3>
                <div className="overflow-x-auto">
                  <table className="w-full border-collapse border border-gray-300">
                    <thead>
                      <tr className="bg-gray-100">
                        <th className="border border-gray-300 px-4 py-2 text-left">
                          Position
                        </th>
                        <th className="border border-gray-300 px-4 py-2 text-left">
                          Semester 5
                        </th>
                        <th className="border border-gray-300 px-4 py-2 text-left">
                          Semester 6
                        </th>
                        <th className="border border-gray-300 px-4 py-2 text-left">
                          Semester 7
                        </th>
                      </tr>
                    </thead>
                    <tbody>
                      {[0, 1].map((pos) => (
                        <tr key={pos}>
                          <td className="border border-gray-300 px-4 py-2 font-semibold">
                            Course {pos + 1}
                          </td>
                          {[5, 6, 7].map((sem) => (
                            <td key={sem} className="border border-gray-300 px-4 py-2">
                              <select
                                value={minorAssignments[sem]?.[pos] || ""}
                                onChange={(e) => {
                                  const courseId = e.target.value
                                    ? parseInt(e.target.value, 10)
                                    : null;
                                  setMinorAssignments((prev) => {
                                    const newAssignments = { ...prev };
                                    newAssignments[sem] = [...(prev[sem] || [])];
                                    newAssignments[sem][pos] = courseId;
                                    return newAssignments;
                                  });
                                }}
                                className="w-full px-2 py-1 border border-gray-300 rounded text-sm"
                              >
                                <option value="">-- Select Course --</option>
                                {minorCourses.map((course) => (
                                  <option key={course.id} value={course.id}>
                                    {course.course_code} - {course.course_name}
                                  </option>
                                ))}
                              </select>
                            </td>
                          ))}
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>

              {/* Department Selection */}
              <div className="mb-6">
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Departments Allowed to Take Minor
                </label>
                <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3 max-h-60 overflow-y-auto border border-gray-300 rounded-lg p-4">
                  {departments
                    .filter((dept) => dept.id !== hodProfile?.department?.id)
                    .map((dept) => (
                      <label
                        key={dept.id}
                        className="flex items-center space-x-2 cursor-pointer"
                      >
                        <input
                          type="checkbox"
                          checked={allowedDepartments.includes(dept.id)}
                          onChange={(e) => {
                            if (e.target.checked) {
                              setAllowedDepartments([...allowedDepartments, dept.id]);
                            } else {
                              setAllowedDepartments(
                                allowedDepartments.filter((id) => id !== dept.id)
                              );
                            }
                          }}
                          className="w-4 h-4 text-purple-600 focus:ring-purple-500"
                        />
                        <span className="text-sm text-gray-700">{dept.name}</span>
                      </label>
                    ))}
                </div>
                <p className="text-xs text-gray-600 mt-2">
                  Selected: {allowedDepartments.length} department(s)
                </p>
              </div>

              {/* Save Minor Button */}
              <div className="flex items-center gap-4">
                <button
                  type="button"
                  onClick={handleSaveMinor}
                  className="px-6 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 font-semibold"
                >
                  Save Minor Program
                </button>
                {minorSaveMessage && (
                  <span
                    className={`text-sm ${
                      minorSaveMessage.includes("✓")
                        ? "text-green-600"
                        : "text-amber-600"
                    }`}
                  >
                    {minorSaveMessage}
                  </span>
                )}
              </div>
            </>
          )}
        </div>
      </div>
    </MainLayout>
  );
};

export default HODElectivePage;