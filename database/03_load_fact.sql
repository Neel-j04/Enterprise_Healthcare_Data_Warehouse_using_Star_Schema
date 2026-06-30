-- Load FactPatientVisit data from staging into warehouse

BEGIN;

-- Load Fact Table
INSERT INTO warehouse.fact_patient_visit
SELECT *
FROM staging.fact_patient_visit_raw;

COMMIT;

-- Verification
SELECT COUNT(*) AS warehouse_fact_records
FROM warehouse.fact_patient_visit;

SELECT COUNT(*) AS staging_fact_records
FROM staging.fact_patient_visit_raw;