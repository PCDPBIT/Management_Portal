# Teacher Lookup by Email - Implementation Summary

## Overview
Changed the teacher lookup mechanism to use **email as the primary identifier** instead of userId. The system now:
1. Fetches teacher data from the `teachers` table using the user's email
2. Retrieves the teacher's `id` and `faculty_id` from the database
3. Uses this data for all subsequent API calls

## Changes Made

### 1. Backend: New API Endpoint
**File:** `server/handlers/student-teacher_entry/teachers.go`

**New Function:** `GetTeacherByEmail`
- **Endpoint:** `GET /api/teachers/by-email?email={email}`
- **Purpose:** Fetch teacher record by email address
- **Returns:** 
  ```json
  {
    "success": true,
    "teacher": {
      "id": 123,
      "faculty_id": "AD001",
      "name": "Teacher Name",
      "email": "teacher@example.com",
      "dept": "AI&DS",
      "department": "Artificial Intelligence & Data Science",
      "designation": "Assistant Professor",
      "theory_subject_count": 2,
      "theory_with_lab_subject_count": 1,
      ...
    }
  }
  ```

**Query:**
```sql
SELECT 
    t.id, t.faculty_id, t.name, t.email, t.phone, t.profile_img, 
    t.dept, d.department_name as department, t.desg, 
    t.last_login, t.status,
    COALESCE(t.theory_subject_count, 0) as theory_subject_count,
    COALESCE(t.theory_with_lab_subject_count, 0) as theory_with_lab_subject_count
FROM teachers t
LEFT JOIN departments d ON t.dept = d.id
WHERE t.email = ? AND t.status = 1
```

### 2. Backend: Route Registration
**File:** `server/routes/routes.go`

**Added Route:**
```go
router.HandleFunc("/api/teachers/by-email", studentteacher.GetTeacherByEmail).Methods("GET", "OPTIONS")
```

**Route Order:** Placed BEFORE the `{id}` route to prevent path conflicts.

### 3. Frontend: Teacher Lookup Logic
**File:** `client/src/pages/teacher/TeacherCourseSelectionPage.js`

**Updated `useEffect`:**
```javascript
useEffect(() => {
  const fetchTeacherByEmail = async () => {
    const userEmail = localStorage.getItem('userEmail') || localStorage.getItem('teacher_email');
    
    if (!userEmail) {
      // Fallback to stored teacher_id
      const storedTeacherId = localStorage.getItem('teacher_id');
      // ... handle fallback
      return;
    }
    
    // Fetch teacher data from backend using email
    const response = await fetch(`${API_BASE_URL}/teachers/by-email?email=${encodeURIComponent(userEmail)}`);
    
    if (response.ok) {
      const data = await response.json();
      if (data.teacher && data.teacher.id) {
        setTeacherId(data.teacher.id.toString());
        
        // Update localStorage with fresh teacher data
        localStorage.setItem('teacher_id', data.teacher.id);
        localStorage.setItem('faculty_id', data.teacher.faculty_id || '');
        localStorage.setItem('teacher_name', data.teacher.name || '');
        localStorage.setItem('teacher_dept', data.teacher.dept || '');
      }
    }
  };
  
  fetchTeacherByEmail();
}, []);
```

**Lookup Priority:**
1. **Primary:** `userEmail` from localStorage → API call → Get teacher_id
2. **Fallback 1:** `teacher_email` from localStorage → API call
3. **Fallback 2:** Stored `teacher_id` from localStorage (if API fails)
4. **Error:** Show user-friendly message if all methods fail

### 4. Login Page: Clear Stale Data
**File:** `client/src/pages/curriculum/loginPage.js`

**Enhancement:**
```javascript
if (data.teacher_data) {
  // Store teacher data
  localStorage.setItem('teacher_id', data.teacher_data.teacher_id);
  // ... other fields
} else {
  // Clear any stale teacher data from previous sessions
  localStorage.removeItem('teacher_id');
  localStorage.removeItem('faculty_id');
  // ... other fields
}
```

## How It Works

### Flow Diagram
```
User Login
    ↓
Login stores userEmail in localStorage
    ↓
User navigates to Teacher Course Selection Page
    ↓
Frontend reads userEmail from localStorage
    ↓
Frontend calls: GET /api/teachers/by-email?email={email}
    ↓
Backend queries teachers table by email
    ↓
Backend returns teacher data (id, faculty_id, etc.)
    ↓
Frontend stores teacher_id and uses it for all subsequent calls
```

### Example API Calls

