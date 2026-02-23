# Database Schema Fix - Removed Non-existent Columns

## Issue
Server was trying to query columns `theory_subject_count` and `theory_with_lab_subject_count` that don't exist in the `teachers` table, causing error:
```
Error 1054 (42S22): Unknown column 'theory_subject_count' in 'field list'
```

## Files Fixed

### 1. `server/handlers/curriculum/auth.go`
**Login Handler - Teacher Data Fetch**

**Before:**
```sql
SELECT id, faculty_id, name, email, phone, profile_img, dept, desg, status, 
       theory_subject_count, theory_with_lab_subject_count 
FROM teachers WHERE email = ? AND status = 1
```

**After:**
```sql
SELECT id, faculty_id, name, email, phone, profile_img, dept, desg, status
FROM teachers WHERE email = ? AND status = 1
```

**Changed:**
- Removed `theory_subject_count` and `theory_with_lab_subject_count` from SELECT
- Removed corresponding Scan variables
- Removed from response map
- Enhanced log to include FacultyID

### 2. `server/handlers/student-teacher_entry/teachers.go`
**GetTeacherByEmail Function**

**Before:**
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

**After:**
```sql
SELECT 
    t.id, t.faculty_id, t.name, t.email, t.phone, t.profile_img, 
    t.dept, d.department_name as department, t.desg, 
    t.last_login, t.status
FROM teachers t
LEFT JOIN departments d ON t.dept = d.id
WHERE t.email = ? AND t.status = 1
```

**Changed:**
- Removed non-existent columns from query
- Changed Teacher struct usage (removed extended struct)
- Removed corresponding Scan variables

### 3. `client/src/pages/curriculum/loginPage.js`
**LocalStorage Management**

**Removed:**
- `localStorage.setItem('theory_subject_count', ...)`
- `localStorage.setItem('theory_with_lab_subject_count', ...)`
- Corresponding removeItem calls

**Impact:** Frontend no longer tries to store/clear these fields

## Current Teacher Table Schema

Based on the fix, your `teachers` table has these columns:
- `id` (INT, PRIMARY KEY)
- `faculty_id` (VARCHAR)
- `name` (VARCHAR)
- `email` (VARCHAR, UNIQUE)
- `phone` (VARCHAR)
- `profile_img` (VARCHAR)
- `dept` (VARCHAR or INT - department reference)
- `desg` (VARCHAR - designation)
- `last_login` (DATETIME)
- `status` (INT - 1=active, 0=deleted)

## Testing

After restarting the server, the login should now work:

1. **Login Response:**
```json
{
  "success": true,
  "teacher_data": {
    "teacher_id": 15,
    "faculty_id": "AD001",
    "name": "Teacher Name",
    "email": "rajkumarvs@bitsathy.ac.in",
    "dept": "CS",
    "designation": "Assistant Professor",
    "status": 1
  }
}
```

2. **GetTeacherByEmail Response:**
```json
{
  "success": true,
  "teacher": {
    "id": 15,
    "faculty_id": "AD001",
    "name": "Teacher Name",
    "email": "rajkumarvs@bitsathy.ac.in",
    ...
  }
}
```

## Next Steps

1. **Restart the Go server:**
   ```bash
   cd server
   air
   ```

2. **Clear browser localStorage:**
   ```javascript
   localStorage.clear();
   location.reload();
   ```

3. **Re-login:**
   - Username: `teacher`
   - Should now login successfully
   - Teacher data will be stored in localStorage

4. **Navigate to Course Selection:**
   - Should fetch teacher by email
   - Should display teacher courses without errors

## Verification

Check server logs for:
```
Teacher data found: ID=X, Name=Y, FacultyID=Z
```

Instead of:
```
Error fetching teacher data: Error 1054...
```

## Optional: Add Columns Later

If you want to add subject count tracking in the future:

```sql
ALTER TABLE teachers 
ADD COLUMN theory_subject_count INT DEFAULT 0,
ADD COLUMN theory_with_lab_subject_count INT DEFAULT 0;
```

Then uncomment the code that handles these columns.
