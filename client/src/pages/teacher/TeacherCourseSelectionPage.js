import React, { useState, useEffect } from 'react';
import MainLayout from '../../components/MainLayout';
import { API_BASE_URL } from '../../config';

const TeacherCourseSelectionPage = () => {
  const [preferences, setPreferences] = useState([]);
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState({ type: '', text: '' });
  const [showAppealModal, setShowAppealModal] = useState(false);
  const [hasPendingAppeal, setHasPendingAppeal] = useState(false);
  const [appealMessage, setAppealMessage] = useState('');
  const [selectedAppealCategory, setSelectedAppealCategory] = useState('');
  const [isSubmittingAppeal, setIsSubmittingAppeal] = useState(false);

  const teacherId = parseInt(localStorage.getItem('teacher_id') || localStorage.getItem('teacherId'));
  const userName = localStorage.getItem('userName');

  useEffect(() => {
    fetchTeacherData();
    checkPendingAppeal();
  }, []);

  const checkPendingAppeal = async () => {
    try {
      const response = await fetch(
        `${API_BASE_URL}/teachers/course-appeal/pending?faculty_id=${teacherId}`
      );
      const data = await response.json();
      setHasPendingAppeal(data.has_pending_appeal);
    } catch (error) {
      console.error('Error checking pending appeal:', error);
    }
  };

  const fetchTeacherData = async () => {
    try {
      setLoading(true);
      const response = await fetch(`${API_BASE_URL}/teachers/${teacherId}/course-preferences`);
      if (response.ok) {
        const data = await response.json();
        setPreferences(data.preferences || []);
      }
    } catch (error) {
      console.error('Error fetching preferences:', error);
      setMessage({ type: 'error', text: 'Failed to load course preferences' });
    } finally {
      setLoading(false);
    }
  };

  const submitAppeal = async () => {
    if (!selectedAppealCategory.trim()) {
      setMessage({ type: 'error', text: 'Please select a course category' });
      return;
    }
    
    if (!appealMessage.trim()) {
      setMessage({ type: 'error', text: 'Please enter an appeal message' });
      return;
    }

    setIsSubmittingAppeal(true);
    try {
      const response = await fetch(`${API_BASE_URL}/teachers/course-appeal/create`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          faculty_id: teacherId,
          course_category: selectedAppealCategory,
          appeal_message: appealMessage
        })
      });

      if (response.ok) {
        setMessage({ type: 'success', text: 'Appeal submitted successfully. HR will review your request.' });
        setShowAppealModal(false);
        setAppealMessage('');
        setSelectedAppealCategory('');
        setHasPendingAppeal(true);
        setTimeout(() => setMessage({ type: '', text: '' }), 3000);
      } else {
        const errorText = await response.text();
        setMessage({ type: 'error', text: errorText || 'Failed to submit appeal' });
      }
    } catch (error) {
      console.error('Error submitting appeal:', error);
      setMessage({ type: 'error', text: 'Network error. Please try again.' });
    } finally {
      setIsSubmittingAppeal(false);
    }
  };

  if (loading) {
    return (
      <MainLayout>
        <div className="flex items-center justify-center min-h-screen">
          <div className="text-2xl text-gray-700">Loading course preferences...</div>
        </div>
      </MainLayout>
    );
  }

  return (
    <MainLayout>
      <div className="max-w-6xl mx-auto py-6">
        {/* Header with Appeal Button */}
        <div className="mb-6 flex justify-between items-start">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Course Selection</h1>
            <p className="text-gray-600 mt-1">Teacher: {userName}</p>
          </div>
          <button
            onClick={() => setShowAppealModal(true)}
            className={`px-6 py-2 rounded font-medium transition ${
              hasPendingAppeal
                ? 'bg-orange-500 text-white cursor-not-allowed'
                : 'bg-blue-600 text-white hover:bg-blue-700'
            }`}
            disabled={hasPendingAppeal}
          >
            {hasPendingAppeal ? '⏳ Appeal Pending' : '📋 File Appeal'}
          </button>
        </div>

        {/* Pending Appeal Warning */}
        {hasPendingAppeal && (
          <div className="mb-6 p-4 bg-orange-50 border border-orange-300 rounded">
            <p className="text-orange-800 font-medium">
              ⚠️ You have a pending appeal. You cannot modify your course selections until it is resolved by HR.
            </p>
          </div>
        )}

        {/* Message Display */}
        {message.text && (
          <div
            className={`mb-4 p-3 rounded text-base font-medium ${
              message.type === 'success'
                ? 'bg-green-50 text-green-800 border border-green-200'
                : 'bg-red-50 text-red-800 border border-red-200'
            }`}
          >
            {message.text}
          </div>
        )}

        {/* Preferences List */}
        <div className="bg-white rounded-lg shadow p-6">
          {preferences.length > 0 ? (
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b-2 border-gray-200">
                    <th className="text-left py-3 px-4 font-semibold text-gray-900">Course Code</th>
                    <th className="text-left py-3 px-4 font-semibold text-gray-900">Course Name</th>
                    <th className="text-left py-3 px-4 font-semibold text-gray-900">Type</th>
                    <th className="text-left py-3 px-4 font-semibold text-gray-900">Status</th>
                  </tr>
                </thead>
                <tbody>
                  {preferences.map((pref, idx) => (
                    <tr key={idx} className="border-b border-gray-100 hover:bg-gray-50">
                      <td className="py-3 px-4 text-gray-900 font-medium">{pref.course_id}</td>
                      <td className="py-3 px-4 text-gray-700">{pref.course_name || 'N/A'}</td>
                      <td className="py-3 px-4 text-gray-700">{pref.course_type || 'N/A'}</td>
                      <td className="py-3 px-4">
                        <span className={`px-3 py-1 rounded text-xs font-medium ${
                          pref.status === 'approved'
                            ? 'bg-green-100 text-green-800'
                            : 'bg-yellow-100 text-yellow-800'
                        }`}>
                          {pref.status || 'Pending'}
                        </span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          ) : (
            <p className="text-gray-600 text-center py-6">No course preferences assigned yet.</p>
          )}
        </div>
      </div>

      {/* Appeal Modal */}
      {showAppealModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg shadow-xl max-w-md w-full p-6">
            <h2 className="text-2xl font-bold text-gray-900 mb-4">File an Appeal</h2>
            
            <div className="space-y-4">
              {/* Category Dropdown */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Course Category *
                </label>
                <select
                  value={selectedAppealCategory}
                  onChange={(e) => setSelectedAppealCategory(e.target.value)}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                >
                  <option value="">Select a category...</option>
                  <option value="theory">Theory</option>
                  <option value="lab">Lab</option>
                  <option value="theory_with_lab">Theory with Lab</option>
                </select>
              </div>

              {/* Message Textarea */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Appeal Message *
                </label>
                <textarea
                  value={appealMessage}
                  onChange={(e) => setAppealMessage(e.target.value)}
                  placeholder="Explain your reason for appeal..."
                  rows="4"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
                />
              </div>

              {/* Buttons */}
              <div className="flex gap-3 pt-4">
                <button
                  onClick={() => setShowAppealModal(false)}
                  className="flex-1 px-4 py-2 border border-gray-300 rounded-lg text-gray-700 font-medium hover:bg-gray-50"
                  disabled={isSubmittingAppeal}
                >
                  Cancel
                </button>
                <button
                  onClick={submitAppeal}
                  className="flex-1 px-4 py-2 bg-blue-600 text-white rounded-lg font-medium hover:bg-blue-700 disabled:opacity-50"
                  disabled={isSubmittingAppeal || !appealMessage.trim() || !selectedAppealCategory}
                >
                  {isSubmittingAppeal ? 'Submitting...' : 'Submit Appeal'}
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </MainLayout>
  );
};

export default TeacherCourseSelectionPage;
