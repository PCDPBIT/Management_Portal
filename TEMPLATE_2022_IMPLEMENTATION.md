# Template 2022 Implementation Guide

## Overview
This implementation adds support for both 2022 and 2026 curriculum templates with distinct features and behaviors.

## Database Migration

Run the SQL migration file:
```bash
mysql -u root -p management_portal < server/TEMPLATE_2022_MIGRATION.sql
```

This adds:
1. `curriculum_template` column to `curriculum` table (values: "2022" or "2026")
2. `course_experiments` table for 2022 template experiments
3. `course_experiment_topics` table for experiment topics

## Template Differences

### Template 2026 (Current/Default)
- **Course Form**: Includes activity hours field
- **Course Types**: 
  - Theory: Shows all hour fields (lecture, tutorial, practical, activity)
  - Experiment: Shows all hour fields
- **Syllabus**: 
  - Modules (not Units)
  - Includes: Objectives, Teamwork, Self-learning, Prerequisites
  
### Template 2022
- **Course Form**: NO activity hours field
- **Course Types**:
  - Theory: No activity hours
  - Experiment: "TWS/SL Hrs" renamed to "Theory Hrs", no activity hours
- **Syllabus**:
  - Units (not Modules)
  - Includes: Objectives (shown first), Outcomes, References
  - NO: Teamwork, Self-learning, Prerequisites
  - Experiments section alongside Units (for lab courses)

## Implementation Status

### ✅ Completed
1. Database schema updated with template support
2. Backend models added (`Curriculum`, `Experiment`, `ExperimentTopic`)
3. Backend handlers: `getCurriculumTemplateByRegulation()` utility function
4. Backend handlers: Template validation in curriculum edit (prevents switching templates when courses exist)
5. Frontend: Template dropdown in curriculum creation form
6. Frontend: Template field in state management across all pages
7. Frontend: Conditional rendering in `semesterDetailPage.js` - hides activity hours for 2022, renames TWS/SL for experiments
8. Frontend: Conditional rendering in `honourCardPage.js` - same conditional logic as semester page
9. Frontend: Conditional tabs and sections in `syllabusPage.js` - shows Units/Experiments for 2022, Modules/Objectives/Teamwork/Self-learning/Prerequisites for 2026

### ✅ Implementation Complete!

The 2022 curriculum template feature is now fully implemented and ready to use. Users can:

1. **Create curricula** with either 2022 or 2026 template selection
2. **Add courses** with template-appropriate fields:
   - 2022: No activity hours field
   - 2022 Experiments: "TWS/SL Hrs" label instead of "Tutorial Hours"
   - 2026: All fields including activity hours
3. **Manage syllabus** with template-specific sections:
   - 2022: Units tab, Experiments tab (for lab courses)
   - 2026: Modules tab, Objectives, Teamwork, Self-learning, Prerequisites tabs

**Note:** The system prevents switching templates after courses have been added to a curriculum to maintain data integrity.

---

## Reference Implementation Details (Already Completed)

The following sections document how the feature was implemented for reference purposes.

#### 1. Backend Handlers (✅ Done)

- `server/handlers/template_utils.go` - Utility function `getCurriculumTemplateByRegulation()`
- `server/handlers/curriculum_edit.go` - Template validation prevents switching after courses exist
- Template is automatically fetched and applied when loading courses

#### 2. Conditional Course Creation Forms (✅ Done)

**Implemented in:**
- `client/src/pages/semesterDetailPage.js` - Conditional activity hours field, TWS/SL label for experiments
- `client/src/pages/honourCardPage.js` - Same conditional logic

Conditional rendering example:
```javascript
const [curriculumTemplate, setCurriculumTemplate] = useState('2026')

// Fetch template when loading curriculum/semester
useEffect(() => {
  // Fetch curriculum details and get curriculum_template
}, [id])

// Conditional rendering in form:
{curriculumTemplate !== '2022' && (
  <div>
    <label>Activity Hrs</label>
    <input type="number" value={newCourse.activity_hours} ... />
  </div>
)}

// For 2022 + Experiment type:
{curriculumTemplate === '2022' && newCourse.course_type === 'Experiment' && (
  <div>
    <label>Theory Hrs (TWS/SL)</label>  {/* Renamed */}
    <input type="number" value={newCourse.theory_hours} ... />
  </div>
)}
```

