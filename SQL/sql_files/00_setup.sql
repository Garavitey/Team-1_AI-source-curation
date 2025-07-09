-- Auto-generated SQL file
-- Generated at: 2025-07-09 12:22:14.655048
BEGIN;

-- Setup script for scale testing
-- Create tracking table
CREATE TABLE IF NOT EXISTS scale_test_log (
    id SERIAL PRIMARY KEY,
    filename VARCHAR(255),
    table_type VARCHAR(50),
    tables_created INTEGER,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    status VARCHAR(20)
);

-- Create indexes on tracking table
CREATE INDEX idx_scale_test_log_status ON scale_test_log(status);
CREATE INDEX idx_scale_test_log_type ON scale_test_log(table_type);

-- Function to log progress
CREATE OR REPLACE FUNCTION log_import_progress(
    p_filename VARCHAR,
    p_table_type VARCHAR,
    p_tables_count INTEGER,
    p_status VARCHAR
) RETURNS VOID AS $$
BEGIN
    INSERT INTO scale_test_log (filename, table_type, tables_created, start_time, status)
    VALUES (p_filename, p_table_type, p_tables_count, NOW(), p_status);
END;
$$ LANGUAGE plpgsql;
;

COMMIT;
