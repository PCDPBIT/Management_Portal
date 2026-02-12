# Minor Program Update - Using Normal Cards

## Changes Made

The minor program system has been updated to use **normal_cards** with `card_type='vertical'` instead of the separate `honour_verticals` table. This allows reusing existing curriculum vertical cards as minor program options.

## What Changed

### 1. Backend Queries Updated

**GetMinorVerticals** (`server/handlers/curriculum/electives.go:936-1028`):
- Now queries `normal_cards` filtered by `card_type='vertical'`
- Joins with `curriculum_courses` to count available courses
- Filters by the HOD's curriculum and requires at least 6 courses per vertical
- Generates vertical name from semester number (e.g., "Semester 5 - Vertical")

**GetVerticalCourses** (`server/handlers/curriculum/electives.go:1030-1098`):
- Now queries `curriculum_courses` using the normal card ID
- Retrieves courses directly from the vertical card's course list

**GetHODMinorSelections** (`server/handlers/curriculum/electives.go:1365-1375`):
- Updated to join with `normal_cards` instead of `honour_verticals`
- Uses same naming convention for vertical display

### 2. Database Schema Updates

**honour_minor_setup.sql**:
- Foreign key constraint changed from `honour_verticals(id)` to `normal_cards(id)`

**New file: update_minor_fk_to_normal_cards.sql**:
- Run this script if the `hod_minor_selections` table already exists
- Drops the old FK constraint and adds new one pointing to `normal_cards`

## Testing

To test the minor program:

1. **Ensure vertical cards exist** in your curriculum:
   - Go to curriculum editor
   - Create vertical cards with `card_type='vertical'`
   - Add at least 6 courses to each vertical card
   - These will automatically appear in the HOD minor verticals dropdown

2. **Access HOD Elective Page**:
   - Login as HOD
   - Navigate to elective management
   - The "Minor Program" section should now show verticals from your normal cards

3. **Database Migration** (if table already exists):
   ```sql
   -- Run this to update the foreign key constraint
   source server/db/update_minor_fk_to_normal_cards.sql
   ```

## Benefits

1. **Reuses existing infrastructure**: No need to create separate honour verticals
2. **Consistency**: Minor programs use the same vertical structure as regular curriculum
3. **Simplified management**: Verticals managed in one place (curriculum editor)
4. **Automatic availability**: As soon as a vertical card is created with enough courses, it's available for minor programs

## API Behavior

The API responses remain unchanged:
- `GET /api/hod/minor-verticals` returns vertical cards as before
- `GET /api/hod/vertical-courses?vertical_id=X` returns courses from that vertical card
- Frontend code requires no changes

## Notes

- The `honour_verticals` table and related code in other files (template_utils.go, sharing.go, regulation.go) remain unchanged as they serve the honour cards curriculum system, which is separate from HOD minor program management
- The minimum course count of 6 per vertical is enforced in the query (`HAVING COUNT(DISTINCT cc.course_id) >= 6`)
