-- Link mark entry windows with specific assessment components
-- This allows admin to specify which fields (CIA1, CIA2, ESE, etc.) are accessible within a time window

CREATE TABLE IF NOT EXISTS mark_entry_window_components (
    id INT AUTO_INCREMENT PRIMARY KEY,
    window_id INT NOT NULL,
    assessment_component_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (window_id) REFERENCES mark_entry_windows(id) ON DELETE CASCADE,
    FOREIGN KEY (assessment_component_id) REFERENCES mark_category_types(id) ON DELETE CASCADE,
    
    UNIQUE KEY unique_window_component (window_id, assessment_component_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- If no components are specified for a window, ALL components are accessible (default open)
-- If components ARE specified, ONLY those components are accessible (explicit allow list)
