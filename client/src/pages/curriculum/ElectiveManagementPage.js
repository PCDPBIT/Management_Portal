import React, { useState } from "react";
import MainLayout from "../../components/MainLayout";

const ElectiveManagementPage = () => {
  const [curricula, setCurricula] = useState([
    { id: 1, name: "2022 Curriculum", year: "2022", status: "Active" },
    { id: 2, name: "2021 Curriculum", year: "2021", status: "Active" },
    { id: 3, name: "2020 Curriculum", year: "2020", status: "Archived" },
  ]);

  const [showCreateModal, setShowCreateModal] = useState(false);
  const [selectedCurriculum, setSelectedCurriculum] = useState(null);
  const [selectedSemester, setSelectedSemester] = useState(null);
  const [showSendConfirmation, setShowSendConfirmation] = useState(false);
  const [newCurriculumName, setNewCurriculumName] = useState("");
  const [newCurriculumYear, setNewCurriculumYear] = useState("");
  const [selectedHOD, setSelectedHOD] = useState(null);
  const [showRejectModal, setShowRejectModal] = useState(false);
  const [rejectionReason, setRejectionReason] = useState("");

  const semesters = [1, 2, 3, 4, 5, 6, 7, 8];

  const [hodApprovals, setHodApprovals] = useState({});

  const departments = [
    { id: 1, name: "CSE", hodName: "Dr. Rajesh Kumar" },
    { id: 2, name: "ECE", hodName: "Dr. Priya Sharma" },
    { id: 3, name: "MECH", hodName: "Dr. Arun Patel" },
    { id: 4, name: "CIVIL", hodName: "Dr. Kavitha Rao" },
    { id: 5, name: "EEE", hodName: "Dr. Suresh Reddy" },
  ];

  const electiveCourses = {
    openElective: [
      "Machine Learning Fundamentals",
      "Cloud Computing",
      "Digital Marketing",
      "Data Science Essentials",
      "Cybersecurity Basics",
    ],
    professionalElective: [
      "Advanced Algorithms",
      "Computer Networks",
      "Software Engineering",
      "Database Management Systems",
      "Web Development",
    ],
    honor: [
      "Research Methodology",
      "Advanced Mathematics",
      "Engineering Ethics",
      "Innovation and Entrepreneurship",
    ],
    minor: [
      "Artificial Intelligence Minor",
      "Data Analytics Minor",
      "IoT Minor",
      "Blockchain Minor",
    ],
  };

  const getRandomElectives = () => {
    return {
      openElective: electiveCourses.openElective.slice(
        0,
        Math.floor(Math.random() * 3) + 2,
      ),
      professionalElective: electiveCourses.professionalElective.slice(
        0,
        Math.floor(Math.random() * 3) + 2,
      ),
      honor: electiveCourses.honor.slice(0, Math.floor(Math.random() * 2) + 1),
      minor: electiveCourses.minor.slice(0, Math.floor(Math.random() * 2) + 1),
    };
  };

  const handleCreateCurriculum = () => {
    if (newCurriculumName && newCurriculumYear) {
      const newCurriculum = {
        id: curricula.length + 1,
        name: newCurriculumName,
        year: newCurriculumYear,
        status: "Active",
      };
      setCurricula([...curricula, newCurriculum]);
      setNewCurriculumName("");
      setNewCurriculumYear("");
      setShowCreateModal(false);
    }
  };

  const handleSendToHODs = (curriculumId, semesterId) => {
    const key = `${curriculumId}-${semesterId}`;
    const approvals = departments.map((dept) => ({
      ...dept,
      status: "Not Submitted", // Initial status when sent to HODs
      electives: null, // No electives until HOD submits
      timestamp: new Date().toISOString(),
      submitted: Math.random() > 0.3, // Dummy: some HODs have submitted, some haven't
    }));
    // For demo purposes, let's make some HODs have submitted
    approvals.forEach((hod, index) => {
      if (hod.submitted) {
        hod.status = Math.random() > 0.5 ? "Approved" : "Pending";
        hod.electives = getRandomElectives();
      }
    });
    setHodApprovals({ ...hodApprovals, [key]: approvals });
    setShowSendConfirmation(false);
    setSelectedSemester(null);
  };

  const handleApproveHOD = (curriculumId, semesterId, hodId) => {
    const key = `${curriculumId}-${semesterId}`;
    const updatedApprovals = hodApprovals[key].map((hod) =>
      hod.id === hodId ? { ...hod, status: "Approved" } : hod,
    );
    setHodApprovals({ ...hodApprovals, [key]: updatedApprovals });
    setSelectedHOD(null);
  };

  const handleRejectHOD = (curriculumId, semesterId, hodId) => {
    const key = `${curriculumId}-${semesterId}`;
    const updatedApprovals = hodApprovals[key].map((hod) =>
      hod.id === hodId ? { ...hod, status: "Rejected", rejectionReason } : hod,
    );
    setHodApprovals({ ...hodApprovals, [key]: updatedApprovals });
    setSelectedHOD(null);
    setShowRejectModal(false);
    setRejectionReason("");
  };

  const openRejectModal = () => {
    setShowRejectModal(true);
  };

  const handleHODCardClick = (hod) => {
    setSelectedHOD(hod);
  };

  const getApprovalKey = (curriculumId, semesterId) => {
    return `${curriculumId}-${semesterId}`;
  };

  return (
    <MainLayout
      title="Elective Management"
      subtitle="Manage elective courses and HOD approvals"
    >
      {/* Main View: Curricula Cards */}
      {!selectedCurriculum && !selectedHOD && (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {curricula.map((curriculum) => (
            <div
              key={curriculum.id}
              onClick={() => setSelectedCurriculum(curriculum)}
              className="bg-white rounded-xl shadow-md hover:shadow-xl transition-all duration-300 cursor-pointer border border-gray-200 overflow-hidden group"
            >
              <div
                className="h-2"
                style={{
                  background:
                    "linear-gradient(to right, rgb(67, 113, 229), rgb(47, 93, 209))",
                }}
              />
              <div className="p-6">
                <div className="flex items-center justify-between mb-4">
                  <h3 className="text-xl font-bold text-gray-900 group-hover:text-blue-600 transition-colors">
                    {curriculum.name}
                  </h3>
                  <span
                    className={`px-3 py-1 rounded-full text-xs font-semibold ${
                      curriculum.status === "Active"
                        ? "bg-green-100 text-green-800"
                        : "bg-gray-100 text-gray-800"
                    }`}
                  >
                    {curriculum.status}
                  </span>
                </div>
                <p className="text-gray-600 mb-4">
                  Academic Year: {curriculum.year}
                </p>
                <div className="flex items-center text-blue-600 font-medium">
                  <span>View Semesters</span>
                  <svg
                    className="w-5 h-5 ml-2 transform group-hover:translate-x-1 transition-transform"
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
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Semester View */}
      {selectedCurriculum && !selectedSemester && !selectedHOD && (
        <div>
          <button
            onClick={() => setSelectedCurriculum(null)}
            className="mb-6 flex items-center text-gray-600 hover:text-gray-900 font-medium"
          >
            <svg
              className="w-5 h-5 mr-2"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M15 19l-7-7 7-7"
              />
            </svg>
            Back to Curricula
          </button>

          <div className="bg-white rounded-xl shadow-md p-6 mb-6">
            <h2 className="text-2xl font-bold text-gray-900 mb-2">
              {selectedCurriculum.name}
            </h2>
            <p className="text-gray-600">
              Select a semester to manage electives
            </p>
          </div>

          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            {semesters.map((sem) => {
              const approvalKey = getApprovalKey(selectedCurriculum.id, sem);
              const hasApprovals = hodApprovals[approvalKey];
              const allApproved = hasApprovals?.every(
                (a) => a.status === "Approved",
              );

              return (
                <div
                  key={sem}
                  onClick={() => setSelectedSemester(sem)}
                  className="bg-white rounded-xl shadow-md hover:shadow-xl transition-all duration-300 cursor-pointer border-2 border-gray-200 hover:border-blue-500 p-6 group relative overflow-hidden"
                >
                  <div
                    className="absolute top-0 left-0 right-0 h-1"
                    style={{
                      background: hasApprovals
                        ? allApproved
                          ? "linear-gradient(to right, rgb(34, 197, 94), rgb(22, 163, 74))"
                          : "linear-gradient(to right, rgb(251, 191, 36), rgb(245, 158, 11))"
                        : "transparent",
                    }}
                  />
                  <div className="text-center">
                    <div
                      className="w-16 h-16 mx-auto mb-3 rounded-full flex items-center justify-center text-white font-bold text-xl"
                      style={{
                        background:
                          "linear-gradient(to bottom right, rgb(67, 113, 229), rgb(47, 93, 209))",
                      }}
                    >
                      {sem}
                    </div>
                    <h3 className="text-lg font-bold text-gray-900 mb-1">
                      Semester {sem}
                    </h3>
                    {hasApprovals && (
                      <p className="text-xs text-gray-600">
                        {
                          hodApprovals[approvalKey].filter(
                            (a) => a.status === "Approved",
                          ).length
                        }
                        /{hodApprovals[approvalKey].length} Approved
                      </p>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      )}

      {/* Semester Detail View */}
      {selectedCurriculum && selectedSemester && !selectedHOD && (
        <div>
          <button
            onClick={() => setSelectedSemester(null)}
            className="mb-6 flex items-center text-gray-600 hover:text-gray-900 font-medium"
          >
            <svg
              className="w-5 h-5 mr-2"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M15 19l-7-7 7-7"
              />
            </svg>
            Back to Semesters
          </button>

          <div className="bg-white rounded-xl shadow-md p-6 mb-6">
            <div className="flex items-center justify-between">
              <div>
                <h2 className="text-2xl font-bold text-gray-900 mb-2">
                  {selectedCurriculum.name} - Semester {selectedSemester}
                </h2>
                <p className="text-gray-600">
                  Manage elective approvals for this semester
                </p>
              </div>
              <button
                onClick={() => setShowSendConfirmation(true)}
                className="px-6 py-3 text-white rounded-lg shadow-md hover:shadow-lg transition-all duration-200"
                style={{
                  background:
                    "linear-gradient(to right, rgb(67, 113, 229), rgb(47, 93, 209))",
                }}
              >
                <div className="flex items-center space-x-2">
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
                      d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"
                    />
                  </svg>
                  <span>Send to All HODs</span>
                </div>
              </button>
            </div>
          </div>

          {/* HOD Approval Cards */}
          {hodApprovals[
            getApprovalKey(selectedCurriculum.id, selectedSemester)
          ] && (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {hodApprovals[
                getApprovalKey(selectedCurriculum.id, selectedSemester)
              ].map((hod) => (
                <div
                  key={hod.id}
                  onClick={() => handleHODCardClick(hod)}
                  className="bg-white rounded-xl shadow-md border border-gray-200 overflow-hidden cursor-pointer hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1"
                >
                  <div
                    className={`h-2 ${
                      hod.status === "Approved"
                        ? "bg-gradient-to-r from-green-500 to-green-600"
                        : hod.status === "Rejected"
                          ? "bg-gradient-to-r from-red-500 to-red-600"
                          : hod.status === "Not Submitted"
                            ? "bg-gradient-to-r from-gray-400 to-gray-500"
                            : "bg-gradient-to-r from-yellow-500 to-yellow-600"
                    }`}
                  />
                  <div className="p-6">
                    <div className="flex items-center mb-4">
                      <div
                        className="w-12 h-12 rounded-full flex items-center justify-center text-white font-bold text-lg mr-4"
                        style={{
                          background:
                            "linear-gradient(to bottom right, rgb(67, 113, 229), rgb(47, 93, 209))",
                        }}
                      >
                        {hod.name.substring(0, 2)}
                      </div>
                      <div className="flex-1">
                        <h3 className="text-lg font-bold text-gray-900">
                          {hod.name} Department
                        </h3>
                        <p className="text-sm text-gray-600">{hod.hodName}</p>
                      </div>
                    </div>
                    <div className="flex items-center justify-between">
                      <span className="text-sm text-gray-600 font-medium">
                        Status:
                      </span>
                      <span
                        className={`px-3 py-1 rounded-full text-xs font-bold ${
                          hod.status === "Approved"
                            ? "bg-green-100 text-green-800"
                            : hod.status === "Rejected"
                              ? "bg-red-100 text-red-800"
                              : hod.status === "Not Submitted"
                                ? "bg-gray-100 text-gray-800"
                                : "bg-yellow-100 text-yellow-800"
                        }`}
                      >
                        {hod.status}
                      </span>
                    </div>
                    <div className="mt-3 flex items-center text-blue-600 text-sm font-medium">
                      <span>View Details</span>
                      <svg
                        className="w-4 h-4 ml-1"
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
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )}

          {!hodApprovals[
            getApprovalKey(selectedCurriculum.id, selectedSemester)
          ] && (
            <div className="bg-gray-50 rounded-xl border-2 border-dashed border-gray-300 p-12 text-center">
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
                  d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"
                />
              </svg>
              <h3 className="text-xl font-bold text-gray-600 mb-2">
                No requests sent yet
              </h3>
              <p className="text-gray-500 mb-4">
                Click "Send to All HODs" to request elective approvals
              </p>
            </div>
          )}
        </div>
      )}

      {/* HOD Detail View */}
      {selectedHOD && (
        <div>
          <button
            onClick={() => setSelectedHOD(null)}
            className="mb-6 flex items-center text-gray-600 hover:text-gray-900 font-medium"
          >
            <svg
              className="w-5 h-5 mr-2"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M15 19l-7-7 7-7"
              />
            </svg>
            Back to HOD List
          </button>

          {/* HOD Header */}
          <div className="bg-white rounded-xl shadow-md p-8 mb-6">
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-6">
                <div
                  className="w-20 h-20 rounded-full flex items-center justify-center text-white font-bold text-3xl"
                  style={{
                    background:
                      "linear-gradient(to bottom right, rgb(67, 113, 229), rgb(47, 93, 209))",
                  }}
                >
                  {selectedHOD.name.substring(0, 2)}
                </div>
                <div>
                  <h2 className="text-3xl font-bold text-gray-900 mb-1">
                    {selectedHOD.name} Department
                  </h2>
                  <p className="text-lg text-gray-600">{selectedHOD.hodName}</p>
                </div>
              </div>
              <div>
                <span
                  className={`px-6 py-3 rounded-full text-base font-bold ${
                    selectedHOD.status === "Approved"
                      ? "bg-green-100 text-green-800"
                      : selectedHOD.status === "Rejected"
                        ? "bg-red-100 text-red-800"
                        : selectedHOD.status === "Not Submitted"
                          ? "bg-gray-100 text-gray-800"
                          : "bg-yellow-100 text-yellow-800"
                  }`}
                >
                  {selectedHOD.status}
                </span>
              </div>
            </div>
          </div>

          {/* Show waiting message if HOD hasn't submitted */}
          {selectedHOD.status === "Not Submitted" ? (
            <div className="bg-white rounded-xl shadow-md p-12 text-center">
              <div className="max-w-md mx-auto">
                <div
                  className="w-24 h-24 mx-auto mb-6 rounded-full flex items-center justify-center"
                  style={{
                    background:
                      "linear-gradient(to bottom right, rgb(156, 163, 175), rgb(107, 114, 128))",
                  }}
                >
                  <svg
                    className="w-12 h-12 text-white"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"
                    />
                  </svg>
                </div>
                <h3 className="text-2xl font-bold text-gray-900 mb-3">
                  Waiting for HOD's Response
                </h3>
                <p className="text-gray-600 text-lg mb-2">
                  The HOD has not yet submitted their elective selections for
                  approval.
                </p>
                <p className="text-gray-500">
                  Sent on{" "}
                  {new Date(selectedHOD.timestamp).toLocaleDateString("en-US", {
                    month: "long",
                    day: "numeric",
                    year: "numeric",
                  })}
                </p>
              </div>
            </div>
          ) : (
            <>
              {/* Elective Sections */}
              <div className="space-y-6">
                {/* Open Elective */}
                <div className="bg-white rounded-xl shadow-md overflow-hidden">
                  <div className="bg-gradient-to-r from-blue-600 to-blue-700 px-6 py-4">
                    <div className="flex items-center text-white">
                      <div className="w-12 h-12 bg-white bg-opacity-20 rounded-lg flex items-center justify-center mr-4">
                        <svg
                          className="w-7 h-7"
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
                      </div>
                      <div>
                        <h3 className="text-2xl font-bold">Open Elective</h3>
                        <p className="text-blue-100 text-sm">
                          {selectedHOD.electives.openElective.length} courses
                          selected
                        </p>
                      </div>
                    </div>
                  </div>
                  <div className="p-6 space-y-3">
                    {selectedHOD.electives.openElective.map((course, index) => (
                      <div
                        key={index}
                        className="flex items-center bg-blue-50 rounded-lg px-5 py-4 border-l-4 border-blue-600"
                      >
                        <div className="w-8 h-8 bg-blue-600 rounded-full flex items-center justify-center text-white font-bold text-sm mr-4">
                          {index + 1}
                        </div>
                        <span className="text-gray-800 font-medium text-lg">
                          {course}
                        </span>
                      </div>
                    ))}
                  </div>
                </div>

                {/* Professional Elective */}
                <div className="bg-white rounded-xl shadow-md overflow-hidden">
                  <div className="bg-gradient-to-r from-purple-600 to-purple-700 px-6 py-4">
                    <div className="flex items-center text-white">
                      <div className="w-12 h-12 bg-white bg-opacity-20 rounded-lg flex items-center justify-center mr-4">
                        <svg
                          className="w-7 h-7"
                          fill="none"
                          stroke="currentColor"
                          viewBox="0 0 24 24"
                        >
                          <path
                            strokeLinecap="round"
                            strokeLinejoin="round"
                            strokeWidth={2}
                            d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
                          />
                        </svg>
                      </div>
                      <div>
                        <h3 className="text-2xl font-bold">
                          Professional Elective
                        </h3>
                        <p className="text-purple-100 text-sm">
                          {selectedHOD.electives.professionalElective.length}{" "}
                          courses selected
                        </p>
                      </div>
                    </div>
                  </div>
                  <div className="p-6 space-y-3">
                    {selectedHOD.electives.professionalElective.map(
                      (course, index) => (
                        <div
                          key={index}
                          className="flex items-center bg-purple-50 rounded-lg px-5 py-4 border-l-4 border-purple-600"
                        >
                          <div className="w-8 h-8 bg-purple-600 rounded-full flex items-center justify-center text-white font-bold text-sm mr-4">
                            {index + 1}
                          </div>
                          <span className="text-gray-800 font-medium text-lg">
                            {course}
                          </span>
                        </div>
                      ),
                    )}
                  </div>
                </div>

                {/* Honor */}
                <div className="bg-white rounded-xl shadow-md overflow-hidden">
                  <div className="bg-gradient-to-r from-amber-600 to-amber-700 px-6 py-4">
                    <div className="flex items-center text-white">
                      <div className="w-12 h-12 bg-white bg-opacity-20 rounded-lg flex items-center justify-center mr-4">
                        <svg
                          className="w-7 h-7"
                          fill="none"
                          stroke="currentColor"
                          viewBox="0 0 24 24"
                        >
                          <path
                            strokeLinecap="round"
                            strokeLinejoin="round"
                            strokeWidth={2}
                            d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z"
                          />
                        </svg>
                      </div>
                      <div>
                        <h3 className="text-2xl font-bold">Honor</h3>
                        <p className="text-amber-100 text-sm">
                          {selectedHOD.electives.honor.length} courses selected
                        </p>
                      </div>
                    </div>
                  </div>
                  <div className="p-6 space-y-3">
                    {selectedHOD.electives.honor.map((course, index) => (
                      <div
                        key={index}
                        className="flex items-center bg-amber-50 rounded-lg px-5 py-4 border-l-4 border-amber-600"
                      >
                        <div className="w-8 h-8 bg-amber-600 rounded-full flex items-center justify-center text-white font-bold text-sm mr-4">
                          {index + 1}
                        </div>
                        <span className="text-gray-800 font-medium text-lg">
                          {course}
                        </span>
                      </div>
                    ))}
                  </div>
                </div>

                {/* Minor */}
                <div className="bg-white rounded-xl shadow-md overflow-hidden">
                  <div className="bg-gradient-to-r from-emerald-600 to-emerald-700 px-6 py-4">
                    <div className="flex items-center text-white">
                      <div className="w-12 h-12 bg-white bg-opacity-20 rounded-lg flex items-center justify-center mr-4">
                        <svg
                          className="w-7 h-7"
                          fill="none"
                          stroke="currentColor"
                          viewBox="0 0 24 24"
                        >
                          <path
                            strokeLinecap="round"
                            strokeLinejoin="round"
                            strokeWidth={2}
                            d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z"
                          />
                        </svg>
                      </div>
                      <div>
                        <h3 className="text-2xl font-bold">Minor</h3>
                        <p className="text-emerald-100 text-sm">
                          {selectedHOD.electives.minor.length} courses selected
                        </p>
                      </div>
                    </div>
                  </div>
                  <div className="p-6 space-y-3">
                    {selectedHOD.electives.minor.map((course, index) => (
                      <div
                        key={index}
                        className="flex items-center bg-emerald-50 rounded-lg px-5 py-4 border-l-4 border-emerald-600"
                      >
                        <div className="w-8 h-8 bg-emerald-600 rounded-full flex items-center justify-center text-white font-bold text-sm mr-4">
                          {index + 1}
                        </div>
                        <span className="text-gray-800 font-medium text-lg">
                          {course}
                        </span>
                      </div>
                    ))}
                  </div>
                </div>
              </div>

              {/* Action Buttons */}
              {selectedHOD.status === "Pending" && (
                <div className="sticky bottom-0 bg-white border-t border-gray-200 mt-8 -mx-8 -mb-8 px-8 py-6 rounded-b-xl">
                  <div className="flex space-x-4">
                    <button
                      onClick={openRejectModal}
                      className="flex-1 px-8 py-4 bg-white border-2 border-red-500 text-red-600 rounded-lg hover:bg-red-50 font-bold text-lg transition-all duration-200 flex items-center justify-center space-x-3"
                    >
                      <svg
                        className="w-6 h-6"
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
                      <span>Reject Selection</span>
                    </button>
                    <button
                      onClick={() =>
                        handleApproveHOD(
                          selectedCurriculum.id,
                          selectedSemester,
                          selectedHOD.id,
                        )
                      }
                      className="flex-1 px-8 py-4 text-white rounded-lg font-bold text-lg shadow-lg hover:shadow-xl transition-all duration-200 flex items-center justify-center space-x-3"
                      style={{
                        background:
                          "linear-gradient(to right, rgb(34, 197, 94), rgb(22, 163, 74))",
                      }}
                    >
                      <svg
                        className="w-6 h-6"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          strokeWidth={2}
                          d="M5 13l4 4L19 7"
                        />
                      </svg>
                      <span>Approve Selection</span>
                    </button>
                  </div>
                </div>
              )}
            </>
          )}
        </div>
      )}

      {/* Create Curriculum Modal */}
      {showCreateModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl shadow-2xl max-w-md w-full p-8">
            <h2 className="text-2xl font-bold text-gray-900 mb-6">
              Create New Curriculum
            </h2>
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Curriculum Name
                </label>
                <input
                  type="text"
                  value={newCurriculumName}
                  onChange={(e) => setNewCurriculumName(e.target.value)}
                  placeholder="e.g., 2023 Curriculum"
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none"
                />
              </div>
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Academic Year
                </label>
                <input
                  type="text"
                  value={newCurriculumYear}
                  onChange={(e) => setNewCurriculumYear(e.target.value)}
                  placeholder="e.g., 2023"
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none"
                />
              </div>
            </div>
            <div className="flex space-x-4 mt-8">
              <button
                onClick={() => setShowCreateModal(false)}
                className="flex-1 px-4 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 font-medium transition-colors"
              >
                Cancel
              </button>
              <button
                onClick={handleCreateCurriculum}
                className="flex-1 px-4 py-3 text-white rounded-lg font-medium shadow-md hover:shadow-lg transition-all duration-200"
                style={{
                  background:
                    "linear-gradient(to right, rgb(67, 113, 229), rgb(47, 93, 209))",
                }}
              >
                Create
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Send Confirmation Modal */}
      {showSendConfirmation && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl shadow-2xl max-w-md w-full p-8">
            <div className="text-center mb-6">
              <div
                className="w-16 h-16 mx-auto mb-4 rounded-full flex items-center justify-center"
                style={{
                  background:
                    "linear-gradient(to bottom right, rgb(67, 113, 229), rgb(47, 93, 209))",
                }}
              >
                <svg
                  className="w-8 h-8 text-white"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"
                  />
                </svg>
              </div>
              <h2 className="text-2xl font-bold text-gray-900 mb-2">
                Send to All HODs?
              </h2>
              <p className="text-gray-600">
                This will send elective selection requests to all{" "}
                {departments.length} department HODs for Semester{" "}
                {selectedSemester}.
              </p>
            </div>
            <div className="flex space-x-4">
              <button
                onClick={() => setShowSendConfirmation(false)}
                className="flex-1 px-4 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 font-medium transition-colors"
              >
                Cancel
              </button>
              <button
                onClick={() =>
                  handleSendToHODs(selectedCurriculum.id, selectedSemester)
                }
                className="flex-1 px-4 py-3 text-white rounded-lg font-medium shadow-md hover:shadow-lg transition-all duration-200"
                style={{
                  background:
                    "linear-gradient(to right, rgb(67, 113, 229), rgb(47, 93, 209))",
                }}
              >
                Send Now
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Reject Modal */}
      {showRejectModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl shadow-2xl max-w-md w-full p-8">
            <h2 className="text-2xl font-bold text-gray-900 mb-6">
              Reject HOD Selection
            </h2>
            <div className="mb-6">
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Rejection Reason (Optional)
              </label>
              <textarea
                value={rejectionReason}
                onChange={(e) => setRejectionReason(e.target.value)}
                placeholder="Provide a reason for rejection..."
                rows={4}
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-red-500 focus:border-transparent outline-none resize-none"
              />
            </div>
            <div className="flex space-x-4">
              <button
                onClick={() => {
                  setShowRejectModal(false);
                  setRejectionReason("");
                }}
                className="flex-1 px-4 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 font-medium transition-colors"
              >
                Cancel
              </button>
              <button
                onClick={() =>
                  handleRejectHOD(
                    selectedCurriculum.id,
                    selectedSemester,
                    selectedHOD.id,
                  )
                }
                className="flex-1 px-4 py-3 bg-gradient-to-r from-red-600 to-red-700 text-white rounded-lg font-medium shadow-md hover:shadow-lg transition-all duration-200"
              >
                Reject
              </button>
            </div>
          </div>
        </div>
      )}
    </MainLayout>
  );
};

export default ElectiveManagementPage;
