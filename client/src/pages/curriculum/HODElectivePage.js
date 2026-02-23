import React, { useEffect, useMemo, useRef, useState } from "react";
import { createPortal } from "react-dom";
import MainLayout from "../../components/MainLayout";
import { API_BASE_URL } from "../../config";

// Searchable Dropdown Component
const SearchableSelect = ({
  value,
  onChange,
  options,
  placeholder,
  disabled,
}) => {
  const [isOpen, setIsOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState("");
  const [dropdownPosition, setDropdownPosition] = useState({
    top: 0,
    left: 0,
    width: 0,
  });
  const dropdownRef = useRef(null);
  const portalRef = useRef(null);

  // Calculate dropdown position
  const updatePosition = () => {
    if (dropdownRef.current) {
      const rect = dropdownRef.current.getBoundingClientRect();
      setDropdownPosition({
        top: rect.bottom + window.scrollY + 8,
        left: rect.left + window.scrollX,
        width: rect.width,
      });
    }
  };

  // Update position when opening
  useEffect(() => {
    if (isOpen) {
      updatePosition();
      window.addEventListener("scroll", updatePosition, true);
      window.addEventListener("resize", updatePosition);
    }
    return () => {
      window.removeEventListener("scroll", updatePosition, true);
      window.removeEventListener("resize", updatePosition);
    };
  }, [isOpen]);

  // Close dropdown when clicking outside
  useEffect(() => {
    const handleClickOutside = (event) => {
      if (
        dropdownRef.current &&
        !dropdownRef.current.contains(event.target) &&
        portalRef.current &&
        !portalRef.current.contains(event.target)
      ) {
        setIsOpen(false);
        setSearchTerm("");
      }
    };
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  // Get selected course details
  const selectedCourse = useMemo(() => {
    for (const [, courses] of options) {
      const found = courses.find((c) => c.id === parseInt(value));
      if (found) return found;
    }
    return null;
  }, [value, options]);

  // Filter courses based on search term
  const filteredOptions = useMemo(() => {
    if (!searchTerm) return options;

    const filtered = [];
    options.forEach(([verticalName, courses]) => {
      const matchingCourses = courses.filter(
        (course) =>
          course.course_code.toLowerCase().includes(searchTerm.toLowerCase()) ||
          course.course_name.toLowerCase().includes(searchTerm.toLowerCase()),
      );
      if (matchingCourses.length > 0) {
        filtered.push([verticalName, matchingCourses]);
      }
    });
    return filtered;
  }, [options, searchTerm]);

  const handleSelect = (courseId) => {
    onChange(courseId);
    setIsOpen(false);
    setSearchTerm("");
  };

  if (disabled) {
    return (
      <div className="w-full px-3 py-2 border border-gray-300 rounded-lg bg-gray-100 text-gray-500 text-sm">
        {placeholder}
      </div>
    );
  }

  const dropdownContent =
    isOpen &&
    createPortal(
      <div
        ref={portalRef}
        className="absolute z-[9999] bg-white border border-gray-300 rounded-lg shadow-2xl overflow-hidden"
        style={{
          top: `${dropdownPosition.top}px`,
          left: `${dropdownPosition.left}px`,
          width: `${dropdownPosition.width}px`,
          maxHeight: "450px",
        }}
      >
        {/* Search Input */}
        <div className="p-4 border-b bg-gray-50 sticky top-0 z-10">
          <input
            type="text"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            placeholder="Search courses..."
            className="w-full px-4 py-3 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 focus:outline-none"
            autoFocus
          />
        </div>

        {/* Options List */}
        <div className="overflow-y-auto max-h-[350px]">
          {/* Empty Option */}
          <div
            onClick={() => handleSelect("")}
            className="px-4 py-3 hover:bg-gray-100 cursor-pointer text-sm text-gray-500 border-b font-medium"
          >
            {placeholder}
          </div>

          {filteredOptions.length === 0 ? (
            <div className="px-4 py-8 text-center text-sm text-gray-500">
              No courses found
            </div>
          ) : (
            filteredOptions.map(([verticalName, courses]) => (
              <div key={verticalName}>
                <div className="px-4 py-2 bg-blue-50 text-xs font-bold text-blue-800 uppercase tracking-wide sticky top-0">
                  {verticalName}
                </div>
                {courses.map((course) => (
                  <div
                    key={course.id}
                    onClick={() => handleSelect(course.id)}
                    className={`px-4 py-3 hover:bg-blue-50 cursor-pointer border-b border-gray-100 transition-colors ${
                      parseInt(value) === course.id
                        ? "bg-blue-100 border-l-4 border-l-blue-600"
                        : ""
                    }`}
                  >
                    <div className="font-semibold text-gray-900 mb-1">
                      {course.course_code} - {course.course_name}
                    </div>
                    <div className="text-xs text-gray-600">
                      {course.credit} Credits
                    </div>
                  </div>
                ))}
              </div>
            ))
          )}
        </div>
      </div>,
      document.body,
    );

  return (
    <div ref={dropdownRef} className="relative w-full">
      {/* Input Display */}
      <div
        onClick={() => setIsOpen(!isOpen)}
        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 text-sm cursor-pointer bg-white flex items-center justify-between hover:border-blue-400"
      >
        <span className={selectedCourse ? "text-gray-900" : "text-gray-500"}>
          {selectedCourse
            ? `${selectedCourse.course_code} - ${selectedCourse.course_name}`
            : placeholder}
        </span>
        <svg
          className={`w-5 h-5 transition-transform ${isOpen ? "rotate-180" : ""}`}
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path
            strokeLinecap="round"
            strokeLinejoin="round"
            strokeWidth={2}
            d="M19 9l-7 7-7-7"
          />
        </svg>
      </div>

      {/* Dropdown rendered via portal */}
      {dropdownContent}
    </div>
  );
};

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
  const [expandedSemesters, setExpandedSemesters] = useState(new Set([4]));

  // Get user email from localStorage (set during login)
  const userEmail = localStorage.getItem("userEmail");

  // Available elective courses (vertical courses from API)
  const [availableElectives, setAvailableElectives] = useState([]);
  // Course assignments per semester: { [semester]: { [courseId]: { slot_ids: [] } } }
  const [courseAssignmentsBySemester, setCourseAssignmentsBySemester] =
    useState({});
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
        const semesterAssignments = {}; // Store assignments grouped by semester

        data.available_electives.forEach((course) => {
          // Filter out open elective courses
          if (course.card_type === "open_elective") {
            return;
          }
          if (!courseMap.has(course.id)) {
            courseMap.set(course.id, course);
          }

          // If this course has an assigned semester, add it to that semester's assignments
          if (course.assigned_semester) {
            if (!semesterAssignments[course.assigned_semester]) {
              semesterAssignments[course.assigned_semester] = {};
            }
            const slotId = course.assigned_slot_id || 0;
            if (slotId) {
              const existing =
                semesterAssignments[course.assigned_semester][course.id]
                  ?.slot_ids || [];
              if (!existing.includes(slotId)) {
                semesterAssignments[course.assigned_semester][course.id] = {
                  slot_ids: [...existing, slotId],
                };
              }
            }
          }
        });

        setAvailableElectives(Array.from(courseMap.values()));

        // Update assignments for all semesters, not just the current one
        setCourseAssignmentsBySemester((prev) => ({
          ...prev,
          ...semesterAssignments,
        }));
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
        `${API_BASE_URL}/hod/minor-verticals?email=${encodeURIComponent(userEmail)}`,
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
        `${API_BASE_URL}/hod/vertical-courses?vertical_id=${verticalId}`,
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
        },
      );

      const result = await response.json();
      if (result.success) {
        setMinorSaveMessage(`✓ ${result.message}`);
      } else {
        setMinorSaveMessage(
          `⚠️ ${result.message || "Failed to save minor program"}`,
        );
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

  // Auto-expand first semester when available semesters change
  useEffect(() => {
    if (availableSemesters.length > 0 && expandedSemesters.size === 0) {
      setExpandedSemesters(new Set([availableSemesters[0]]));
    }
  }, [availableSemesters]);

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
          (assignment) =>
            !assignment.slot_ids || assignment.slot_ids.length === 0,
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

    const isHonourSlot = selectedSlot.slot_name
      .toLowerCase()
      .includes("honour slot");

    // Check 1: If it's a specific honour slot (Honour Slot 1 or 2), allow max 1 course
    if (isHonourSlot) {
      const semesterAssignments =
        courseAssignmentsBySemester[targetSemester] || {};
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
      const courseInProfessionalElective = Object.entries(
        semesterAssignments,
      ).some(
        ([cid, assignment]) =>
          parseInt(cid, 10) === courseId &&
          assignment.slot_ids &&
          assignment.slot_ids.some((sid) => {
            const slot = semesterSlots.find((s) => s.id === sid);
            return (
              slot &&
              slot.slot_name.toLowerCase().includes("professional elective")
            );
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
      const totalHonourCoursesInSem = Object.entries(
        semesterAssignments,
      ).filter(
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

  const handleRemoveCourseFromSlot = (courseId, slotId, semester = null) => {
    const normalizedSlotId = parseInt(slotId, 10) || 0;
    const semesterToUse = semester || targetSemester;
    if (!semesterToUse) {
      return;
    }
    setCourseAssignmentsBySemester((prev) => {
      const semesterAssignments = prev[semesterToUse] || {};
      const existing = semesterAssignments[courseId]?.slot_ids || [];
      const nextSlots = existing.filter((id) => id !== normalizedSlotId);
      if (nextSlots.length === 0) {
        const nextSemesterAssignments = { ...semesterAssignments };
        delete nextSemesterAssignments[courseId];
        return {
          ...prev,
          [semesterToUse]: nextSemesterAssignments,
        };
      }
      return {
        ...prev,
        [semesterToUse]: {
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

  // New handler for dropdown-based course assignment
  const handleAssignCourseToSlot = (courseId, slotId, semester) => {
    const parsedCourseId = courseId ? parseInt(courseId, 10) : null;
    const parsedSlotId = parseInt(slotId, 10);

    if (!parsedCourseId || !parsedSlotId || !semester) {
      return;
    }

    // Remove course from any previous slot assignments in same semester
    setCourseAssignmentsBySemester((prev) => {
      const semesterAssignments = prev[semester] || {};

      // Clear this course from other slots in same semester
      const clearedAssignments = {};
      Object.entries(semesterAssignments).forEach(([cid, assignment]) => {
        if (parseInt(cid, 10) !== parsedCourseId) {
          clearedAssignments[cid] = assignment;
        }
      });

      // Add new assignment
      clearedAssignments[parsedCourseId] = { slot_ids: [parsedSlotId] };

      return {
        ...prev,
        [semester]: clearedAssignments,
      };
    });
  };

  // Toggle semester expansion
  const toggleSemester = (semester) => {
    setExpandedSemesters((prev) => {
      const next = new Set(prev);
      if (next.has(semester)) {
        next.delete(semester);
      } else {
        next.add(semester);
      }
      return next;
    });
  };

  // Get slot type badge info
  const getSlotTypeBadge = (slotName) => {
    const name = slotName.toLowerCase();
    if (name.includes("professional")) {
      return {
        label: "Professional Elective",
        color: "bg-purple-100 text-purple-800",
      };
    }
    if (name.includes("honour") || name.includes("honor")) {
      return { label: "Honors", color: "bg-amber-100 text-amber-800" };
    }
    if (name.includes("open")) {
      return { label: "Open Elective", color: "bg-blue-100 text-blue-800" };
    }
    return { label: "Elective", color: "bg-gray-100 text-gray-800" };
  };

  // Calculate semester assignment status
  const calculateSemesterStatus = (semester) => {
    const slots = semesterSlots.filter((s) => s.semester === semester);
    const assignments = courseAssignmentsBySemester[semester] || {};

    const assignedSlotIds = new Set();
    Object.values(assignments).forEach((assignment) => {
      assignment.slot_ids?.forEach((slotId) => assignedSlotIds.add(slotId));
    });

    const assignedCount = assignedSlotIds.size;
    const totalCount = slots.length;
    const emptyCount = totalCount - assignedCount;

    return { assignedCount, emptyCount, totalCount };
  };

  const getVerticalName = (course) => {
    if (course.vertical_name) {
      return course.vertical_name;
    }
    if (course.vertical && course.vertical.name) {
      return course.vertical.name;
    }
    if (course.verticalName) {
      return course.verticalName;
    }
    return "Uncategorized";
  };

  const groupedElectives = useMemo(() => {
    const grouped = new Map();
    availableElectives.forEach((course) => {
      const name = getVerticalName(course);
      if (!grouped.has(name)) {
        grouped.set(name, []);
      }
      grouped.get(name).push(course);
    });

    const toNum = (value) => {
      const parsed = Number(value);
      return Number.isFinite(parsed) ? parsed : null;
    };

    return Array.from(grouped.entries()).sort(
      ([a, coursesA], [b, coursesB]) => {
        const semA = toNum(coursesA[0]?.vertical_semester);
        const semB = toNum(coursesB[0]?.vertical_semester);

        if (semA !== null && semB !== null && semA !== semB) {
          return semA - semB;
        }
        if (semA !== null && semB === null) {
          return -1;
        }
        if (semA === null && semB !== null) {
          return 1;
        }
        return a.localeCompare(b);
      },
    );
  }, [availableElectives]);

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
                Open elective courses are automatically assigned when you save.
                They will be placed in the "Open Elective" slot if available,
                otherwise in the last "Professional Elective" slot for each
                semester. Semesters with only one professional elective slot
                will not receive open electives.
              </p>
            </div>
          </div>
        </div>

        {/* Header Bar with Controls */}
        <div className="bg-white rounded-lg shadow-md p-4 mb-6 flex items-center justify-between flex-wrap gap-4">
          <div className="flex items-center gap-4 flex-wrap">
            {/* Academic Year Badge */}
            {academicYear && (
              <div className="px-3 py-1.5 bg-blue-100 text-blue-800 rounded-md text-sm font-semibold">
                {academicYear}
              </div>
            )}

            {/* Curriculum Info */}
            {hodProfile?.curriculum && (
              <div className="text-sm text-gray-700">
                <span className="font-medium">
                  {hodProfile.curriculum.name}
                </span>
              </div>
            )}

            {/* Batch Selector */}
            <select
              value={selectedBatch}
              onChange={(e) => setSelectedBatch(e.target.value)}
              className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-sm"
            >
              {batches.map((batch) => (
                <option key={batch} value={batch}>
                  Batch {batch}
                </option>
              ))}
            </select>
          </div>

          {/* Save Button with Status */}
          <div className="flex items-center gap-3">
            {totalAssignedCourses > 0 && (
              <span className="text-sm px-3 py-1 bg-orange-100 text-orange-800 rounded-md font-medium">
                🟠 Unsaved changes
              </span>
            )}
            <button
              onClick={handleSave}
              disabled={saving || !selectedBatch}
              className={`px-6 py-2 rounded-lg font-semibold transition-all text-sm ${
                saving || !selectedBatch
                  ? "bg-gray-300 text-gray-500 cursor-not-allowed"
                  : "bg-blue-600 hover:bg-blue-700 text-white shadow-md hover:shadow-lg"
              }`}
            >
              {saving ? "Saving..." : "Save All Changes"}
            </button>
          </div>
        </div>

        {/* Save Message */}
        {saveMessage && (
          <div
            className={`mb-6 p-3 rounded-lg ${saveMessage.includes("✅") ? "bg-green-50 text-green-700" : "bg-red-50 text-red-700"}`}
          >
            {saveMessage}
          </div>
        )}

        {/* Loading State */}
        {loading && (
          <div className="text-center py-12">
            <div className="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
            <p className="mt-4 text-gray-600">Loading vertical courses...</p>
          </div>
        )}

        {/* Main Layout */}
        {!loading && (
          <div className="space-y-4">
            {availableSemesters.map((semester) => {
              const slots = semesterSlots.filter(
                (s) => s.semester === semester,
              );
              const status = calculateSemesterStatus(semester);
              const isExpanded = expandedSemesters.has(semester);

              return (
                <div
                  key={semester}
                  className="bg-white rounded-lg shadow-md overflow-hidden"
                >
                  {/* Accordion Header */}
                  <button
                    onClick={() => toggleSemester(semester)}
                    className="w-full px-6 py-4 flex items-center justify-between bg-white hover:bg-gray-50 border-b transition-colors"
                  >
                    <div className="flex items-center gap-3">
                      <svg
                        className="w-5 h-5 transition-transform duration-200"
                        style={{
                          transform: isExpanded
                            ? "rotate(90deg)"
                            : "rotate(0deg)",
                        }}
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
                      <h3 className="text-lg font-bold text-gray-900">
                        Semester {semester}
                      </h3>
                    </div>

                    {/* Status Badge */}
                    <div>
                      {status.emptyCount === 0 && status.totalCount > 0 ? (
                        <span className="px-3 py-1 rounded-full text-sm font-medium bg-green-100 text-green-800">
                          All Assigned
                        </span>
                      ) : status.assignedCount > 0 ? (
                        <span className="px-3 py-1 rounded-full text-sm font-medium bg-orange-100 text-orange-800">
                          {status.assignedCount} Assigned / {status.emptyCount}{" "}
                          Empty
                        </span>
                      ) : (
                        <span className="px-3 py-1 rounded-full text-sm font-medium bg-gray-100 text-gray-600">
                          {status.totalCount} Pending
                        </span>
                      )}
                    </div>
                  </button>

                  {/* Accordion Content */}
                  {isExpanded && (
                    <div className="p-6">
                      {slots.length === 0 ? (
                        <div className="text-center text-gray-500 py-8">
                          No slots configured for Semester {semester}
                        </div>
                      ) : (
                        <table className="w-full">
                          <thead>
                            <tr className="border-b">
                              <th className="text-left py-3 px-4 text-sm font-semibold text-gray-700">
                                Slot Type
                              </th>
                              <th className="text-left py-3 px-4 text-sm font-semibold text-gray-700">
                                Slot Name
                              </th>
                              <th className="text-left py-3 px-4 text-sm font-semibold text-gray-700">
                                Assigned Course
                              </th>
                              <th className="w-20"></th>
                            </tr>
                          </thead>
                          <tbody>
                            {slots.map((slot) => {
                              const badgeInfo = getSlotTypeBadge(
                                slot.slot_name,
                              );

                              // Find assigned course for this slot
                              const assignedCourseId = Object.entries(
                                courseAssignmentsBySemester[semester] || {},
                              ).find(([, assignment]) =>
                                assignment.slot_ids?.includes(slot.id),
                              )?.[0];

                              return (
                                <tr
                                  key={slot.id}
                                  className="border-b even:bg-gray-50 hover:bg-gray-100"
                                >
                                  {/* Slot Type Badge */}
                                  <td className="py-3 px-4">
                                    <span
                                      className={`px-2 py-1 rounded-md text-xs font-semibold ${badgeInfo.color}`}
                                    >
                                      {badgeInfo.label}
                                    </span>
                                  </td>

                                  {/* Slot Name */}
                                  <td className="py-3 px-4 text-sm font-medium text-gray-900">
                                    {slot.slot_name}
                                  </td>

                                  {/* Course Dropdown */}
                                  <td className="py-3 px-4">
                                    <SearchableSelect
                                      value={assignedCourseId || ""}
                                      onChange={(courseId) =>
                                        handleAssignCourseToSlot(
                                          courseId,
                                          slot.id,
                                          semester,
                                        )
                                      }
                                      options={groupedElectives}
                                      placeholder={
                                        slot.slot_name
                                          .toLowerCase()
                                          .includes("open elective")
                                          ? "Auto-allocated"
                                          : "Select Course..."
                                      }
                                      disabled={slot.slot_name
                                        .toLowerCase()
                                        .includes("open elective")}
                                    />
                                  </td>

                                  {/* Actions */}
                                  <td className="py-3 px-4 text-center">
                                    {assignedCourseId ? (
                                      <button
                                        onClick={() =>
                                          handleRemoveCourseFromSlot(
                                            parseInt(assignedCourseId),
                                            slot.id,
                                            semester,
                                          )
                                        }
                                        className="text-red-600 hover:text-red-800 font-bold text-lg"
                                        title="Remove course"
                                      >
                                        ×
                                      </button>
                                    ) : (
                                      <span className="text-xs text-gray-400">
                                        Required
                                      </span>
                                    )}
                                  </td>
                                </tr>
                              );
                            })}
                          </tbody>
                        </table>
                      )}
                    </div>
                  )}
                </div>
              );
            })}

            {availableSemesters.length === 0 && (
              <div className="bg-white rounded-lg shadow-md p-12 text-center">
                <div className="text-gray-500">
                  <svg
                    className="w-16 h-16 mx-auto mb-4 text-gray-400"
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
                  <p className="text-lg font-medium">
                    No semesters available for assignment
                  </p>
                  <p className="text-sm mt-2">
                    Please check academic calendar configuration
                  </p>
                </div>
              </div>
            )}
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
              <strong>Minor programs</strong> allow other departments to study
              courses from your verticals. Select a vertical, distribute 6
              courses across semesters 5, 6, 7 (2 each), and choose which
              departments can access them.
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
                            <td
                              key={sem}
                              className="border border-gray-300 px-4 py-2"
                            >
                              <select
                                value={minorAssignments[sem]?.[pos] || ""}
                                onChange={(e) => {
                                  const courseId = e.target.value
                                    ? parseInt(e.target.value, 10)
                                    : null;
                                  setMinorAssignments((prev) => {
                                    const newAssignments = { ...prev };
                                    newAssignments[sem] = [
                                      ...(prev[sem] || []),
                                    ];
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
                              setAllowedDepartments([
                                ...allowedDepartments,
                                dept.id,
                              ]);
                            } else {
                              setAllowedDepartments(
                                allowedDepartments.filter(
                                  (id) => id !== dept.id,
                                ),
                              );
                            }
                          }}
                          className="w-4 h-4 text-purple-600 focus:ring-purple-500"
                        />
                        <span className="text-sm text-gray-700">
                          {dept.name}
                        </span>
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
