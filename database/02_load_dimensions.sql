BEGIN;

-- Load Patient Dimension
INSERT INTO warehouse.dim_patient
SELECT DISTINCT *
FROM staging.dim_patient_raw;

-- Load Doctor Dimension
INSERT INTO warehouse.dim_doctor
SELECT DISTINCT *
FROM staging.dim_doctor_raw;

-- Load Hospital Dimension
INSERT INTO warehouse.dim_hospital
SELECT DISTINCT *
FROM staging.dim_hospital_raw;

-- Load Department Dimension
INSERT INTO warehouse.dim_department
SELECT DISTINCT *
FROM staging.dim_department_raw;

-- Load Treatment Dimension
INSERT INTO warehouse.dim_treatment
SELECT DISTINCT *
FROM staging.dim_treatment_raw;

-- Load Medicine Dimension
INSERT INTO warehouse.dim_medicine
SELECT DISTINCT *
FROM staging.dim_medicine_raw;

-- Load Insurance Dimension
INSERT INTO warehouse.dim_insurance
SELECT DISTINCT *
FROM staging.dim_insurance_raw;

-- Load Date Dimension
INSERT INTO warehouse.dim_date
SELECT DISTINCT *
FROM staging.dim_date_raw;

COMMIT;



SELECT COUNT(*) FROM warehouse.dim_patient;
SELECT COUNT(*) FROM warehouse.dim_doctor;
SELECT COUNT(*) FROM warehouse.dim_hospital;
SELECT COUNT(*) FROM warehouse.dim_department;
SELECT COUNT(*) FROM warehouse.dim_treatment;
SELECT COUNT(*) FROM warehouse.dim_medicine;
SELECT COUNT(*) FROM warehouse.dim_insurance;
SELECT COUNT(*) FROM warehouse.dim_date;