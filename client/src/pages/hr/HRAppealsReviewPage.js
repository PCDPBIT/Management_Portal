import React, { useState, useEffect } from 'react';
import MainLayout from '../../components/MainLayout';
import { API_BASE_URL } from '../../config';

const HRAppealsReviewPage = () => {
  const [appeals, setAppeals] = useState([]);
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState({ type: '', text: '' });
  const [statusFilter, setStatusFilter] = useState('pending');
  const [showDecisionModal, setShowDecisionModal] = useState(false);
  const [selectedAppeal, setSelectedAppeal] = useState(null);
  const [decision, setDecision] = useState('');
  const [hrMessage, setHrMessage] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    fetchAppeals();
  }, [statusFilter]);

  const fetchAppeals = async () => {
    try {
      setLoading(true);
      const url = `${API_BASE_URL}/hr/appeals?status=${statusFilter}`;
      const response = await fetch(url);
      
      if (response.ok) {
        const data = await response.json();
        setAppeals(data || []);
      } else {
        setMessage({ type: 'error', text: 'Failed to fetch appeals' });
      }
    } catch (error) {
      console.error('Error fetching appeals:', error);
      setMessage({ type: 'error', text: 'Network error. Please try again.' });
    } finally {
      setLoading(false);
    }
  };

  const openDecisionModal = (appeal) => {
    setSelectedAppeal(appeal);
    setDecision('');
    setHrMessage('');
    setShowDecisionModal(true);
  };

  const handleDecision = async () => {
    if (!decision) {
      setMessage({ type: 'error', text: 'Please select a decision' });
      return;
    }

    setIsSubmitting(true);
    try {
      const requestBody = {
        hr_action: decision,
        hr_message: hrMessage || null
      };

      const response = await fetch(
        `${API_BASE_URL}/hr/appeals/${selectedAppeal.id}/resolve`,
        {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(requestBody)
        }
      );

      if (response.ok) {
        setMessage({ type: 'success', text: 'Appeal decision saved successfully' });
        setShowDecisionModal(false);
        setSelectedAppeal(null);
        fetchAppeals();
        setTimeout(() => setMessage({ type: '', text: '' }), 3000);
      } else {
        const errorText = await response.text();
        setMessage({ type: 'error', text: errorText || 'Failed to save decision' });
      }
    } catch (error) {
      console.error('Error saving decision:', error);
      setMessage({ type: 'error', text: 'Network error. Please try again.' });
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <MainLayout>
      <div className="max-w-7xl mx-auto py-6">
        {/* Header */}
        <div className="mb-6">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">Teacher Course Appeals</h1>
          <p className="text-gray-600">Review and respond to teacher course limit appeals</p>
        </div>

        {/* Message */}
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

        {/* Filter Tabs */}
        <div className="mb-6 flex gap-2">
          <button
            onClick={() => setStatusFilter('pending')}
            className={`px-6 py-2 rounded font-medium transition ${
              statusFilter === 'pending'
                ? 'bg-orange-600 text-white'
                : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
            }`}
          >
            Pending ({appeals.filter(a => !a.appeal_status).length})
          </button>
          <button
            onClick={() => setStatusFilter('resolved')}
            className={`px-6 py-2 rounded font-medium transition ${
              statusFilter === 'resolved'
                ? 'bg-green-600 text-white'
                : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
            }`}
          >
            Resolved
          </button>
          <button
            onClick={() => setStatusFilter('all')}
            className={`px-6 py-2 rounded font-medium transition ${
              statusFilter === 'all'
                ? 'bg-blue-600 text-white'
                : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
            }`}
          >
            All Appeals
          </button>
        </div>

        {/* Appeals Table */}
        {loading ? (
          <div className="text-center py-12">
            <p className="text-xl text-gray-600">Loading appeals...</p>
          </div>
        ) : appeals.length === 0 ? (
          <div className="text-center py-12 bg-white rounded-lg shadow">
            <p className="text-xl text-gray-600">No appeals found</p>
          </div>
        ) : (
          <div className="bg-white rounded-lg shadow overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead className="bg-gray-50 border-b-2 border-gray-200">
                  <tr>
                    <th className="text-left py-3 px-4 font-semibold text-gray-900">Teacher</th>
                    <th className="text-left py-3 px-4 font-semibold text-gray-900">Message</th>
                    <th className="text-left py-3 px-4 font-semibold text-gray-900">Status</th>
                    <th className="text-left py-3 px-4 font-semibold text-gray-900">Decision</th>
                    <th className="text-left py-3 px-4 font-semibold text-gray-900">Date</th>
                    <th className="text-left py-3 px-4 font-semibold text-gray-900">Action</th>
                  </tr>
                </thead>
                <tbody>
                  {appeals.map((appeal) => (
                    <tr key={appeal.id} className="border-b border-gray-100 hover:bg-gray-50">
                      <td className="py-3 px-4">
                        <p className="font-medium text-gray-900">{appeal.teacher_name}</p>
                        <p className="text-xs text-gray-600">{appeal.teacher_email}</p>
                      </td>
                      <td className="py-3 px-4">
                        <p className="text-gray-700 max-w-xs truncate" title={appeal.appeal_message}>
                          {appeal.appeal_message}
                        </p>
                      </td>
                      <td className="py-3 px-4">
                        <span
                          className={`px-3 py-1 rounded text-xs font-medium ${
                            appeal.appeal_status
                              ? 'bg-green-100 text-green-800'
                              : 'bg-orange-100 text-orange-800'
                          }`}
                        >
                          {appeal.appeal_status ? 'Resolved' : 'Pending'}
                        </span>
                      </td>
                      <td className="py-3 px-4">
                        {appeal.hr_action?.String ? (
                          <div>
                            <span
                              className={`px-2 py-1 rounded text-xs font-bold ${
                                appeal.hr_action.String === 'REJECTED'
                                  ? 'bg-red-100 text-red-800'
                                  : 'bg-green-100 text-green-800'
                              }`}
                            >
                              {appeal.hr_action.String}
                            </span>
                          </div>
                        ) : (
                          <span className="text-gray-400 text-xs">-</span>
                        )}
                      </td>
                      <td className="py-3 px-4">
                        <p className="text-xs text-gray-600">
                          {new Date(appeal.created_at).toLocaleDateString()}
                        </p>
                        {appeal.appeal_status && (
                          <p className="text-xs text-gray-500">
                            Resolved: {new Date(appeal.updated_at).toLocaleDateString()}
                          </p>
                        )}
                      </td>
                      <td className="py-3 px-4">
                        {!appeal.appeal_status ? (
                          <button
                            onClick={() => openDecisionModal(appeal)}
                            className="px-4 py-1 bg-blue-600 text-white rounded text-xs font-medium hover:bg-blue-700"
                          >
                            Review
                          </button>
                        ) : (
                          <button
                            onClick={() => openDecisionModal(appeal)}
                            className="px-4 py-1 bg-gray-300 text-gray-700 rounded text-xs font-medium hover:bg-gray-400"
                          >
                            View
                          </button>
                        )}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}
      </div>

      {/* Decision Modal */}
      {showDecisionModal && selectedAppeal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg shadow-xl max-w-2xl w-full p-6 max-h-[90vh] overflow-y-auto">
            <h2 className="text-2xl font-bold text-gray-900 mb-4">
              {selectedAppeal.appeal_status ? 'Appeal Details' : 'Review Appeal'}
            </h2>

            <div className="space-y-4">
              {/* Teacher Info */}
              <div className="bg-gray-50 p-4 rounded">
                <p className="text-sm text-gray-600 mb-1">Teacher:</p>
                <p className="text-lg font-medium text-gray-900">{selectedAppeal.teacher_name}</p>
                <p className="text-sm text-gray-600">{selectedAppeal.teacher_email}</p>
              </div>

              {/* Appeal Details */}
              <div className="bg-blue-50 p-4 rounded">
                <p className="text-sm text-gray-600 mb-1">Course Category:</p>
                <p className="text-base font-medium text-gray-900 mb-3">{selectedAppeal.course_category}</p>
                <p className="text-sm text-gray-600 mb-1">Appeal Message:</p>
                <p className="text-base text-gray-700">{selectedAppeal.appeal_message}</p>
                <p className="text-xs text-gray-500 mt-2">
                  Submitted: {new Date(selectedAppeal.created_at).toLocaleString()}
                </p>
              </div>

              {/* Decision Section - Only show if not resolved */}
              {!selectedAppeal.appeal_status && (
                <>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Decision *
                    </label>
                    <select
                      value={decision}
                      onChange={(e) => setDecision(e.target.value)}
                      className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    >
                      <option value="">Select decision...</option>
                      <option value="APPROVED">Approve (keep current limit)</option>
                      <option value="APPROVED_WITH_COUNT">Approve with new count</option>
                      <option value="REJECTED">Reject</option>
                    </select>
                  </div>

                  {decision === 'APPROVED_WITH_COUNT' && (
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">
                        New Course Count *
                      </label>
                      <input
                        type="number"
                        value={newCount}
                        onChange={(e) => setNewCount(e.target.value)}
                        placeholder="Enter new course limit..."
                        min="1"
                        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      />
                    </div>
                  )}

                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      HR Message (Optional)
                    </label>
                    <textarea
                      value={hrMessage}
                      onChange={(e) => setHrMessage(e.target.value)}
                      placeholder="Add a message to the teacher..."
                      rows="3"
                      className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
                    />
                  </div>
                </>
              )}

              {/* Show decision if already resolved */}
              {selectedAppeal.appeal_status && (
                <div
                  className={`p-4 rounded border-2 ${
                    selectedAppeal.hr_action?.String === 'REJECTED'
                      ? 'bg-red-50 border-red-300'
                      : 'bg-green-50 border-green-300'
                  }`}
                >
                  <p className="text-sm font-medium mb-2">
                    Decision:{' '}
                    <span
                      className={`ml-2 px-3 py-1 rounded text-sm font-bold ${
                        selectedAppeal.hr_action?.String === 'REJECTED'
                          ? 'bg-red-600 text-white'
                          : 'bg-green-600 text-white'
                      }`}
                    >
                      {selectedAppeal.hr_action?.String}
                    </span>
                  </p>

                  {selectedAppeal.hr_message?.String && (
                    <div>
                      <p className="text-sm text-gray-600 mb-1">HR Message:</p>
                      <p className="text-base text-gray-800">{selectedAppeal.hr_message.String}</p>
                    </div>
                  )}

                  <p className="text-xs text-gray-500 mt-3">
                    Resolved: {selectedAppeal.resolved_at ? new Date(selectedAppeal.resolved_at.Time).toLocaleString() : new Date(selectedAppeal.updated_at).toLocaleString()}
                  </p>
                </div>
              )}

              {/* Buttons */}
              <div className="flex gap-3 pt-4">
                <button
                  onClick={() => setShowDecisionModal(false)}
                  className="flex-1 px-4 py-2 border border-gray-300 rounded-lg text-gray-700 font-medium hover:bg-gray-50"
                  disabled={isSubmitting}
                >
                  {selectedAppeal.appeal_status ? 'Close' : 'Cancel'}
                </button>
                {!selectedAppeal.appeal_status && (
                  <button
                    onClick={handleDecision}
                    className="flex-1 px-4 py-2 bg-blue-600 text-white rounded-lg font-medium hover:bg-blue-700 disabled:opacity-50"
                    disabled={isSubmitting || !decision}
                  >
                    {isSubmitting ? 'Saving...' : 'Save Decision'}
                  </button>
                )}
              </div>
            </div>
          </div>
        </div>
      )}
    </MainLayout>
  );
};

export default HRAppealsReviewPage;
