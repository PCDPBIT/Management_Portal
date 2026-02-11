import React, { useState, useEffect } from 'react';
import MainLayout from '../../components/MainLayout';

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

  useEffect(() => {
    fetchElectives();
  }, []);

  const fetchElectives = async () => {
    try {
      setLoading(true);
      const url = `${process.env.REACT_APP_API_BASE_URL || 'http://localhost:5000/api'}/students/electives/available?email=${userEmail}`;
      console.log('Fetching from URL:', url);
      
      const response = await fetch(url);
      
      console.log('Response status:', response.status);
      console.log('Response headers:', response.headers);
      
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
          });
        }
        setGroupedElectives(grouped);
        console.log('Grouped Electives:', grouped);
        
        // Load existing selections from backend response (PRIMARY SOURCE OF TRUTH)
        if (data.existing_selections && Object.keys(data.existing_selections).length > 0) {
          console.log('Loading existing selections from backend:', data.existing_selections);
          setSelections(data.existing_selections);
          calculateTotalCredits(data.existing_selections);
          
          // Check if already submitted (has selections for all slots)
          const totalSlots = data.slots.length;
          const selectedSlots = Object.keys(data.existing_selections).length;
          if (selectedSlots === totalSlots) {
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
    Object.entries(currentSelections).forEach(([slotName, courseId]) => {
      // Find the course in any slot
      for (const slot of electiveData.slots) {
        const elective = slot.courses.find(e => 
          e.course_id === courseId && ['honour', 'minor', 'addon'].includes(e.category)
        );
        if (elective) {
          total += elective.credits;
          break;
        }
      }
    });
    setTotalCreditUsed(total);
  };

  const handleSelection = (category, courseId, credits) => {
    if (isSubmitted) return;

    // Check COMMON credit limit for honour/minor/addon (total 6 credits shared)
    if (['honour', 'minor', 'addon'].includes(category)) {
      let adjustedCredit = totalCreditUsed;
      
      // If changing selection, subtract old credits first
      if (selections[category]) {
        // Find the old course in any slot
        let oldElective = null;
        for (const slot of electiveData.slots) {
          oldElective = slot.courses.find(e => e.course_id === selections[category]);
          if (oldElective) break;
        }
        if (oldElective) {
          adjustedCredit -= oldElective.credits;
        }
      }
      
      // Check if new selection exceeds total 6 credit limit
      if (adjustedCredit + credits > 6) {
        setMessage({ 
          type: 'error', 
          text: `Cannot select. Total credit limit exceeded. Maximum 6 credits allowed for Honour/Minor/Add-On combined.` 
        });
        setTimeout(() => setMessage({ type: '', text: '' }), 3000);
        return;
      }
    }

    const newSelections = {
      ...selections,
      [category]: courseId
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
    // Validate: Check if ALL slots have a selection
    const totalSlots = Object.keys(groupedElectives).length;
    const selectedSlots = Object.keys(selections).length;
    
    if (selectedSlots < totalSlots) {
      setMessage({ 
        type: 'error', 
        text: `Please select one course from each slot. Selected: ${selectedSlots}/${totalSlots}` 
      });
      setTimeout(() => setMessage({ type: '', text: '' }), 3000);
      return;
    }

    try {
      const response = await fetch(
        `${process.env.REACT_APP_API_BASE_URL || 'http://localhost:5000/api'}/students/electives/selections?email=${userEmail}`,
        {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            selections: selections,
            semester: electiveData.next_semester
          })
        }
      );

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
        const error = await response.json();
        setMessage({ type: 'error', text: error.error || 'Failed to save selections' });
      }
    } catch (error) {
      console.error('Error saving selections:', error);
      setMessage({ type: 'error', text: 'Network error. Please try again.' });
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
              <span className="font-semibold">Total Credits (Honour/Minor/Add-On):</span> {totalCreditUsed}/6
              <span className="ml-3 text-gray-600">(Remaining: {6 - totalCreditUsed})</span>
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

        {/* Electives List */}
        <div className="space-y-5">
          {Object.entries(groupedElectives).map(([slotName, slotData]) => (
            <div 
              key={slotName} 
              className={`bg-white border-2 border-gray-300 rounded p-4 ${
                isSubmitted ? 'opacity-60 pointer-events-none' : ''
              }`}
            >
              <div className="mb-3">
                <h2 className="text-xl font-bold text-gray-900">
                  {slotData.slot_name}
                </h2>
                <span className="text-sm text-gray-600 font-medium">
                  {slotData.slot_type === 'PROFESSIONAL' && '📚 Professional Elective'}
                  {slotData.slot_type === 'OPEN' && '🌐 Open Elective'}
                  {slotData.slot_type === 'MIXED' && '📚🌐 Professional + Open Elective'}
                </span>
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
          ))}
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
              Selected: {Object.keys(selections).length} / {Object.keys(groupedElectives).length} slots
            </p>
          </div>
        )}
      </div>
    </MainLayout>
  );
};

export default ElectiveSelectionPage;