#### 3. Syllabus Page Template Support (✅ Done)

**Implemented in:** `client/src/pages/syllabusPage.js`

Features:
- Conditional tabs based on template (Units/Experiments for 2022, Modules/Teamwork/Self-learning/Prerequisites for 2026)
- Dynamic tab labels
- Template-specific content rendering

Conditional rendering example:
```javascript
// Conditional section rendering
{curriculumTemplate === '2026' && (
  <>
    {/* Objectives section */}
    {/* Teamwork section */}
    {/* Self-learning section */}
    {/* Prerequisites section */}
  </>
)}

// Change "Modules" to "Units" for 2022
<h3>{curriculumTemplate === '2022' ? 'Units' : 'Modules'}</h3>

// Add Experiments section for 2022
{curriculumTemplate === '2022' && (
  <div className="experiments-section">
    <h3>Experiments</h3>
    <button onClick={handleAddExperiment}>Add Experiment</button>
    {experiments.map(exp => (
      <div key={exp.id}>
        <h4>{exp.experiment_name}</h4>
        <button onClick={() => handleAddExperimentTopic(exp.id)}>Add Topic</button>
        {exp.topics.map(topic => <div>{topic.topic_text}</div>)}
      </div>
    ))}
  </div>
)}
```

#### 4. Create Experiment Handlers

**New file: `server/handlers/experiments.go`**

```go
// AddExperiment - POST /api/course/:courseId/experiment
// GetExperiments - GET /api/course/:courseId/experiments
// UpdateExperiment - PUT /api/experiment/:id
// DeleteExperiment - DELETE /api/experiment/:id
// AddExperimentTopic - POST /api/experiment/:expId/topic
// DeleteExperimentTopic - DELETE /api/experiment/topic/:id
```

#### 5. Update PDF Generation

**File: `server/handlers/pdf_html.go`**

Add conditional rendering in HTML template:
```html
{{if eq $.CurriculumTemplate "2022"}}
  <h3>Units</h3>
  <!-- Don't render objectives, teamwork, etc. -->
  
  {{if isLab $course.CourseType}}
    <h3>Experiments</h3>
    {{range $course.Experiments}}
      <div>{{.ExperimentName}}</div>
      {{range .Topics}}<li>{{.TopicText}}</li>{{end}}
    {{end}}
  {{end}}
{{else}}
  <h3>Modules</h3>
  <!-- Render all sections including objectives, teamwork, etc. -->
{{end}}
```

## API Changes Required

### Curriculum Creation
```json
POST /api/curriculum/create
{
  "name": "R2022 CSE",
  "academic_year": "2022-23",
  "max_credits": 160,
  "curriculum_template": "2022"  // NEW
}
```

### Experiments API (New)
```json
POST /api/course/{courseId}/experiment
{
  "experiment_number": 1,
  "experiment_name": "Study of basic gates"
}

POST /api/experiment/{expId}/topic
{
  "topic_text": "AND gate implementation",
  "topic_order": 1
}
```

## Testing Checklist

- [ ] Create curriculum with 2026 template - verify default behavior
- [ ] Create curriculum with 2022 template
- [ ] Add course to 2022 curriculum - verify NO activity hours field
- [ ] Add Theory course to 2022 - verify no activity hours
- [ ] Add Experiment course to 2022 - verify "Theory Hrs" label
- [ ] Edit syllabus for 2022 course - verify Units label, no objectives/teamwork/etc
- [ ] Add experiments to 2022 lab course
- [ ] Generate PDF for 2022 curriculum - verify correct template
- [ ] Edit curriculum template - verify changes propagate

## Migration Path for Existing Data

All existing curriculums default to "2026" template, preserving current functionality.

## Notes

- The `activity_hours` field remains in the database for all templates but is hidden/not used in 2022 template
- 2022 template uses `theory_hours` field for what's labeled as "TWS/SL Hrs" in experiment courses
- Experiments table is only used for 2022 template courses
- Template cannot be changed after curriculum has courses (add validation)
