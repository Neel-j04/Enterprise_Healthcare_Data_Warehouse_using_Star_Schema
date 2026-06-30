-- DROP EXISTING FOREIGN KEYS (IF ANY)
ALTER TABLE IF EXISTS warehouse.fact_patient_visit DROP CONSTRAINT IF EXISTS fk_fact_patient;
ALTER TABLE IF EXISTS warehouse.fact_patient_visit DROP CONSTRAINT IF EXISTS fk_fact_doctor;
ALTER TABLE IF EXISTS warehouse.fact_patient_visit DROP CONSTRAINT IF EXISTS fk_fact_hospital;
ALTER TABLE IF EXISTS warehouse.fact_patient_visit DROP CONSTRAINT IF EXISTS fk_fact_department;
ALTER TABLE IF EXISTS warehouse.fact_patient_visit DROP CONSTRAINT IF EXISTS fk_fact_treatment;
ALTER TABLE IF EXISTS warehouse.fact_patient_visit DROP CONSTRAINT IF EXISTS fk_fact_medicine;
ALTER TABLE IF EXISTS warehouse.fact_patient_visit DROP CONSTRAINT IF EXISTS fk_fact_insurance;
ALTER TABLE IF EXISTS warehouse.fact_patient_visit DROP CONSTRAINT IF EXISTS fk_fact_admission_date;
ALTER TABLE IF EXISTS warehouse.fact_patient_visit DROP CONSTRAINT IF EXISTS fk_fact_discharge_date;



-- DROP EXISTING PRIMARY KEYS (IF ANY)
ALTER TABLE IF EXISTS warehouse.dim_patient DROP CONSTRAINT IF EXISTS pk_dim_patient;
ALTER TABLE IF EXISTS warehouse.dim_doctor DROP CONSTRAINT IF EXISTS pk_dim_doctor;
ALTER TABLE IF EXISTS warehouse.dim_hospital DROP CONSTRAINT IF EXISTS pk_dim_hospital;
ALTER TABLE IF EXISTS warehouse.dim_department DROP CONSTRAINT IF EXISTS pk_dim_department;
ALTER TABLE IF EXISTS warehouse.dim_treatment DROP CONSTRAINT IF EXISTS pk_dim_treatment;
ALTER TABLE IF EXISTS warehouse.dim_medicine DROP CONSTRAINT IF EXISTS pk_dim_medicine;
ALTER TABLE IF EXISTS warehouse.dim_insurance DROP CONSTRAINT IF EXISTS pk_dim_insurance;
ALTER TABLE IF EXISTS warehouse.dim_date DROP CONSTRAINT IF EXISTS pk_dim_date;



-- PRIMARY KEYS
ALTER TABLE warehouse.dim_patient
ADD CONSTRAINT pk_dim_patient
PRIMARY KEY ("PatientKey");

ALTER TABLE warehouse.dim_doctor
ADD CONSTRAINT pk_dim_doctor
PRIMARY KEY ("DoctorKey");

ALTER TABLE warehouse.dim_hospital
ADD CONSTRAINT pk_dim_hospital
PRIMARY KEY ("HospitalKey");

ALTER TABLE warehouse.dim_department
ADD CONSTRAINT pk_dim_department
PRIMARY KEY ("DepartmentKey");

ALTER TABLE warehouse.dim_treatment
ADD CONSTRAINT pk_dim_treatment
PRIMARY KEY ("TreatmentKey");

ALTER TABLE warehouse.dim_medicine
ADD CONSTRAINT pk_dim_medicine
PRIMARY KEY ("MedicineKey");

ALTER TABLE warehouse.dim_insurance
ADD CONSTRAINT pk_dim_insurance
PRIMARY KEY ("InsuranceKey");

ALTER TABLE warehouse.dim_date
ADD CONSTRAINT pk_dim_date
PRIMARY KEY ("DateKey");



-- FOREIGN KEYS
ALTER TABLE warehouse.fact_patient_visit
ADD CONSTRAINT fk_fact_patient
FOREIGN KEY ("PatientKey")
REFERENCES warehouse.dim_patient ("PatientKey");

ALTER TABLE warehouse.fact_patient_visit
ADD CONSTRAINT fk_fact_doctor
FOREIGN KEY ("DoctorKey")
REFERENCES warehouse.dim_doctor ("DoctorKey");

ALTER TABLE warehouse.fact_patient_visit
ADD CONSTRAINT fk_fact_hospital
FOREIGN KEY ("HospitalKey")
REFERENCES warehouse.dim_hospital ("HospitalKey");

ALTER TABLE warehouse.fact_patient_visit
ADD CONSTRAINT fk_fact_department
FOREIGN KEY ("DepartmentKey")
REFERENCES warehouse.dim_department ("DepartmentKey");

ALTER TABLE warehouse.fact_patient_visit
ADD CONSTRAINT fk_fact_treatment
FOREIGN KEY ("TreatmentKey")
REFERENCES warehouse.dim_treatment ("TreatmentKey");

ALTER TABLE warehouse.fact_patient_visit
ADD CONSTRAINT fk_fact_medicine
FOREIGN KEY ("MedicineKey")
REFERENCES warehouse.dim_medicine ("MedicineKey");

ALTER TABLE warehouse.fact_patient_visit
ADD CONSTRAINT fk_fact_insurance
FOREIGN KEY ("InsuranceKey")
REFERENCES warehouse.dim_insurance ("InsuranceKey");



-- ROLE PLAYING DATE DIMENSION
ALTER TABLE warehouse.fact_patient_visit
ADD CONSTRAINT fk_fact_admission_date
FOREIGN KEY ("DateKey")
REFERENCES warehouse.dim_date ("DateKey");



-- VERIFY
SELECT
    tc.constraint_name,
    tc.constraint_type,
    tc.table_name
FROM information_schema.table_constraints tc
WHERE tc.table_schema = 'warehouse'
ORDER BY tc.table_name, tc.constraint_type;