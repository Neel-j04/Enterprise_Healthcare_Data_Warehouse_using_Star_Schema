-- Create Staging Schema
CREATE SCHEMA IF NOT EXISTS staging;

-- Create Warehouse Schema
CREATE SCHEMA IF NOT EXISTS warehouse;

-- Create Analytics Schema
CREATE SCHEMA IF NOT EXISTS analytics;

-- Verify
SELECT schema_name
FROM information_schema.schemata
WHERE schema_name IN (
    'staging',
    'warehouse',
    'analytics'
);