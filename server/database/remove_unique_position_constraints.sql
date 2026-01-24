-- Remove UNIQUE constraints on (curriculum_id, position) to allow soft deletes
-- This allows multiple records with the same position as long as only one has status=1

-- Drop procedure if exists
DROP PROCEDURE IF EXISTS RemoveUniquePositionConstraints;

DELIMITER $$

CREATE PROCEDURE RemoveUniquePositionConstraints()
BEGIN
    -- curriculum_mission
    IF EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS 
        WHERE TABLE_SCHEMA = DATABASE() 
        AND TABLE_NAME = 'curriculum_mission' 
        AND CONSTRAINT_NAME = 'department_id'
    ) THEN
        ALTER TABLE `curriculum_mission` DROP INDEX `department_id`;
    END IF;

    -- curriculum_peos
    IF EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS 
        WHERE TABLE_SCHEMA = DATABASE() 
        AND TABLE_NAME = 'curriculum_peos' 
        AND CONSTRAINT_NAME = 'department_id'
    ) THEN
        ALTER TABLE `curriculum_peos` DROP INDEX `department_id`;
    END IF;

    -- curriculum_pos
    IF EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS 
        WHERE TABLE_SCHEMA = DATABASE() 
        AND TABLE_NAME = 'curriculum_pos' 
        AND CONSTRAINT_NAME = 'department_id'
    ) THEN
        ALTER TABLE `curriculum_pos` DROP INDEX `department_id`;
    END IF;

    -- curriculum_psos
    IF EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS 
        WHERE TABLE_SCHEMA = DATABASE() 
        AND TABLE_NAME = 'curriculum_psos' 
        AND CONSTRAINT_NAME = 'department_id'
    ) THEN
        ALTER TABLE `curriculum_psos` DROP INDEX `department_id`;
    END IF;
END$$

DELIMITER ;

-- Execute the procedure
CALL RemoveUniquePositionConstraints();

-- Drop the procedure
DROP PROCEDURE RemoveUniquePositionConstraints;
