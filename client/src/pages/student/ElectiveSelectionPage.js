import React, { useState, useEffect } from 'react';
import MainLayout from '../../components/MainLayout';
import { API_BASE_URL } from '../../config';

const ElectiveSelectionPage = () => {
  const [selections, setSelections] = useState({});
  const [totalCreditUsed, setTotalCreditUsed] = useState(0);
  const [isSubmitted, setIsSubmitted] = useState(false);
  const [message, setMessage] = useState({ type: '', text: '' });
  const [loading, setLoading] = useState(true);
  const [electiveData, setElectiveData] = useState(null);
  const [groupedElectives, setGroupedElectives] = useState({});

  const userEmail = localStorage.getItem('userEmail'); // Get email from login
  const userName = localStorage.getItem('userName');
  const userId = localStorage.getItem('userId');

  useEffect(() => {
    fetchElectives();
  }, []);

  const fetchElectives = async () => {
    try {
      setLoading(true);
      const url = `${API_BASE_URL}/students/electives/available?email=${userEmail}`;
      console.log('Fetching from URL:', url);

      const response = await fetch(url);

      if (response.ok) {
        const data = await response.json();
        console.log('Elective Data:', data);
        setElectiveData(data);

        // Group electives by slot (new structure with slots)
        const grouped = {};
        if (data.slots && data.slots.length > 0) {
          data.slots.forEach(slot => {
            // Use slot_name as the category key
            const category = slot.slot_name || 'Unassigned';
            grouped[category] = {
              slot_id: slot.slot_id,
              slot_name: slot.slot_name,
              slot_type: slot.slot_type,
              is_active: slot.is_active,
              courses: slot.courses || []
            };
            console.log(`Slot: ${slot.slot_name}, Type: ${slot.slot_type}`);
          });
        }
        setGroupedElectives(grouped);
        console.log('Grouped Electives:', grouped);

        // Load existing selections from backend response (PRIMARY SOURCE OF TRUTH)
        if (data.existing_selections && Object.keys(data.existing_selections).length > 0) {
          console.log('Loading existing selections from backend:', data.existing_selections);
          setSelections(data.existing_selections);
          calculateTotalCredits(data.existing_selections);

          // Check if already submitted (has selections for all REQUIRED slots only)
          const requiredSlots = data.slots.filter(slot =>
            ['PROFESSIONAL', 'OPEN', 'MIXED'].includes(slot.slot_type)
          );
          const selectedRequiredSlots = Object.keys(data.existing_selections).filter(slotName => {
            const slot = data.slots.find(s => s.slot_name === slotName);
            return slot && ['PROFESSIONAL', 'OPEN', 'MIXED'].includes(slot.slot_type);
          });

          if (selectedRequiredSlots.length === requiredSlots.length && requiredSlots.length > 0) {
            setIsSubmitted(true);
          } else {
            setIsSubmitted(false);
          }
        } else {
          // No existing selections in database - clear any old localStorage data
          console.log('No existing selections found in backend - clearing localStorage');
          setSelections({});
          setIsSubmitted(false);
          setTotalCreditUsed(0);
          // Clear old localStorage data for this semester
          localStorage.removeItem(`elective_selections_${userEmail}_sem${data.next_semester}`);
          localStorage.removeItem(`elective_submitted_${userEmail}_sem${data.next_semester}`);
          localStorage.removeItem(`elective_submission_${userEmail}_sem${data.next_semester}`);
        }
      } else {
        const errorText = await response.text();
        console.error('Error response:', errorText);
        setMessage({ type: 'error', text: errorText || 'Failed to fetch electives' });
      }
    } catch (error) {
      console.error('Error fetching electives:', error);
      setMessage({ type: 'error', text: 'Network error. Please try again.' });
    } finally {
      setLoading(false);
    }
  };

  const loadSavedSelections = (semester) => {
    const savedSelections = localStorage.getItem(`elective_selections_${userEmail}_sem${semester}`);
    const savedSubmitted = localStorage.getItem(`elective_submitted_${userEmail}_sem${semester}`);

    if (savedSelections) {
      const parsed = JSON.parse(savedSelections);
      setSelections(parsed);
      calculateTotalCredits(parsed);
    }

    if (savedSubmitted === 'true') {
      setIsSubmitted(true);
    }
  };

  // Calculate TOTAL credit usage for honour/minor/addon (common pool)
  const calculateTotalCredits = (currentSelections) => {
    if (!electiveData || !electiveData.slots) return;

    let total = 0;
    console.log('Calculating credits for selections:', currentSelections);
    Object.entries(currentSelections).forEach(([slotName, courseId]) => {
      // Check if this slot is HONOR/MINOR/ADDON by slot type
      const slot = electiveData.slots.find(s => s.slot_name === slotName);
      console.log(`Slot: ${slotName}, Type: ${slot?.slot_type}, Course ID: ${courseId}`);
      if (slot && ['HONOR', 'MINOR', 'ADDON'].includes(slot.slot_type)) {
        // Find the course in this slot and add its credits
        const course = slot.courses.find(c => c.course_id === courseId);
        if (course) {
          console.log(`  Adding ${course.credits} credits from ${course.course_name}`);
          total += course.credits;
        }
      }
    });
    console.log(`Total credits calculated: ${total}`);
    setTotalCreditUsed(total);
  };

  const handleSelection = (slotName, courseId, credits) => {
    if (isSubmitted) return;

    // Find the slot to check its type
    const slot = electiveData.slots.find(s => s.slot_name === slotName);

    // Check COMMON credit limit for honour/minor/addon (total 6 credits shared)
    if (slot && ['HONOR', 'MINOR', 'ADDON'].includes(slot.slot_type)) {
      let adjustedCredit = totalCreditUsed;

      // If changing selection, subtract old credits first
      if (selections[slotName]) {
        // Find the old course in this slot
        const oldCourse = slot.courses.find(c => c.course_id === selections[slotName]);
        if (oldCourse) {
          adjustedCredit -= oldCourse.credits;
        }
      }

      // Check if new selection exceeds total 8 credit limit
      if (adjustedCredit + credits > 8) {
        setMessage({
          type: 'error',
          text: `Cannot select. Total credit limit exceeded. Maximum 8 credits allowed for Honour/Minor/Add-On combined.`
        });
        setTimeout(() => setMessage({ type: '', text: '' }), 3000);
        return;
      }
    }

    const newSelections = {
      ...selections,
      [slotName]: courseId
    };

    setSelections(newSelections);
    calculateTotalCredits(newSelections);

    // Save to localStorage with semester-specific key
    localStorage.setItem(
      `elective_selections_${userEmail}_sem${electiveData.next_semester}`,
      JSON.stringify(newSelections)
    );
  };

  const handleSubmit = async () => {
    const requiredSlots = Object.keys(groupedElectives).filter(slotName => {
      const slotType = groupedElectives[slotName].slot_type;
      return slotType === 'PROFESSIONAL' || slotType === 'MIXED' || slotType === 'OPEN';
    });

    const requiredSelections = Object.keys(selections).filter(slotName => {
      const slotType = groupedElectives[slotName]?.slot_type;
      return slotType === 'PROFESSIONAL' || slotType === 'MIXED' || slotType === 'OPEN';
    });

    if (requiredSelections.length < requiredSlots.length) {
      setMessage({
        type: 'error',
        text: `Please select one course from each required slot. Selected: ${requiredSelections.length}/${requiredSlots.length} (Honors/Minor/Add-ons are optional)`
      });
      setTimeout(() => setMessage({ type: '', text: '' }), 3000);
      return;
    }

    // Validate: if ANY HONOR slot is selected, ALL HONOR slots must be filled
    const allHonorSlots = Object.keys(groupedElectives).filter(s => groupedElectives[s].slot_type === 'HONOR');
    const selectedHonorSlots = allHonorSlots.filter(s => selections[s]);
    if (selectedHonorSlots.length > 0 && selectedHonorSlots.length < allHonorSlots.length) {
      setMessage({
        type: 'error',
        text: `If you choose an Honour course, you must fill all ${allHonorSlots.length} Honour slots. Please select ${allHonorSlots.length - selectedHonorSlots.length} more.`
      });
      setTimeout(() => setMessage({ type: '', text: '' }), 4000);
      return;
    }

    // Validate: if ANY MINOR slot is selected, ALL MINOR slots must be filled
    const allMinorSlots = Object.keys(groupedElectives).filter(s => groupedElectives[s].slot_type === 'MINOR');
    const selectedMinorSlots = allMinorSlots.filter(s => selections[s]);
    if (selectedMinorSlots.length > 0 && selectedMinorSlots.length < allMinorSlots.length) {
      setMessage({
        type: 'error',
        text: `If you choose a Minor course, you must fill all ${allMinorSlots.length} Minor slots. Please select ${allMinorSlots.length - selectedMinorSlots.length} more.`
      });
      setTimeout(() => setMessage({ type: '', text: '' }), 4000);
      return;
    }

    console.log('Submitting selections:', selections);
    console.log('Email:', userEmail);
    console.log('Semester:', electiveData.next_semester);

    try {
      const response = await fetch(
        `${API_BASE_URL}/students/electives/selections?email=${userEmail}`,
        {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            selections: selections,
            semester: electiveData.next_semester
          })
        }
      );

      console.log('Submit response status:', response.status);
      const responseText = await response.text();
      console.log('Submit response body:', responseText);

      if (response.ok) {
        // Mark as submitted
        setIsSubmitted(true);
        localStorage.setItem(`elective_submitted_${userEmail}_sem${electiveData.next_semester}`, 'true');

        // Save submission data
        const submissionData = {
          selections: selections,
          semester: electiveData.next_semester,
          submittedAt: new Date().toISOString(),
          userEmail: userEmail,
          userName: userName,
          totalCredits: totalCreditUsed
        };
        localStorage.setItem(
          `elective_submission_${userEmail}_sem${electiveData.next_semester}`,
          JSON.stringify(submissionData)
        );

        console.log('Submission Data:', submissionData);
        setMessage({ type: 'success', text: 'Selections submitted successfully!' });
        setTimeout(() => setMessage({ type: '', text: '' }), 3000);
      } else {
        let errorMsg = 'Failed to save selections';
        try {
          const error = JSON.parse(responseText);
          errorMsg = error.error || error.message || errorMsg;
        } catch (e) {
          errorMsg = responseText || errorMsg;
        }
        setMessage({ type: 'error', text: errorMsg });
        setTimeout(() => setMessage({ type: '', text: '' }), 5000);
      }
    } catch (error) {
      console.error('Error saving selections:', error);
      setMessage({ type: 'error', text: 'Network error. Please try again.' });
      setTimeout(() => setMessage({ type: '', text: '' }), 5000);
    }
  };

  const getCategoryTitle = (category) => {
    const titles = {
      'professional': 'Professional Elective',
      'open': 'Open Elective',
      'honour': 'Honour',
      'minor': 'Minor',
      'addon': 'Add-On'
    };
    return titles[category] || category.toUpperCase();
  };

  if (loading) {
    return (
      <MainLayout>
        <div className="flex items-center justify-center min-h-screen">
          <div className="text-2xl text-gray-700">Loading electives...</div>
        </div>
      </MainLayout>
    );
  }

  if (!electiveData || !electiveData.slots || electiveData.slots.length === 0) {
    return (
      <MainLayout>
        <div className="max-w-4xl mx-auto py-12">
          <div className="text-center">
            <h1 className="text-3xl font-bold text-gray-900 mb-4">No Electives Available</h1>
            <p className="text-xl text-gray-600">
              There are no electives available for the next semester at this time.
            </p>
            <p className="text-lg text-gray-500 mt-2">
              Please contact your HOD if you believe this is an error.
            </p>
          </div>
        </div>
      </MainLayout>
    );
  }

  return (
    <MainLayout>
      <div className="max-w-4xl mx-auto py-6">
        {/* Header */}
        <div className="mb-6">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">Elective Selection</h1>
          <p className="text-lg text-gray-600">Semester {electiveData.next_semester}</p>
          <div className="mt-3 p-3 bg-gray-100 border border-gray-300 rounded">
            <p className="text-base text-gray-800">
              <span className="font-semibold">Total Credits (Honour/Minor/Add-On):</span> {totalCreditUsed}/8
              <span className="ml-3 text-gray-600">(Remaining: {8 - totalCreditUsed})</span>
            </p>
          </div>
        </div>

        {/* Message */}
        {message.text && (
          <div className={`mb-4 p-3 rounded text-base font-medium ${
            message.type === 'success' 
              ? 'bg-green-50 text-green-800 border border-green-200' 
              : 'bg-red-50 text-red-800 border border-red-200'
          }`}>
            {message.text}
          </div>
        )}

        {/* Submission Status */}
        {isSubmitted && (
          <div className="mb-4 p-3 bg-gray-100 border border-gray-300 rounded">
            <p className="text-base font-medium text-gray-800">
              ✓ Your selections have been submitted and locked.
            </p>
          </div>
        )}

        {/* Rules Note */}
        <div className="mb-5 p-4 bg-blue-50 border border-blue-200 rounded-lg">
          <h3 className="text-sm font-bold text-blue-800 mb-2">📋 Selection Rules</h3>
          <ul className="text-sm text-blue-700 space-y-1 list-disc list-inside">
            <li><span className="font-semibold">Professional / Open / Mixed</span> slots are <span className="font-semibold">required</span> — you must select one course from each.</li>
            <li><span className="font-semibold">Honour</span> slots are <span className="font-semibold">optional</span>, but if you choose one Honour course, you must fill <span className="font-semibold">all</span> Honour slots.</li>
            <li><span className="font-semibold">Minor</span> slots are <span className="font-semibold">optional</span>, but if you choose one Minor course, you must fill <span className="font-semibold">all</span> Minor slots.</li>
            <li><span className="font-semibold">Add-On</span> slots are fully optional and independent.</li>
            <li>Total credits for Honour / Minor / Add-On combined must not exceed <span className="font-semibold">8 credits</span>.</li>
          </ul>
        </div>

        {/* Electives List */}
        <div className="space-y-5">
          {Object.entries(groupedElectives).map(([slotName, slotData]) => {
            // Check if this optional slot type is "partially filled" (some but not all slots of same type selected)
            const sameTypeSlots = Object.keys(groupedElectives).filter(s => groupedElectives[s].slot_type === slotData.slot_type);
            const selectedSameType = sameTypeSlots.filter(s => selections[s]);
            const isPartiallyFilled = ['HONOR', 'MINOR'].includes(slotData.slot_type)
              && selectedSameType.length > 0
              && selectedSameType.length < sameTypeSlots.length
              && !selections[slotName];

            return (
            <div
              key={slotName}
              className={`bg-white border-2 rounded p-4 ${
                isSubmitted ? 'opacity-60 pointer-events-none' : ''
              } ${isPartiallyFilled ? 'border-orange-400' : 'border-gray-300'}`}
            >
              <div className="mb-3 flex justify-between items-start">
                <div>
                  <h2 className="text-xl font-bold text-gray-900">
                    {slotName}
                  </h2>
                  <span className="text-sm text-gray-600 font-medium">
                    {slotData.slot_type === 'PROFESSIONAL' && '📚 Professional Elective'}
                    {slotData.slot_type === 'OPEN' && '🌐 Open Elective'}
                    {slotData.slot_type === 'MIXED' && '📚🌐 Professional + Open Elective'}
                    {slotData.slot_type === 'HONOR' && '🏆 Honour Course (Optional — must fill all Honour slots if choosing)'}
                    {slotData.slot_type === 'MINOR' && '📖 Minor Course (Optional — must fill all Minor slots if choosing)'}
                    {slotData.slot_type === 'ADDON' && '➕ Add-On Course (Optional)'}
                  </span>
                  {isPartiallyFilled && (
                    <p className="text-xs text-orange-600 font-semibold mt-1">
                      ⚠ You must fill all {slotData.slot_type === 'HONOR' ? 'Honour' : 'Minor'} slots or clear your selections.
                    </p>
                  )}
                </div>

                {/* Clear button for optional slots */}
                {['HONOR', 'MINOR', 'ADDON'].includes(slotData.slot_type) && selections[slotName] && !isSubmitted && (
                  <button
                    onClick={() => {
                      const newSelections = { ...selections };
                      delete newSelections[slotName];
                      setSelections(newSelections);
                      calculateTotalCredits(newSelections);
                      const storageKey = `elective_selections_${userEmail}_sem${electiveData.next_semester}`;
                      localStorage.setItem(storageKey, JSON.stringify(newSelections));
                    }}
                    className="px-3 py-1 text-sm bg-red-500 text-white rounded hover:bg-red-600 transition"
                  >
                    Clear Selection
                  </button>
                )}
              </div>

              <div className="space-y-2">
                {slotData.courses.map(course => (
                  <label
                    key={course.course_id}
                    className={`flex items-center p-3 border-2 rounded cursor-pointer transition ${
                      selections[slotName] === course.course_id
                        ? 'border-gray-900 bg-gray-100'
                        : 'border-gray-200 hover:border-gray-400 hover:bg-gray-50'
                    }`}
                  >
                    <input
                      type="radio"
                      name={slotName}
                      value={course.course_id}
                      checked={selections[slotName] === course.course_id}
                      onChange={() => handleSelection(slotName, course.course_id, course.credits)}
                      disabled={isSubmitted}
                      className="w-4 h-4 text-gray-900"
                    />
                    <div className="ml-3 flex-1">
                      <div className="flex items-baseline gap-2">
                        <span className="text-lg font-bold text-gray-900">
                          {course.course_code}
                        </span>
                        <span className="text-base text-gray-700">
                          {course.course_name}
                        </span>
                      </div>
                      <div className="flex items-center gap-3">
                        <span className="text-sm text-gray-600">
                          {course.credits} {course.credits === 1 ? 'Credit' : 'Credits'}
                        </span>
                        <span className="text-xs text-gray-500">
                          {course.category}
                        </span>
                      </div>
                    </div>
                  </label>
                ))}
              </div>
            </div>
            );
          })}
        </div>

        {/* Submit Button */}
        {!isSubmitted && (
          <div className="mt-6 flex flex-col items-center gap-3">
            <button
              onClick={handleSubmit}
              disabled={Object.keys(selections).length < Object.keys(groupedElectives).length}
              className={`px-8 py-3 text-white text-lg font-bold rounded transition ${
                Object.keys(selections).length < Object.keys(groupedElectives).length
                  ? 'bg-gray-400 cursor-not-allowed'
                  : 'bg-gray-900 hover:bg-gray-800'
              }`}
            >
              Submit Selections
            </button>
            <p className="text-sm text-gray-600">
              {(() => {
                const requiredSlots = Object.keys(groupedElectives).filter(slotName => {
                  const slotType = groupedElectives[slotName].slot_type;
                  return slotType === 'PROFESSIONAL' || slotType === 'MIXED' || slotType === 'OPEN';
                });
                const requiredSelections = Object.keys(selections).filter(slotName => {
                  const slotType = groupedElectives[slotName]?.slot_type;
                  return slotType === 'PROFESSIONAL' || slotType === 'MIXED' || slotType === 'OPEN';
                });
                const optionalSelections = Object.keys(selections).length - requiredSelections.length;
                return `Selected: ${requiredSelections.length} / ${requiredSlots.length} required slots${optionalSelections > 0 ? ` (${optionalSelections} optional)` : ''}`;
              })()}
            </p>
          </div>
        )}
      </div>
    </MainLayout>
  );
};

export default ElectiveSelectionPage;