**1. Fetch Teacher by Email:**
```http
GET http://localhost:5000/api/teachers/by-email?email=teacher@example.com

Response:
{
  "success": true,
  "teacher": {
    "id": 15,
    "faculty_id": "AD001",
    "name": "John Doe",
    "email": "teacher@example.com",
    ...
  }
}
```

**2. Then Use teacher_id for Other Calls:**
```http
GET http://localhost:5000/api/teachers/15/semester/6/courses
GET http://localhost:5000/api/teachers/15/allocation-summary
GET http://localhost:5000/api/teachers/15/course-preferences?next_semester=4
```

## Benefits

1. ✅ **Email is unique** - No ambiguity about which teacher
2. ✅ **Always up-to-date** - Fetches fresh data from database
3. ✅ **No stale IDs** - Even if localStorage has old data, email lookup fixes it
4. ✅ **Better error messages** - Clear indication if teacher doesn't exist
5. ✅ **Audit trail** - Backend logs show which email is being queried
6. ✅ **Single source of truth** - Teachers table is authoritative

## Error Handling

### Scenario 1: Teacher Not Found
**User sees:**
```
No teacher record found for email: teacher@example.com
Please contact your administrator to add you to the teachers database.
```

### Scenario 2: API Fails
**System:**
- Falls back to stored `teacher_id` from localStorage
- Logs error to console
- User can continue if they have cached data

### Scenario 3: No Email or ID
**User sees:**
```
No teacher email or ID found. Please log in as a teacher.
```

## Testing

### Test Cases

1. **New Login:**
   - Clear localStorage
   - Login as teacher
   - Navigate to course selection
   - Should fetch by email successfully

2. **Existing Teacher:**
   - Login with valid teacher email
   - Check teacher data is loaded
   - Verify faculty_id is available

3. **Non-existent Teacher:**
   - Login with user that has teacher role but no teacher record
   - Should show clear error message

4. **API Failure:**
   - Simulate network error
   - Should fallback to localStorage teacher_id
   - Should still work if cached data exists

## Database Requirements

**Teachers table must have:**
- `email` column (unique, indexed)
- `status` column (1 = active, 0 = deleted)
- `faculty_id` column
- Matching email with `users` table

**To check:**
```sql
-- Verify email is indexed
SHOW INDEX FROM teachers WHERE Column_name = 'email';

-- Check for duplicate emails
SELECT email, COUNT(*) 
FROM teachers 
WHERE status = 1 
GROUP BY email 
HAVING COUNT(*) > 1;

-- Find users without teacher records
SELECT u.email, u.role
FROM users u
LEFT JOIN teachers t ON u.email = t.email AND t.status = 1
WHERE u.role IN ('teacher', 'hod')
AND t.id IS NULL;
```

## Migration Guide

### For Existing Users

1. **Clear browser cache:**
   ```javascript
   localStorage.clear();
   ```

2. **Re-login:**
   - System will now use email-based lookup
   - Fresh teacher data will be fetched

3. **Verify:**
   - Check browser console for "Teacher found by email" message
   - Confirm no 500 errors in API calls

### For Admins

1. **Ensure all teacher emails match:**
   ```sql
   -- Check for mismatches
   SELECT u.email as user_email, t.email as teacher_email
   FROM users u
   LEFT JOIN teachers t ON u.email = t.email
   WHERE u.role IN ('teacher', 'hod')
   AND (t.id IS NULL OR u.email != t.email);
   ```

2. **Create missing teacher records:**
   ```sql
   INSERT INTO teachers (name, email, faculty_id, dept, status)
   SELECT 
       u.username as name,
       u.email,
       CONCAT('T', LPAD(u.id, 3, '0')) as faculty_id,
       'GEN' as dept,
       1 as status
   FROM users u
   LEFT JOIN teachers t ON u.email = t.email
   WHERE u.role = 'teacher'
   AND t.id IS NULL;
   ```

## Next Steps

1. **Restart server** to load new endpoint
2. **Clear localStorage** in browser
3. **Re-login** as teacher
4. **Test** course selection page
5. **Monitor logs** for successful email lookup

## Troubleshooting

**Issue:** Still getting 404 errors

**Check:**
```sql
SELECT * FROM teachers WHERE email = 'your.email@example.com' AND status = 1;
```

**Issue:** "No email found"

**Solution:**
- Re-login to get fresh email in localStorage
- Check login response includes user.email

**Issue:** Server not responding

**Solution:**
- Restart Go server: `cd server && go run main.go`
- Check route is registered: Look for "by-email" in server logs
