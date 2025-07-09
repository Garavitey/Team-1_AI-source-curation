-- Auto-generated SQL file
-- Generated at: 2025-07-09 12:22:15.110569
BEGIN;

-- Monitoring queries for scale test

-- Check import progress
SELECT 
    table_type,
    COUNT(*) as files_processed,
    SUM(tables_created) as total_tables,
    MIN(start_time) as first_start,
    MAX(end_time) as last_end,
    EXTRACT(EPOCH FROM (MAX(end_time) - MIN(start_time)))/60 as total_minutes
FROM scale_test_log
WHERE status = 'completed'
GROUP BY table_type
ORDER BY table_type;

-- Count actual objects
SELECT 
    CASE 
        WHEN c.relkind = 'r' AND c.relpersistence = 'p' THEN 'regular table'
        WHEN c.relkind = 'r' AND c.relpersistence = 'u' THEN 'unlogged table'
        WHEN c.relkind = 'v' THEN 'view'
        WHEN c.relkind = 'm' THEN 'materialized view'
        WHEN c.relkind = 'p' THEN 'partitioned table'
    END as object_type,
    COUNT(*) as count
FROM pg_class c
JOIN pg_namespace n ON c.relnamespace = n.oid
WHERE n.nspname = 'public'
AND c.relkind IN ('r', 'v', 'm', 'p')
GROUP BY c.relkind, c.relpersistence
ORDER BY count DESC;

-- Database size
SELECT 
    pg_size_pretty(pg_database_size(current_database())) as database_size,
    pg_size_pretty(SUM(pg_total_relation_size(c.oid))) as total_table_size
FROM pg_class c
JOIN pg_namespace n ON c.relnamespace = n.oid
WHERE n.nspname = 'public';

-- Top 10 largest system catalog tables
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
FROM pg_tables
WHERE schemaname = 'pg_catalog'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC
LIMIT 10;
;

COMMIT;
