-- Update Minor System to use normal_cards instead of honour_verticals
-- Run this if hod_minor_selections table already exists with FK to honour_verticals

-- Drop the old foreign key constraint
ALTER TABLE hod_minor_selections 
DROP FOREIGN KEY hod_minor_selections_ibfk_3;

-- Add new foreign key constraint to normal_cards
ALTER TABLE hod_minor_selections 
ADD CONSTRAINT hod_minor_selections_ibfk_3 
FOREIGN KEY (vertical_id) REFERENCES normal_cards(id);

-- Verify the change
-- SHOW CREATE TABLE hod_minor_selections;
